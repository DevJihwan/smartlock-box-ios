//
//  AdaptiveProgressBar.swift
//  SmartLockBox - Design System Components
//
//  Created by DevJihwan on 2025-11-04.
//  Adaptive progress bar with color-coded states
//

import SwiftUI

/// Adaptive Progress Bar
/// Changes color based on progress percentage
struct AdaptiveProgressBar: View {

    // MARK: - Properties

    let progress: Double // 0.0 ~ 1.0
    var height: CGFloat = ComponentSize.progressBarHeight
    var cornerRadius: CGFloat = 4
    var showPercentage: Bool = false
    var animationDuration: Double = 0.5

    // MARK: - Computed Properties

    /// Progress color based on percentage
    var progressColor: Color {
        switch progress {
        case 0..<0.6:
            return .green  // Good - under 60%
        case 0.6..<0.85:
            return .orange  // Warning - 60-85%
        default:
            return .red  // Critical - over 85%
        }
    }

    /// Percentage text
    var percentageText: String {
        "\(Int(progress * 100))%"
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .trailing, spacing: Spacing.xxs) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.secondary.opacity(0.2))

                    // Progress fill
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(progressColor)
                        .frame(width: max(0, min(geometry.size.width * progress, geometry.size.width)))
                        .animation(.spring(response: animationDuration, dampingFraction: 0.7), value: progress)
                }
            }
            .frame(height: height)

            // Optional percentage display
            if showPercentage {
                Text(percentageText)
                    .font(.captionSmall)
                    .foregroundColor(progressColor)
            }
        }
    }
}

// MARK: - Preset Styles

extension AdaptiveProgressBar {

    /// Large progress bar with percentage
    static func large(progress: Double) -> some View {
        AdaptiveProgressBar(
            progress: progress,
            height: 12,
            showPercentage: true
        )
    }

    /// Small compact progress bar
    static func small(progress: Double) -> some View {
        AdaptiveProgressBar(
            progress: progress,
            height: 6,
            showPercentage: false
        )
    }
}

// MARK: - Circular Progress View

/// Circular Progress Indicator
struct CircularProgressView: View {

    // MARK: - Properties

    let progress: Double  // 0.0 ~ 1.0
    var lineWidth: CGFloat = 8
    var size: CGFloat = 120

    // MARK: - Computed Properties

    var progressColor: Color {
        switch progress {
        case 0..<0.6:
            return .green
        case 0.6..<0.85:
            return .orange
        default:
            return .red
        }
    }

    var percentageText: String {
        "\(Int(progress * 100))%"
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.secondary.opacity(0.2), lineWidth: lineWidth)

            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    progressColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: progress)

            // Center text
            VStack(spacing: Spacing.xxs) {
                Text(percentageText)
                    .font(.displaySmall)
                    .fontWeight(.bold)
                    .foregroundColor(progressColor)

                Text("달성")
                    .font(.captionLarge)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Preview

struct AdaptiveProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: Spacing.lg) {
                // Different progress levels
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("40% - 안전")
                        .font(.titleSmall)

                    AdaptiveProgressBar(progress: 0.4, showPercentage: true)
                }

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("70% - 주의")
                        .font(.titleSmall)

                    AdaptiveProgressBar(progress: 0.7, showPercentage: true)
                }

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("90% - 위험")
                        .font(.titleSmall)

                    AdaptiveProgressBar(progress: 0.9, showPercentage: true)
                }

                Divider()

                // Preset styles
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Large Style")
                        .font(.titleSmall)

                    AdaptiveProgressBar.large(progress: 0.65)
                }

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Small Style")
                        .font(.titleSmall)

                    AdaptiveProgressBar.small(progress: 0.35)
                }

                Divider()

                // Circular progress
                CircularProgressView(progress: 0.75)
            }
            .padding()
            .previewDisplayName("Light Mode")

            // Dark mode
            VStack(spacing: Spacing.lg) {
                AdaptiveProgressBar(progress: 0.6, showPercentage: true)
                CircularProgressView(progress: 0.8)
            }
            .padding()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
