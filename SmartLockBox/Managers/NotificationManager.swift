//
//  NotificationManager.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    /// 알림 권한 요청
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    /// 목표 근접 알림 스케줄 (목표 시간 10분 전)
    func scheduleGoalApproachingNotification(remainingMinutes: Int) {
        guard remainingMinutes == Constants.Notifications.goalApproachingMinutes else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "⚠️ 목표 시간 임박"
        content.body = "목표 시간까지 \(remainingMinutes)분 남았습니다!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "goalApproaching", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    /// 잠금 알림
    func scheduleLockNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🔒 스마트폰 잠금"
        content.body = "오늘 목표 시간을 달성했습니다. 스마트폰이 잠겼습니다."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "locked", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    /// 일일 리포트 알림 스케줄 (매일 오후 9시)
    func scheduleDailyReportNotification() {
        let content = UNMutableNotificationContent()
        content.title = "📊 일일 사용 리포트"
        content.body = "오늘의 스마트폰 사용 현황을 확인해보세요!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = Constants.Notifications.dailyReportHour
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReport", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    /// 모든 알림 취소
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// 특정 알림 취소
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
