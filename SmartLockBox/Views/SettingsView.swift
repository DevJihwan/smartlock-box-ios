//
//  SettingsView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var dailyGoalHours: Double = 3
    @State private var autoUnlockTime: Date = Calendar.current.date(from: DateComponents(hour: 0, minute: 0))!
    @State private var isShowingResetAlert = false
    
    var body: some View {
        Form {
            // Goal Settings
            Section(header: Text("settings_goal_header".localized)) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("settings_daily_goal".localized(with: Int(dailyGoalHours)))
                        .font(.headline)
                    
                    Slider(value: $dailyGoalHours, in: 1...8, step: 0.5) {
                        Text("settings_goal_slider".localized)
                    }
                    .onChange(of: dailyGoalHours) { newValue in
                        appState.dailyGoalMinutes = Int(newValue * 60)
                    }
                    
                    Text("settings_goal_explanation".localized(with: Int(dailyGoalHours)))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Unlock Settings
            Section(header: Text("settings_unlock_header".localized)) {
                DatePicker("settings_auto_unlock_time".localized, 
                           selection: $autoUnlockTime, 
                           displayedComponents: .hourAndMinute)
                    .onChange(of: autoUnlockTime) { newValue in
                        let calendar = Calendar.current
                        let hour = calendar.component(.hour, from: newValue)
                        let minute = calendar.component(.minute, from: newValue)
                        appState.autoUnlockTime = (hour: hour, minute: minute)
                    }
                
                Text("settings_auto_unlock_explanation".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Creative Challenge Settings
            Section(header: Text("settings_challenge_header".localized)) {
                Toggle("settings_enable_creative".localized, isOn: .constant(true))
                
                HStack {
                    Text("settings_daily_attempts".localized)
                    Spacer()
                    Text("10")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("settings_word_refresh".localized)
                    Spacer()
                    Text("3")
                        .foregroundColor(.secondary)
                }
            }
            
            // Notification Settings
            NotificationSettingsView()
            
            // Language Settings
            Section(header: Text("settings_language_header".localized)) {
                LanguagePickerView()
            }
            
            // App Info & Actions
            Section(header: Text("settings_app_info_header".localized)) {
                HStack {
                    Text("settings_version".localized)
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                Button(action: {
                    // Screen Time permission request
                    Task {
                        await appState.screenTimeManager?.requestAuthorization()
                    }
                }) {
                    Text("settings_screen_time_permission".localized)
                }
                
                Button(action: {
                    isShowingResetAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                        Text("settings_reset_data".localized)
                            .foregroundColor(.red)
                    }
                }
                .alert(isPresented: $isShowingResetAlert) {
                    Alert(
                        title: Text("settings_reset_confirm_title".localized),
                        message: Text("settings_reset_confirm_message".localized),
                        primaryButton: .destructive(Text("settings_reset_confirm_button".localized)) {
                            // Perform data reset
                            resetAllData()
                        },
                        secondaryButton: .cancel(Text("settings_reset_cancel_button".localized))
                    )
                }
            }
        }
        .navigationTitle("settings_title".localized)
        .onAppear {
            dailyGoalHours = Double(appState.dailyGoalMinutes) / 60.0
            
            // Set auto unlock time from app state
            let calendar = Calendar.current
            var components = DateComponents()
            components.hour = appState.autoUnlockTime.hour
            components.minute = appState.autoUnlockTime.minute
            if let date = calendar.date(from: components) {
                autoUnlockTime = date
            }
        }
        .animation(.easeInOut, value: dailyGoalHours)
    }
    
    private func resetAllData() {
        // Reset all data in the app
        appState.resetAllData()
        
        // Reset notifications
        NotificationManager.shared.cancelAllNotifications()
        
        // Show confirmation
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .environmentObject(AppStateManager())
        }
    }
}
