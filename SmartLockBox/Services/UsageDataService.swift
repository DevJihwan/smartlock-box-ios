//
//  UsageDataService.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation

class UsageDataService {
    static let shared = UsageDataService()
    
    private init() {}
    
    func getWeeklyStats() -> WeeklyStats {
        // TODO: Core Data에서 실제 데이터 가져오기
        // 임시 샘플 데이터
        return WeeklyStats(
            totalMinutes: 1110, // 18시간 30분
            goalMinutes: 1260, // 21시간 (3시간 x 7일)
            averageMinutesPerDay: 158.57 // 약 2시간 38분
        )
    }
    
    func getMonthlyStats() -> MonthlyStats {
        // TODO: Core Data에서 실제 데이터 가져오기
        // 임시 샘플 데이터 (30일)
        var dailyData: [UsageData] = []
        let calendar = Calendar.current
        let today = Date()
        
        for day in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -day, to: today) else { continue }
            
            // 랜덤하게 목표 달성 여부 결정 (87% 달성률)
            let achieved = Double.random(in: 0...1) < 0.87
            let usageMinutes = achieved ? Int.random(in: 120...180) : Int.random(in: 181...240)
            
            dailyData.append(UsageData(
                date: date,
                usageMinutes: usageMinutes,
                goalMinutes: 180,
                achieved: achieved
            ))
        }
        
        dailyData.sort { $0.date > $1.date }
        
        let achievedDays = dailyData.filter { $0.achieved }.count
        
        return MonthlyStats(
            achievedDays: achievedDays,
            totalDays: 30,
            dailyData: dailyData
        )
    }
    
    func saveUsageData(date: Date, usageMinutes: Int, goalMinutes: Int) {
        // TODO: Core Data에 저장
    }
    
    func getTodayUsage() -> UsageData? {
        // TODO: Core Data에서 오늘 데이터 가져오기
        return nil
    }
}
