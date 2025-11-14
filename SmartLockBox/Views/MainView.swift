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
        ScrollView {
            VStack(spacing: 24) {
                headerView

                // Time Slot Settings
                timeSlotSettingsSection

                // Show status if control is enabled
                if appState.isControlEnabled {
                    currentStatusSection
                    usageProgressSection
                }

                Spacer(minLength: 20)
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("ThinkFree")
        .foregroundColor(AppColors.text)
        .onAppear {
            checkNotificationPermission()
            appState.loadSettings()
        }
        .alert(isPresented: $showNotificationPermissionAlert) {
            notificationPermissionAlert
        }
        .preferredColorScheme(nil)
    }

    // MARK: - Header View

    private var headerView: some View {
        HStack {
            Text("📱 ThinkFree")
                .font(.title2.bold())
                .foregroundColor(AppColors.text)

            Spacer()

            LanguageSwitcher()
        }
    }

    // MARK: - Time Slot Settings Section

    private var timeSlotSettingsSection: some View {
        VStack(spacing: 16) {
            // Section Header
            HStack {
                Text("⏰ " + "time_slot".localized)
                    .font(.headline)
                    .foregroundColor(AppColors.text)
                Spacer()
            }

            // Time Range Display Box
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(AppColors.accent)
                    Text("time_slot_start".localized + ":")
                        .foregroundColor(AppColors.text)
                    Spacer()
                    DatePicker("", selection: $appState.slotStartTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }

                Divider()

                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(AppColors.accent)
                    Text("time_slot_end".localized + ":")
                        .foregroundColor(AppColors.text)
                    Spacer()
                    DatePicker("", selection: $appState.slotEndTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.secondaryBackground)
            )

            // Limit Time Section
            HStack {
                Text("⏱️ " + "limit_time".localized)
                    .font(.headline)
                    .foregroundColor(AppColors.text)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(formatHours(appState.limitMinutes))
                        .font(.title2.bold())
                        .foregroundColor(AppColors.accent)
                    Spacer()
                }

                Slider(
                    value: Binding(
                        get: { Double(appState.limitMinutes) / 60.0 },
                        set: { appState.limitMinutes = Int($0 * 60) }
                    ),
                    in: 0.5...8,
                    step: 0.5
                )
                .accentColor(AppColors.accent)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.secondaryBackground)
            )

            Divider()

            // Control Toggle
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("control_enabled".localized)
                        .font(.headline)
                        .foregroundColor(AppColors.text)
                    Text("control_enabled_description".localized)
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                Spacer()
                Toggle("", isOn: $appState.isControlEnabled)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: AppColors.accent))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .adaptiveShadow(radius: 8, opacity: 0.08, y: 4)
        )
        .onChange(of: appState.slotStartTime) { _ in appState.saveSettings() }
        .onChange(of: appState.slotEndTime) { _ in appState.saveSettings() }
        .onChange(of: appState.limitMinutes) { _ in appState.saveSettings() }
        .onChange(of: appState.isControlEnabled) { _ in appState.saveSettings() }
    }

    private func formatHours(_ minutes: Int) -> String {
        let hours = Double(minutes) / 60.0
        if hours.truncatingRemainder(dividingBy: 1) == 0 {
            return "hours_format".localized(with: Int(hours))
        } else {
            return "hours_minutes_format".localized(with: hours)
        }
    }

    // MARK: - Current Status Section

    private var currentStatusSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("📊 " + "today_status".localized)
                    .font(.headline)
                    .foregroundColor(AppColors.text)
                Spacer()
            }

            VStack(spacing: 12) {
                // Status Badge
                HStack {
                    if appState.isWithinTimeSlot {
                        statusIndicator(text: "🟢 " + "control_active".localized, color: .green)
                    } else {
                        statusIndicator(text: "⚪ " + "outside_time_slot".localized, color: .gray)
                    }
                    Spacer()
                }

                Divider()

                // Time Info
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("time_slot".localized)
                            .font(.caption)
                            .foregroundColor(AppColors.secondaryText)
                        Text("\(timeFormatter.string(from: appState.slotStartTime)) - \(timeFormatter.string(from: appState.slotEndTime))")
                            .font(.subheadline.bold())
                            .foregroundColor(AppColors.text)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("limit_time".localized)
                            .font(.caption)
                            .foregroundColor(AppColors.secondaryText)
                        Text(formatHours(appState.limitMinutes))
                            .font(.subheadline.bold())
                            .foregroundColor(AppColors.text)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.secondaryBackground)
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .adaptiveShadow(radius: 8, opacity: 0.08, y: 4)
        )
    }

    private func statusIndicator(text: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            Text(text)
                .font(.subheadline.bold())
                .foregroundColor(color)
        }
    }

    // MARK: - Usage Progress Section

    private var usageProgressSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("📈 " + "usage_tracking".localized)
                    .font(.headline)
                    .foregroundColor(AppColors.text)
                Spacer()
            }

            VStack(spacing: 16) {
                usageTimeDisplay
                linearProgressBar
                Divider()
                timeUntilLockDisplay
                warningMessage
                unlockButton
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.secondaryBackground)
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .adaptiveShadow(radius: 8, opacity: 0.08, y: 4)
        )
    }

    private var usageTimeDisplay: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("usage_time".localized)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                Text("\(appState.todayUsageMinutes) " + "minutes".localized + " / \(appState.limitMinutes) " + "minutes".localized)
                    .font(.title3.bold())
                    .foregroundColor(AppColors.text)
            }
            Spacer()
            circularProgressIndicator
        }
    }

    private var circularProgressIndicator: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                .frame(width: 60, height: 60)

            Circle()
                .trim(from: 0, to: CGFloat(min(Double(appState.usagePercentage) / 100.0, 1.0)))
                .stroke(progressBarColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(-90))

            Text("\(Int(appState.usagePercentage))%")
                .font(.caption.bold())
                .foregroundColor(progressBarColor)
        }
    }

    private var linearProgressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 12)

                RoundedRectangle(cornerRadius: 10)
                    .fill(progressBarColor)
                    .frame(
                        width: geometry.size.width * CGFloat(min(Double(appState.usagePercentage) / 100.0, 1.0)),
                        height: 12
                    )
            }
        }
        .frame(height: 12)
    }

    private var timeUntilLockDisplay: some View {
        HStack {
            Image(systemName: "clock.badge.exclamationmark")
                .foregroundColor(appState.remainingMinutes > 0 ? AppColors.accent : .red)
            Text("until_lock".localized + ":")
                .foregroundColor(AppColors.text)
            Spacer()
            Text(appState.remainingMinutes > 0 ? "min_remaining".localized(with: appState.remainingMinutes) : "locked_status".localized)
                .font(.subheadline.bold())
                .foregroundColor(appState.remainingMinutes > 0 ? AppColors.accent : .red)
        }
    }

    @ViewBuilder
    private var warningMessage: some View {
        if appState.usagePercentage >= 86 && appState.remainingMinutes > 0 {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("warning_will_lock_soon".localized)
                    .font(.subheadline)
                    .foregroundColor(.orange)
                Spacer()
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(8)
        }
    }

    @ViewBuilder
    private var unlockButton: some View {
        if appState.currentState == .locked {
            Button(action: {
                navigateToUnlock()
            }) {
                HStack {
                    Image(systemName: "lock.open.fill")
                    Text("creative_unlock".localized)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: Color.blue.opacity(0.3), radius: 8, y: 4)
            }
        }
    }

    // MARK: - Helper Views

    private var progressBarColor: Color {
        let percentage = appState.usagePercentage
        if percentage <= 60 {
            return .green
        } else if percentage <= 85 {
            return .yellow
        } else {
            return .red
        }
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
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

    // MARK: - Helper Methods

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

    private func navigateToUnlock() {
        appState.startUnlockChallenge()
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
