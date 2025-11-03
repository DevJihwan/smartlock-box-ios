//
//  SubscriptionModels.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-03.
//

import Foundation

// MARK: - Subscription Tier

enum SubscriptionTier: String, Codable {
    case free = "free"
    case premium = "premium"

    var displayName: String {
        switch self {
        case .free:
            return "subscription_tier_free".localized
        case .premium:
            return "subscription_tier_premium".localized
        }
    }

    var maxTimeSlots: Int {
        switch self {
        case .free:
            return 0 // Free users cannot create time slots
        case .premium:
            return 3 // Premium users can create up to 3 time slots
        }
    }

    var unlockAttempts: Int? {
        switch self {
        case .free:
            return 3 // 3 attempts per day
        case .premium:
            return nil // Unlimited
        }
    }

    var wordRefreshes: Int? {
        switch self {
        case .free:
            return 1 // 1 refresh per day
        case .premium:
            return nil // Unlimited
        }
    }
}

// MARK: - Time Slot

struct TimeSlot: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var startHour: Int
    var startMinute: Int
    var endHour: Int
    var endMinute: Int
    var allowedDuration: TimeInterval // in seconds
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        startHour: Int,
        startMinute: Int,
        endHour: Int,
        endMinute: Int,
        allowedDuration: TimeInterval,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.allowedDuration = allowedDuration
        self.createdAt = createdAt
    }

    // MARK: - Computed Properties

    var startTime: Date {
        var components = DateComponents()
        components.hour = startHour
        components.minute = startMinute
        return Calendar.current.date(from: components) ?? Date()
    }

    var endTime: Date {
        var components = DateComponents()
        components.hour = endHour
        components.minute = endMinute
        return Calendar.current.date(from: components) ?? Date()
    }

    /// Duration of the time slot in seconds
    var slotDuration: TimeInterval {
        let start = startHour * 3600 + startMinute * 60
        let end = endHour * 3600 + endMinute * 60
        return TimeInterval(end - start)
    }

    /// Duration in hours (for display)
    var slotDurationHours: Double {
        slotDuration / 3600.0
    }

    /// Allowed duration in hours (for display)
    var allowedDurationHours: Double {
        allowedDuration / 3600.0
    }

    // MARK: - Validation

    /// Check if this time slot overlaps with another
    func overlaps(with other: TimeSlot) -> Bool {
        let thisStart = startHour * 60 + startMinute
        let thisEnd = endHour * 60 + endMinute
        let otherStart = other.startHour * 60 + other.startMinute
        let otherEnd = other.endHour * 60 + other.endMinute

        // Check for overlap
        return !(thisEnd <= otherStart || thisStart >= otherEnd)
    }

    /// Check if a given time falls within this time slot
    func contains(time: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        guard let hour = components.hour, let minute = components.minute else {
            return false
        }

        let timeInMinutes = hour * 60 + minute
        let startInMinutes = startHour * 60 + startMinute
        let endInMinutes = endHour * 60 + endMinute

        return timeInMinutes >= startInMinutes && timeInMinutes < endInMinutes
    }

    /// Validate this time slot
    var isValid: Bool {
        // Must be at least 1 hour long
        guard slotDuration >= 3600 else { return false }

        // Start time must be before end time
        let startInMinutes = startHour * 60 + startMinute
        let endInMinutes = endHour * 60 + endMinute
        guard startInMinutes < endInMinutes else { return false }

        // Hours must be in valid range (0-23)
        guard startHour >= 0 && startHour <= 23 else { return false }
        guard endHour >= 0 && endHour <= 23 else { return false }

        // Minutes must be in valid range (0-59)
        guard startMinute >= 0 && startMinute <= 59 else { return false }
        guard endMinute >= 0 && endMinute <= 59 else { return false }

        // Allowed duration must not exceed slot duration
        guard allowedDuration <= slotDuration else { return false }

        return true
    }

    // MARK: - Formatting

    func formatTime(hour: Int, minute: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        if let date = Calendar.current.date(from: components) {
            return formatter.string(from: date)
        }

        return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
    }

    var formattedTimeRange: String {
        let start = formatTime(hour: startHour, minute: startMinute)
        let end = formatTime(hour: endHour, minute: endMinute)
        return "\(start) - \(end)"
    }
}

// MARK: - Free Tier Settings

struct FreeTierSettings: Codable {
    var dailyLimit: TimeInterval // Total allowed duration per day in seconds
    var autoUnlockHour: Int
    var autoUnlockMinute: Int

    init(
        dailyLimit: TimeInterval = 10800, // 3 hours default
        autoUnlockHour: Int = 0,
        autoUnlockMinute: Int = 0
    ) {
        self.dailyLimit = dailyLimit
        self.autoUnlockHour = autoUnlockHour
        self.autoUnlockMinute = autoUnlockMinute
    }

    var dailyLimitHours: Double {
        dailyLimit / 3600.0
    }

    var autoUnlockTime: (hour: Int, minute: Int) {
        (autoUnlockHour, autoUnlockMinute)
    }
}

// MARK: - Premium Tier Settings

struct PremiumTierSettings: Codable {
    var timeSlots: [TimeSlot]
    var useTimeSlotMode: Bool // true: time slot mode, false: daily total mode

    init(
        timeSlots: [TimeSlot] = [],
        useTimeSlotMode: Bool = true
    ) {
        self.timeSlots = timeSlots
        self.useTimeSlotMode = useTimeSlotMode
    }

    /// Validate that time slots don't overlap
    var hasOverlappingSlots: Bool {
        for i in 0..<timeSlots.count {
            for j in (i+1)..<timeSlots.count {
                if timeSlots[i].overlaps(with: timeSlots[j]) {
                    return true
                }
            }
        }
        return false
    }

    /// Get the current active time slot
    func getCurrentTimeSlot() -> TimeSlot? {
        let now = Date()
        return timeSlots.first { $0.contains(time: now) }
    }
}

// MARK: - User Defaults Extensions

extension UserDefaults {
    private enum Keys {
        static let subscriptionTier = "subscriptionTier"
        static let freeTierSettings = "freeTierSettings"
        static let premiumTierSettings = "premiumTierSettings"
    }

    var subscriptionTier: SubscriptionTier {
        get {
            guard let rawValue = string(forKey: Keys.subscriptionTier),
                  let tier = SubscriptionTier(rawValue: rawValue) else {
                return .free
            }
            return tier
        }
        set {
            set(newValue.rawValue, forKey: Keys.subscriptionTier)
        }
    }

    var freeTierSettings: FreeTierSettings {
        get {
            guard let data = data(forKey: Keys.freeTierSettings),
                  let settings = try? JSONDecoder().decode(FreeTierSettings.self, from: data) else {
                return FreeTierSettings()
            }
            return settings
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                set(data, forKey: Keys.freeTierSettings)
            }
        }
    }

    var premiumTierSettings: PremiumTierSettings {
        get {
            guard let data = data(forKey: Keys.premiumTierSettings),
                  let settings = try? JSONDecoder().decode(PremiumTierSettings.self, from: data) else {
                return PremiumTierSettings()
            }
            return settings
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                set(data, forKey: Keys.premiumTierSettings)
            }
        }
    }
}
