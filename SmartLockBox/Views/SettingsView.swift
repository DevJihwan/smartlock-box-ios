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
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Form {
            // Goal Settings
            Section(header: Text("settings_goal_header".localized)
                        .foregroundColor(AppColors.accent)) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("settings_daily_goal".localized(with: Int(dailyGoalHours)))
                        .font(.headline)
                        .foregroundColor(AppColors.text)
                    
                    Slider(value: $dailyGoalHours, in: 1...8, step: 0.5) {
                        Text("settings_goal_slider".localized)
                    }
                    .accentColor(AppColors.accent)
                    .onChange(of: dailyGoalHours) { newValue in
                        appState.dailyGoalMinutes = Int(newValue * 60)
                    }
                    
                    Text("settings_goal_explanation".localized(with: Int(dailyGoalHours)))
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            // Unlock Settings
            Section(header: Text("settings_unlock_header".localized)
                        .foregroundColor(AppColors.accent)) {
                DatePicker("settings_auto_unlock_time".localized, 
                           selection: $autoUnlockTime, 
                           displayedComponents: .hourAndMinute)
                    .foregroundColor(AppColors.text)
                    .accentColor(AppColors.accent)
                    .onChange(of: autoUnlockTime) { newValue in
                        let calendar = Calendar.current
                        let hour = calendar.component(.hour, from: newValue)
                        let minute = calendar.component(.minute, from: newValue)
                        appState.autoUnlockTime = (hour: hour, minute: minute)
                    }
                
                Text("settings_auto_unlock_explanation".localized)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            // Creative Challenge Settings
            Section(header: Text("settings_challenge_header".localized)
                        .foregroundColor(AppColors.accent)) {
                Toggle("settings_enable_creative".localized, isOn: .constant(true))
                    .foregroundColor(AppColors.text)
                    .toggleStyle(SwitchToggleStyle(tint: AppColors.accent))
                
                HStack {
                    Text("settings_daily_attempts".localized)
                        .foregroundColor(AppColors.text)
                    Spacer()
                    Text("10")
                        .foregroundColor(AppColors.secondaryText)
                }
                
                HStack {
                    Text("settings_word_refresh".localized)
                        .foregroundColor(AppColors.text)
                    Spacer()
                    Text("3")
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            // Notification Settings
            NotificationSettingsView()
            
            // Language Settings
            Section(header: Text("settings_language_header".localized)
                        .foregroundColor(AppColors.accent)) {
                LanguagePickerView()
            }
            
            // App Info & Actions
            Section(header: Text("settings_app_info_header".localized)
                        .foregroundColor(AppColors.accent)) {
                HStack {
                    Text("settings_version".localized)
                        .foregroundColor(AppColors.text)
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Button(action: {
                    // Screen Time permission request
                    Task {
                        await appState.screenTimeManager?.requestAuthorization()
                    }
                }) {
                    Text("settings_screen_time_permission".localized)
                        .foregroundColor(AppColors.accent)
                }
                
                Button(action: {
                    isShowingResetAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundColor(AppColors.warning)
                        Text("settings_reset_data".localized)
                            .foregroundColor(AppColors.warning)
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
        .background(AppColors.background)
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
        Group {
            NavigationView {
                SettingsView()
                    .environmentObject(AppStateManager())
            }
            .preferredColorScheme(.light)
            .previewDisplayName("Light Mode")
            
            NavigationView {
                SettingsView()
                    .environmentObject(AppStateManager())
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
