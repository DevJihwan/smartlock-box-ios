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
    
    /// 예상 잠금 시간을 Date로 반환
    func getExpectedLockTime(currentMinutes: Int, goalMinutes: Int) -> Date {
        let remainingMinutes = goalMinutes - currentMinutes
        
        if remainingMinutes <= 0 {
            // 즉시 잠금
            return Date()
        }
        
        // 남은 시간 후의 Date 반환
        return Date().addingTimeInterval(TimeInterval(remainingMinutes * 60))
    }
}
