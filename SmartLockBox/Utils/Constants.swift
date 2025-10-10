//
//  Constants.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation

enum Constants {
    // MARK: - 기본 설정
    enum Settings {
        static let defaultDailyGoalMinutes = 180 // 3시간
        static let minGoalMinutes = 60 // 1시간
        static let maxGoalMinutes = 480 // 8시간
        static let defaultAutoUnlockHour = 0 // 자정
    }
    
    // MARK: - 창의적 해제
    enum UnlockChallenge {
        static let minSentenceLength = 10
        static let maxDailyAttempts = 10
        static let maxDailyWordRefresh = 3
        static let apiTimeout: TimeInterval = 30.0
    }
    
    // MARK: - API
    enum API {
        static let openAIEndpoint = "https://api.openai.com/v1/chat/completions"
        static let anthropicEndpoint = "https://api.anthropic.com/v1/messages"
        static let openAIModel = "gpt-4"
        static let claudeModel = "claude-3-opus-20240229"
    }
    
    // MARK: - 알림
    enum Notifications {
        static let goalApproachingMinutes = 10
        static let dailyReportHour = 21 // 오후 9시
    }
    
    // MARK: - 통계
    enum Statistics {
        static let daysInWeek = 7
        static let daysInMonth = 30
        static let monthsInYear = 12
    }
    
    // MARK: - UI
    enum UI {
        static let cardCornerRadius: CGFloat = 16
        static let cardShadowRadius: CGFloat = 5
        static let defaultPadding: CGFloat = 16
        static let animationDuration: Double = 0.3
    }
}
