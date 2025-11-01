//
//  UsageRecord+CoreDataProperties.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import CoreData

extension UsageRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsageRecord> {
        return NSFetchRequest<UsageRecord>(entityName: "UsageRecord")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var usageMinutes: Int32
    @NSManaged public var goalMinutes: Int32
    @NSManaged public var isGoalAchieved: Bool

}

extension UsageRecord : Identifiable {

}
