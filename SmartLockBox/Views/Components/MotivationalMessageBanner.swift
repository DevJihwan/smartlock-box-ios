//
//  MotivationalMessageBanner.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-04.
//  Motivational message banner component
//

import SwiftUI

/// Motivational Message Banner
/// Displays motivational messages based on user achievement
struct MotivationalMessageBanner: View {

    // MARK: - Properties

    let motivation: MotivationManager.Motivation

    @Environment(\.themeColor) private var themeColor

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Text(motivation.icon)
                .font(.system(size: 24))

            VStack(alignment: .leading, spacing: 4) {
                // Streak display for consecutive achievements
                if let streak = motivation.streakDays, motivation.type == .streak {
                    HStack(spacing: 8) {
                        Text(String(format: "motivation.streak_prefix".localized, streak))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)

                        Spacer()
                    }
                }

                // Main message
                Text(motivation.message)
                    .font(.system(size: motivation.type == .streak ? 14 : 16,
                                  weight: motivation.type == .streak ? .medium : .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(motivation.type.backgroundColor)
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .opacity
        ))
    }
}

// MARK: - Preview

#Preview("Welcome Message") {
    MotivationalMessageBanner(
        motivation: MotivationManager.Motivation(
            message: "오늘부터 당신의 시간을 되찾아보세요!",
            icon: "💪",
            type: .welcome,
            streakDays: nil
        )
    )
    .padding(.vertical)
}

#Preview("Success Message") {
    MotivationalMessageBanner(
        motivation: MotivationManager.Motivation(
            message: "어제도 목표 달성! 멋져요!",
            icon: "🎉",
            type: .success,
            streakDays: nil
        )
    )
    .padding(.vertical)
}

#Preview("Retry Message") {
    MotivationalMessageBanner(
        motivation: MotivationManager.Motivation(
            message: "괜찮아요, 오늘 다시 도전해봐요!",
            icon: "💙",
            type: .retry,
            streakDays: nil
        )
    )
    .padding(.vertical)
}

#Preview("Streak Message") {
    MotivationalMessageBanner(
        motivation: MotivationManager.Motivation(
            message: "어제도 목표 달성! 멋져요!",
            icon: "🔥",
            type: .streak,
            streakDays: 5
        )
    )
    .padding(.vertical)
}

#Preview("Week Streak") {
    MotivationalMessageBanner(
        motivation: MotivationManager.Motivation(
            message: "연속 7일! 한 주 완주!",
            icon: "🔥",
            type: .streak,
            streakDays: 7
        )
    )
    .padding(.vertical)
}
