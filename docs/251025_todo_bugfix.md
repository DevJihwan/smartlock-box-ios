# CoreData fetchRequest() 중복 선언 오류 수정

**작성일**: 2025년 10월 25일  
**작성자**: DevJihwan  
**우선순위**: 🔴 HIGH (빌드 실패)

---

## 🐛 오류 상황

### 빌드 오류 메시지

```
1. Command SwiftCompile failed with a nonzero exit code

2. /Users/jihwanseok/Library/Developer/Xcode/DerivedData/SmartLockBox-frdkfkkpnyzvqjazhdiwizrxhcky/Build/Intermediates.noindex/SmartLockBox.build/Debug-iphonesimulator/SmartLockBox.build/DerivedSources/CoreDataGenerated/SmartLockBox/UnlockAttempt+CoreDataProperties.swift:16:32
Invalid redeclaration of 'fetchRequest()'

3. /Users/jihwanseok/Library/Developer/Xcode/DerivedData/SmartLockBox-frdkfkkpnyzvqjazhdiwizrxhcky/Build/Intermediates.noindex/SmartLockBox.build/Debug-iphonesimulator/SmartLockBox.build/DerivedSources/CoreDataGenerated/SmartLockBox/UsageRecord+CoreDataProperties.swift:16:32
Invalid redeclaration of 'fetchRequest()'
```

---

## 🔍 문제 분석

### 근본 원인

CoreData 모델 파일(`SmartLockBox.xcdatamodeld/SmartLockBox.xcdatamodel/contents`)에서 두 엔티티가 다음과 같이 설정되어 있습니다:

```xml
<entity name="UsageRecord" representedClassName="UsageRecord" 
        syncable="YES" codeGenerationType="class">
```

```xml
<entity name="UnlockAttempt" representedClassName="UnlockAttempt" 
        syncable="YES" codeGenerationType="class">
```

### 문제 상세 설명

1. **자동 코드 생성 설정**: `codeGenerationType="class"`
   - Xcode가 자동으로 `UnlockAttempt+CoreDataClass.swift` 생성
   - Xcode가 자동으로 `UnlockAttempt+CoreDataProperties.swift` 생성
   - Properties 파일에 `fetchRequest()` 메서드가 자동으로 포함됨

2. **수동 Extension 파일 존재**:
   - `SmartLockBox/Models/UnlockAttempt+CoreDataExtensions.swift`
   - `SmartLockBox/Models/UsageRecord+CoreDataExtensions.swift`
   - 이 파일들에 `createFetchRequest()` 메서드가 정의되어 있음

3. **충돌 발생**:
   - Xcode 자동 생성: `fetchRequest()` 메서드
   - 수동 파일: 비슷한 목적의 메서드
   - 빌드 시스템이 중복 선언으로 인식

---

## ✅ 해결 방안

### 방법 1: Codegen을 Manual/None으로 변경 (권장)

**장점**:
- 완전한 수동 제어 가능
- Extension 파일과 충돌 없음
- 코드 커스터마이징 자유로움

**단점**:
- 모든 CoreData 클래스를 수동으로 작성해야 함
- 모델 변경 시 수동으로 클래스도 업데이트 필요

#### 실행 단계:

1. **Xcode에서 CoreData 모델 파일 열기**
   ```
   SmartLockBox.xcdatamodeld 파일 선택
   ```

2. **각 엔티티 선택 후 Codegen 변경**
   - `UnlockAttempt` 엔티티 선택
   - Data Model Inspector (⌥⌘3) 열기
   - Codegen: `Class Definition` → `Manual/None` 변경
   
   - `UsageRecord` 엔티티 선택
   - Data Model Inspector (⌥⌘3) 열기
   - Codegen: `Class Definition` → `Manual/None` 변경

3. **수동으로 CoreData 클래스 파일 작성**

   **파일 1**: `SmartLockBox/Models/UnlockAttempt+CoreDataClass.swift`
   ```swift
   //
   //  UnlockAttempt+CoreDataClass.swift
   //  SmartLockBox
   //
   
   import Foundation
   import CoreData
   
   @objc(UnlockAttempt)
   public class UnlockAttempt: NSManagedObject {
   }
   ```

   **파일 2**: `SmartLockBox/Models/UnlockAttempt+CoreDataProperties.swift`
   ```swift
   //
   //  UnlockAttempt+CoreDataProperties.swift
   //  SmartLockBox
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
   }
   
   extension UnlockAttempt : Identifiable {
   }
   ```

   **파일 3**: `SmartLockBox/Models/UsageRecord+CoreDataClass.swift`
   ```swift
   //
   //  UsageRecord+CoreDataClass.swift
   //  SmartLockBox
   //
   
   import Foundation
   import CoreData
   
   @objc(UsageRecord)
   public class UsageRecord: NSManagedObject {
   }
   ```

   **파일 4**: `SmartLockBox/Models/UsageRecord+CoreDataProperties.swift`
   ```swift
   //
   //  UsageRecord+CoreDataProperties.swift
   //  SmartLockBox
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
   }
   
   extension UsageRecord : Identifiable {
   }
   ```

