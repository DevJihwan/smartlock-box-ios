//
//  DeviceActivityMonitor.swift
//  DeviceActivityMonitorExtension
//
//  Created by DevJihwan on 2025-11-03.
//

import DeviceActivity
import Foundation
import ManagedSettings

class DeviceActivityMonitor: DeviceActivityMonitor {

    // App Group identifier for sharing data with main app
    private let appGroupIdentifier = "group.com.devjihwan.smartlockbox"

    // Shared UserDefaults for communication with main app
    private var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupIdentifier)
    }

    // MARK: - DeviceActivityMonitor Overrides

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)

        print("📊 DeviceActivityMonitor: Interval started for \(activity)")

        // Update monitoring status
        sharedDefaults?.set(true, forKey: "isMonitoring")
        sharedDefaults?.set(Date(), forKey: "lastIntervalStartTime")
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)

        print("📊 DeviceActivityMonitor: Interval ended for \(activity)")

        // Update monitoring status
        sharedDefaults?.set(false, forKey: "isMonitoring")
        sharedDefaults?.set(Date(), forKey: "lastIntervalEndTime")
    }

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)

        print("⚠️ DeviceActivityMonitor: Event threshold reached - \(event) for \(activity)")

        // Time limit exceeded - enable app blocking
        let store = ManagedSettingsStore()

        // Record threshold breach
        sharedDefaults?.set(true, forKey: "thresholdReached")
        sharedDefaults?.set(Date(), forKey: "thresholdReachedTime")

        // Notify main app to enable blocking
        // The actual blocking is handled by ScreenTimeManager in the main app
        // This extension just records the event
    }

    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)

        print("⚠️ DeviceActivityMonitor: Interval will start warning for \(activity)")

        // Send warning notification
        sharedDefaults?.set(true, forKey: "warningTriggered")
        sharedDefaults?.set(Date(), forKey: "warningTime")
    }

    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)

        print("⚠️ DeviceActivityMonitor: Interval will end warning for \(activity)")

        // Send warning that interval is about to end
        sharedDefaults?.set(true, forKey: "intervalEndingWarning")
        sharedDefaults?.set(Date(), forKey: "intervalEndingWarningTime")
    }

    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)

        print("⚠️ DeviceActivityMonitor: Event will reach threshold warning - \(event) for \(activity)")

        // Send warning that threshold is approaching
        sharedDefaults?.set(true, forKey: "thresholdWarning")
        sharedDefaults?.set(Date(), forKey: "thresholdWarningTime")
    }
}
