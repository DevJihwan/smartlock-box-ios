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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 오늘의 목표 달성률
                    TodayGoalCard(
                        usageMinutes: appState.todayUsageMinutes,
                        goalMinutes: appState.dailyGoalMinutes,
                        percentage: appState.usagePercentage,
                        progressColor: appState.progressColor
                    )
                    
                    // 잠금까지 남은 시간
                    TimeUntilLockCard(
                        remainingMinutes: appState.remainingMinutes,
                        expectedLockTime: viewModel.getExpectedLockTime(
                            currentMinutes: appState.todayUsageMinutes,
                            goalMinutes: appState.dailyGoalMinutes
                        )
                    )
                    
                    // 이번 주 사용 현황
                    if let weeklyStats = viewModel.weeklyStats {
                        WeeklyStatsCard(stats: weeklyStats)
                    }
                    
                    // 월간 목표 달성 현황
                    if let monthlyStats = viewModel.monthlyStats {
                        MonthlyHeatmapCard(stats: monthlyStats)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("📱 바보상자자물쇠")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: DetailedStatsView()) {
                        Image(systemName: "chart.bar.fill")
                    }
                }
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
