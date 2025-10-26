//
//  UsageRecord+CoreDataProperties.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-25.
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
    @NSManaged public var achieved: Bool
    
    // Convenience property to match existing code usage
    var isGoalAchieved: Bool {
        get { achieved }
        set { achieved = newValue }
    }
}

extension UsageRecord : Identifiable {
}
