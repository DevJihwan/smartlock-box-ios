//
//  AppStateManager.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import Combine

class AppStateManager: ObservableObject {
    @Published var currentState: AppState = .normal
    @Published var todayUsageMinutes: Int = 150 // 2시간 30분
    @Published var dailyGoalMinutes: Int = 180 // 3시간
    @Published var unlockTime: Date?
    
    var remainingMinutes: Int {
        return max(0, dailyGoalMinutes - todayUsageMinutes)
    }
    
    var usagePercentage: Double {
        return Double(todayUsageMinutes) / Double(dailyGoalMinutes) * 100
    }
    
    var progressColor: String {
        let percentage = usagePercentage
        if percentage <= 60 {
            return "green"
        } else if percentage <= 85 {
            return "yellow"
        } else {
            return "red"
        }
    }
    
    func checkAndLockIfNeeded() {
        if todayUsageMinutes >= dailyGoalMinutes {
            lockDevice()
        }
    }
    
    func lockDevice() {
        currentState = .locked
        // 다음날 0시로 설정
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.day! += 1
        components.hour = 0
        components.minute = 0
        unlockTime = Calendar.current.date(from: components)
    }
    
    func unlockDevice() {
        currentState = .normal
        unlockTime = nil
    }
    
    func startUnlockChallenge() {
        currentState = .unlockChallenge
    }
}
