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
        case normal
        case locked
        case unlockChallenge
    }

    @Published var currentState: AppState = .normal
    
    // MARK: - Usage Tracking
    
    /// 오늘 사용한 시간 (분)
    @Published var todayUsageMinutes: Int = 0
    
    /// 일일 목표 시간 (분) - 0이면 미설정 상태
    @Published var dailyGoalMinutes: Int = 0 {
        didSet {
            UserDefaults.standard.set(dailyGoalMinutes, forKey: "dailyGoalMinutes")
            checkGoalStatus()
        }
    }

    /// 목표 시간이 설정되어 있는지 여부
    var hasGoalSet: Bool {
        return dailyGoalMinutes > 0
    }
    
    /// 사용 비율 (%)
    var usagePercentage: Int {
        // v2.0: Use limitMinutes instead of dailyGoalMinutes
        guard limitMinutes > 0 else { return 0 }
        return min(100, (todayUsageMinutes * 100) / limitMinutes)
    }

    /// 남은 사용 시간 (분)
    var remainingMinutes: Int {
        // v2.0: Use limitMinutes instead of dailyGoalMinutes
        return max(0, limitMinutes - todayUsageMinutes)
    }
    
    // MARK: - Lock State
    
    /// 잠금 여부
    @Published var isLocked: Bool = false {
        didSet {
            currentState = isLocked ? .locked : .normal
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

    // MARK: - Streak Tracking

    /// 연속 달성 일수
    @Published var currentStreak: Int = 0 {
        didSet {
            UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        }
    }

    /// 마지막 목표 달성 날짜
    private var lastGoalMetDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastGoalMetDate") as? Date
        }
        set {
            if let date = newValue {
                UserDefaults.standard.set(date, forKey: "lastGoalMetDate")
            } else {
                UserDefaults.standard.removeObject(forKey: "lastGoalMetDate")
            }
        }
    }

    // MARK: - Screen Time Integration

    var screenTimeManager: ScreenTimeManager? = ScreenTimeManager.shared

    // MARK: - Time Slot Control Settings (v2.0)

    @Published var isControlEnabled: Bool = false
    @Published var slotStartTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
    @Published var slotEndTime: Date = Calendar.current.date(from: DateComponents(hour: 18, minute: 0))!  // Changed to 6 PM
    @Published var limitMinutes: Int = 120 // 2 hours by default


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
        // 0이면 미설정 상태로 유지

        // Load time slot control settings
        isControlEnabled = UserDefaults.standard.bool(forKey: "isControlEnabled")
        if let startTime = UserDefaults.standard.object(forKey: "slotStartTime") as? Date {
            slotStartTime = startTime
        }
        if let endTime = UserDefaults.standard.object(forKey: "slotEndTime") as? Date {
            slotEndTime = endTime
        }
        let savedLimit = UserDefaults.standard.integer(forKey: "limitMinutes")
        if savedLimit > 0 {
            limitMinutes = savedLimit
        }

        // Load streak
        currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")

        // If no goal is set, ensure the app is not locked
        if !hasGoalSet {
            isLocked = false
        } else {
            isLocked = UserDefaults.standard.bool(forKey: "isLocked")
        }

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

    func saveSettings() {
        UserDefaults.standard.set(isControlEnabled, forKey: "isControlEnabled")
        UserDefaults.standard.set(slotStartTime, forKey: "slotStartTime")
        UserDefaults.standard.set(slotEndTime, forKey: "slotEndTime")
        UserDefaults.standard.set(limitMinutes, forKey: "limitMinutes")
    }

    func loadSettings() {
        loadSavedState()
    }

    // Check if current time is within the time slot
    var isWithinTimeSlot: Bool {
        let now = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)

        let startHour = calendar.component(.hour, from: slotStartTime)
        let startMinute = calendar.component(.minute, from: slotStartTime)
        let endHour = calendar.component(.hour, from: slotEndTime)
        let endMinute = calendar.component(.minute, from: slotEndTime)

        let currentTimeInMinutes = currentHour * 60 + currentMinute
        let startTimeInMinutes = startHour * 60 + startMinute
        let endTimeInMinutes = endHour * 60 + endMinute

        return currentTimeInMinutes >= startTimeInMinutes && currentTimeInMinutes < endTimeInMinutes
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
        // Debug log
        print("⏱️ Update usage called - Control: \(isControlEnabled), InTimeSlot: \(isWithinTimeSlot), Locked: \(isLocked)")

        // v2.0: Only count usage when control is enabled and within time slot
        guard isControlEnabled else {
            print("⚠️ Usage not counted - Control is disabled")
            return
        }

        guard isWithinTimeSlot else {
            print("⚠️ Usage not counted - Outside time slot")
            let calendar = Calendar.current
            let now = Date()
            let currentHour = calendar.component(.hour, from: now)
            let currentMinute = calendar.component(.minute, from: now)
            let startHour = calendar.component(.hour, from: slotStartTime)
            let startMinute = calendar.component(.minute, from: slotStartTime)
            let endHour = calendar.component(.hour, from: slotEndTime)
            let endMinute = calendar.component(.minute, from: slotEndTime)
            print("   Current time: \(currentHour):\(currentMinute)")
            print("   Time slot: \(startHour):\(startMinute) - \(endHour):\(endMinute)")
            return
        }

        guard !isLocked else {
            print("⚠️ Usage not counted - App is locked")
            return
        }

        // Update total usage
        todayUsageMinutes += 1
        UserDefaults.standard.set(todayUsageMinutes, forKey: "todayUsageMinutes")

        print("📊 Usage updated: \(todayUsageMinutes)/\(limitMinutes) minutes (remaining: \(remainingMinutes))")

        checkGoalStatus()
    }
    
    private func checkGoalStatus() {
        // v2.0: Only check if control is enabled
        guard isControlEnabled else { return }

        // v2.0: Lock when usage exceeds limit during time slot
        let shouldLock = todayUsageMinutes >= limitMinutes

        if shouldLock && !isLocked {
            enableLock()
        }
    }
    
    // MARK: - Lock Management
    
    func enableLock() {
        isLocked = true

        // Integrate with ScreenTimeManager
        screenTimeManager?.enableAppBlocking()

        print("🔒 Lock enabled - Usage: \(todayUsageMinutes)/\(limitMinutes) minutes")
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
        currentState = .unlockChallenge
        todayChallengeAttempts += 1

        print("🎮 Challenge started - Attempts: \(todayChallengeAttempts)/\(maxDailyAttempts)")
    }

    func endUnlockChallenge(success: Bool) {
        isChallengeActive = false

        if success {
            // Reset usage time when challenge is succeeded
            todayUsageMinutes = 0
            UserDefaults.standard.set(0, forKey: "todayUsageMinutes")

            disableLock()
            print("✅ Challenge succeeded - Lock disabled, usage reset to 0")
        } else {
            currentState = .locked
            print("❌ Challenge failed - Lock remains")
        }
    }

    func cancelUnlockChallenge() {
        isChallengeActive = false
        currentState = isLocked ? .locked : .normal
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

        // Check yesterday's goal achievement before reset
        updateStreak()

        // Reset daily counters
        todayUsageMinutes = 0
        todayChallengeAttempts = 0

        // Update last reset date
        lastResetDate = Calendar.current.startOfDay(for: Date())

        // Save to UserDefaults
        UserDefaults.standard.set(0, forKey: "todayUsageMinutes")
        UserDefaults.standard.set(0, forKey: "todayChallengeAttempts")

        // Unlock when daily reset happens (usage is now 0)
        if isLocked {
            disableLock()
            print("🔓 Daily reset: Lock automatically disabled")
        }

        // Also check if should auto-unlock based on time
        checkAutoUnlock()
    }

    /// 연속 달성 일수 업데이트
    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // v2.0: Goal is to NOT exceed limit during time slot
        let goalMet = todayUsageMinutes < limitMinutes

        if goalMet {
            // Check if this continues the streak
            if let lastDate = lastGoalMetDate {
                let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
                let lastDateStart = calendar.startOfDay(for: lastDate)

                if lastDateStart == yesterday {
                    // Continue streak
                    currentStreak += 1
                    print("📈 Streak continued: \(currentStreak) days")
                } else if lastDateStart < yesterday {
                    // Streak broken, start new
                    currentStreak = 1
                    print("🔄 Streak broken, starting new: 1 day")
                }
                // If lastDate == today, don't update (already counted)
            } else {
                // First goal met
                currentStreak = 1
                print("🎉 First goal met! Streak: 1 day")
            }

            lastGoalMetDate = today
        } else {
            // Goal not met
            if let lastDate = lastGoalMetDate {
                let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
                let lastDateStart = calendar.startOfDay(for: lastDate)

                if lastDateStart == yesterday {
                    // Streak broken
                    currentStreak = 0
                    lastGoalMetDate = nil
                    print("💔 Goal not met, streak reset to 0")
                }
            }
        }
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
