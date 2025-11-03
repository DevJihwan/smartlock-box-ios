#!/usr/bin/env python3

import uuid
import re
import os

def generate_uuid():
    """Generate a unique UUID for Xcode objects"""
    return uuid.uuid4().hex[:24].upper()

def add_extension_to_project():
    """Add DeviceActivityMonitorExtension target to Xcode project"""

    project_path = '/Users/jihwanseok/Desktop/smartlock-box-ios/SmartLockBox.xcodeproj/project.pbxproj'

    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()

    # Generate UUIDs for all new objects
    extension_target_uuid = generate_uuid()
    monitor_swift_file_ref = generate_uuid()
    info_plist_file_ref = generate_uuid()
    entitlements_file_ref = generate_uuid()

    monitor_swift_build_file = generate_uuid()
    info_plist_build_file = generate_uuid()

    sources_build_phase = generate_uuid()
    resources_build_phase = generate_uuid()
    frameworks_build_phase = generate_uuid()

    extension_group = generate_uuid()

    debug_config = generate_uuid()
    release_config = generate_uuid()
    config_list = generate_uuid()

    # Copy files build phase for embedding extension
    copy_files_phase = generate_uuid()
    copy_extension_build_file = generate_uuid()

    # Target dependency
    target_dependency = generate_uuid()
    container_item_proxy = generate_uuid()

    print(f"🔧 Generated UUIDs:")
    print(f"   Extension Target: {extension_target_uuid}")
    print(f"   Monitor Swift: {monitor_swift_file_ref}")
    print(f"   Info.plist: {info_plist_file_ref}")
    print(f"   Entitlements: {entitlements_file_ref}")

    # 1. Add file references
    file_refs_section = f"""
/* Begin PBXFileReference section */
		{monitor_swift_file_ref} /* DeviceActivityMonitor.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = DeviceActivityMonitor.swift; sourceTree = "<group>"; }};
		{info_plist_file_ref} /* Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; }};
		{entitlements_file_ref} /* DeviceActivityMonitorExtension.entitlements */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = DeviceActivityMonitorExtension.entitlements; sourceTree = "<group>"; }};
		{extension_target_uuid} /* DeviceActivityMonitorExtension.appex */ = {{isa = PBXFileReference; explicitFileType = "wrapper.app-extension"; includeInIndex = 0; path = DeviceActivityMonitorExtension.appex; sourceTree = BUILT_PRODUCTS_DIR; }};
"""

    # Find and update PBXFileReference section
    file_ref_pattern = r'(/\* Begin PBXFileReference section \*/)'
    content = re.sub(file_ref_pattern, file_refs_section, content, count=1)

    # 2. Add build files
    build_files_section = f"""
/* Begin PBXBuildFile section */
		{monitor_swift_build_file} /* DeviceActivityMonitor.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {monitor_swift_file_ref} /* DeviceActivityMonitor.swift */; }};
		{copy_extension_build_file} /* DeviceActivityMonitorExtension.appex in Embed Foundation Extensions */ = {{isa = PBXBuildFile; fileRef = {extension_target_uuid} /* DeviceActivityMonitorExtension.appex */; settings = {{ATTRIBUTES = (RemoveHeadersOnCopy, ); }}; }};
"""

    build_file_pattern = r'(/\* Begin PBXBuildFile section \*/)'
    content = re.sub(build_file_pattern, build_files_section, content, count=1)

    # 3. Add group for extension files
    groups_section = f"""
		{extension_group} /* DeviceActivityMonitorExtension */ = {{
			isa = PBXGroup;
			children = (
				{monitor_swift_file_ref} /* DeviceActivityMonitor.swift */,
				{info_plist_file_ref} /* Info.plist */,
				{entitlements_file_ref} /* DeviceActivityMonitorExtension.entitlements */,
			);
			path = DeviceActivityMonitorExtension;
			sourceTree = "<group>";
		}};
"""

    # Find main group and add extension group to it
    main_group_pattern = r'(children = \([^)]*?29B97314FDCFA39411CA2CEA[^)]*?\);)'

    def add_extension_group(match):
        children_content = match.group(1)
        # Add extension group before the closing parenthesis
        return children_content.replace(');', f',\n				{extension_group} /* DeviceActivityMonitorExtension */,\n			);')

    content = re.sub(main_group_pattern, add_extension_group, content)

    # Add the group definition
    group_section_pattern = r'(/\* End PBXGroup section \*/)'
    content = re.sub(group_section_pattern, f'{groups_section}\n/* End PBXGroup section */', content, count=1)

    # 4. Add build phases
    sources_phase = f"""
		{sources_build_phase} /* Sources */ = {{
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				{monitor_swift_build_file} /* DeviceActivityMonitor.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
"""

    frameworks_phase = f"""
		{frameworks_build_phase} /* Frameworks */ = {{
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
"""

    resources_phase = f"""
		{resources_build_phase} /* Resources */ = {{
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		}};
"""

    # Add build phases
    sources_pattern = r'(/\* End PBXSourcesBuildPhase section \*/)'
    content = re.sub(sources_pattern, f'{sources_phase}\n/* End PBXSourcesBuildPhase section */', content, count=1)

    frameworks_pattern = r'(/\* End PBXFrameworksBuildPhase section \*/)'
    content = re.sub(frameworks_pattern, f'{frameworks_phase}\n/* End PBXFrameworksBuildPhase section */', content, count=1)

    resources_pattern = r'(/\* End PBXResourcesBuildPhase section \*/)'
    content = re.sub(resources_pattern, f'{resources_phase}\n/* End PBXResourcesBuildPhase section */', content, count=1)

    # 5. Add copy files build phase for embedding extension
    copy_files_section = f"""
		{copy_files_phase} /* Embed Foundation Extensions */ = {{
			isa = PBXCopyFilesBuildPhase;
			buildActionMask = 2147483647;
			dstPath = "";
			dstSubfolderSpec = 13;
			files = (
				{copy_extension_build_file} /* DeviceActivityMonitorExtension.appex in Embed Foundation Extensions */,
			);
			name = "Embed Foundation Extensions";
			runOnlyForDeploymentPostprocessing = 0;
		}};
"""

    copy_files_pattern = r'(/\* End PBXCopyFilesBuildPhase section \*/)'
    if '/* End PBXCopyFilesBuildPhase section */' in content:
        content = re.sub(copy_files_pattern, f'{copy_files_section}\n/* End PBXCopyFilesBuildPhase section */', content, count=1)
    else:
        # Add section if it doesn't exist
        resources_end = r'(/\* End PBXResourcesBuildPhase section \*/)'
        content = re.sub(resources_end, f'/* End PBXResourcesBuildPhase section */\n\n/* Begin PBXCopyFilesBuildPhase section */\n{copy_files_section}/* End PBXCopyFilesBuildPhase section */', content, count=1)

    # 6. Add native target for extension
    native_target = f"""
		{extension_target_uuid} /* DeviceActivityMonitorExtension */ = {{
			isa = PBXNativeTarget;
			buildConfigurationList = {config_list} /* Build configuration list for PBXNativeTarget "DeviceActivityMonitorExtension" */;
			buildPhases = (
				{sources_build_phase} /* Sources */,
				{frameworks_build_phase} /* Frameworks */,
				{resources_build_phase} /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = DeviceActivityMonitorExtension;
			productName = DeviceActivityMonitorExtension;
			productReference = {extension_target_uuid} /* DeviceActivityMonitorExtension.appex */;
			productType = "com.apple.product-type.app-extension";
		}};
"""

    target_pattern = r'(/\* End PBXNativeTarget section \*/)'
    content = re.sub(target_pattern, f'{native_target}\n/* End PBXNativeTarget section */', content, count=1)

    # 7. Add target dependency
    container_proxy = f"""
		{container_item_proxy} /* PBXContainerItemProxy */ = {{
			isa = PBXContainerItemProxy;
			containerPortal = 29B97313FDCFA39411CA2CEA /* Project object */;
			proxyType = 1;
			remoteGlobalIDString = {extension_target_uuid};
			remoteInfo = DeviceActivityMonitorExtension;
		}};
"""

    dependency = f"""
		{target_dependency} /* PBXTargetDependency */ = {{
			isa = PBXTargetDependency;
			target = {extension_target_uuid} /* DeviceActivityMonitorExtension */;
			targetProxy = {container_item_proxy} /* PBXContainerItemProxy */;
		}};
"""

    # Add container proxy
    proxy_pattern = r'(/\* End PBXContainerItemProxy section \*/)'
    if '/* End PBXContainerItemProxy section */' in content:
        content = re.sub(proxy_pattern, f'{container_proxy}\n/* End PBXContainerItemProxy section */', content, count=1)
    else:
        # Add section
        target_dep_start = r'(/\* Begin PBXTargetDependency section \*/)'
        content = re.sub(target_dep_start, f'/* Begin PBXContainerItemProxy section */\n{container_proxy}/* End PBXContainerItemProxy section */\n\n/* Begin PBXTargetDependency section */', content, count=1)

    # Add target dependency
    dependency_pattern = r'(/\* End PBXTargetDependency section \*/)'
    if '/* End PBXTargetDependency section */' in content:
        content = re.sub(dependency_pattern, f'{dependency}\n/* End PBXTargetDependency section */', content, count=1)
    else:
        # Add section
        native_end = r'(/\* End PBXNativeTarget section \*/)'
        content = re.sub(native_end, f'/* End PBXNativeTarget section */\n\n/* Begin PBXTargetDependency section */\n{dependency}/* End PBXTargetDependency section */', content, count=1)

    # 8. Add build configurations
    debug_build_config = f"""
		{debug_config} /* Debug */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				CODE_SIGN_ENTITLEMENTS = DeviceActivityMonitorExtension/DeviceActivityMonitorExtension.entitlements;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = JVUXYR66CL;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = DeviceActivityMonitorExtension/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = DeviceActivityMonitorExtension;
				INFOPLIST_KEY_NSHumanReadableCopyright = "";
				IPHONEOS_DEPLOYMENT_TARGET = 18.2;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
					"@executable_path/../../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.devjihwan.cardnewsapp.SmartLockBox.DeviceActivityMonitorExtension;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SKIP_INSTALL = YES;
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Debug;
		}};
"""

    release_build_config = f"""
		{release_config} /* Release */ = {{
			isa = XCBuildConfiguration;
			buildSettings = {{
				CODE_SIGN_ENTITLEMENTS = DeviceActivityMonitorExtension/DeviceActivityMonitorExtension.entitlements;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = JVUXYR66CL;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = DeviceActivityMonitorExtension/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = DeviceActivityMonitorExtension;
				INFOPLIST_KEY_NSHumanReadableCopyright = "";
				IPHONEOS_DEPLOYMENT_TARGET = 18.2;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
					"@executable_path/../../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.devjihwan.cardnewsapp.SmartLockBox.DeviceActivityMonitorExtension;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SKIP_INSTALL = YES;
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			}};
			name = Release;
		}};
"""

    config_list_obj = f"""
		{config_list} /* Build configuration list for PBXNativeTarget "DeviceActivityMonitorExtension" */ = {{
			isa = XCConfigurationList;
			buildConfigurations = (
				{debug_config} /* Debug */,
				{release_config} /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		}};
"""

    # Add build configurations
    build_config_pattern = r'(/\* End XCBuildConfiguration section \*/)'
    content = re.sub(build_config_pattern, f'{debug_build_config}{release_build_config}\n/* End XCBuildConfiguration section */', content, count=1)

    # Add configuration list
    config_list_pattern = r'(/\* End XCConfigurationList section \*/)'
    content = re.sub(config_list_pattern, f'{config_list_obj}\n/* End XCConfigurationList section */', content, count=1)

    # 9. Add extension to main app's build phases (embed extension)
    # Find main target UUID first
    main_target_match = re.search(r'(\w{24}) /\* SmartLockBox \*/ = \{[^}]*isa = PBXNativeTarget', content)
    if main_target_match:
        main_target_uuid = main_target_match.group(1)
        print(f"   Main Target: {main_target_uuid}")

        # Add copy files phase to main target's buildPhases
        main_target_pattern = f'({main_target_uuid} /\\* SmartLockBox \\*/ = {{[^}}]*buildPhases = \\([^)]*)'

        def add_copy_phase(match):
            phases = match.group(1)
            if copy_files_phase not in phases:
                return phases.replace(');', f',\n				{copy_files_phase} /* Embed Foundation Extensions */,\n			);')
            return phases

        content = re.sub(main_target_pattern, add_copy_phase, content)

        # Add dependency to main target
        main_deps_pattern = f'({main_target_uuid} /\\* SmartLockBox \\*/ = {{[^}}]*dependencies = \\([^)]*)'

        def add_dependency(match):
            deps = match.group(1)
            if target_dependency not in deps:
                return deps.replace(');', f',\n				{target_dependency} /* PBXTargetDependency */,\n			);')
            return deps

        content = re.sub(main_deps_pattern, add_dependency, content)

    # 10. Add extension to project targets
    project_pattern = r'(29B97313FDCFA39411CA2CEA /\* Project object \*/ = \{[^}]*targets = \([^)]*)'

    def add_to_targets(match):
        targets = match.group(1)
        if extension_target_uuid not in targets:
            return targets.replace(');', f',\n				{extension_target_uuid} /* DeviceActivityMonitorExtension */,\n			);')
        return targets

    content = re.sub(project_pattern, add_to_targets, content)

    # Write back
    with open(project_path, 'w') as f:
        f.write(content)

    print(f"\n✅ Extension added to Xcode project successfully!")
    print(f"   - DeviceActivityMonitor.swift")
    print(f"   - Info.plist")
    print(f"   - DeviceActivityMonitorExtension.entitlements")
    print(f"   - Extension target configured with App Group support")
    return True

if __name__ == '__main__':
    try:
        success = add_extension_to_project()
        if success:
            print("\n🎉 DeviceActivity Extension setup complete!")
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
