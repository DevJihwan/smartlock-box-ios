//
//  SmartLockBoxApp.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

@main
struct SmartLockBoxApp: App {
    @StateObject private var appState = AppStateManager()
    @StateObject private var themeManager = ThemeManager.shared
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(themeManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .withThemeColor()
        }
    }
}
