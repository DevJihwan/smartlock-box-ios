//
//  AppGroupDefaults.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-03.
//

import Foundation

/// Shared storage for communication between main app and DeviceActivity extension
class AppGroupDefaults {

    // MARK: - Singleton

    static let shared = AppGroupDefaults()

    // MARK: - Properties

    private let appGroupIdentifier = "group.com.devjihwan.smartlockbox"

    private var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupIdentifier)
    }

    // MARK: - Keys

    enum Key: String {
        // Monitoring status
        case isMonitoring
        case lastIntervalStartTime
        case lastIntervalEndTime

        // Threshold events
        case thresholdReached
        case thresholdReachedTime
        case thresholdWarning
        case thresholdWarningTime

        // Warning events
        case warningTriggered
        case warningTime
        case intervalEndingWarning
        case intervalEndingWarningTime

        // Usage tracking
        case todayUsageSeconds
        case lastUsageUpdateTime

        // Lock state
        case isLocked
        case lockTime
        case unlockTime
    }

    // MARK: - Initialization

    private init() {
        // Verify app group is accessible
        guard sharedDefaults != nil else {
            print("❌ AppGroupDefaults: Failed to access app group '\(appGroupIdentifier)'")
            return
        }
        print("✅ AppGroupDefaults: Successfully initialized with app group '\(appGroupIdentifier)'")
    }

    // MARK: - Generic Accessors

    func set(_ value: Any?, forKey key: Key) {
        sharedDefaults?.set(value, forKey: key.rawValue)
    }

    func get(forKey key: Key) -> Any? {
        return sharedDefaults?.object(forKey: key.rawValue)
    }

    func getBool(forKey key: Key) -> Bool {
        return sharedDefaults?.bool(forKey: key.rawValue) ?? false
    }

    func getInt(forKey key: Key) -> Int {
        return sharedDefaults?.integer(forKey: key.rawValue) ?? 0
    }

    func getDouble(forKey key: Key) -> Double {
        return sharedDefaults?.double(forKey: key.rawValue) ?? 0.0
    }

    func getString(forKey key: Key) -> String? {
        return sharedDefaults?.string(forKey: key.rawValue)
    }

    func getDate(forKey key: Key) -> Date? {
        return sharedDefaults?.object(forKey: key.rawValue) as? Date
    }

    func remove(forKey key: Key) {
        sharedDefaults?.removeObject(forKey: key.rawValue)
    }

    // MARK: - Monitoring Status

    var isMonitoring: Bool {
        get { getBool(forKey: .isMonitoring) }
        set { set(newValue, forKey: .isMonitoring) }
    }

    var lastIntervalStartTime: Date? {
        get { getDate(forKey: .lastIntervalStartTime) }
        set { set(newValue, forKey: .lastIntervalStartTime) }
    }

    var lastIntervalEndTime: Date? {
        get { getDate(forKey: .lastIntervalEndTime) }
        set { set(newValue, forKey: .lastIntervalEndTime) }
    }

    // MARK: - Threshold Events

    var thresholdReached: Bool {
        get { getBool(forKey: .thresholdReached) }
        set { set(newValue, forKey: .thresholdReached) }
    }

    var thresholdReachedTime: Date? {
        get { getDate(forKey: .thresholdReachedTime) }
        set { set(newValue, forKey: .thresholdReachedTime) }
    }

    var thresholdWarning: Bool {
        get { getBool(forKey: .thresholdWarning) }
        set { set(newValue, forKey: .thresholdWarning) }
    }

    var thresholdWarningTime: Date? {
        get { getDate(forKey: .thresholdWarningTime) }
        set { set(newValue, forKey: .thresholdWarningTime) }
    }

    // MARK: - Warning Events

    var warningTriggered: Bool {
        get { getBool(forKey: .warningTriggered) }
        set { set(newValue, forKey: .warningTriggered) }
    }

    var warningTime: Date? {
        get { getDate(forKey: .warningTime) }
        set { set(newValue, forKey: .warningTime) }
    }

    // MARK: - Usage Tracking

    var todayUsageSeconds: Int {
        get { getInt(forKey: .todayUsageSeconds) }
        set { set(newValue, forKey: .todayUsageSeconds) }
    }

    var lastUsageUpdateTime: Date? {
        get { getDate(forKey: .lastUsageUpdateTime) }
        set { set(newValue, forKey: .lastUsageUpdateTime) }
    }

    // MARK: - Lock State

    var isLocked: Bool {
        get { getBool(forKey: .isLocked) }
        set { set(newValue, forKey: .isLocked) }
    }

    var lockTime: Date? {
        get { getDate(forKey: .lockTime) }
        set { set(newValue, forKey: .lockTime) }
    }

    var unlockTime: Date? {
        get { getDate(forKey: .unlockTime) }
        set { set(newValue, forKey: .unlockTime) }
    }

    // MARK: - Utilities

    func clearAll() {
        guard let defaults = sharedDefaults else { return }

        Key.allCases.forEach { key in
            defaults.removeObject(forKey: key.rawValue)
        }

        print("🗑️ AppGroupDefaults: Cleared all shared data")
    }

    func synchronize() {
        sharedDefaults?.synchronize()
    }
}

// MARK: - Key CaseIterable

extension AppGroupDefaults.Key: CaseIterable {}
