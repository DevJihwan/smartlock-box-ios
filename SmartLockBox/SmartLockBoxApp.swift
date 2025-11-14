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
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    appState.loadSettings()
                }
        }
    }
}
