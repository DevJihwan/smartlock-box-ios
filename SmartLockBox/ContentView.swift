//
//  ContentView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppStateManager

    var body: some View {
        Group {
            switch appState.currentState {
            case .normal:
                MainView_New()
            case .locked:
                LockScreenView_New()
            case .unlockChallenge:
                UnlockChallengeView_New()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppStateManager())
    }
}
