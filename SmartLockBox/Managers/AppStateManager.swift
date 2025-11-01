//
//  AppStateManager.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import SwiftUI
import Combine

/// 앱의 전체 상태를 관리하는 중앙 매니저
class AppStateManager: ObservableObject {
    // MARK: - App State
    
    /// 현재 앱 잠금 상태
    enum AppState {
        case unlocked
        case locked
        case challengeActive
    }
    
    @Published var currentState: AppState = .unlocked
    
    // MARK: - Usage Tracking
    
    /// 오늘 사용한 시간 (분)
    @Published var todayUsageMinutes: Int = 0
    
    /// 일일 목표 시간 (분)
    @Published var dailyGoalMinutes: Int = 180 {
        didSet {
            UserDefaults.standard.set(dailyGoalMinutes, forKey: "dailyGoalMinutes")
            checkGoalStatus()
        }
    }
    
    /// 사용 비율 (%)
    var usagePercentage: Int {
        guard dailyGoalMinutes > 0 else { return 0 }
        return min(100, (todayUsageMinutes * 100) / dailyGoalMinutes)
    }
    
    /// 남은 사용 시간 (분)
    var remainingMinutes: Int {
        return max(0, dailyGoalMinutes - todayUsageMinutes)
    }
    
    // MARK: - Lock State
    
    /// 잠금 여부
    @Published var isLocked: Bool = false {
        didSet {
            currentState = isLocked ? .locked : .unlocked
            UserDefaults.standard.set(isLocked, forKey: "isLocked")
            
            if isLocked {
                // 잠금 시작 시간 저장
                lockStartTime = Date()
                calculateUnlockTime()
            } else {
                lockStartTime = nil
                unlockTime = nil
            }
        }
    }
    
    /// 잠금 시작 시간
    @Published var lockStartTime: Date? {
        didSet {
            if let time = lockStartTime {
                UserDefaults.standard.set(time, forKey: "lockStartTime")
            } else {
                UserDefaults.standard.removeObject(forKey: "lockStartTime")
            }
        }
    }
    
    /// 자동 해제 시간
    @Published var unlockTime: Date?
    
    /// 자동 해제 시간 설정 (시, 분)
    @Published var autoUnlockTime: (hour: Int, minute: Int) = (0, 0) {
        didSet {
            UserDefaults.standard.set(autoUnlockTime.hour, forKey: "autoUnlockHour")
            UserDefaults.standard.set(autoUnlockTime.minute, forKey: "autoUnlockMinute")
            calculateUnlockTime()
        }
    }
    
    // MARK: - Challenge State
    
    /// 해제 챌린지 진행 중
    @Published var isChallengeActive: Bool = false
    
    /// 오늘 시도한 챌린지 횟수
    @Published var todayChallengeAttempts: Int = 0 {
        didSet {
            UserDefaults.standard.set(todayChallengeAttempts, forKey: "todayChallengeAttempts")
        }
    }
    
    /// 최대 일일 시도 횟수
    let maxDailyAttempts: Int = 10
    
    /// 남은 시도 횟수
    var remainingAttempts: Int {
        return max(0, maxDailyAttempts - todayChallengeAttempts)
    }
    
    // MARK: - Screen Time Integration
    
    var screenTimeManager: ScreenTimeManager? = ScreenTimeManager.shared
    
    // MARK: - Initialization
    
    init() {
        loadSavedState()
        startUsageTimer()
        checkDailyReset()
    }
    
    // MARK: - Load/Save State
    
    private func loadSavedState() {
        // Load saved values from UserDefaults
        dailyGoalMinutes = UserDefaults.standard.integer(forKey: "dailyGoalMinutes")
        if dailyGoalMinutes == 0 {
            dailyGoalMinutes = 180 // Default 3 hours
        }
        
        isLocked = UserDefaults.standard.bool(forKey: "isLocked")
        todayChallengeAttempts = UserDefaults.standard.integer(forKey: "todayChallengeAttempts")
        todayUsageMinutes = UserDefaults.standard.integer(forKey: "todayUsageMinutes")
        
        // Load auto unlock time
        let hour = UserDefaults.standard.integer(forKey: "autoUnlockHour")
        let minute = UserDefaults.standard.integer(forKey: "autoUnlockMinute")
        autoUnlockTime = (hour: hour, minute: minute)
        
        // Load lock start time
        if let savedLockTime = UserDefaults.standard.object(forKey: "lockStartTime") as? Date {
            lockStartTime = savedLockTime
            calculateUnlockTime()
        }
        
        // Check if need to unlock
        checkAutoUnlock()
    }
    
