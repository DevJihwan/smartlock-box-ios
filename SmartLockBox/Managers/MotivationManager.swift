//
//  MotivationManager.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-04.
//  Manages motivational messages based on user achievement data
//

import Foundation
import SwiftUI

/// Manages motivational messages based on user usage patterns
class MotivationManager: ObservableObject {

    // MARK: - Singleton

    static let shared = MotivationManager()

    // MARK: - Published Properties

    @Published var currentMotivation: Motivation?
    @Published var showMotivationMessages: Bool {
        didSet {
            UserDefaults.standard.set(showMotivationMessages, forKey: UserDefaultsKeys.showMotivation)
        }
    }

    // MARK: - Types

    struct Motivation {
        let message: String
        let icon: String
        let type: MessageType
        let streakDays: Int?

        enum MessageType {
            case welcome      // 1일차
            case success      // 성공
            case retry        // 재도전
            case streak       // 연속 달성

            var backgroundColor: Color {
                switch self {
                case .welcome:
                    return Color.blue.opacity(0.1)
                case .success:
                    return Color.green.opacity(0.1)
                case .retry:
                    return Color.blue.opacity(0.1)
                case .streak:
                    return Color.orange.opacity(0.1)
                }
            }
        }
    }

    // MARK: - UserDefaults Keys

    private enum UserDefaultsKeys {
        static let totalUsageDays = "totalUsageDays"
        static let yesterdayAchieved = "yesterdayAchieved"
        static let consecutiveAchievementDays = "consecutiveAchievementDays"
        static let lastLoginDate = "lastLoginDate"
        static let dailyAchievementHistory = "dailyAchievementHistory"
        static let showMotivation = "showMotivationMessages"
    }

    // MARK: - Properties

    private var totalUsageDays: Int {
        get { UserDefaults.standard.integer(forKey: UserDefaultsKeys.totalUsageDays) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.totalUsageDays) }
    }

    private var yesterdayAchieved: Bool {
        get { UserDefaults.standard.bool(forKey: UserDefaultsKeys.yesterdayAchieved) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.yesterdayAchieved) }
    }

    private var consecutiveAchievementDays: Int {
        get { UserDefaults.standard.integer(forKey: UserDefaultsKeys.consecutiveAchievementDays) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.consecutiveAchievementDays) }
    }

    private var lastLoginDate: Date? {
        get { UserDefaults.standard.object(forKey: UserDefaultsKeys.lastLoginDate) as? Date }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.lastLoginDate) }
    }

    // MARK: - Initialization

    private init() {
        self.showMotivationMessages = UserDefaults.standard.object(forKey: UserDefaultsKeys.showMotivation) as? Bool ?? true
        updateDailyData()
        updateMotivation()
    }

    // MARK: - Public Methods

    /// Update motivation message based on current data
    func updateMotivation() {
        guard showMotivationMessages else {
            currentMotivation = nil
            return
        }

        let usageDays = totalUsageDays
        let streakDays = consecutiveAchievementDays

        if usageDays == 1 {
            // 1일차
            currentMotivation = Motivation(
                message: "motivation.day1".localized,
                icon: "💪",
                type: .welcome,
                streakDays: nil
            )
        } else if streakDays >= 3 {
            // 연속 달성
            let streakMessage = getStreakMessage(for: streakDays)
            currentMotivation = Motivation(
                message: streakMessage,
                icon: "🔥",
                type: .streak,
                streakDays: streakDays
            )
        } else if yesterdayAchieved {
            // 어제 성공
            currentMotivation = Motivation(
                message: "motivation.success".localized,
                icon: "🎉",
                type: .success,
                streakDays: nil
            )
        } else {
            // 어제 실패
            currentMotivation = Motivation(
                message: "motivation.retry".localized,
                icon: "💙",
                type: .retry,
                streakDays: nil
            )
        }
    }

    /// Record today's achievement
    func recordTodayAchievement(achieved: Bool) {
        yesterdayAchieved = achieved

        if achieved {
            consecutiveAchievementDays += 1
        } else {
            consecutiveAchievementDays = 0
        }

        // Save to history
        let today = Calendar.current.startOfDay(for: Date())
        var history = getDailyAchievementHistory()
        history[today] = achieved
        saveDailyAchievementHistory(history)

        updateMotivation()
    }

    /// Check if today is a new day and update usage days
    func updateDailyData() {
        let today = Calendar.current.startOfDay(for: Date())

        if let lastLogin = lastLoginDate {
            let lastLoginDay = Calendar.current.startOfDay(for: lastLogin)

            if today > lastLoginDay {
                // New day
                totalUsageDays += 1

                // Check if yesterday's goal was achieved
                checkYesterdayAchievement()
            }
        } else {
            // First time
            totalUsageDays = 1
            consecutiveAchievementDays = 0
        }

        lastLoginDate = Date()
    }

    // MARK: - Private Methods

    private func getStreakMessage(for days: Int) -> String {
        switch days {
        case 7:
            return String(format: "motivation.streak_week".localized, days)
        case 30:
            return String(format: "motivation.streak_month".localized, days)
        case 100:
            return String(format: "motivation.streak_hundred".localized, days)
        default:
            return String(format: "motivation.streak".localized, days)
        }
    }

    private func checkYesterdayAchievement() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let yesterdayStart = Calendar.current.startOfDay(for: yesterday)

        let history = getDailyAchievementHistory()
        if let achieved = history[yesterdayStart] {
            yesterdayAchieved = achieved

            if achieved {
                consecutiveAchievementDays += 1
            } else {
                consecutiveAchievementDays = 0
            }
        }
    }

    private func getDailyAchievementHistory() -> [Date: Bool] {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.dailyAchievementHistory),
              let history = try? JSONDecoder().decode([String: Bool].self, from: data) else {
            return [:]
        }

        let formatter = ISO8601DateFormatter()
        var result: [Date: Bool] = [:]
        for (key, value) in history {
            if let date = formatter.date(from: key) {
                result[date] = value
            }
        }
        return result
    }

    private func saveDailyAchievementHistory(_ history: [Date: Bool]) {
        let formatter = ISO8601DateFormatter()
        var stringDict: [String: Bool] = [:]
        for (date, value) in history {
            stringDict[formatter.string(from: date)] = value
        }

        if let data = try? JSONEncoder().encode(stringDict) {
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.dailyAchievementHistory)
        }
    }
}
