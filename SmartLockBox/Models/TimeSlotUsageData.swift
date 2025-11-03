//
//  TimeSlotUsageData.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-03.
//

import Foundation

// MARK: - Time Slot Usage Data

struct TimeSlotUsageData: Codable {
    let timeSlotId: UUID
    var usageSeconds: TimeInterval
    var lastUpdated: Date

    init(timeSlotId: UUID, usageSeconds: TimeInterval = 0, lastUpdated: Date = Date()) {
        self.timeSlotId = timeSlotId
        self.usageSeconds = usageSeconds
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Daily Usage Record

struct DailyUsageRecord: Codable {
    let date: Date
    var totalUsageSeconds: TimeInterval
    var timeSlotUsages: [TimeSlotUsageData]

    init(date: Date = Date(), totalUsageSeconds: TimeInterval = 0, timeSlotUsages: [TimeSlotUsageData] = []) {
        self.date = date
        self.totalUsageSeconds = totalUsageSeconds
        self.timeSlotUsages = timeSlotUsages
    }

    // Get usage for a specific time slot
    func usage(for timeSlotId: UUID) -> TimeInterval {
        return timeSlotUsages.first { $0.timeSlotId == timeSlotId }?.usageSeconds ?? 0
    }

    // Update usage for a specific time slot
    mutating func updateUsage(for timeSlotId: UUID, seconds: TimeInterval) {
        if let index = timeSlotUsages.firstIndex(where: { $0.timeSlotId == timeSlotId }) {
            timeSlotUsages[index].usageSeconds = seconds
            timeSlotUsages[index].lastUpdated = Date()
        } else {
            timeSlotUsages.append(TimeSlotUsageData(timeSlotId: timeSlotId, usageSeconds: seconds))
        }
    }
}

// MARK: - User Defaults Extension

extension UserDefaults {
    private enum Keys {
        static let dailyUsageRecord = "dailyUsageRecord"
    }

    var dailyUsageRecord: DailyUsageRecord {
        get {
            guard let data = data(forKey: Keys.dailyUsageRecord),
                  let record = try? JSONDecoder().decode(DailyUsageRecord.self, from: data) else {
                return DailyUsageRecord()
            }

            // Check if record is from today
            let calendar = Calendar.current
            if calendar.isDateInToday(record.date) {
                return record
            } else {
                // Return fresh record for new day
                return DailyUsageRecord()
            }
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                set(data, forKey: Keys.dailyUsageRecord)
            }
        }
    }
}
