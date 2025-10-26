//
//  UsageDataService.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import CoreData

// MARK: - Data Models

struct UsageData: Identifiable {
    let id = UUID()
    let date: Date
    let usageMinutes: Int
    let goalMinutes: Int
    let achieved: Bool
}

struct WeeklyStats {
    let totalMinutes: Int
    let goalMinutes: Int
    let averageMinutesPerDay: Double
}

struct MonthlyStats {
    let achievedDays: Int
    let totalDays: Int
    let dailyData: [UsageData]
    
    var achievementRate: Double {
        return totalDays > 0 ? Double(achievedDays) / Double(totalDays) * 100.0 : 0.0
    }
}

struct UnlockAttemptData: Identifiable {
    let id = UUID()
    let timestamp: Date
    let word1: String
    let word2: String
    let sentence: String
    let chatGPTResult: String
    let claudeResult: String
    let isSuccessful: Bool
}

// MARK: - UsageDataService

class UsageDataService {
    static let shared = UsageDataService()
    
    private let persistenceController = PersistenceController.shared
    private var context: NSManagedObjectContext {
        return persistenceController.container.viewContext
    }
    
    private init() {}
    
    // MARK: - Usage Records (CRUD)
    
    /// 사용 기록 저장 (Create)
    func saveUsageData(date: Date, usageMinutes: Int, goalMinutes: Int) {
        // 해당 날짜의 기록이 이미 있는지 확인
        if let existing = fetchUsageRecord(for: date) {
            // 기존 기록 업데이트
            existing.usageMinutes = Int32(usageMinutes)
            existing.goalMinutes = Int32(goalMinutes)
            existing.isGoalAchieved = usageMinutes <= goalMinutes
        } else {
            // 새 기록 생성
            let record = UsageRecord(context: context)
            record.id = UUID()
            record.date = date
            record.usageMinutes = Int32(usageMinutes)
            record.goalMinutes = Int32(goalMinutes)
            record.isGoalAchieved = usageMinutes <= goalMinutes
        }
        
        saveContext()
    }
    
    /// 특정 날짜의 사용 기록 조회 (Read)
    func fetchUsageRecord(for date: Date) -> UsageRecord? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request: NSFetchRequest<UsageRecord> = UsageRecord.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("❌ 사용 기록 조회 실패: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 오늘의 사용 기록 조회
    func getTodayUsage() -> UsageData? {
        guard let record = fetchUsageRecord(for: Date()) else {
            return nil
        }
        
        return UsageData(
            date: record.date ?? Date(),
            usageMinutes: Int(record.usageMinutes),
            goalMinutes: Int(record.goalMinutes),
            achieved: record.isGoalAchieved
        )
    }
    
    /// 기간별 사용 기록 조회
    func fetchUsageRecords(from startDate: Date, to endDate: Date) -> [UsageRecord] {
        let request: NSFetchRequest<UsageRecord> = UsageRecord.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("❌ 사용 기록 조회 실패: \(error.localizedDescription)")
            return []
        }
    }
    
    /// 사용 기록 삭제 (Delete)
    func deleteUsageRecord(_ record: UsageRecord) {
        context.delete(record)
        saveContext()
    }
    
