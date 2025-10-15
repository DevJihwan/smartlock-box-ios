//
//  NotificationSettingsView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-16.
//

import SwiftUI

struct NotificationSettingsView: View {
    @ObservedObject private var notificationManager = NotificationManager.shared
    @State private var isShowingPermissionAlert = false
    
    var body: some View {
        Section(header: Text("notification_settings_header".localized)) {
            if !notificationManager.isAuthorized {
                Button(action: {
                    requestPermission()
                }) {
                    HStack {
                        Image(systemName: "bell.slash")
                            .foregroundColor(.red)
                        Text("notification_permission_required".localized)
                    }
                }
                .alert(isPresented: $isShowingPermissionAlert) {
                    Alert(
                        title: Text("notification_permission_title".localized),
                        message: Text("notification_permission_message".localized),
                        primaryButton: .default(Text("notification_open_settings".localized)) {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        },
                        secondaryButton: .cancel(Text("notification_cancel".localized))
                    )
                }
            }
            
            // Goal approaching notification (10 min before)
            NotificationToggleRow(
                title: "notification_goal_approaching_setting".localized,
                subtitle: "notification_goal_approaching_desc".localized,
                iconName: "timer",
                iconColor: .orange,
                isOn: Binding(
                    get: { notificationManager.notificationSettings[.goalApproaching] ?? true },
                    set: { notificationManager.notificationSettings[.goalApproaching] = $0; notificationManager.saveSettings() }
                )
            )
            
            // Lock notification
            NotificationToggleRow(
                title: "notification_locked_setting".localized,
                subtitle: "notification_locked_desc".localized,
                iconName: "lock.fill",
                iconColor: .red,
                isOn: Binding(
                    get: { notificationManager.notificationSettings[.locked] ?? true },
                    set: { notificationManager.notificationSettings[.locked] = $0; notificationManager.saveSettings() }
                )
            )
            
            // Unlock notification
            NotificationToggleRow(
                title: "notification_unlocked_setting".localized,
                subtitle: "notification_unlocked_desc".localized,
                iconName: "lock.open.fill",
                iconColor: .green,
                isOn: Binding(
                    get: { notificationManager.notificationSettings[.unlocked] ?? true },
                    set: { notificationManager.notificationSettings[.unlocked] = $0; notificationManager.saveSettings() }
                )
            )
            
            // Daily report notification (9 PM)
            NotificationToggleRow(
                title: "notification_daily_report_setting".localized,
                subtitle: "notification_daily_report_desc".localized,
                iconName: "chart.bar.fill",
                iconColor: .blue,
                isOn: Binding(
                    get: { notificationManager.notificationSettings[.dailyReport] ?? false },
                    set: { 
                        notificationManager.notificationSettings[.dailyReport] = $0
                        notificationManager.saveSettings()
                        if $0 {
                            notificationManager.scheduleDailyReportNotification()
                        } else {
                            notificationManager.cancelNotification(type: .dailyReport)
                        }
                    }
                )
            )
            
            // Motivation notification
            NotificationToggleRow(
                title: "notification_motivation_setting".localized,
                subtitle: "notification_motivation_desc".localized,
                iconName: "heart.fill",
                iconColor: .pink,
                isOn: Binding(
                    get: { notificationManager.notificationSettings[.motivation] ?? false },
                    set: { 
                        notificationManager.notificationSettings[.motivation] = $0
                        notificationManager.saveSettings()
                        if $0 {
                            notificationManager.scheduleMotivationNotification()
                        } else {
                            notificationManager.cancelNotification(type: .motivation)
                        }
                    }
                )
            )
        }
    }
    
    private func requestPermission() {
        Task {
            let granted = await notificationManager.requestAuthorization()
            
            await MainActor.run {
                if !granted {
                    isShowingPermissionAlert = true
                }
            }
        }
    }
}

struct NotificationToggleRow: View {
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: Color
    @Binding var isOn: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $isOn) {
                HStack {
                    Image(systemName: iconName)
                        .foregroundColor(iconColor)
                        .frame(width: 24)
                    
                    Text(title)
                        .font(.body)
                }
            }
            
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading, 32)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    Form {
        NotificationSettingsView()
    }
}
