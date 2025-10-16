//
//  Colors.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-16.
//

import SwiftUI

/// 앱 전체에서 사용되는 색상 테마 정의
struct AppColors {
    // 기본 색상 - 라이트/다크 모드 자동 대응
    static let background = Color("Background")
    static let cardBackground = Color("CardBackground")
    static let secondaryBackground = Color("SecondaryBackground")
    static let text = Color("Text")
    static let secondaryText = Color("SecondaryText")
    static let accent = Color("Accent")
    
    // 기능별 색상
    static let progress = Color("ProgressColor")
    static let lock = Color("LockColor")
    static let unlock = Color("UnlockColor")
    static let warning = Color("WarningColor")
    static let success = Color("SuccessColor")
    
    // 프로그레스 색상 (사용량 기반)
    static func progressColor(percentage: Double) -> Color {
        if percentage < 60 {
            return Color("ProgressLow") // 녹색
        } else if percentage < 90 {
            return Color("ProgressMedium") // 노랑/주황
        } else {
            return Color("ProgressHigh") // 빨강
        }
    }
    
    // 그라데이션
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let lockScreenGradient = LinearGradient(
        gradient: Gradient(colors: [Color("LockGradientStart"), Color("LockGradientEnd")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Color Extensions
extension Color {
    /// 모든 모드에서 흰색/검은색 (다크모드에서 반전)
    static var adaptiveWhite: Color {
        Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        })
    }
    
    static var adaptiveBlack: Color {
        Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        })
    }
    
    /// 버튼 배경에 적합한 색상
    static var buttonBackground: Color {
        Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? 
                UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0) :
                UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        })
    }
    
    /// 미묘한 그림자에 적합한 색상
    static var subtleShadow: Color {
        Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? 
                UIColor(white: 0, alpha: 0.5) : 
                UIColor(white: 0, alpha: 0.1)
        })
    }
    
    /// 시스템 배경과 대비되는 색상
    static var contrastBackground: Color {
        Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? 
                UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0) :
                UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        })
    }
    
    /// 그림자 효과 헬퍼
    static func dynamicShadow(radius: CGFloat = 10, opacity: Double = 0.1) -> some View {
        let shadowColor = Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? 
                UIColor(white: 0, alpha: opacity * 2) : // 다크모드에서 더 강한 그림자
                UIColor(white: 0, alpha: opacity)
        })
        
        return AnyView(
            shadow(color: shadowColor, radius: radius, x: 0, y: 4)
        )
    }
}

// MARK: - View Extensions for Styling
extension View {
    /// 카드 스타일 적용 (다크모드 대응)
    func cardStyle() -> some View {
        self
            .padding()
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .shadow(
                color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1),
                radius: 10,
                x: 0,
                y: 5
            )
            .environment(\.colorScheme, colorScheme)
    }
    
    /// 현재 colorScheme 가져오기
    @ViewBuilder func environment(\.colorScheme, _ colorScheme: ColorScheme?) -> some View {
        self.environment(\.colorScheme, colorScheme ?? .light)
    }
    
    /// 다양한 그림자 효과
    func adaptiveShadow(radius: CGFloat = 10, opacity: Double = 0.1, y: CGFloat = 4) -> some View {
        self.shadow(
            color: Color.black.opacity(colorScheme == .dark ? opacity * 2 : opacity),
            radius: radius,
            x: 0,
            y: y
        )
    }
}
