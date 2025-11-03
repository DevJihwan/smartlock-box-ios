//
//  SubscriptionSettingsView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-03.
//

import SwiftUI

struct SubscriptionSettingsView: View {
    @ObservedObject var subscriptionManager = SubscriptionManager.shared

    var body: some View {
        VStack(spacing: 0) {
            // Header with tier badge
            headerSection
                .padding()
                .background(AppColors.cardBackground)

            Divider()

            // Content based on tier
            ScrollView {
                Group {
                    switch subscriptionManager.currentTier {
                    case .free:
                        FreeTierSettingsView()
                    case .premium:
                        PremiumTierSettingsView()
                    }
                }
                .padding(.top)
            }
        }
        .background(AppColors.background)
    }

    // MARK: - Header Section

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("settings_subscription".localized)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.text)

                if subscriptionManager.isSubscriptionActive {
                    Text("subscription_active".localized)
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("subscription_inactive".localized)
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }

            Spacer()

            // Tier Badge
            tierBadge
        }
    }

    private var tierBadge: some View {
        HStack(spacing: 6) {
            if subscriptionManager.currentTier == .premium {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
            }

            Text(subscriptionManager.currentTier.displayName)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(subscriptionManager.currentTier == .premium ? .yellow : AppColors.secondaryText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            subscriptionManager.currentTier == .premium
                ? Color.yellow.opacity(0.2)
                : AppColors.background
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    subscriptionManager.currentTier == .premium ? Color.yellow : Color.gray.opacity(0.3),
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Previews

struct SubscriptionSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Free tier preview
            SubscriptionSettingsView()
                .preferredColorScheme(.light)
                .previewDisplayName("Free Tier - Light")
                .onAppear {
                    SubscriptionManager.shared.downgradeToFree()
                }

            // Premium tier preview
            SubscriptionSettingsView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Premium Tier - Dark")
                .onAppear {
                    SubscriptionManager.shared.upgradeToPremium()
                }
        }
    }
}
