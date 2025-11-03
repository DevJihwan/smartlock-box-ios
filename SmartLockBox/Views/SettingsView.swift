//
//  SettingsView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppStateManager
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @State private var dailyGoalHours: Double = 3
    @State private var autoUnlockTime: Date = Calendar.current.date(from: DateComponents(hour: 0, minute: 0))!
    @State private var isShowingResetAlert = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Form {
            subscriptionSection
            goalSettingsSection
            unlockSettingsSection
            challengeSettingsSection
            notificationSection
            languageSection
            appInfoSection
        }
        .navigationTitle("settings_title".localized)
        .background(AppColors.background)
        .onAppear {
            loadSettings()
        }
        .animation(.easeInOut, value: dailyGoalHours)
    }
    
    // MARK: - Subscription Settings

    private var subscriptionSection: some View {
        Section {
            NavigationLink(destination: SubscriptionSettingsView()) {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                    Text("settings_subscription".localized)
                        .foregroundColor(AppColors.text)
                }
            }
        }
    }

    // MARK: - Goal Settings

    private var goalSettingsSection: some View {
        Section(header: sectionHeader("settings_goal_header".localized)) {
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
    }
    
    // MARK: - Unlock Settings
    
    private var unlockSettingsSection: some View {
        Section(header: sectionHeader("settings_unlock_header".localized)) {
            DatePicker(
                "settings_auto_unlock_time".localized,
                selection: $autoUnlockTime,
                displayedComponents: .hourAndMinute
            )
            .foregroundColor(AppColors.text)
            .accentColor(AppColors.accent)
            .onChange(of: autoUnlockTime) { newValue in
                updateAutoUnlockTime(newValue)
            }
            
            Text("settings_auto_unlock_explanation".localized)
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
        }
    }
    
    // MARK: - Challenge Settings
    
    private var challengeSettingsSection: some View {
        Section(header: sectionHeader("settings_challenge_header".localized)) {
            Toggle("settings_enable_creative".localized, isOn: .constant(true))
                .foregroundColor(AppColors.text)
                .toggleStyle(SwitchToggleStyle(tint: AppColors.accent))
            
            settingsRow(
                title: "settings_daily_attempts".localized,
                value: "10"
            )
            
            settingsRow(
                title: "settings_word_refresh".localized,
                value: "3"
            )
        }
    }
    
    // MARK: - Notification Settings
    
    private var notificationSection: some View {
        NotificationSettingsView()
    }
    
    // MARK: - Language Settings
    
    private var languageSection: some View {
        Section(header: sectionHeader("settings_language_header".localized)) {
            LanguagePickerView()
        }
    }
    
    // MARK: - App Info & Actions
    
    private var appInfoSection: some View {
        Section(header: sectionHeader("settings_app_info_header".localized)) {
            settingsRow(
                title: "settings_version".localized,
                value: "1.0.0"
            )
            
            Button(action: requestScreenTimePermission) {
                Text("settings_screen_time_permission".localized)
                    .foregroundColor(AppColors.accent)
            }
            
            Button(action: { isShowingResetAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(AppColors.warning)
                    Text("settings_reset_data".localized)
                        .foregroundColor(AppColors.warning)
                }
            }
            .alert(isPresented: $isShowingResetAlert) {
                resetDataAlert
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .foregroundColor(AppColors.accent)
    }
    
    private func settingsRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(AppColors.text)
            Spacer()
            Text(value)
                .foregroundColor(AppColors.secondaryText)
        }
    }
    
    private var resetDataAlert: Alert {
        Alert(
            title: Text("settings_reset_confirm_title".localized),
            message: Text("settings_reset_confirm_message".localized),
            primaryButton: .destructive(Text("settings_reset_confirm_button".localized)) {
                resetAllData()
            },
            secondaryButton: .cancel(Text("settings_reset_cancel_button".localized))
        )
    }
    
    // MARK: - Helper Methods
    
    private func loadSettings() {
        dailyGoalHours = Double(appState.dailyGoalMinutes) / 60.0
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = appState.autoUnlockTime.hour
        components.minute = appState.autoUnlockTime.minute
        if let date = calendar.date(from: components) {
            autoUnlockTime = date
        }
    }
    
    private func updateAutoUnlockTime(_ newValue: Date) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: newValue)
        let minute = calendar.component(.minute, from: newValue)
        appState.autoUnlockTime = (hour: hour, minute: minute)
    }
    
    private func requestScreenTimePermission() {
        Task {
            do {
                try await appState.screenTimeManager?.requestAuthorization()
            } catch {
                print("❌ Screen Time permission request failed: \(error)")
            }
        }
    }
    
    private func resetAllData() {
        appState.resetAllData()
        NotificationManager.shared.cancelAllNotifications()
        
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
    }
}

// MARK: - Previews

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
