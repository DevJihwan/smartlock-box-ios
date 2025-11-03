//
//  CardView.swift
//  SmartLockBox - Design System Components
//
//  Created by DevJihwan on 2025-11-04.
//  Reusable card component with consistent styling
//

import SwiftUI

/// Standard Card View Component
/// Provides consistent card styling across the app
struct CardView<Content: View>: View {

    // MARK: - Properties

    let content: Content
    var cornerRadius: CGFloat = CornerRadius.large
    var shadowStyle: ShadowStyle = .card
    var backgroundColor: Color = Color("CardBackground")
    var horizontalPadding: CGFloat = Spacing.md
    var verticalPadding: CGFloat = Spacing.md

    // MARK: - Initialization

    init(
        cornerRadius: CGFloat = CornerRadius.large,
        shadowStyle: ShadowStyle = .card,
        backgroundColor: Color = Color("CardBackground"),
        horizontalPadding: CGFloat = Spacing.md,
        verticalPadding: CGFloat = Spacing.md,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.shadowStyle = shadowStyle
        self.backgroundColor = backgroundColor
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(
                color: shadowStyle.color,
                radius: shadowStyle.radius,
                x: shadowStyle.x,
                y: shadowStyle.y
            )
    }
}

// MARK: - Preview

#Preview("Standard Card") {
    CardView {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Card Title")
                .font(.titleMedium)
            Text("Card content goes here")
                .font(.bodyLarge)
                .foregroundColor(.secondary)
        }
    }
    .padding()
}

#Preview("Compact Card") {
    CardView(
        horizontalPadding: Spacing.sm,
        verticalPadding: Spacing.sm
    ) {
        Text("Compact Card")
            .font(.bodyMedium)
    }
    .padding()
}

#Preview("Dark Mode") {
    CardView {
        Text("Dark Mode Card")
            .font(.titleMedium)
    }
    .padding()
    .preferredColorScheme(.dark)
}