    /// 모든 사용 기록 삭제
    func deleteAllUsageRecords() {
        let request: NSFetchRequest<NSFetchRequestResult> = UsageRecord.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
            print("✅ 모든 사용 기록 삭제 완료")
        } catch {
            print("❌ 사용 기록 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Statistics
    
    /// 주간 통계
    func getWeeklyStats() -> WeeklyStats {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
        
        let records = fetchUsageRecords(from: startOfWeek, to: endOfWeek)
        
        let totalMinutes = records.reduce(0) { $0 + Int($1.usageMinutes) }
        let totalGoalMinutes = records.reduce(0) { $0 + Int($1.goalMinutes) }
        let averageMinutes = records.isEmpty ? 0.0 : Double(totalMinutes) / Double(records.count)
        
        return WeeklyStats(
            totalMinutes: totalMinutes,
            goalMinutes: totalGoalMinutes,
            averageMinutesPerDay: averageMinutes
        )
    }
    
    /// 월간 통계
    func getMonthlyStats() -> MonthlyStats {
        let calendar = Calendar.current
        let today = Date()
        
        // 현재 월의 시작일과 마지막일
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        let records = fetchUsageRecords(from: startOfMonth, to: endOfMonth)
        
        // 날짜별로 데이터 매핑
        var dailyDataDict: [Date: UsageData] = [:]
        for record in records {
            guard let date = record.date else { continue }
            let dayStart = calendar.startOfDay(for: date)
            
            dailyDataDict[dayStart] = UsageData(
                date: dayStart,
                usageMinutes: Int(record.usageMinutes),
                goalMinutes: Int(record.goalMinutes),
                achieved: record.isGoalAchieved
            )
        }
        
        // 전체 월의 날짜 배열 생성
        var dailyData: [UsageData] = []
        var currentDate = startOfMonth
        
        while currentDate <= endOfMonth {
            let dayStart = calendar.startOfDay(for: currentDate)
            
            if let data = dailyDataDict[dayStart] {
                dailyData.append(data)
            } else {
                // 데이터가 없는 날은 0으로 처리
                dailyData.append(UsageData(
                    date: dayStart,
                    usageMinutes: 0,
                    goalMinutes: 180,
                    achieved: false
                ))
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        let achievedDays = dailyData.filter { $0.achieved }.count
        let totalDays = dailyData.count
        
        return MonthlyStats(
            achievedDays: achievedDays,
            totalDays: totalDays,
            dailyData: dailyData
        )
    }
    
    // MARK: - Unlock Attempts (CRUD)
    
    /// 해제 시도 기록 저장
    func saveUnlockAttempt(
        word1: String,
        word2: String,
        sentence: String,
        chatGPTResult: String,
        claudeResult: String,
        isSuccessful: Bool
    ) {
        let attempt = UnlockAttempt(context: context)
        attempt.id = UUID()
        attempt.timestamp = Date()
        attempt.word1 = word1
        attempt.word2 = word2
        attempt.sentence = sentence
        attempt.chatGPTResult = chatGPTResult
        attempt.claudeResult = claudeResult
        attempt.isSuccessful = isSuccessful
        
        saveContext()
        print("✅ 해제 시도 기록 저장 완료")
    }
    
    /// 오늘의 해제 시도 횟수
    func getTodayUnlockAttemptCount() -> Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request: NSFetchRequest<UnlockAttempt> = UnlockAttempt.fetchRequest()
        request.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            return try context.count(for: request)
        } catch {
            print("❌ 해제 시도 횟수 조회 실패: \(error.localizedDescription)")
            return 0
        }
    }
    
    /// 최근 해제 시도 내역 조회
    func fetchRecentUnlockAttempts(limit: Int = 10) -> [UnlockAttemptData] {
        let request: NSFetchRequest<UnlockAttempt> = UnlockAttempt.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = limit
        
        do {
            let results = try context.fetch(request)
            return results.map { attempt in
                UnlockAttemptData(
                    timestamp: attempt.timestamp,
                    word1: attempt.word1 ?? "",
                    word2: attempt.word2 ?? "",
                    sentence: attempt.sentence,
                    chatGPTResult: attempt.chatGPTResult,
                    claudeResult: attempt.claudeResult ?? "",
                    isSuccessful: attempt.isSuccessful
                )
            }
        } catch {
            print("❌ 해제 시도 내역 조회 실패: \(error.localizedDescription)")
            return []
        }
    }
    
    /// 모든 해제 시도 기록 삭제
    func deleteAllUnlockAttempts() {
        let request: NSFetchRequest<NSFetchRequestResult> = UnlockAttempt.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
            print("✅ 모든 해제 시도 기록 삭제 완료")
        } catch {
            print("❌ 해제 시도 기록 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helper Methods
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Core Data 저장 실패: \(error.localizedDescription)")
            }
        }
    }
}
