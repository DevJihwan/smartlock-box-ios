#!/usr/bin/env python3

import uuid
import re

def generate_uuid():
    """Generate a unique UUID for Xcode objects"""
    return uuid.uuid4().hex[:24].upper()

def add_shared_file_to_project():
    """Add AppGroupDefaults.swift to both main app and extension targets"""

    project_path = '/Users/jihwanseok/Desktop/smartlock-box-ios/SmartLockBox.xcodeproj/project.pbxproj'

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # Generate UUIDs
    file_ref_uuid = generate_uuid()
    build_file_main = generate_uuid()
    build_file_ext = generate_uuid()
    shared_group = generate_uuid()

    print(f"🔧 Generated UUIDs:")
    print(f"   File Reference: {file_ref_uuid}")
    print(f"   Build File (Main): {build_file_main}")
    print(f"   Build File (Extension): {build_file_ext}")
    print(f"   Shared Group: {shared_group}")

    # Find main app target UUID
    main_target_match = re.search(r'(\w{24}) /\* SmartLockBox \*/ = \{[^}]*isa = PBXNativeTarget[^}]*productType = "com\.apple\.product-type\.application"', content, re.DOTALL)
    if not main_target_match:
        print("❌ Could not find main app target")
        return False

    main_target_uuid = main_target_match.group(1)

    # Find extension target UUID
    ext_target_match = re.search(r'(\w{24}) /\* DeviceActivityMonitorExtension \*/ = \{[^}]*isa = PBXNativeTarget', content, re.DOTALL)
    if not ext_target_match:
        print("❌ Could not find extension target")
        return False

    ext_target_uuid = ext_target_match.group(1)

    print(f"   Main Target: {main_target_uuid}")
    print(f"   Extension Target: {ext_target_uuid}")

    # 1. Add file reference
    file_ref = f"""{file_ref_uuid} /* AppGroupDefaults.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AppGroupDefaults.swift; sourceTree = "<group>"; }};
"""

    file_ref_pattern = r'(/\* Begin PBXFileReference section \*/)'
    content = re.sub(file_ref_pattern, f'/* Begin PBXFileReference section */\n\t\t{file_ref}', content, count=1)

    # 2. Add build files
    build_files = f"""{build_file_main} /* AppGroupDefaults.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_uuid} /* AppGroupDefaults.swift */; }};
\t\t{build_file_ext} /* AppGroupDefaults.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_uuid} /* AppGroupDefaults.swift */; }};
"""

    build_file_pattern = r'(/\* Begin PBXBuildFile section \*/)'
    content = re.sub(build_file_pattern, f'/* Begin PBXBuildFile section */\n\t\t{build_files}', content, count=1)

    # 3. Create Shared group
    group_def = f"""\t\t{shared_group} /* Shared */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t{file_ref_uuid} /* AppGroupDefaults.swift */,
\t\t\t);
\t\t\tpath = Shared;
\t\t\tsourceTree = "<group>";
\t\t}};
"""

    # Add group definition
    group_pattern = r'(/\* End PBXGroup section \*/)'
    content = re.sub(group_pattern, f'{group_def}\n/* End PBXGroup section */', content, count=1)

    # Add Shared group to SmartLockBox group
    smartlockbox_group_pattern = r'(EE201F162E9906C20025EA5D /\* SmartLockBox \*/ = \{[^}]*children = \([^)]*)'

    def add_to_group(match):
        children = match.group(1)
        if shared_group not in children:
            return children.replace(');', f',\n\t\t\t\t{shared_group} /* Shared */,\n\t\t\t);')
        return children

    content = re.sub(smartlockbox_group_pattern, add_to_group, content, flags=re.DOTALL)

    # 4. Add to main app sources build phase
    main_sources_pattern = r'(\w{24}) /\* Sources \*/ = \{[^}]*isa = PBXSourcesBuildPhase[^}]*buildActionMask = 2147483647;[^}]*files = \([^)]*' + re.escape(main_target_uuid)

    # Find main app's sources build phase
    main_sources_match = re.search(r'(' + main_target_uuid + r' /\* SmartLockBox \*/ = \{[^}]*buildPhases = \([^)]*(\w{24}) /\* Sources \*/)', content, re.DOTALL)

    if main_sources_match:
        main_sources_uuid = main_sources_match.group(2)
        print(f"   Main Sources Phase: {main_sources_uuid}")

        # Add build file to sources phase
        sources_pattern = f'({main_sources_uuid} /\\* Sources \\*/ = {{[^}}]*files = \\([^)]*)'

        def add_to_sources(match):
            files = match.group(1)
            if build_file_main not in files:
                return files.replace(');', f',\n\t\t\t\t{build_file_main} /* AppGroupDefaults.swift in Sources */,\n\t\t\t);')
            return files

        content = re.sub(sources_pattern, add_to_sources, content, flags=re.DOTALL)

    # 5. Add to extension sources build phase
    ext_sources_match = re.search(r'(' + ext_target_uuid + r' /\* DeviceActivityMonitorExtension \*/ = \{[^}]*buildPhases = \([^)]*(\w{24}) /\* Sources \*/)', content, re.DOTALL)

    if ext_sources_match:
        ext_sources_uuid = ext_sources_match.group(2)
        print(f"   Extension Sources Phase: {ext_sources_uuid}")

        # Add build file to sources phase
        sources_pattern = f'({ext_sources_uuid} /\\* Sources \\*/ = {{[^}}]*files = \\([^)]*)'

        def add_to_sources(match):
            files = match.group(1)
            if build_file_ext not in files:
                return files.replace(');', f',\n\t\t\t\t{build_file_ext} /* AppGroupDefaults.swift in Sources */,\n\t\t\t);')
            return files

        content = re.sub(sources_pattern, add_to_sources, content, flags=re.DOTALL)

    # Write back
    with open(project_path, 'w') as f:
        f.write(content)

    print(f"\n✅ AppGroupDefaults.swift added to both targets successfully!")
    return True

if __name__ == '__main__':
    try:
        success = add_shared_file_to_project()
        if success:
            print("\n🎉 Shared file setup complete!")
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
