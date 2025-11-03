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
                goalAchievementSection
                timeRemainingSection
                weeklyStatsSection
                monthlyHeatmapSection
                Spacer(minLength: 20)
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("app_name".localized)
        .foregroundColor(AppColors.text)
        .toolbar {
            toolbarContent
        }
        .onAppear {
            checkNotificationPermission()
        }
        .alert(isPresented: $showNotificationPermissionAlert) {
            notificationPermissionAlert
        }
        .preferredColorScheme(nil)
    }
    
    // MARK: - Header View

    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Spacer()
                LanguageSwitcher()
                    .padding(.top, 4)
            }

            // Debug info
            Text("Current: \(localizationManager.currentLanguage.displayName)")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("app_name".localized)
                .font(.caption)
                .foregroundColor(.blue)
        }
    }
    
    // MARK: - Goal Achievement Section
    
    private var goalAchievementSection: some View {
        VStack(spacing: 16) {
            Text("today_goal".localized)
                .font(.title2.bold())
                .foregroundColor(AppColors.text)
            
            progressBar
            lockStatusView
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .adaptiveShadow()
        )
    }
    
    private var progressBar: some View {
        AnimatedProgressBarWithLabel(
            value: Double(appState.todayUsageMinutes),
            maxValue: Double(appState.dailyGoalMinutes),
            title: "usage_minutes".localized(with: appState.todayUsageMinutes),
            subtitle: appState.usagePercentage < 100
                ? "remaining_minutes".localized(with: max(0, appState.remainingMinutes))
                : "goal_exceeded".localized(with: appState.todayUsageMinutes - appState.dailyGoalMinutes),
            foregroundColor: AppColors.progressColor(percentage: Double(appState.usagePercentage))
        )
    }
    
    private var lockStatusView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(appState.currentState == .locked
                     ? "status_locked".localized
                     : "status_unlocked".localized)
                    .font(.headline)
                    .foregroundColor(appState.currentState == .locked ? AppColors.lock : AppColors.unlock)
                
                Text(appState.currentState == .locked
                     ? "tap_to_unlock".localized
                     : "auto_locks".localized(with: Int(appState.usagePercentage)))
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            PulsatingLockButton(
                isLocked: Binding<Bool>(
                    get: { appState.currentState == .locked },
                    set: { _ in }
                ),
                onTap: {
                    if appState.currentState == .locked {
                        navigateToUnlock()
                    }
                },
                size: 60
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.secondaryBackground)
        )
    }
    
    // MARK: - Time Remaining Section
    
    private var timeRemainingSection: some View {
        TimeRemainingView(
            remainingMinutes: appState.remainingMinutes,
            expectedLockTime: viewModel.getExpectedLockTime(
                currentMinutes: appState.todayUsageMinutes,
                goalMinutes: appState.dailyGoalMinutes
            )
        )
    }
    
    // MARK: - Weekly Stats Section
    
    @ViewBuilder
    private var weeklyStatsSection: some View {
        if let weeklyStats = viewModel.weeklyStats {
            WeeklyStatsCard(stats: weeklyStats)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardBackground)
                        .adaptiveShadow()
                )
        }
    }
    
    // MARK: - Monthly Heatmap Section
    
    @ViewBuilder
    private var monthlyHeatmapSection: some View {
        if let monthlyStats = viewModel.monthlyStats {
            MonthlyHeatmapCard(stats: monthlyStats)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardBackground)
                        .adaptiveShadow()
                )
        }
    }
    
    // MARK: - Toolbar Content
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination: DetailedStatsView()) {
                Image(systemName: "chart.bar.fill")
                    .imageScale(.large)
                    .foregroundColor(AppColors.accent)
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .foregroundColor(AppColors.accent)
            }
        }
    }
    
    // MARK: - Alert
    
    private var notificationPermissionAlert: Alert {
        Alert(
            title: Text("notification_permission_title".localized),
            message: Text("notification_permission_required".localized),
            primaryButton: .default(Text("notification_request".localized)) {
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

// MARK: - Time Remaining View

struct TimeRemainingView: View {
    let remainingMinutes: Int
    let expectedLockTime: Date
    
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Text("time_until_lock".localized)
                .font(.headline)
                .foregroundColor(AppColors.text)
            
            timeDisplay
            expectedLockTimeText
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .adaptiveShadow()
        )
        .onAppear {
            startAnimation()
        }
    }
    
    private var timeDisplay: some View {
        HStack(spacing: 20) {
            timeUnit(value: remainingMinutes / 60, label: "hours".localized)
            timeSeparator
            timeUnit(value: remainingMinutes % 60, label: "minutes".localized)
        }
        .padding()
    }
    
    private func timeUnit(value: Int, label: String) -> some View {
        VStack {
            Text("\(value)")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.text)
            Text(label)
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(width: 80)
        .scaleEffect(isAnimating ? 1.05 : 1.0)
    }
    
    private var timeSeparator: some View {
        Text(":")
            .font(.system(size: 36, weight: .bold))
            .foregroundColor(AppColors.secondaryText)
            .offset(y: -4)
    }
    
    private var expectedLockTimeText: some View {
        let formattedTime = expectedLockTime.formatted(date: .omitted, time: .shortened)
        let localizedFormat = NSLocalizedString("expected_lock_time", comment: "Expected lock time format")
        let finalText = String(format: localizedFormat, formattedTime)
        
        return Text(finalText)
            .font(.subheadline)
            .foregroundColor(AppColors.secondaryText)
    }
    
    private func startAnimation() {
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
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
