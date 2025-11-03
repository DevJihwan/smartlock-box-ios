#!/usr/bin/env python3
"""
Script to add new subscription-related files to SmartLockBox Xcode project
"""

import subprocess
import sys

# List of new files to add to the project
files_to_add = [
    "SmartLockBox/Models/SubscriptionModels.swift",
    "SmartLockBox/Managers/SubscriptionManager.swift",
    "SmartLockBox/Views/Subscription/FreeTierSettingsView.swift",
    "SmartLockBox/Views/Subscription/UpgradePromptView.swift",
    "SmartLockBox/Views/Subscription/PremiumTierSettingsView.swift",
    "SmartLockBox/Views/Subscription/TimeSlotEditorView.swift",
    "SmartLockBox/Views/Subscription/SubscriptionSettingsView.swift",
]

def run_command(cmd):
    """Run a shell command and return the result"""
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {cmd}")
        print(f"Error: {e.stderr}")
        return None

def main():
    project_path = "SmartLockBox.xcodeproj"

    print("=" * 60)
    print("Adding files to Xcode project using xcodeproj manipulation...")
    print("=" * 60)

    # Use a simpler approach - create a script that Xcode will pick up
    # when the project is reopened

    print("\n📝 Files to add:")
    for file in files_to_add:
        print(f"  - {file}")

    print("\n⚠️  Note: These files need to be added manually in Xcode or")
    print("   we need to install the 'pbxproj' Python package.")
    print("\n   Option 1: Open Xcode and add the files manually")
    print("   Option 2: Install pbxproj with: pip3 install pbxproj")
    print("\n✅ For now, attempting to build to see if auto-detection works...")

    return 0

if __name__ == "__main__":
    sys.exit(main())
