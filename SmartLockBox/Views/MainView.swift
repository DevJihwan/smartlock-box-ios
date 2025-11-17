//
//  MainView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppStateManager
    @StateObject private var viewModel = MainViewModel()
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @State private var showNotificationPermissionAlert = false
    @State private var showSettings = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        // Force view to update when language changes
        let _ = localizationManager.currentLanguage

        if #available(iOS 16.0, *) {
            NavigationStack {
                mainContent
            }
        } else {
            NavigationView {
                mainContent
            }
        }
    }

    private var mainContent: some View {
        ZStack {
            // Background
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with language switcher
                headerView
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Time slot info
                        timeSlotInfoView
                            .padding(.top, 24)

                        // Circular timer
                        circularTimerView

                        // Control toggle
                        controlToggleView

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                }

                // Settings button at bottom
                settingsButtonView
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
            }
        }
        .onAppear {
            checkNotificationPermission()
            appState.loadSettings()
        }
        .alert(isPresented: $showNotificationPermissionAlert) {
            notificationPermissionAlert
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(appState)
        }
        .preferredColorScheme(nil)
    }

    // MARK: - Header View

    private var headerView: some View {
        HStack(alignment: .center, spacing: 12) {
            // ThinkFree BI Logo
            HStack(spacing: 12) {
                // Lock icon
                Image(systemName: "lock.fill")
                    .font(.system(size: 32))
                    .foregroundColor(AppColors.accent)

                // Brand text
                VStack(alignment: .leading, spacing: 2) {
                    Text("ThinkFree")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(AppColors.text)

                    Text("생각하면 자유로워진다")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(AppColors.accent)
                }
            }

            Spacer()

            LanguageSwitcher()
        }
    }

    // MARK: - Time Slot Info View

    private var timeSlotInfoView: some View {
        VStack(spacing: 12) {
            // Clock icon
            Image(systemName: "clock")
                .font(.system(size: 32))
                .foregroundColor(AppColors.secondaryText.opacity(0.6))

            // Time range
            Text(formatTimeRange())
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppColors.text)

            // Limit description
            Text("limit_time_description".localized(with: formatHours(appState.limitMinutes)))
                .font(.system(size: 17))
                .foregroundColor(AppColors.secondaryText)
        }
    }

    // MARK: - Circular Timer View

    private var circularTimerView: some View {
        VStack(spacing: 16) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.gray.opacity(0.15), lineWidth: 20)
                    .frame(width: 240, height: 240)

                // Progress circle
                Circle()
                    .trim(from: 0, to: CGFloat(min(Double(appState.usagePercentage) / 100.0, 1.0)))
                    .stroke(
                        Color(red: 1.0, green: 0.75, blue: 0.0), // Yellow/Gold color
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .frame(width: 240, height: 240)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: appState.usagePercentage)

                // Center content
                VStack(spacing: 8) {
                    // Current time remaining
                    Text(formatTimeRemaining())
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(AppColors.text)

                    // Divider line
                    Rectangle()
                        .fill(AppColors.secondaryText.opacity(0.3))
                        .frame(width: 60, height: 1)

                    // Total limit time
                    Text(formatHours(appState.limitMinutes))
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.secondaryText)
                }
            }

            // Time remaining text
            Text(formatTimeRemainingDescription())
                .font(.system(size: 15))
                .foregroundColor(AppColors.secondaryText)

            // Debug info (temporary)
            #if DEBUG
            VStack(spacing: 4) {
                Text("Debug Info:")
                    .font(.caption.bold())
                    .foregroundColor(.orange)
                Text("Control: \(appState.isControlEnabled ? "ON" : "OFF")")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text("In Time Slot: \(appState.isWithinTimeSlot ? "YES" : "NO")")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text("Usage: \(appState.todayUsageMinutes) min")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(8)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(8)
            #endif
        }
    }

    // MARK: - Control Toggle View

    private var controlToggleView: some View {
        VStack(spacing: 16) {
            // Divider
            Rectangle()
                .fill(AppColors.secondaryText.opacity(0.2))
                .frame(height: 1)
                .padding(.horizontal, -24)

            // Toggle
            VStack(spacing: 12) {
                // Custom toggle with smooth animation
                HStack(spacing: 16) {
                    Spacer()

                    // Toggle text
                    Text(appState.isControlEnabled ? "ON" : "OFF")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(width: 40)
                        .animation(.easeInOut(duration: 0.3), value: appState.isControlEnabled)

                    // Custom animated toggle
                    ZStack {
                        // Background capsule
                        Capsule()
                            .fill(appState.isControlEnabled ? AppColors.accent : Color.gray.opacity(0.3))
                            .frame(width: 51, height: 31)

                        // Moving circle
                        HStack {
                            if !appState.isControlEnabled {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 27, height: 27)
                                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                                Spacer()
                            } else {
                                Spacer()
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 27, height: 27)
                                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                            }
                        }
                        .padding(.horizontal, 2)
                        .frame(width: 51, height: 31)
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                            appState.isControlEnabled.toggle()
                            appState.saveSettings()
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: 240)

                // Status description
                Text(appState.isControlEnabled ? "control_active".localized : "control_inactive".localized)
                    .font(.system(size: 15))
                    .foregroundColor(AppColors.secondaryText)
                    .animation(.easeInOut(duration: 0.3), value: appState.isControlEnabled)
            }

            // Divider
            Rectangle()
                .fill(AppColors.secondaryText.opacity(0.2))
                .frame(height: 1)
                .padding(.horizontal, -24)
        }
    }

    // MARK: - Settings Button View

    private var settingsButtonView: some View {
        Button(action: {
            showSettings = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "gearshape")
                    .font(.system(size: 20))
                Text("settings".localized)
                    .font(.system(size: 17))
            }
            .foregroundColor(AppColors.text.opacity(0.7))
        }
    }

    // MARK: - Helper Methods

    private func formatTimeRange() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: localizationManager.currentLanguage.rawValue == "ko" ? "ko_KR" : "en_US")

        let startStr = formatter.string(from: appState.slotStartTime)
        let endStr = formatter.string(from: appState.slotEndTime)

        return "\(startStr) ~ \(endStr)"
    }

    private func formatTimeRemaining() -> String {
        let remaining = appState.remainingMinutes
        let hours = remaining / 60
        let minutes = remaining % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    private func formatTimeRemainingDescription() -> String {
        let remaining = appState.remainingMinutes
        if remaining > 0 {
            return "min_remaining_description".localized(with: remaining)
        } else {
            return "locked_status".localized
        }
    }

    private func formatHours(_ minutes: Int) -> String {
        let hours = Double(minutes) / 60.0
        if hours.truncatingRemainder(dividingBy: 1) == 0 {
            return "hours_format".localized(with: Int(hours))
        } else {
            return "hours_minutes_format".localized(with: hours)
        }
    }

    // MARK: - Alert

    private var notificationPermissionAlert: Alert {
        Alert(
            title: Text("notification_permission_title".localized),
            message: Text("notification_permission_message".localized),
            primaryButton: .default(Text("notification_enable".localized)) {
                requestNotificationPermission()
            },
            secondaryButton: .cancel(Text("cancel".localized))
        )
    }

    // MARK: - Notification Permission Methods

    private func checkNotificationPermission() {
        NotificationManager.shared.checkAuthorizationStatus()

        if !NotificationManager.shared.isAuthorized {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showNotificationPermissionAlert = true
            }
        }
    }

    private func requestNotificationPermission() {
        Task {
            await NotificationManager.shared.requestAuthorization()
        }
    }
}

// MARK: - Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .environmentObject(AppStateManager())
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")

            MainView()
                .environmentObject(AppStateManager())
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
