#!/usr/bin/env python3
"""
Add FamilyActivityPickerView.swift to the Xcode project
"""

import re
import uuid
import shutil
from pathlib import Path

def generate_uuid():
    """Generate a 24-character UUID in Xcode format"""
    return ''.join(str(uuid.uuid4()).replace('-', '').upper()[:24])

def add_file_to_pbxproj():
    project_file = Path("SmartLockBox.xcodeproj/project.pbxproj")
    
    # Backup the project file
    shutil.copy(project_file, f"{project_file}.backup_familypicker")
    print(f"✅ Backed up project file to {project_file}.backup_familypicker")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Generate UUIDs
    file_ref_id = generate_uuid()
    build_file_id = generate_uuid()
    
    print(f"📝 Generated UUIDs for FamilyActivityPickerView.swift")
    print(f"   File Reference: {file_ref_id}")
    print(f"   Build File: {build_file_id}")
    
    # Add PBXBuildFile entry
    pbx_buildfile_section_pattern = r'/\* Begin PBXBuildFile section \*/'
    match = re.search(pbx_buildfile_section_pattern, content)
    
    if match:
        insert_pos = match.end()
        entry = f"\n\t\t{build_file_id} /* FamilyActivityPickerView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* FamilyActivityPickerView.swift */; }};"
        content = content[:insert_pos] + entry + content[insert_pos:]
        print("✅ Added PBXBuildFile entry")
    
    # Add PBXFileReference entry
    pbx_fileref_section_pattern = r'/\* Begin PBXFileReference section \*/'
    match = re.search(pbx_fileref_section_pattern, content)
    
    if match:
        insert_pos = match.end()
        entry = f"\n\t\t{file_ref_id} /* FamilyActivityPickerView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = FamilyActivityPickerView.swift; sourceTree = \"<group>\"; }};"
        content = content[:insert_pos] + entry + content[insert_pos:]
        print("✅ Added PBXFileReference entry")
    
    # Add to PBXSourcesBuildPhase
    sources_buildphase_pattern = r'(/\* Sources \*/.*?buildPhase.*?files = \()(.*?)(\);)'
    match = re.search(sources_buildphase_pattern, content, re.DOTALL)
    
    if match:
        files_section = match.group(2)
        entry = f"\n\t\t\t\t{build_file_id} /* FamilyActivityPickerView.swift in Sources */,"
        new_files_section = files_section + entry
        content = content[:match.start(2)] + new_files_section + content[match.end(2):]
        print("✅ Added to PBXSourcesBuildPhase")
    
    # Find Views group and add file
    views_group_pattern = r'(/\* Views \*/.*?isa = PBXGroup;.*?children = \()(.*?)(\);)'
    match = re.search(views_group_pattern, content, re.DOTALL)
    
    if match:
        children_section = match.group(2)
        entry = f"\n\t\t\t\t{file_ref_id} /* FamilyActivityPickerView.swift */,"
        new_children_section = children_section + entry
        content = content[:match.start(2)] + new_children_section + content[match.end(2):]
        print("✅ Added to Views group")
    
    # Write the modified content back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print(f"\n✅ Successfully modified {project_file}")
    print(f"📦 Added FamilyActivityPickerView.swift to the Xcode project")

if __name__ == "__main__":
    try:
        add_file_to_pbxproj()
        print("\n✅ Done! FamilyActivityPickerView.swift has been added to the project.")
    except Exception as e:
        print(f"\n❌ Error: {e}")
        print("The project file backup is available at SmartLockBox.xcodeproj/project.pbxproj.backup_familypicker")
