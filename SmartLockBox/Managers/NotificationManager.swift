//
//  NotificationManager.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import UserNotifications

/// 알림 타입
enum NotificationType: String {
    case goalApproaching = "goalApproaching"
    case locked = "locked"
    case unlocked = "unlocked"
    case dailyReport = "dailyReport"
    case motivation = "motivation"
}

/// 알림 관리 매니저
class NotificationManager: NSObject, ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    @Published var notificationSettings: [NotificationType: Bool] = [
        .goalApproaching: true,
        .locked: true,
        .unlocked: true,
        .dailyReport: false,
        .motivation: false
    ]
    
    private let center = UNUserNotificationCenter.current()
    private let settingsKey = "notificationSettings"
    
    override private init() {
        super.init()
        center.delegate = self
        loadSettings()
        checkAuthorizationStatus()
    }
    
    // MARK: - Settings Management
    
    private func loadSettings() {
        if let savedSettings = UserDefaults.standard.dictionary(forKey: settingsKey) as? [String: Bool] {
            for (key, value) in savedSettings {
                if let type = NotificationType(rawValue: key) {
                    notificationSettings[type] = value
                }
            }
        }
    }
    
    func saveSettings() {
        let settings = notificationSettings.reduce(into: [String: Bool]()) { result, item in
            result[item.key.rawValue] = item.value
        }
        UserDefaults.standard.set(settings, forKey: settingsKey)
    }
    
    func toggleNotification(type: NotificationType) {
        notificationSettings[type]?.toggle()
        saveSettings()
    }
    
    // MARK: - Authorization
    
    /// 알림 권한 요청
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge, .provisional])
            await MainActor.run {
                isAuthorized = granted
            }
            return granted
        } catch {
            print("❌ 알림 권한 요청 실패: \(error.localizedDescription)")
            return false
        }
    }
    
    /// 권한 상태 확인
    func checkAuthorizationStatus() {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Schedule Notifications
    
    /// 목표 근접 알림 (10분 전)
    func scheduleGoalApproachingNotification(remainingMinutes: Int) {
        guard notificationSettings[.goalApproaching] == true else { return }
        guard remainingMinutes <= 10 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "notification_goal_approaching_title".localized
        content.body = "notification_goal_approaching_body".localized(with: remainingMinutes)
        content.sound = .default
        content.categoryIdentifier = "GOAL_APPROACHING"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: NotificationType.goalApproaching.rawValue,
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("❌ 목표 근접 알림 스케줄 실패: \(error.localizedDescription)")
            } else {
                print("✅ 목표 근접 알림 스케줄 완료")
            }
        }
    }
    
    /// 잠금 알림
    func scheduleLockNotification() {
        guard notificationSettings[.locked] == true else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "notification_locked_title".localized
        content.body = "notification_locked_body".localized
        content.sound = .default
        content.categoryIdentifier = "LOCKED"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: NotificationType.locked.rawValue,
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("❌ 잠금 알림 스케줄 실패: \(error.localizedDescription)")
            } else {
                print("✅ 잠금 알림 스케줄 완료")
            }
        }
    }
    
    /// 해제 알림
    func scheduleUnlockNotification(isCreative: Bool) {
        guard notificationSettings[.unlocked] == true else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "notification_unlocked_title".localized
        content.body = isCreative 
            ? "notification_unlocked_creative_body".localized
            : "notification_unlocked_auto_body".localized
        content.sound = .default
        content.categoryIdentifier = "UNLOCKED"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: NotificationType.unlocked.rawValue,
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("❌ 해제 알림 스케줄 실패: \(error.localizedDescription)")
            } else {
                print("✅ 해제 알림 스케줄 완료")
            }
        }
    }
    
    /// 일일 리포트 알림 (매일 오후 9시)
    func scheduleDailyReportNotification() {
        guard notificationSettings[.dailyReport] == true else {
            cancelNotification(identifier: NotificationType.dailyReport.rawValue)
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "notification_daily_report_title".localized
        content.body = "notification_daily_report_body".localized
        content.sound = .default
        content.categoryIdentifier = "DAILY_REPORT"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 21 // 오후 9시
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: NotificationType.dailyReport.rawValue,
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("❌ 일일 리포트 알림 스케줄 실패: \(error.localizedDescription)")
            } else {
                print("✅ 일일 리포트 알림 스케줄 완료")
            }
        }
    }
    
    /// 동기부여 알림 (랜덤 시간)
    func scheduleMotivationNotification() {
        guard notificationSettings[.motivation] == true else {
            cancelNotification(identifier: NotificationType.motivation.rawValue)
            return
        }
        
        let motivations = [
            "notification_motivation_1".localized,
            "notification_motivation_2".localized,
            "notification_motivation_3".localized,
            "notification_motivation_4".localized,
            "notification_motivation_5".localized
        ]
        
        let content = UNMutableNotificationContent()
        content.title = "notification_motivation_title".localized
        content.body = motivations.randomElement() ?? motivations[0]
        content.sound = .default
        content.categoryIdentifier = "MOTIVATION"
        
        // 랜덤 시간 (3-5시간 후)
        let randomInterval = TimeInterval.random(in: (3*3600)...(5*3600))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: randomInterval, repeats: false)
        let request = UNNotificationRequest(
            identifier: NotificationType.motivation.rawValue,
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("❌ 동기부여 알림 스케줄 실패: \(error.localizedDescription)")
            } else {
                print("✅ 동기부여 알림 스케줄 완료")
            }
        }
    }
    
    // MARK: - Cancel Notifications
    
    /// 모든 알림 취소
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        print("✅ 모든 알림 취소 완료")
    }
    
    /// 특정 알림 취소
    func cancelNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        print("✅ 알림 취소: \(identifier)")
    }
    
    /// 특정 타입 알림 취소
    func cancelNotification(type: NotificationType) {
        cancelNotification(identifier: type.rawValue)
    }
    
    // MARK: - Badge
    
    /// 배지 개수 설정
    func setBadgeCount(_ count: Int) {
        center.setBadgeCount(count)
    }
    
    /// 배지 초기화
    func clearBadge() {
        center.setBadgeCount(0)
    }
    
    // MARK: - Pending Notifications
    
    /// 대기 중인 알림 확인
    func getPendingNotifications() async -> [UNNotificationRequest] {
        return await center.pendingNotificationRequests()
    }
    
    /// 대기 중인 알림 출력 (디버깅용)
    func printPendingNotifications() {
        Task {
            let requests = await getPendingNotifications()
            print("📋 대기 중인 알림: \(requests.count)개")
            for request in requests {
                print("  - \(request.identifier): \(request.content.title)")
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    /// 포그라운드에서 알림 표시
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // 앱이 실행 중일 때도 알림 표시
        completionHandler([.banner, .sound, .badge])
    }
    
    /// 알림 탭 처리
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let identifier = response.notification.request.identifier
        print("📬 알림 탭: \(identifier)")
        
        // 알림 타입별 처리
        if let type = NotificationType(rawValue: identifier) {
            handleNotificationTap(type: type)
        }
        
        completionHandler()
    }
    
    private func handleNotificationTap(type: NotificationType) {
        switch type {
        case .goalApproaching:
            // 메인 화면으로 이동
            NotificationCenter.default.post(name: .openMainView, object: nil)
        case .locked:
            // 잠금 화면으로 이동
            NotificationCenter.default.post(name: .openLockScreen, object: nil)
        case .unlocked:
            // 메인 화면으로 이동
            NotificationCenter.default.post(name: .openMainView, object: nil)
        case .dailyReport:
            // 상세 통계로 이동
            NotificationCenter.default.post(name: .openDetailedStats, object: nil)
        case .motivation:
            // 메인 화면으로 이동
            NotificationCenter.default.post(name: .openMainView, object: nil)
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let openMainView = Notification.Name("openMainView")
    static let openLockScreen = Notification.Name("openLockScreen")
    static let openDetailedStats = Notification.Name("openDetailedStats")
}
