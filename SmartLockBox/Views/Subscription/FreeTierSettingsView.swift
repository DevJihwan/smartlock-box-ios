//
//  FreeTierSettingsView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-03.
//

import SwiftUI

struct FreeTierSettingsView: View {
    @ObservedObject var subscriptionManager = SubscriptionManager.shared
    @State private var dailyLimitHours: Double
    @State private var showUpgradePrompt = false

    init() {
        let hours = SubscriptionManager.shared.freeTierSettings.dailyLimitHours
        _dailyLimitHours = State(initialValue: hours)
    }

    var body: some View {
        VStack(spacing: 24) {
            // Daily Limit Section
            dailyLimitSection

            // Upgrade Prompt
            upgradePromptSection
        }
        .padding()
        .sheet(isPresented: $showUpgradePrompt) {
            UpgradePromptView(isPresented: $showUpgradePrompt)
        }
    }

    // MARK: - Daily Limit Section

    private var dailyLimitSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("free_daily_limit_title".localized)
                .font(.headline)
                .foregroundColor(AppColors.text)

            Text("free_daily_limit_description".localized)
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)

            // Slider
            VStack(spacing: 8) {
                HStack {
                    Spacer()
                    Text(formatHours(dailyLimitHours))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.accent)
                    Spacer()
                }

                Slider(value: $dailyLimitHours, in: 1...8, step: 0.5)
                    .accentColor(AppColors.accent)
                    .onChange(of: dailyLimitHours) { newValue in
                        subscriptionManager.updateDailyLimit(hours: newValue)
                    }

                HStack {
                    Text("1h")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                    Spacer()
                    Text("8h")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding()
            .background(AppColors.cardBackground)
            .cornerRadius(12)

            // Warning
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.orange)
                Text("free_limit_warning".localized)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(8)
        }
    }

    // MARK: - Upgrade Prompt Section

    private var upgradePromptSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundColor(.purple)
                Text("free_upgrade_prompt".localized)
                    .font(.subheadline)
                    .foregroundColor(AppColors.text)
            }

            Button(action: { showUpgradePrompt = true }) {
                HStack {
                    Text("free_view_premium".localized)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                }
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
        }
    }

    // MARK: - Helper Methods

    private func formatHours(_ hours: Double) -> String {
        let h = Int(hours)
        let m = Int((hours - Double(h)) * 60)

        if m == 0 {
            return "\(h)h"
        } else {
            return "\(h)h \(m)m"
        }
    }
}

// MARK: - Previews

struct FreeTierSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FreeTierSettingsView()
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")

            FreeTierSettingsView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