4. **기존 Extension 파일 삭제 또는 병합**
   - `UnlockAttempt+CoreDataExtensions.swift` 삭제 (또는 필요한 메서드만 Properties 파일에 병합)
   - `UsageRecord+CoreDataExtensions.swift` 삭제 (또는 필요한 메서드만 Properties 파일에 병합)

5. **Clean Build Folder**
   ```
   Product → Clean Build Folder (⇧⌘K)
   또는
   rm -rf ~/Library/Developer/Xcode/DerivedData/SmartLockBox-*
   ```

6. **빌드 및 테스트**
   ```
   ⌘B (빌드)
   ⌘R (실행)
   ```

---

### 방법 2: Category/Extension으로 변경

**장점**:
- Properties만 자동 생성
- 클래스 파일은 수동 관리
- 부분적 자동화 가능

**단점**:
- Properties 파일은 자동 생성되어 편집 불가
- 약간의 혼란 가능성

#### 실행 단계:

1. **Xcode에서 CoreData 모델 파일 열기**

2. **각 엔티티의 Codegen을 변경**
   - Codegen: `Class Definition` → `Category/Extension` 변경

3. **클래스 파일만 수동 작성**
   - Properties 파일은 Xcode가 자동 생성
   - Class 파일만 직접 작성

4. **Clean Build 및 재빌드**

---

### 방법 3: Extension 파일 제거 (비권장)

**장점**:
- 가장 간단한 방법
- 즉시 해결 가능

**단점**:
- 커스텀 메서드를 추가할 공간이 없음
- 확장성이 제한됨

#### 실행 단계:

1. **Extension 파일 삭제**
   - `UnlockAttempt+CoreDataExtensions.swift` 삭제
   - `UsageRecord+CoreDataExtensions.swift` 삭제

2. **Clean Build 및 재빌드**

---

## 📋 권장 수정 방안: 방법 1 (Manual/None)

### 단계별 체크리스트

- [ ] 1. Xcode에서 `SmartLockBox.xcdatamodeld` 파일 열기
- [ ] 2. `UnlockAttempt` 엔티티 선택 → Codegen을 `Manual/None`으로 변경
- [ ] 3. `UsageRecord` 엔티티 선택 → Codegen을 `Manual/None`으로 변경
- [ ] 4. `UnlockAttempt+CoreDataClass.swift` 파일 생성
- [ ] 5. `UnlockAttempt+CoreDataProperties.swift` 파일 생성 (모든 속성 포함)
- [ ] 6. `UsageRecord+CoreDataClass.swift` 파일 생성
- [ ] 7. `UsageRecord+CoreDataProperties.swift` 파일 생성 (모든 속성 포함)
- [ ] 8. 기존 `*+CoreDataExtensions.swift` 파일 삭제
- [ ] 9. DerivedData 폴더 삭제: `rm -rf ~/Library/Developer/Xcode/DerivedData/SmartLockBox-*`
- [ ] 10. Clean Build Folder (⇧⌘K)
- [ ] 11. 프로젝트 빌드 (⌘B)
- [ ] 12. 테스트 실행하여 정상 동작 확인

---

## 🔧 추가 확인 사항

### UsageDataService.swift 업데이트 필요

기존 코드에서 `createFetchRequest()`를 사용하고 있다면 `fetchRequest()`로 변경해야 합니다.

**변경 전**:
```swift
let request = UnlockAttempt.createFetchRequest()
let request = UsageRecord.createFetchRequest()
```

**변경 후**:
```swift
let request = UnlockAttempt.fetchRequest()
let request = UsageRecord.fetchRequest()
```

### 영향받는 파일 목록

다음 파일들을 검색하여 `createFetchRequest()` 사용을 확인하고 `fetchRequest()`로 변경:

```bash
grep -r "createFetchRequest" SmartLockBox/
```

예상 파일:
- `SmartLockBox/Services/UsageDataService.swift`
- `SmartLockBox/Services/PersistenceController.swift`
- 기타 CoreData 관련 서비스 파일

---

## 📊 작업 진행 상황

### Phase별 완료 현황 (문서 검토 결과)

