//
//  TimeFormatter.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation

struct TimeFormatter {
    /// 분을 "X시간 Y분" 형식으로 변환
    static func format(minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        
        if hours > 0 && mins > 0 {
            return "\(hours)시간 \(mins)분"
        } else if hours > 0 {
            return "\(hours)시간"
        } else {
            return "\(mins)분"
        }
    }
    
    /// 초를 "X시간 Y분 Z초" 형식으로 변환
    static func format(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        
        if hours > 0 {
            return "\(hours)시간 \(minutes)분"
        } else if minutes > 0 {
            return "\(minutes)분 \(secs)초"
        } else {
            return "\(secs)초"
        }
    }
    
    /// 두 시간 차이를 계산
    static func timeDifference(from startDate: Date, to endDate: Date) -> (hours: Int, minutes: Int, seconds: Int) {
        let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: startDate, to: endDate)
        return (
            hours: difference.hour ?? 0,
            minutes: difference.minute ?? 0,
            seconds: difference.second ?? 0
        )
    }
    
    /// 남은 시간을 자연어로 표현
    static func naturalLanguageRemaining(minutes: Int) -> String {
        if minutes <= 0 {
            return "곧 잠금"
        } else if minutes < 60 {
            return "\(minutes)분 남음"
        } else {
            let hours = minutes / 60
            let mins = minutes % 60
            if mins == 0 {
                return "\(hours)시간 남음"
            } else {
                return "\(hours)시간 \(mins)분 남음"
            }
        }
    }
}
