#!/usr/bin/env python3

import uuid
import re

def generate_uuid():
    """Generate a unique UUID for Xcode objects"""
    return uuid.uuid4().hex[:24].upper()

def add_design_system_files():
    """Add all Design System files to Xcode project"""

    project_path = '/Users/jihwanseok/Desktop/smartlock-box-ios/SmartLockBox.xcodeproj/project.pbxproj'

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # Define all files to add
    files_to_add = [
        ('Typography.swift', 'DesignSystem'),
        ('Spacing.swift', 'DesignSystem'),
        ('ThemeManager.swift', 'DesignSystem'),
        ('Animations.swift', 'DesignSystem'),
        ('CardView.swift', 'DesignSystem/Components'),
        ('AdaptiveProgressBar.swift', 'DesignSystem/Components'),
        ('HeatmapCell.swift', 'DesignSystem/Components'),
    ]

    # Find main target UUID
    main_target_match = re.search(r'(\w{24}) /\* SmartLockBox \*/ = \{[^}]*isa = PBXNativeTarget[^}]*productType = "com\.apple\.product-type\.application"', content, re.DOTALL)
    if not main_target_match:
        print("❌ Could not find main app target")
        return False

    main_target_uuid = main_target_match.group(1)
    print(f"✅ Found main target: {main_target_uuid}")

    # Find sources build phase
    main_sources_match = re.search(r'(' + main_target_uuid + r' /\* SmartLockBox \*/ = \{[^}]*buildPhases = \([^)]*(\w{24}) /\* Sources \*/)', content, re.DOTALL)
    if not main_sources_match:
        print("❌ Could not find sources build phase")
        return False

    main_sources_uuid = main_sources_match.group(2)
    print(f"✅ Found sources phase: {main_sources_uuid}")

    # Groups
    design_system_group_uuid = generate_uuid()
    components_group_uuid = generate_uuid()

    file_refs = []
    build_files = []

    # Generate UUIDs for all files
    for filename, path in files_to_add:
        file_ref_uuid = generate_uuid()
        build_file_uuid = generate_uuid()

        file_refs.append((filename, file_ref_uuid, path))
        build_files.append((filename, file_ref_uuid, build_file_uuid))

        print(f"📄 {filename}: {file_ref_uuid}")

    # 1. Add file references
    file_refs_section = ""
    for filename, file_ref_uuid, path in file_refs:
        file_refs_section += f"\t\t{file_ref_uuid} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {filename}; sourceTree = \"<group>\"; }};\n"

    file_ref_pattern = r'(/\* Begin PBXFileReference section \*/)'
    content = re.sub(file_ref_pattern, f'/* Begin PBXFileReference section */\n{file_refs_section}', content, count=1)

    # 2. Add build files
    build_files_section = ""
    for filename, file_ref_uuid, build_file_uuid in build_files:
        build_files_section += f"\t\t{build_file_uuid} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_uuid} /* {filename} */; }};\n"

    build_file_pattern = r'(/\* Begin PBXBuildFile section \*/)'
    content = re.sub(build_file_pattern, f'/* Begin PBXBuildFile section */\n{build_files_section}', content, count=1)

    # 3. Create groups
    design_system_children = ""
    for filename, file_ref_uuid, path in file_refs:
        if path == 'DesignSystem':
            design_system_children += f"\t\t\t\t{file_ref_uuid} /* {filename} */,\n"

    components_children = ""
    for filename, file_ref_uuid, path in file_refs:
        if path == 'DesignSystem/Components':
            components_children += f"\t\t\t\t{file_ref_uuid} /* {filename} */,\n"

    groups_section = f"""\t\t{design_system_group_uuid} /* DesignSystem */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{design_system_children}\t\t\t\t{components_group_uuid} /* Components */,
\t\t\t);
\t\t\tpath = DesignSystem;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{components_group_uuid} /* Components */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{components_children}\t\t\t);
\t\t\tpath = Components;
\t\t\tsourceTree = "<group>";
\t\t}};
"""

    group_pattern = r'(/\* End PBXGroup section \*/)'
    content = re.sub(group_pattern, f'{groups_section}\n/* End PBXGroup section */', content, count=1)

    # Add DesignSystem group to SmartLockBox group
    smartlockbox_group_pattern = r'(EE201F162E9906C20025EA5D /\* SmartLockBox \*/ = \{[^}]*children = \([^)]*)'

    def add_to_group(match):
        children = match.group(1)
        if design_system_group_uuid not in children:
            return children.replace(');', f',\n\t\t\t\t{design_system_group_uuid} /* DesignSystem */,\n\t\t\t);')
        return children

    content = re.sub(smartlockbox_group_pattern, add_to_group, content, flags=re.DOTALL)

    # 4. Add to sources build phase
    sources_pattern = f'({main_sources_uuid} /\\* Sources \\*/ = {{[^}}]*files = \\([^)]*)'

    def add_to_sources(match):
        files = match.group(1)
        for filename, file_ref_uuid, build_file_uuid in build_files:
            if build_file_uuid not in files:
                files += f',\n\t\t\t\t{build_file_uuid} /* {filename} in Sources */'
        return files + ','

    content = re.sub(sources_pattern, add_to_sources, content, flags=re.DOTALL)

    # Write back
    with open(project_path, 'w') as f:
        f.write(content)

    print(f"\n✅ Successfully added {len(files_to_add)} Design System files to project!")
    print("\n📁 File Structure:")
    print("DesignSystem/")
    print("├── Typography.swift")
    print("├── Spacing.swift")
    print("├── ThemeManager.swift")
    print("├── Animations.swift")
    print("└── Components/")
    print("    ├── CardView.swift")
    print("    ├── AdaptiveProgressBar.swift")
    print("    └── HeatmapCell.swift")

    return True

if __name__ == '__main__':
    try:
        success = add_design_system_files()
        if success:
            print("\n🎉 Design System integration complete!")
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