```
Phase 1:   100% ████████████ ✅ 완료 (2025-10-10)
  - 단어 데이터베이스 구축
  - AI API 연동 (OpenAI, Claude)
  - Screen Time API 구현
  - Core Data CRUD 구현

Phase 1.5: 100% ████████████ ✅ 완료 (2025-10-12)
  - LocalizationManager 구현
  - 한국어/영어 번역 (72개 키)
  - 언어 선택 UI 컴포넌트
  - 다국어 지원 가이드 문서

Phase 2:   100% ████████████ ✅ 완료 (2025-10-16)
  - 알림 시스템 구현 (5가지 유형)
  - 애니메이션 컴포넌트 (프로그레스바, 자물쇠)
  - UI/UX 개선 (메인, 잠금 화면)
  - 설정 화면 완성

Phase 3:   100% ████████████ ✅ 완료 (2025-10-16)
  - 다크 모드 지원
  - 색상 시스템 구축
  - 모든 화면 다크 모드 대응

Bugfix:      0% ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ 🔴 진행중 (2025-10-25)
  - CoreData fetchRequest 중복 선언 오류
```

### 현재 상태

✅ **완료된 기능**:
- Phase 1~3 모든 핵심 기능 구현 완료
- 총 120개 단어 데이터베이스
- AI 이중 평가 시스템
- Screen Time 앱 차단
- 다국어 지원 (한국어, 영어)
- 알림 시스템
- 다크 모드

🔴 **현재 이슈**:
- CoreData 빌드 오류로 인한 앱 실행 불가
- `fetchRequest()` 메서드 중복 선언 문제

---

## 🎯 예상 소요 시간

- Codegen 설정 변경: 5분
- CoreData 클래스 파일 수동 작성: 20분
- 기존 코드에서 메서드명 변경: 10분
- 빌드 테스트 및 검증: 10분

**총 예상 시간**: 약 45분

---

## ⚠️ 주의사항

1. **백업 필수**
   - 작업 전 현재 코드를 Git에 커밋
   - 브랜치를 생성하여 작업하는 것을 권장

2. **DerivedData 삭제**
   - 반드시 DerivedData 폴더를 삭제하여 이전 자동 생성 파일 제거

3. **전체 빌드 확인**
   - 수정 후 반드시 Clean Build를 수행
   - 시뮬레이터와 실제 기기 모두에서 테스트

4. **CoreData 마이그레이션**
   - 현재는 모델 구조 변경이 아니므로 마이그레이션 불필요
   - Codegen 설정만 변경하는 것이므로 데이터 손실 없음

---

## 📝 참고 문서

### Apple 공식 문서
- [Core Data Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/)
- [Using Core Data with SwiftUI](https://developer.apple.com/documentation/coredata/using_core_data_with_swiftui)
- [NSManagedObject Code Generation](https://developer.apple.com/documentation/coredata/modeling_data/generating_code)

### 프로젝트 내부 문서
- `docs/phase1_completed_251010.md` - Core Data 구현 상세
- `docs/working_251010.md` - 작업 로그
- `docs/todolist_251010.md` - 전체 계획

---

## 🎉 수정 완료 후 확인 사항

### 빌드 성공 확인
- [ ] Clean Build 성공
- [ ] 일반 빌드 성공
- [ ] Warning 없음
- [ ] 시뮬레이터 실행 성공
- [ ] 실제 기기 실행 성공

### 기능 정상 동작 확인
- [ ] CoreData 읽기 동작 확인
- [ ] CoreData 쓰기 동작 확인
- [ ] UsageRecord 저장/조회 테스트
- [ ] UnlockAttempt 저장/조회 테스트
- [ ] 통계 화면 정상 표시
- [ ] 앱 전체 기능 테스트

---

## 💬 문의 및 지원

수정 중 문제가 발생하거나 추가 도움이 필요한 경우:

1. **GitHub Issues 생성**
   - 오류 메시지 전체 복사
   - 스크린샷 첨부
   - 수행한 단계 상세 기록

2. **관련 로그 확인**
   ```bash
   # Xcode 빌드 로그 상세 보기
   Product → Show Build Timeline
   ```

3. **DerivedData 경로 확인**
   ```bash
   ls -la ~/Library/Developer/Xcode/DerivedData/
   ```

---

**작성자**: DevJihwan  
**작성일**: 2025년 10월 25일  
**문서 버전**: 1.0  
**최종 업데이트**: 2025년 10월 25일

---

## 📌 Quick Fix (빠른 해결)

급하게 빌드만 성공시켜야 하는 경우:

```bash
# 1. Extension 파일 삭제
rm SmartLockBox/Models/UnlockAttempt+CoreDataExtensions.swift
rm SmartLockBox/Models/UsageRecord+CoreDataExtensions.swift

# 2. DerivedData 삭제
rm -rf ~/Library/Developer/Xcode/DerivedData/SmartLockBox-*

# 3. Xcode에서 Clean Build (⇧⌘K)
# 4. Build (⌘B)
```

단, 이 방법은 임시 방편이며, 장기적으로는 **방법 1 (Manual/None)**을 적용하는 것을 권장합니다.
