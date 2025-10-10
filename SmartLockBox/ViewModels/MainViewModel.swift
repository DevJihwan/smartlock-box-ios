//
//  MainViewModel.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var weeklyStats: WeeklyStats?
    @Published var monthlyStats: MonthlyStats?
    
    private let usageService = UsageDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadWeeklyStats()
        loadMonthlyStats()
    }
    
    func loadWeeklyStats() {
        weeklyStats = usageService.getWeeklyStats()
    }
    
    func loadMonthlyStats() {
        monthlyStats = usageService.getMonthlyStats()
    }
    
    func formatTime(minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)시간 \(mins)분"
    }
    
    func getExpectedLockTime(currentMinutes: Int, goalMinutes: Int) -> String {
        let remainingMinutes = goalMinutes - currentMinutes
        if remainingMinutes <= 0 {
            return "즉시 잠금"
        }
        
        let lockTime = Date().addingTimeInterval(TimeInterval(remainingMinutes * 60))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 mm분"
        return formatter.string(from: lockTime) + " 잠금"
    }
}
