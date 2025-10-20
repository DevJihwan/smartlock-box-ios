//
//  UnlockAttempt+CoreDataExtensions.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-16.
//

import Foundation
import CoreData

// 확장을 통한 fetchRequest 정의로 중복 선언 문제 해결
extension UnlockAttempt {
    // fetchRequest 메서드명을 createFetchRequest()로 변경하여 충돌 방지
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<UnlockAttempt> {
        return NSFetchRequest<UnlockAttempt>(entityName: "UnlockAttempt")
    }
}
