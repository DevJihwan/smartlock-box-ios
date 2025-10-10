//
//  PersistenceController.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import CoreData

/// Core Data Stack 관리 및 데이터 영속성 컨트롤러
class PersistenceController {
    /// 싱글톤 인스턴스
    static let shared = PersistenceController()
    
    /// 프리뷰 및 테스트용 인스턴스 (메모리 저장소)
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        // 샘플 데이터 생성
        for i in 0..<10 {
            let record = UsageRecord(context: context)
            record.id = UUID()
            record.date = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            record.usageMinutes = Int32.random(in: 120...200)
            record.goalMinutes = 180
            record.isGoalAchieved = record.usageMinutes <= record.goalMinutes
        }
        
        // 샘플 해제 시도 데이터
        for i in 0..<5 {
            let attempt = UnlockAttempt(context: context)
            attempt.id = UUID()
            attempt.timestamp = Calendar.current.date(byAdding: .hour, value: -i, to: Date())
            attempt.word1 = "바다"
            attempt.word2 = "꿈"
            attempt.sentence = "바다에서 꿈같은 일몰을 바라보며 평화를 느꼈다"
            attempt.chatGPTResult = i % 2 == 0 ? "PASS" : "FAIL"
            attempt.claudeResult = i % 3 == 0 ? "PASS" : "FAIL"
            attempt.isSuccessful = i % 2 == 0 && i % 3 == 0
        }
        
        do {
            try context.save()
        } catch {
            print("❌ 프리뷰 데이터 생성 실패: \(error.localizedDescription)")
        }
        
        return controller
    }()
    
    /// Core Data 컨테이너
    let container: NSPersistentContainer
    
    /// 초기화
    /// - Parameter inMemory: true일 경우 메모리에만 저장 (테스트용)
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SmartLockBox")
        
        if inMemory {
            // 메모리 저장소 설정 (테스트/프리뷰용)
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Core Data Store 로드
        container.loadPersistentStores { description, error in
            if let error = error {
                // 프로덕션에서는 적절한 에러 핸들링 필요
                fatalError("❌ Core Data Store 로드 실패: \(error.localizedDescription)")
            } else {
                print("✅ Core Data Store 로드 성공: \(description.url?.lastPathComponent ?? "unknown")")
            }
        }
        
        // 자동 병합 설정
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - Save Context
    
    /// Context 변경사항 저장
    func saveContext() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                print("✅ Core Data 저장 완료")
            } catch {
                let nsError = error as NSError
                print("❌ Core Data 저장 실패: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Batch Operations
    
    /// 특정 엔티티의 모든 데이터 삭제
    /// - Parameter entityName: 엔티티 이름
    func deleteAll(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let result = try container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
            
            // 변경사항을 viewContext에 병합
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                let changes = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
            }
            
            print("✅ \(entityName) 전체 삭제 완료")
        } catch {
            print("❌ \(entityName) 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    /// 모든 데이터 삭제 (초기화)
    func deleteAllData() {
        deleteAll(entityName: "UsageRecord")
        deleteAll(entityName: "UnlockAttempt")
        print("✅ 모든 데이터 삭제 완료")
    }
    
    // MARK: - Background Context
    
    /// 백그라운드 작업을 위한 새로운 Context 생성
    /// - Returns: 백그라운드 Context
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    /// 백그라운드에서 작업 수행
    /// - Parameter block: 수행할 작업
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("❌ 백그라운드 저장 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Data Migration
    
    /// 데이터 마이그레이션 필요 여부 확인
    func needsMigration() -> Bool {
        guard let storeURL = container.persistentStoreDescriptions.first?.url else {
            return false
        }
        
        do {
            let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(
                ofType: NSSQLiteStoreType,
                at: storeURL,
                options: nil
            )
            
            let model = container.managedObjectModel
            return !model.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
        } catch {
            print("⚠️ 마이그레이션 확인 실패: \(error.localizedDescription)")
            return false
        }
    }
    
    /// 경량 마이그레이션 수행
    func performLightweightMigration() {
        let description = container.persistentStoreDescriptions.first
        description?.shouldInferMappingModelAutomatically = true
        description?.shouldMigrateStoreAutomatically = true
        
        print("✅ 경량 마이그레이션 설정 완료")
    }
    
    // MARK: - Debug Helpers
    
    #if DEBUG
    /// 저장소 경로 출력 (디버깅용)
    func printStoreURL() {
        if let url = container.persistentStoreDescriptions.first?.url {
            print("📂 Core Data Store: \(url.path)")
        }
    }
    
    /// 엔티티별 데이터 개수 출력 (디버깅용)
    func printDataCounts() {
        let context = container.viewContext
        
        let usageCount = (try? context.count(for: UsageRecord.fetchRequest())) ?? 0
        let attemptCount = (try? context.count(for: UnlockAttempt.fetchRequest())) ?? 0
        
        print("📊 Core Data 통계:")
        print("  - UsageRecord: \(usageCount)개")
        print("  - UnlockAttempt: \(attemptCount)개")
    }
    #endif
}

// MARK: - Core Data Entity Extensions

extension UsageRecord {
    /// 편리한 초기화
    convenience init(context: NSManagedObjectContext, date: Date, usageMinutes: Int, goalMinutes: Int) {
        self.init(context: context)
        self.id = UUID()
        self.date = date
        self.usageMinutes = Int32(usageMinutes)
        self.goalMinutes = Int32(goalMinutes)
        self.isGoalAchieved = usageMinutes <= goalMinutes
    }
}

extension UnlockAttempt {
    /// 편리한 초기화
    convenience init(
        context: NSManagedObjectContext,
        word1: String,
        word2: String,
        sentence: String,
        chatGPTResult: String,
        claudeResult: String,
        isSuccessful: Bool
    ) {
        self.init(context: context)
        self.id = UUID()
        self.timestamp = Date()
        self.word1 = word1
        self.word2 = word2
        self.sentence = sentence
        self.chatGPTResult = chatGPTResult
        self.claudeResult = claudeResult
        self.isSuccessful = isSuccessful
    }
}
