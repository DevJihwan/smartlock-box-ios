#!/usr/bin/env python3
"""
Add entitlements file to Xcode project
"""

import re
import uuid
import shutil
from pathlib import Path

def generate_uuid():
    """Generate a 24-character UUID in Xcode format"""
    return ''.join(str(uuid.uuid4()).replace('-', '').upper()[:24])

def add_entitlements_to_pbxproj():
    project_file = Path("SmartLockBox.xcodeproj/project.pbxproj")
    
    # Backup the project file
    shutil.copy(project_file, f"{project_file}.backup_entitlements")
    print(f"✅ Backed up project file to {project_file}.backup_entitlements")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Generate UUIDs
    file_ref_id = generate_uuid()
    print(f"📝 Generated UUID for SmartLockBox.entitlements: {file_ref_id}")
    
    # Add file reference
    pbx_fileref_section_pattern = r'/\* Begin PBXFileReference section \*/'
    match = re.search(pbx_fileref_section_pattern, content)
    
    if match:
        insert_pos = match.end()
        entry = f"\n\t\t{file_ref_id} /* SmartLockBox.entitlements */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = SmartLockBox.entitlements; sourceTree = \"<group>\"; }};"
        content = content[:insert_pos] + entry + content[insert_pos:]
        print("✅ Added PBXFileReference entry")
    
    # Find SmartLockBox group and add entitlements file
    smartlockbox_group_pattern = r'(/\* SmartLockBox \*/.*?isa = PBXGroup;.*?children = \()(.*?)(\);)'
    match = re.search(smartlockbox_group_pattern, content, re.DOTALL)
    
    if match:
        children_section = match.group(2)
        entry = f"\n\t\t\t\t{file_ref_id} /* SmartLockBox.entitlements */,"
        new_children_section = children_section + entry
        content = content[:match.start(2)] + new_children_section + content[match.end(2):]
        print("✅ Added to SmartLockBox group")
    
    # Add CODE_SIGN_ENTITLEMENTS to build settings
    # Find XCBuildConfiguration section for Debug
    build_config_pattern = r'(name = Debug;.*?buildSettings = \{)(.*?)(};)'
    
    for match in re.finditer(build_config_pattern, content, re.DOTALL):
        settings = match.group(2)
        if 'CODE_SIGN_ENTITLEMENTS' not in settings:
            entry = '\n\t\t\t\tCODE_SIGN_ENTITLEMENTS = SmartLockBox/SmartLockBox.entitlements;'
            new_settings = settings + entry
            content = content[:match.start(2)] + new_settings + content[match.end(2):]
            print("✅ Added CODE_SIGN_ENTITLEMENTS to Debug configuration")
            break
    
    # Add CODE_SIGN_ENTITLEMENTS to build settings for Release
    build_config_pattern = r'(name = Release;.*?buildSettings = \{)(.*?)(};)'
    
    for match in re.finditer(build_config_pattern, content, re.DOTALL):
        settings = match.group(2)
        if 'CODE_SIGN_ENTITLEMENTS' not in settings:
            entry = '\n\t\t\t\tCODE_SIGN_ENTITLEMENTS = SmartLockBox/SmartLockBox.entitlements;'
            new_settings = settings + entry
            content = content[:match.start(2)] + new_settings + content[match.end(2):]
            print("✅ Added CODE_SIGN_ENTITLEMENTS to Release configuration")
            break
    
    # Write the modified content back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print(f"\n✅ Successfully modified {project_file}")
    print(f"📦 Added SmartLockBox.entitlements to the Xcode project")

if __name__ == "__main__":
    try:
        add_entitlements_to_pbxproj()
        print("\n✅ Done! The entitlements file has been added to the project.")
        print("⚠️  Note: You may need to manually add 'Family Controls' capability in Xcode:")
        print("   1. Select the project in Xcode")
        print("   2. Go to Signing & Capabilities")
        print("   3. Click '+ Capability'")
        print("   4. Add 'Family Controls'")
    except Exception as e:
        print(f"\n❌ Error: {e}")
        print("The project file backup is available at SmartLockBox.xcodeproj/project.pbxproj.backup_entitlements")
