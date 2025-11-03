//
//  Animations.swift
//  SmartLockBox - Design System
//
//  Created by DevJihwan on 2025-11-04.
//  Standard animation library for consistent motion
//

import SwiftUI

// MARK: - Animation Presets

extension Animation {

    // MARK: - Standard Animations

    /// Standard spring animation for most UI transitions
    static let standardSpring = Animation.spring(
        response: 0.3,
        dampingFraction: 0.7,
        blendDuration: 0
    )

    /// Smooth ease out for gentle transitions
    static let smoothEaseOut = Animation.easeOut(duration: 0.3)

    /// Bouncy animation for emphasis
    static let bouncy = Animation.spring(
        response: 0.5,
        dampingFraction: 0.6,
        blendDuration: 0.2
    )

    /// Quick snap for instant feedback
    static let quickSnap = Animation.easeOut(duration: 0.2)

    /// Slow smooth for loading states
    static let slowSmooth = Animation.easeInOut(duration: 0.5)
}

// MARK: - View Modifiers for Common Animations

extension View {

    /// Button press animation
    func buttonPressAnimation(isPressed: Bool) -> some View {
        self.scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.smoothEaseOut, value: isPressed)
    }

    /// Pulse animation (e.g., for lock icon)
    func pulseAnimation(isPulsing: Bool) -> some View {
        self.scaleEffect(isPulsing ? 1.0 : 0.95)
            .animation(
                .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                value: isPulsing
            )
    }

    /// Slide in from bottom
    func slideInFromBottom(isVisible: Bool) -> some View {
        self.transition(.asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .opacity
        ))
        .animation(.standardSpring, value: isVisible)
    }

    /// Fade in animation
    func fadeIn(isVisible: Bool, delay: Double = 0) -> some View {
        self.opacity(isVisible ? 1 : 0)
            .animation(.smoothEaseOut.delay(delay), value: isVisible)
    }

    /// Scale popup animation
    func scalePopup(isVisible: Bool) -> some View {
        self.scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            .animation(.bouncy, value: isVisible)
    }
}

// MARK: - Haptic Feedback

enum HapticFeedback {

    /// Generate haptic feedback
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    /// Success haptic
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    /// Warning haptic
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    /// Error haptic
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    /// Selection haptic
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// MARK: - Usage Examples

/*
 Usage Examples:

 // Button with press animation and haptic
 Button("Tap Me") {
     HapticFeedback.impact()
     // Action
 }
 .buttonPressAnimation(isPressed: isPressed)
 .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
     isPressed = pressing
 }, perform: {})

 // Slide in view
 CardView {
     Text("Content")
 }
 .slideInFromBottom(isVisible: showCard)

 // Pulse animation
 Image(systemName: "lock.fill")
     .pulseAnimation(isPulsing: isLocked)

 // Scale popup
 AlertView()
     .scalePopup(isVisible: showAlert)

 // Success feedback
 Button("Complete") {
     HapticFeedback.success()
     completeTask()
 }
 */
