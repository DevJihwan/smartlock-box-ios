//
//  TimeFormatterTests.swift
//  SmartLockBoxTests
//
//  Created by DevJihwan on 2025-10-10.
//

import XCTest
@testable import SmartLockBox

class TimeFormatterTests: XCTestCase {
    
    func testFormatMinutes_WithHoursAndMinutes() {
        let result = TimeFormatter.format(minutes: 150)
        XCTAssertEqual(result, "2시간 30분")
    }
    
    func testFormatMinutes_WithHoursOnly() {
        let result = TimeFormatter.format(minutes: 120)
        XCTAssertEqual(result, "2시간")
    }
    
    func testFormatMinutes_WithMinutesOnly() {
        let result = TimeFormatter.format(minutes: 45)
        XCTAssertEqual(result, "45분")
    }
    
    func testNaturalLanguageRemaining_LessThanHour() {
        let result = TimeFormatter.naturalLanguageRemaining(minutes: 45)
        XCTAssertEqual(result, "45분 남음")
    }
}
