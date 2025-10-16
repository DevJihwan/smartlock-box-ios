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
    @State private var showNotificationPermissionAlert = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Language switcher
                    HStack {
                        Spacer()
                        LanguageSwitcher()
                            .padding(.top, 4)
                    }
                    
                    // Today's goal achievement
                    VStack(spacing: 16) {
                        Text("today_goal".localized)
                            .font(.title2.bold())
                            .foregroundColor(AppColors.text)
                        
                        AnimatedProgressBarWithLabel(
                            value: Double(appState.todayUsageMinutes),
                            maxValue: Double(appState.dailyGoalMinutes),
                            title: "usage_minutes".localized(with: appState.todayUsageMinutes),
                            subtitle: appState.usagePercentage < 100 
                                ? "remaining_minutes".localized(with: max(0, appState.remainingMinutes))
                                : "goal_exceeded".localized(with: appState.todayUsageMinutes - appState.dailyGoalMinutes),
                            foregroundColor: AppColors.progressColor(percentage: appState.usagePercentage)
                        )
                        
                        // Lock status and action
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(appState.isLocked 
                                     ? "status_locked".localized
                                     : "status_unlocked".localized)
                                    .font(.headline)
                                    .foregroundColor(appState.isLocked ? AppColors.lock : AppColors.unlock)
                                
                                Text(appState.isLocked
                                     ? "tap_to_unlock".localized
                                     : "auto_locks".localized(with: Int(appState.usagePercentage)))
                                    .font(.subheadline)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            
                            Spacer()
                            
                            PulsatingLockButton(
                                isLocked: $appState.isLocked,
                                onTap: {
                                    if appState.isLocked {
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
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.cardBackground)
                            .adaptiveShadow()
                    )
                    
                    // Time until lock
                    TimeRemainingView(
                        remainingMinutes: appState.remainingMinutes,
                        expectedLockTime: viewModel.getExpectedLockTime(
                            currentMinutes: appState.todayUsageMinutes,
                            goalMinutes: appState.dailyGoalMinutes
                        )
                    )
                    
                    // Weekly stats
                    if let weeklyStats = viewModel.weeklyStats {
                        WeeklyStatsCard(stats: weeklyStats)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppColors.cardBackground)
                                    .adaptiveShadow()
                            )
                    }
                    
                    // Monthly heatmap
                    if let monthlyStats = viewModel.monthlyStats {
                        MonthlyHeatmapCard(stats: monthlyStats)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppColors.cardBackground)
                                    .adaptiveShadow()
                            )
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("app_name".localized)
            .foregroundColor(AppColors.text)
            .toolbar {
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
        }
        .onAppear {
            // Check notification permission on appear
            checkNotificationPermission()
        }
        .alert(isPresented: $showNotificationPermissionAlert) {
            Alert(
                title: Text("notification_permission_title".localized),
                message: Text("notification_permission_required".localized),
                primaryButton: .default(Text("notification_request".localized)) {
                    requestNotificationPermission()
                },
                secondaryButton: .cancel(Text("cancel".localized))
            )
        }
        .preferredColorScheme(nil) // 시스템 설정 사용
    }
    
    private func checkNotificationPermission() {
        NotificationManager.shared.checkAuthorizationStatus()
        
        // If permission is needed, show alert after a delay
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
        // Navigate to unlock challenge view
        appState.currentView = .unlockChallenge
    }
}

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
            
            HStack(spacing: 20) {
                VStack {
                    Text("\(remainingMinutes / 60)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.text)
                    Text("hours".localized)
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(width: 80)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
                
                Text(":")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(AppColors.secondaryText)
                    .offset(y: -4)
                
                VStack {
                    Text("\(remainingMinutes % 60)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.text)
                    Text("minutes".localized)
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(width: 80)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
            }
            .padding()
            
            Text("expected_lock_time".localized(with: expectedLockTime.formatted(date: .omitted, time: .shortened)))
                .font(.subheadline)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .adaptiveShadow()
        )
        .onAppear {
            // Start pulsating animation
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

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
