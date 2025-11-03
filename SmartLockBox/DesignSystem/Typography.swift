//
//  Typography.swift
//  SmartLockBox - Design System
//
//  Created by DevJihwan on 2025-11-04.
//  Typography system based on San Francisco Font
//

import SwiftUI

/// SmartLockBox Typography System
/// Based on Apple's San Francisco Font with semantic naming
extension Font {

    // MARK: - Display (Large Titles & Headers)

    /// Display Large - 48pt Bold
    /// 사용처: 숫자 강조 (카운트다운, 통계 수치)
    static let displayLarge = Font.system(size: 48, weight: .bold, design: .default)

    /// Display Medium - 36pt Bold
    /// 사용처: 주요 숫자 표시 (남은 시간, 목표 달성률)
    static let displayMedium = Font.system(size: 36, weight: .bold, design: .default)

    /// Display Small - 28pt Bold
    /// 사용처: 화면 제목 (오늘의 목표 달성률)
    static let displaySmall = Font.system(size: 28, weight: .bold, design: .default)

    // MARK: - Title (Section Headers)

    /// Title Large - 24pt Semibold
    /// 사용처: 큰 섹션 제목, 중요한 레이블
    static let titleLarge = Font.system(size: 24, weight: .semibold, design: .default)

    /// Title Medium - 20pt Semibold
    /// 사용처: 카드 제목, 섹션 헤더
    static let titleMedium = Font.system(size: 20, weight: .semibold, design: .default)

    /// Title Small - 18pt Medium
    /// 사용처: 작은 섹션 제목
    static let titleSmall = Font.system(size: 18, weight: .medium, design: .default)

    // MARK: - Body (Main Content)

    /// Body Large - 17pt Regular
    /// 사용처: 주요 본문 텍스트
    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)

    /// Body Medium - 15pt Regular
    /// 사용처: 보조 본문 텍스트
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)

    /// Body Small - 13pt Regular
    /// 사용처: 작은 본문, 부가 정보
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)

    // MARK: - Caption (Helper Text)

    /// Caption Large - 12pt Regular
    /// 사용처: 설명 텍스트, 도움말
    static let captionLarge = Font.system(size: 12, weight: .regular, design: .default)

    /// Caption Small - 11pt Regular
    /// 사용처: 매우 작은 설명 텍스트
    static let captionSmall = Font.system(size: 11, weight: .regular, design: .default)

    // MARK: - Button Text

    /// Button Large - 17pt Semibold
    /// 사용처: 주요 버튼 텍스트
    static let buttonLarge = Font.system(size: 17, weight: .semibold, design: .default)

    /// Button Medium - 15pt Medium
    /// 사용처: 일반 버튼 텍스트
    static let buttonMedium = Font.system(size: 15, weight: .medium, design: .default)

    /// Button Small - 13pt Medium
    /// 사용처: 작은 버튼 텍스트
    static let buttonSmall = Font.system(size: 13, weight: .medium, design: .default)
}

// MARK: - UIFont Extension (UIKit compatibility)

extension UIFont {

    // MARK: - Display

    static let displayLarge = UIFont.systemFont(ofSize: 48, weight: .bold)
    static let displayMedium = UIFont.systemFont(ofSize: 36, weight: .bold)
    static let displaySmall = UIFont.systemFont(ofSize: 28, weight: .bold)

    // MARK: - Title

    static let titleLarge = UIFont.systemFont(ofSize: 24, weight: .semibold)
    static let titleMedium = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let titleSmall = UIFont.systemFont(ofSize: 18, weight: .medium)

    // MARK: - Body

    static let bodyLarge = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let bodyMedium = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let bodySmall = UIFont.systemFont(ofSize: 13, weight: .regular)

    // MARK: - Caption

    static let captionLarge = UIFont.systemFont(ofSize: 12, weight: .regular)
    static let captionSmall = UIFont.systemFont(ofSize: 11, weight: .regular)

    // MARK: - Button

    static let buttonLarge = UIFont.systemFont(ofSize: 17, weight: .semibold)
    static let buttonMedium = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let buttonSmall = UIFont.systemFont(ofSize: 13, weight: .medium)
}

// MARK: - Typography Usage Examples

/*
 Usage Examples:

 // SwiftUI
 Text("오늘의 목표")
     .font(.displaySmall)  // 28pt Bold

 Text("2시간 30분")
     .font(.displayMedium)  // 36pt Bold

 Text("달성률")
     .font(.titleMedium)  // 20pt Semibold

 Text("설명 텍스트")
     .font(.bodyLarge)  // 17pt Regular

 Text("도움말")
     .font(.captionLarge)  // 12pt Regular

 // Button
 Button("제출하기") {}
     .font(.buttonLarge)  // 17pt Semibold

 // UIKit
 let label = UILabel()
 label.font = .displaySmall

 let button = UIButton()
 button.titleLabel?.font = .buttonLarge
 */
