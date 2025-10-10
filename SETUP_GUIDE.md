# 🚀 SmartLockBox 프로젝트 설정 가이드

## ⚠️ Xcode 프로젝트 파일 생성

GitHub에서 클론한 프로젝트는 Xcode 프로젝트 파일이 올바르게 생성되지 않았습니다.
아래 단계를 따라 프로젝트를 설정해주세요.

## 📝 설정 단계

### 1. 기존 프로젝트 파일 삭제

```bash
cd ~/Desktop/smartlock-box-ios
rm -rf SmartLockBox.xcodeproj
```

### 2. Xcode에서 새 프로젝트 생성

1. **Xcode 실행**
2. **File > New > Project** (⇧⌘N)
3. **iOS > App** 템플릿 선택 후 **Next**
4. 프로젝트 설정:
   ```
   Product Name: SmartLockBox
   Team: (본인 Apple Developer 계정)
   Organization Identifier: com.devjihwan
   Interface: SwiftUI
   Language: Swift
   Storage: Core Data ✅ (반드시 체크!)
   Include Tests: ✅ (체크)
   ```
5. **Next**
6. **Save** 위치: `~/Desktop/smartlock-box-ios` 선택
   - "Create Git repository" 체크 해제 (이미 Git 리포지토리이므로)

### 3. 파일 구조 정리

Xcode가 생성한 기본 파일들을 정리합니다:

```bash
# Xcode 종료 후 터미널에서 실행
cd ~/Desktop/smartlock-box-ios/SmartLockBox

# 기본 생성된 파일 삭제 (이미 GitHub에서 가져온 파일로 대체)
rm -f SmartLockBoxApp.swift
rm -f ContentView.swift
rm -f Assets.xcassets  # 필요시 보관
```

### 4. Xcode에서 파일 추가

#### 4.1 파일 그룹 생성

Xcode 프로젝트 네비게이터에서:

1. `SmartLockBox` 폴더에서 우클릭
2. **New Group** 선택
3. 다음 그룹들을 생성:
   - `Models`
   - `Views`
   - `Views/Components`
   - `ViewModels`
   - `Services`
   - `Managers`
   - `Utils`
   - `Resources`

#### 4.2 파일 추가

각 그룹에 해당하는 `.swift` 파일들을 드래그 앤 드롭으로 추가합니다:

```
Models/
  - AppState.swift
  - UnlockChallenge.swift

Views/
  - MainView.swift
  - LockScreenView.swift
  - UnlockChallengeView.swift
  - SettingsView.swift
  - DetailedStatsView.swift
  
  Components/
    - TodayGoalCard.swift
    - TimeUntilLockCard.swift
    - WeeklyStatsCard.swift
    - MonthlyHeatmapCard.swift

ViewModels/
  - AppStateManager.swift
  - MainViewModel.swift
  - UnlockChallengeViewModel.swift

Services/
  - WordService.swift
  - AIEvaluationService.swift
  - UsageDataService.swift
  - PersistenceController.swift

Managers/
  - NotificationManager.swift
  - ScreenTimeManager.swift

Utils/
  - DateExtensions.swift
  - ColorExtensions.swift
  - TimeFormatter.swift
  - Constants.swift

Resources/
  - Words.json
```

**중요**: 파일 추가 시 "Copy items if needed" 체크 해제 (이미 폴더 안에 있으므로)

### 5. Capabilities 추가

1. 프로젝트 선택 > Target: SmartLockBox
2. **Signing & Capabilities** 탭
3. **+ Capability** 클릭
4. 다음 항목 추가:
   - **Family Controls** (Screen Time API 사용)
   - **Background Modes** (필요시)

### 6. Info.plist 설정

**Info.plist** 파일에 다음 권한 추가:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>앱 사용 시간을 모니터링하기 위해 Screen Time 권한이 필요합니다.</string>
```

Xcode에서:
1. `Info.plist` 파일 선택
2. 우클릭 > **Open As > Source Code**
3. 위 XML 추가

### 7. Core Data 모델 설정

1. 프로젝트에 **SmartLockBox.xcdatamodeld** 파일이 있는지 확인
2. 없다면:
   - **File > New > File**
   - **Core Data > Data Model** 선택
   - 이름: `SmartLockBox`
3. Entity 추가:
   - `UsageRecord`
     - `id`: UUID
     - `date`: Date
     - `usageMinutes`: Integer 32
     - `goalMinutes`: Integer 32
     - `achieved`: Boolean
   - `UnlockAttempt`
     - `id`: UUID
     - `date`: Date
     - `word1`: String
     - `word2`: String
     - `attemptText`: String
     - `gptResult`: String (Optional)
     - `claudeResult`: String (Optional)
     - `success`: Boolean

### 8. 빌드 및 실행

1. **Product > Clean Build Folder** (⇧⌘K)
2. **Product > Build** (⌘B)
3. 시뮬레이터 선택: **iPhone 15** (또는 원하는 기기)
4. **Product > Run** (⌘R)

## 🐛 문제 해결

### 컴파일 오류 발생 시

#### 1. "Cannot find type 'XXX' in scope"
- 해당 파일이 프로젝트에 추가되었는지 확인
- 파일의 Target Membership이 체크되어 있는지 확인

#### 2. "Use of undeclared type"
- 필요한 import 문이 있는지 확인
- 프레임워크가 올바르게 링크되었는지 확인

#### 3. Core Data 오류
- `PersistenceController.swift`에서 모델 이름이 "SmartLockBox"인지 확인

### Screen Time API 권한 오류

1. Capabilities에 **Family Controls** 추가 확인
2. Info.plist에 권한 설명 추가 확인
3. 실제 기기에서 테스트 (시뮬레이터는 제한적)

## ✅ 완료 체크리스트

- [ ] Xcode 프로젝트 생성 완료
- [ ] 모든 Swift 파일 추가 완료
- [ ] Resources 파일 (Words.json) 추가
- [ ] Capabilities 설정 완료
- [ ] Info.plist 권한 추가
- [ ] Core Data 모델 설정
- [ ] 빌드 성공
- [ ] 시뮬레이터에서 실행 확인

## 📚 참고 자료

- [Apple Developer - Creating an Xcode Project](https://developer.apple.com/documentation/xcode/creating-an-xcode-project-for-an-app)
- [Screen Time API Documentation](https://developer.apple.com/documentation/screentime)
- [Core Data Documentation](https://developer.apple.com/documentation/coredata)

## 💬 문의

문제가 계속되면 GitHub Issues에 등록해주세요:
https://github.com/DevJihwan/smartlock-box-ios/issues

---

**Note**: 이 가이드는 GitHub에서 클론한 프로젝트의 Xcode 프로젝트 파일 문제를 해결하기 위한 것입니다.
정상적으로 설정이 완료되면 앱 개발을 시작할 수 있습니다! 🚀
