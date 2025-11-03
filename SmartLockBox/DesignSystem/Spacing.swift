//
//  Spacing.swift
//  SmartLockBox - Design System
//
//  Created by DevJihwan on 2025-11-04.
//  8pt Grid System for consistent spacing
//

import SwiftUI

/// SmartLockBox Spacing System
/// Based on 8pt grid system for perfect pixel alignment
enum Spacing {

    // MARK: - Spacing Values (8pt grid)

    /// Extra Extra Small - 4pt (0.5 × 8)
    /// 사용처: 매우 작은 간격, 히트맵 셀 사이
    static let xxs: CGFloat = 4

    /// Extra Small - 8pt (1 × 8)
    /// 사용처: 텍스트 간격, 작은 패딩
    static let xs: CGFloat = 8

    /// Small - 12pt (1.5 × 8)
    /// 사용처: 컴포넌트 내부 패딩
    static let sm: CGFloat = 12

    /// Medium - 16pt (2 × 8)
    /// 사용처: 일반 패딩, 카드 좌우 여백
    static let md: CGFloat = 16

    /// Large - 24pt (3 × 8)
    /// 사용처: 섹션 간격, 큰 여백
    static let lg: CGFloat = 24

    /// Extra Large - 32pt (4 × 8)
    /// 사용처: 큰 섹션 구분, 화면 상단 여백
    static let xl: CGFloat = 32

    /// Extra Extra Large - 48pt (6 × 8)
    /// 사용처: 매우 큰 여백, 중요한 구분
    static let xxl: CGFloat = 48

    /// Extra Extra Extra Large - 64pt (8 × 8)
    /// 사용처: 특별한 강조 영역
    static let xxxl: CGFloat = 64
}

// MARK: - Corner Radius

enum CornerRadius {

    /// Small - 8pt
    /// 사용처: 작은 컴포넌트
    static let small: CGFloat = 8

    /// Medium - 12pt
    /// 사용처: 입력 필드, 일반 컴포넌트
    static let medium: CGFloat = 12

    /// Large - 16pt
    /// 사용처: 카드, 큰 컴포넌트
    static let large: CGFloat = 16

    /// Extra Large - 24pt
    /// 사용처: 매우 둥근 컴포넌트
    static let extraLarge: CGFloat = 24

    /// Pill - 999pt
    /// 사용처: 완전한 캡슐 모양 (Word Pill)
    static let pill: CGFloat = 999
}

// MARK: - Border Width

enum BorderWidth {

    /// Thin - 1pt
    /// 사용처: 일반 테두리
    static let thin: CGFloat = 1

    /// Medium - 2pt
    /// 사용처: 강조 테두리
    static let medium: CGFloat = 2

    /// Thick - 3pt
    /// 사용처: 선택된 상태
    static let thick: CGFloat = 3
}

// MARK: - Shadow

struct ShadowStyle {

    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    // MARK: - Predefined Shadows

    /// Card Shadow - 카드 컴포넌트용 그림자
    static let card = ShadowStyle(
        color: Color.black.opacity(0.1),
        radius: 8,
        x: 0,
        y: 4
    )

    /// Light Shadow - 가벼운 그림자
    static let light = ShadowStyle(
        color: Color.black.opacity(0.05),
        radius: 4,
        x: 0,
        y: 2
    )

    /// Medium Shadow - 중간 그림자
    static let medium = ShadowStyle(
        color: Color.black.opacity(0.15),
        radius: 12,
        x: 0,
        y: 6
    )

    /// Heavy Shadow - 진한 그림자
    static let heavy = ShadowStyle(
        color: Color.black.opacity(0.2),
        radius: 16,
        x: 0,
        y: 8
    )
}

// MARK: - View Extensions for Easy Application

extension View {

    /// Apply card shadow
    func cardShadow() -> some View {
        self.shadow(
            color: ShadowStyle.card.color,
            radius: ShadowStyle.card.radius,
            x: ShadowStyle.card.x,
            y: ShadowStyle.card.y
        )
    }

    /// Apply light shadow
    func lightShadow() -> some View {
        self.shadow(
            color: ShadowStyle.light.color,
            radius: ShadowStyle.light.radius,
            x: ShadowStyle.light.x,
            y: ShadowStyle.light.y
        )
    }

    /// Apply medium shadow
    func mediumShadow() -> some View {
        self.shadow(
            color: ShadowStyle.medium.color,
            radius: ShadowStyle.medium.radius,
            x: ShadowStyle.medium.x,
            y: ShadowStyle.medium.y
        )
    }

    /// Apply heavy shadow
    func heavyShadow() -> some View {
        self.shadow(
            color: ShadowStyle.heavy.color,
            radius: ShadowStyle.heavy.radius,
            x: ShadowStyle.heavy.x,
            y: ShadowStyle.heavy.y
        )
    }
}

// MARK: - Component Sizing

enum ComponentSize {

    // MARK: - Button Heights

    /// Small button - 44pt (iOS minimum tap target)
    static let buttonSmall: CGFloat = 44

    /// Medium button - 50pt
    static let buttonMedium: CGFloat = 50

    /// Large button - 56pt (primary action)
    static let buttonLarge: CGFloat = 56

    // MARK: - Icon Sizes

    /// Small icon - 16×16pt
    static let iconSmall: CGFloat = 16

    /// Medium icon - 20×20pt
    static let iconMedium: CGFloat = 20

    /// Large icon - 24×24pt
    static let iconLarge: CGFloat = 24

    /// Extra large icon - 32×32pt
    static let iconXL: CGFloat = 32

    /// Huge icon - 48×48pt
    static let iconHuge: CGFloat = 48

    /// Massive icon - 80×80pt (lock screen)
    static let iconMassive: CGFloat = 80

    // MARK: - Progress Bar

    /// Progress bar height - 8pt
    static let progressBarHeight: CGFloat = 8

    // MARK: - Heatmap Cell

    /// Heatmap cell size - 16×16pt
    static let heatmapCell: CGFloat = 16

    /// Heatmap cell spacing - 4pt
    static let heatmapSpacing: CGFloat = 4
}

// MARK: - Usage Examples

/*
 Usage Examples:

 // Spacing
 VStack(spacing: Spacing.md) { }  // 16pt spacing

 .padding(.horizontal, Spacing.md)  // 16pt horizontal padding

 .padding(.vertical, Spacing.lg)  // 24pt vertical padding

 // Corner Radius
 RoundedRectangle(cornerRadius: CornerRadius.large)  // 16pt corners

 .cornerRadius(CornerRadius.medium)  // 12pt corners

 // Shadow
 CardView()
     .cardShadow()  // Apply card shadow

 // Button
 Button("Action") {}
     .frame(height: ComponentSize.buttonLarge)  // 56pt height

 // Icon
 Image(systemName: "lock.fill")
     .font(.system(size: ComponentSize.iconLarge))  // 24×24pt
 */
