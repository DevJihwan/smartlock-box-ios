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
                        
                        AnimatedProgressBarWithLabel(
                            value: Double(appState.todayUsageMinutes),
                            maxValue: Double(appState.dailyGoalMinutes),
                            title: "usage_minutes".localized(with: appState.todayUsageMinutes),
                            subtitle: appState.usagePercentage < 100 
                                ? "remaining_minutes".localized(with: max(0, appState.remainingMinutes))
                                : "goal_exceeded".localized(with: appState.todayUsageMinutes - appState.dailyGoalMinutes),
                            foregroundColor: appState.progressColor
                        )
                        
                        // Lock status and action
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(appState.isLocked 
                                     ? "status_locked".localized
                                     : "status_unlocked".localized)
                                    .font(.headline)
                                    .foregroundColor(appState.isLocked ? .red : .green)
                                
                                Text(appState.isLocked
                                     ? "tap_to_unlock".localized
                                     : "auto_locks".localized(with: Int(appState.usagePercentage)))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
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
                                .fill(Color(.systemGray6))
                        )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
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
                    }
                    
                    // Monthly heatmap
                    if let monthlyStats = viewModel.monthlyStats {
                        MonthlyHeatmapCard(stats: monthlyStats)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("app_name".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: DetailedStatsView()) {
                        Image(systemName: "chart.bar.fill")
                            .imageScale(.large)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .imageScale(.large)
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
                secondaryButton: .cancel()
            )
        }
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
    
    var body: some View {
        VStack(spacing: 12) {
            Text("time_until_lock".localized)
                .font(.headline)
            
            HStack(spacing: 20) {
                VStack {
                    Text("\(remainingMinutes / 60)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("hours".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(width: 80)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
                
                Text(":")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.secondary)
                    .offset(y: -4)
                
                VStack {
                    Text("\(remainingMinutes % 60)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("minutes".localized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(width: 80)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
            }
            .padding()
            
            Text("expected_lock_time".localized(with: expectedLockTime.formatted(date: .omitted, time: .shortened)))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
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
        MainView()
            .environmentObject(AppStateManager())
    }
}
