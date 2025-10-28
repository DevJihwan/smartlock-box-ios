//
//  LocalizationManager.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import SwiftUI

// MARK: - Language

enum AppLanguage: String, CaseIterable, Identifiable {
    case korean = "ko"
    case english = "en"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .korean:
            return "한국어"
        case .english:
            return "English"
        }
    }
    
    var shortCode: String {
        switch self {
        case .korean:
            return "KO"
        case .english:
            return "EN"
        }
    }
}

// MARK: - LocalizationManager

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
            updateBundle()
        }
    }
    
    private let languageKey = "appLanguage"
    private var bundle: Bundle?
    
    private init() {
        // 저장된 언어 불러오기
        if let savedLanguage = UserDefaults.standard.string(forKey: languageKey),
           let language = AppLanguage(rawValue: savedLanguage) {
            currentLanguage = language
        } else {
            // 기본 언어 설정 (시스템 언어 기반)
            let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            currentLanguage = systemLanguage.contains("ko") ? .korean : .english
        }
        
        updateBundle()
    }
    
    private func updateBundle() {
        if let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj") {
            bundle = Bundle(path: path)
        } else {
            bundle = Bundle.main
        }
    }
    
    func localizedString(_ key: String) -> String {
        return bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
    
    func changeLanguage(to language: AppLanguage) {
        currentLanguage = language
        // 언어 변경 알림 (중복 제거: LanguageManager.swift에 정의됨)
        NotificationCenter.default.post(name: .languageDidChange, object: nil)
    }
}

// MARK: - Localization Keys

struct LocalizationKey {
    // MARK: - Common
    static let appName = "app_name"
    static let ok = "ok"
    static let cancel = "cancel"
    static let confirm = "confirm"
    static let delete = "delete"
    static let save = "save"
    static let close = "close"
    static let settings = "settings"
    
    // MARK: - Main View
    static let todayGoal = "today_goal"
    static let timeUntilLock = "time_until_lock"
    static let weeklyStats = "weekly_stats"
    static let monthlyHeatmap = "monthly_heatmap"
    static let detailedStats = "detailed_stats"
    static let goalAchievement = "goal_achievement"
    static let averagePerDay = "average_per_day"
    static let achievementRate = "achievement_rate"
    static let goalAchieved = "goal_achieved"
    static let goalNotAchieved = "goal_not_achieved"
    
    // MARK: - Lock Screen
    static let locked = "locked"
    static let phoneLocked = "phone_locked"
    static let usedToday = "used_today"
    static let autoUnlockIn = "auto_unlock_in"
    static let unlockWithCreativity = "unlock_with_creativity"
    static let emergencyCall = "emergency_call"
    
    // MARK: - Unlock Challenge
    static let unlockChallenge = "unlock_challenge"
    static let challengeDescription = "challenge_description"
    static let word1 = "word1"
    static let word2 = "word2"
    static let enterSentence = "enter_sentence"
    static let minimumCharacters = "minimum_characters"
    static let currentCharacters = "current_characters"
    static let changeWords = "change_words"
    static let submit = "submit"
    static let evaluating = "evaluating"
    static let unlockSuccess = "unlock_success"
    static let unlockFailed = "unlock_failed"
    static let bothAiRequired = "both_ai_required"
    static let tryAgain = "try_again"
    static let backToLockScreen = "back_to_lock_screen"
    static let refreshLimitReached = "refresh_limit_reached"
    static let remainingRefreshes = "remaining_refreshes"
    static let evaluationLimitReached = "evaluation_limit_reached"
    static let remainingEvaluations = "remaining_evaluations"
    
    // MARK: - Settings
    static let dailyGoal = "daily_goal"
    static let autoUnlockTime = "auto_unlock_time"
    static let notifications = "notifications"
    static let screenTimePermission = "screen_time_permission"
    static let language = "language"
    static let dataManagement = "data_management"
    static let deleteAllData = "delete_all_data"
    static let version = "version"
    static let licenses = "licenses"
    
    // MARK: - Time
    static let hours = "hours"
    static let minutes = "minutes"
    static let seconds = "seconds"
    static let hoursShort = "hours_short"
    static let minutesShort = "minutes_short"
    static let secondsShort = "seconds_short"
    
    // MARK: - Days
    static let monday = "monday"
    static let tuesday = "tuesday"
    static let wednesday = "wednesday"
    static let thursday = "thursday"
    static let friday = "friday"
    static let saturday = "saturday"
    static let sunday = "sunday"
    
    // MARK: - Errors
    static let error = "error"
    static let networkError = "network_error"
    static let apiError = "api_error"
    static let permissionDenied = "permission_denied"
    static let unknownError = "unknown_error"
    
    // MARK: - AI Evaluation
    static let creative = "creative"
    static let notCreative = "not_creative"
    static let goodGrammar = "good_grammar"
    static let poorGrammar = "poor_grammar"
    static let meaningfulConnection = "meaningful_connection"
    static let lackingConnection = "lacking_connection"
}
