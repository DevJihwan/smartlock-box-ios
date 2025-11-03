//
//  SubscriptionManager.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-03.
//

import Foundation
import SwiftUI
import StoreKit

// MARK: - Subscription Manager

class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()

    // MARK: - Published Properties

    @Published var currentTier: SubscriptionTier = .free
    @Published var isSubscriptionActive: Bool = false
    @Published var subscriptionExpiryDate: Date?

    // Settings based on tier
    @Published var freeTierSettings: FreeTierSettings
    @Published var premiumTierSettings: PremiumTierSettings

    // MARK: - Product IDs

    private let monthlySubscriptionID = "com.smartlockbox.premium.monthly"
    private let yearlySubscriptionID = "com.smartlockbox.premium.yearly"

    // MARK: - Initialization

    private init() {
        // Load saved tier
        self.currentTier = UserDefaults.standard.subscriptionTier

        // Load settings
        self.freeTierSettings = UserDefaults.standard.freeTierSettings
        self.premiumTierSettings = UserDefaults.standard.premiumTierSettings

        // Check subscription status
        Task {
            await checkSubscriptionStatus()
        }
    }

    // MARK: - Subscription Status

    @MainActor
    func checkSubscriptionStatus() async {
        // TODO: Implement StoreKit 2 subscription verification
        // For now, load from UserDefaults
        currentTier = UserDefaults.standard.subscriptionTier

        // Validate expiry date if premium
        if currentTier == .premium {
            // Check if subscription is still active
            // This will be implemented with StoreKit 2
            isSubscriptionActive = true
        } else {
            isSubscriptionActive = false
        }

        print("📊 Subscription Status: \(currentTier.displayName)")
        print("✅ Active: \(isSubscriptionActive)")
    }

    // MARK: - Subscription Actions

    /// Switch to Premium tier (for testing/development)
    @MainActor
    func upgradeToPremium() {
        currentTier = .premium
        isSubscriptionActive = true
        UserDefaults.standard.subscriptionTier = .premium

        print("💎 Upgraded to Premium")

        // Post notification
        NotificationCenter.default.post(name: .subscriptionTierChanged, object: nil)
    }

    /// Downgrade to Free tier
    @MainActor
    func downgradeToFree() {
        currentTier = .free
        isSubscriptionActive = false
        UserDefaults.standard.subscriptionTier = .free

        // Clear premium settings
        premiumTierSettings = PremiumTierSettings()
        UserDefaults.standard.premiumTierSettings = premiumTierSettings

        print("📉 Downgraded to Free")

        // Post notification
        NotificationCenter.default.post(name: .subscriptionTierChanged, object: nil)
    }

    // MARK: - Free Tier Settings

    func updateFreeTierSettings(_ settings: FreeTierSettings) {
        freeTierSettings = settings
        UserDefaults.standard.freeTierSettings = settings
        print("💾 Free tier settings updated: \(settings.dailyLimitHours)h")
    }

    func updateDailyLimit(hours: Double) {
        var settings = freeTierSettings
        settings.dailyLimit = hours * 3600.0 // Convert hours to seconds
        updateFreeTierSettings(settings)
    }

    func updateAutoUnlockTime(hour: Int, minute: Int) {
        var settings = freeTierSettings
        settings.autoUnlockHour = hour
        settings.autoUnlockMinute = minute
        updateFreeTierSettings(settings)
    }

    // MARK: - Premium Tier Settings

    func updatePremiumTierSettings(_ settings: PremiumTierSettings) {
        premiumTierSettings = settings
        UserDefaults.standard.premiumTierSettings = settings
        print("💾 Premium tier settings updated: \(settings.timeSlots.count) time slots")
    }

    // MARK: - Time Slot Management

    /// Check if user can add more time slots
    func canAddTimeSlot() -> Bool {
        guard currentTier == .premium else {
            return false
        }

        return premiumTierSettings.timeSlots.count < currentTier.maxTimeSlots
    }

    /// Add a new time slot (Premium only)
    func addTimeSlot(_ timeSlot: TimeSlot) throws {
        guard currentTier == .premium else {
            throw SubscriptionError.requiresPremium
        }

        guard canAddTimeSlot() else {
            throw SubscriptionError.maxTimeSlotsReached
        }

        // Validate time slot
        guard timeSlot.isValid else {
            throw SubscriptionError.invalidTimeSlot
        }

        // Check for overlaps
        for existingSlot in premiumTierSettings.timeSlots {
            if timeSlot.overlaps(with: existingSlot) {
                throw SubscriptionError.overlappingTimeSlots
            }
        }

        // Add time slot
        var settings = premiumTierSettings
        settings.timeSlots.append(timeSlot)
        updatePremiumTierSettings(settings)

        print("✅ Time slot added: \(timeSlot.name)")
    }

    /// Update an existing time slot
    func updateTimeSlot(_ timeSlot: TimeSlot) throws {
        guard currentTier == .premium else {
            throw SubscriptionError.requiresPremium
        }

        guard let index = premiumTierSettings.timeSlots.firstIndex(where: { $0.id == timeSlot.id }) else {
            throw SubscriptionError.timeSlotNotFound
        }

        // Validate time slot
        guard timeSlot.isValid else {
            throw SubscriptionError.invalidTimeSlot
        }

        // Check for overlaps (excluding itself)
        for (i, existingSlot) in premiumTierSettings.timeSlots.enumerated() where i != index {
            if timeSlot.overlaps(with: existingSlot) {
                throw SubscriptionError.overlappingTimeSlots
            }
        }

        // Update time slot
        var settings = premiumTierSettings
        settings.timeSlots[index] = timeSlot
        updatePremiumTierSettings(settings)

        print("✏️ Time slot updated: \(timeSlot.name)")
    }

    /// Remove a time slot
    func removeTimeSlot(_ timeSlot: TimeSlot) {
        guard currentTier == .premium else {
            return
        }

        var settings = premiumTierSettings
        settings.timeSlots.removeAll { $0.id == timeSlot.id }
        updatePremiumTierSettings(settings)

        print("🗑️ Time slot removed: \(timeSlot.name)")
    }

    /// Get the current active time slot
    func getCurrentTimeSlot() -> TimeSlot? {
        guard currentTier == .premium else {
            return nil
        }

        return premiumTierSettings.getCurrentTimeSlot()
    }

    // MARK: - Usage Limit Check

    /// Check if device should be locked based on current tier and usage
    func shouldLockDevice(todayUsage: TimeInterval, currentSlotUsage: TimeInterval? = nil) -> Bool {
        switch currentTier {
        case .free:
            // Free: check total daily usage
            return todayUsage >= freeTierSettings.dailyLimit

        case .premium:
            if !premiumTierSettings.useTimeSlotMode {
                // Premium but using daily mode
                // Premium users in daily mode have no limit (or could set one)
                return false
            }

            // Premium with time slot mode
            guard let currentSlot = getCurrentTimeSlot() else {
                // Not in any time slot - no restriction
                return false
            }

            // Check if usage in current time slot exceeds limit
            if let slotUsage = currentSlotUsage {
                return slotUsage >= currentSlot.allowedDuration
            }

            return false
        }
    }

    // MARK: - Feature Access

    func hasFeatureAccess(_ feature: PremiumFeature) -> Bool {
        switch feature {
        case .timeSlots:
            return currentTier == .premium
        case .unlimitedUnlockAttempts:
            return currentTier == .premium
        case .unlimitedWordRefreshes:
            return currentTier == .premium
        case .dualAIEvaluation:
            return currentTier == .premium
        case .unlimitedStatistics:
            return currentTier == .premium
        case .noAds:
            return currentTier == .premium
        case .timeSlotStatistics:
            return currentTier == .premium
        case .aiOptimization:
            return currentTier == .premium
        case .presetTemplates:
            return currentTier == .premium
        }
    }
}

// MARK: - Premium Features

enum PremiumFeature {
    case timeSlots
    case unlimitedUnlockAttempts
    case unlimitedWordRefreshes
    case dualAIEvaluation
    case unlimitedStatistics
    case noAds
    case timeSlotStatistics
    case aiOptimization
    case presetTemplates
}

// MARK: - Subscription Errors

enum SubscriptionError: LocalizedError {
    case requiresPremium
    case maxTimeSlotsReached
    case invalidTimeSlot
    case overlappingTimeSlots
    case timeSlotNotFound

    var errorDescription: String? {
        switch self {
        case .requiresPremium:
            return "subscription_error_requires_premium".localized
        case .maxTimeSlotsReached:
            return "subscription_error_max_time_slots".localized
        case .invalidTimeSlot:
            return "subscription_error_invalid_time_slot".localized
        case .overlappingTimeSlots:
            return "subscription_error_overlapping_time_slots".localized
        case .timeSlotNotFound:
            return "subscription_error_time_slot_not_found".localized
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let subscriptionTierChanged = Notification.Name("subscriptionTierChanged")
}
