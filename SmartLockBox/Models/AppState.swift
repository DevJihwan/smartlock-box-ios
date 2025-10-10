//
//  AppState.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation

enum AppState {
    case normal
    case locked
    case unlockChallenge
}

struct UsageData: Codable {
    let date: Date
    let usageMinutes: Int
    let goalMinutes: Int
    let achieved: Bool
    
    var percentage: Double {
        return Double(usageMinutes) / Double(goalMinutes) * 100
    }
}

struct WeeklyStats {
    let totalMinutes: Int
    let goalMinutes: Int
    let averageMinutesPerDay: Double
    
    var percentage: Double {
        return Double(totalMinutes) / Double(goalMinutes) * 100
    }
}

struct MonthlyStats {
    let achievedDays: Int
    let totalDays: Int
    let dailyData: [UsageData]
    
    var achievementRate: Double {
        return Double(achievedDays) / Double(totalDays) * 100
    }
}
