//
//  ColorExtensions.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

extension Color {
    /// 사용률에 따른 색상 반환
    static func usageColor(for percentage: Double) -> Color {
        if percentage <= 60 {
            return .green
        } else if percentage <= 85 {
            return .yellow
        } else {
            return .red
        }
    }
    
    /// 히트맵 색상 (목표 달성 여부에 따라)
    static func heatmapColor(achieved: Bool) -> Color {
        return achieved ? .green : Color.gray.opacity(0.3)
    }
    
    /// 커스텀 브랜드 컬러
    static let brandPrimary = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let brandSecondary = Color(red: 0.6, green: 0.3, blue: 0.8)
    
    /// 그라데이션 컬러 세트
    static let successGradient = LinearGradient(
        gradient: Gradient(colors: [.green, .mint]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let warningGradient = LinearGradient(
        gradient: Gradient(colors: [.orange, .yellow]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let dangerGradient = LinearGradient(
        gradient: Gradient(colors: [.red, .orange]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [.blue, .purple]),
        startPoint: .leading,
        endPoint: .trailing
    )
}
