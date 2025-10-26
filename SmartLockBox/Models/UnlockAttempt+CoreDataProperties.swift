//
//  UnlockAttempt+CoreDataProperties.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-25.
//

import Foundation
import CoreData

extension UnlockAttempt {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UnlockAttempt> {
        return NSFetchRequest<UnlockAttempt>(entityName: "UnlockAttempt")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var word1: String?
    @NSManaged public var word2: String?
    @NSManaged public var attemptText: String?
    @NSManaged public var gptResult: String?
    @NSManaged public var claudeResult: String?
    @NSManaged public var success: Bool
    
    // Convenience properties with non-optional values
    var timestamp: Date {
        get { date ?? Date() }
        set { date = newValue }
    }
    
    var sentence: String {
        get { attemptText ?? "" }
        set { attemptText = newValue }
    }
    
    var chatGPTResult: String {
        get { gptResult ?? "" }
        set { gptResult = newValue }
    }
    
    var isSuccessful: Bool {
        get { success }
        set { success = newValue }
    }
}

extension UnlockAttempt : Identifiable {
}