    // MARK: - Usage Tracking
    
    private var usageTimer: Timer?
    
    private func startUsageTimer() {
        // Update usage every minute when app is active
        usageTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateUsage()
        }
    }
    
    private func updateUsage() {
        // In production, integrate with ScreenTimeManager
        // For now, simulate usage tracking
        guard !isLocked else { return }
        
        todayUsageMinutes += 1
        UserDefaults.standard.set(todayUsageMinutes, forKey: "todayUsageMinutes")
        
        checkGoalStatus()
    }
    
    private func checkGoalStatus() {
        // Auto-lock when goal is exceeded
        if todayUsageMinutes >= dailyGoalMinutes && !isLocked {
            enableLock()
        }
    }
    
    // MARK: - Lock Management
    
    func enableLock() {
        isLocked = true
        
        // Integrate with ScreenTimeManager
        screenTimeManager?.enableAppBlocking()
        
        print("🔒 Lock enabled - Usage: \(todayUsageMinutes)/\(dailyGoalMinutes) minutes")
    }
    
    func disableLock() {
        isLocked = false
        
        // Integrate with ScreenTimeManager
        screenTimeManager?.disableAppBlocking()
        
        print("🔓 Lock disabled")
    }
    
    private func calculateUnlockTime() {
        guard isLocked else { return }
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = autoUnlockTime.hour
        components.minute = autoUnlockTime.minute
        
        if let targetTime = calendar.date(from: components) {
            // If target time has passed today, set to tomorrow
            if targetTime <= Date() {
                unlockTime = calendar.date(byAdding: .day, value: 1, to: targetTime)
            } else {
                unlockTime = targetTime
            }
        }
    }
    
    private func checkAutoUnlock() {
        if isLocked, let unlock = unlockTime, unlock <= Date() {
            disableLock()
        }
    }
    
    // MARK: - Challenge Management
    
    func startUnlockChallenge() {
        guard !isChallengeActive else { return }
        guard remainingAttempts > 0 else {
            print("⚠️ No attempts remaining today")
            return
        }
        
        isChallengeActive = true
        currentState = .challengeActive
        todayChallengeAttempts += 1
        
        print("🎮 Challenge started - Attempts: \(todayChallengeAttempts)/\(maxDailyAttempts)")
    }
    
    func endUnlockChallenge(success: Bool) {
        isChallengeActive = false
        
        if success {
            disableLock()
            print("✅ Challenge succeeded - Lock disabled")
        } else {
            currentState = .locked
            print("❌ Challenge failed - Lock remains")
        }
    }
    
    func cancelUnlockChallenge() {
        isChallengeActive = false
        currentState = isLocked ? .locked : .unlocked
        // Don't decrement attempts - user already used one
    }
    
    // MARK: - Daily Reset
    
    private var lastResetDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastResetDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastResetDate")
        }
    }
    
    private func checkDailyReset() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastReset = lastResetDate {
            let lastResetDay = calendar.startOfDay(for: lastReset)
            
            if today > lastResetDay {
                performDailyReset()
            }
        } else {
            lastResetDate = today
        }
        
        // Schedule daily reset check
        Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            self?.checkDailyReset()
        }
    }
    
    private func performDailyReset() {
        print("🔄 Performing daily reset")
        
        // Reset daily counters
        todayUsageMinutes = 0
        todayChallengeAttempts = 0
        
        // Update last reset date
        lastResetDate = Calendar.current.startOfDay(for: Date())
        
        // Save to UserDefaults
        UserDefaults.standard.set(0, forKey: "todayUsageMinutes")
        UserDefaults.standard.set(0, forKey: "todayChallengeAttempts")
        
        // Check if should auto-unlock
        checkAutoUnlock()
    }
    
    // MARK: - Data Management
    
    func resetAllData() {
        print("🗑️ Resetting all data")
        
        // Reset all tracked data
        todayUsageMinutes = 0
        todayChallengeAttempts = 0
        dailyGoalMinutes = 180
        
        // Disable lock
        if isLocked {
            disableLock()
        }
        
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "todayUsageMinutes")
        UserDefaults.standard.removeObject(forKey: "todayChallengeAttempts")
        UserDefaults.standard.removeObject(forKey: "dailyGoalMinutes")
        UserDefaults.standard.removeObject(forKey: "isLocked")
        UserDefaults.standard.removeObject(forKey: "lockStartTime")
        UserDefaults.standard.removeObject(forKey: "lastResetDate")
        
        print("✅ All data reset complete")
    }
    
    deinit {
        usageTimer?.invalidate()
    }
}
