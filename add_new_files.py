#!/usr/bin/env python3
"""
Add TimeSlotUsageData.swift and StoreManager.swift to the project
"""

import re
import uuid
import shutil
from pathlib import Path

def generate_uuid():
    """Generate a 24-character UUID in Xcode format"""
    return ''.join(str(uuid.uuid4()).replace('-', '').upper()[:24])

def add_files_to_pbxproj():
    project_file = Path("SmartLockBox.xcodeproj/project.pbxproj")

    # Backup the project file
    shutil.copy(project_file, f"{project_file}.backup2")
    print(f"✅ Backed up project file to {project_file}.backup2")

    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()

    # Files to add
    files = [
        {
            "name": "TimeSlotUsageData.swift",
            "path": "SmartLockBox/Models/TimeSlotUsageData.swift",
            "group": "Models"
        },
        {
            "name": "StoreManager.swift",
            "path": "SmartLockBox/Managers/StoreManager.swift",
            "group": "Managers"
        },
    ]

    # Generate UUIDs for each file
    file_refs = []
    build_file_refs = []

    for file_info in files:
        file_ref_id = generate_uuid()
        build_file_id = generate_uuid()
        file_refs.append((file_ref_id, file_info))
        build_file_refs.append((build_file_id, file_ref_id, file_info))
        print(f"📝 Generated UUIDs for {file_info['name']}")

    # Find the PBXBuildFile section
    pbx_buildfile_section_pattern = r'/\* Begin PBXBuildFile section \*/'
    match = re.search(pbx_buildfile_section_pattern, content)

    if match:
        insert_pos = match.end()
        build_file_entries = []

        for build_file_id, file_ref_id, file_info in build_file_refs:
            entry = f"\n\t\t{build_file_id} /* {file_info['name']} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {file_info['name']} */; }};"
            build_file_entries.append(entry)

        content = content[:insert_pos] + ''.join(build_file_entries) + content[insert_pos:]
        print("✅ Added PBXBuildFile entries")

    # Find the PBXFileReference section
    pbx_fileref_section_pattern = r'/\* Begin PBXFileReference section \*/'
    match = re.search(pbx_fileref_section_pattern, content)

    if match:
        insert_pos = match.end()
        file_ref_entries = []

        for file_ref_id, file_info in file_refs:
            entry = f"\n\t\t{file_ref_id} /* {file_info['name']} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {file_info['name']}; sourceTree = \"<group>\"; }};"
            file_ref_entries.append(entry)

        content = content[:insert_pos] + ''.join(file_ref_entries) + content[insert_pos:]
        print("✅ Added PBXFileReference entries")

    # Find the PBXSourcesBuildPhase section and add to Sources
    sources_buildphase_pattern = r'(/\* Sources \*/.*?buildPhase.*?files = \()(.*?)(\);)'
    match = re.search(sources_buildphase_pattern, content, re.DOTALL)

    if match:
        files_section = match.group(2)
        source_entries = []

        for build_file_id, file_ref_id, file_info in build_file_refs:
            entry = f"\n\t\t\t\t{build_file_id} /* {file_info['name']} in Sources */,"
            source_entries.append(entry)

        new_files_section = files_section + ''.join(source_entries)
        content = content[:match.start(2)] + new_files_section + content[match.end(2):]
        print("✅ Added to PBXSourcesBuildPhase")

    # Write the modified content back
    with open(project_file, 'w') as f:
        f.write(content)

    print(f"\n✅ Successfully modified {project_file}")
    print(f"📦 Added {len(files)} files to the Xcode project")

if __name__ == "__main__":
    try:
        add_files_to_pbxproj()
        print("\n✅ Done! The project file has been updated.")
    except Exception as e:
        print(f"\n❌ Error: {e}")
        print("The project file backup is available at SmartLockBox.xcodeproj/project.pbxproj.backup2")
