//
//  UnlockAttempt+CoreDataProperties.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import CoreData

extension UnlockAttempt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UnlockAttempt> {
        return NSFetchRequest<UnlockAttempt>(entityName: "UnlockAttempt")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var word1: String?
    @NSManaged public var word2: String?
    @NSManaged public var sentence: String?
    @NSManaged public var chatGPTResult: String?
    @NSManaged public var claudeResult: String?
    @NSManaged public var isSuccessful: Bool

}

extension UnlockAttempt : Identifiable {

}
