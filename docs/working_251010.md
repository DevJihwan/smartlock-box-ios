# 작업 일지 - 2025년 10월 10일

## 📋 작업 개요

**작업자**: DevJihwan  
**날짜**: 2025년 10월 10일  
**목표**: iOS 앱 초기 구조 생성 및 Xcode 프로젝트 설정 완료

---

## ✅ 완료된 작업

### 1. 요구사항 문서 개선

#### 변경 내용
- 메인 화면 UI 요구사항을 **동기부여 중심**으로 재설계
- GitHub 커밋 기록 스타일의 **월간 히트맵** 추가
- 실시간 카운트다운 기능 명세 추가
- 주간 통계 표시 기능 추가

#### 주요 기능
1. **오늘의 목표 달성률**
   - 실시간 프로그레스바
   - 사용률에 따른 색상 변화 (초록 → 노랑 → 빨강)
   - 퍼센트 수치 표시

2. **잠금까지 남은 시간**
   - 실시간 카운트다운
   - 예상 잠금 시각 표시
   - 10분 이하 시 경고 애니메이션

3. **이번 주 사용 현황**
   - 주간 총 사용시간
   - 일평균 사용시간
   - 목표 대비 진행률

4. **월간 목표 달성 현황 (GitHub 스타일 히트맵)**
   - 7×4~5 그리드 형태
   - 목표 달성/미달성 시각화
   - 월별 달성률 표시
   - 각 날짜 탭으로 상세 정보 확인

#### 관련 커밋
- `85fab92` - docs: 메인 화면 UI 요구사항 개선

---

### 2. iOS 앱 코드 생성

#### 아키텍처
- **UI 프레임워크**: SwiftUI
- **디자인 패턴**: MVVM (Model-View-ViewModel)
- **최소 지원 버전**: iOS 15.0+
- **언어**: Swift 5.5+

#### 생성된 파일 구조

```
SmartLockBox/
├── App
│   ├── SmartLockBoxApp.swift
│   └── ContentView.swift
│
├── Models/
│   ├── AppState.swift
│   └── UnlockChallenge.swift
│
├── Views/
│   ├── MainView.swift
│   ├── LockScreenView.swift
│   ├── UnlockChallengeView.swift
│   ├── SettingsView.swift
│   ├── DetailedStatsView.swift
│   └── Components/
│       ├── TodayGoalCard.swift
│       ├── TimeUntilLockCard.swift
│       ├── WeeklyStatsCard.swift
│       └── MonthlyHeatmapCard.swift
│
├── ViewModels/
│   ├── AppStateManager.swift
│   ├── MainViewModel.swift
│   └── UnlockChallengeViewModel.swift
│
├── Services/
│   ├── WordService.swift
│   ├── AIEvaluationService.swift
│   ├── UsageDataService.swift
│   └── PersistenceController.swift
│
├── Managers/
│   ├── NotificationManager.swift
│   └── ScreenTimeManager.swift
│
├── Utils/
│   ├── DateExtensions.swift
│   ├── ColorExtensions.swift
│   ├── TimeFormatter.swift
│   └── Constants.swift
│
└── Resources/
    └── Words.json
```

#### 주요 컴포넌트

**1. AppStateManager**
- 앱 전체 상태 관리
- 사용 시간 추적
- 잠금/해제 로직
- 목표 달성률 계산

**2. MainView**
- 메인 화면 구현
- 4가지 주요 카드 컴포넌트 배치
- 실시간 업데이트

**3. MonthlyHeatmapCard**
- GitHub 스타일 히트맵
- 월간 데이터 시각화
- 탭 인터랙션

**4. UnlockChallengeView**
- 창의적 해제 시스템
- AI 평가 UI
- 결과 표시

#### 관련 커밋
- `1514618` - feat: iOS 앱 초기 구조 및 핵심 기능 구현
- `17c172a` - feat: 서비스 레이어 및 추가 화면 구현
- `2b9b548` - feat: Core Data 모델 및 리소스 파일 추가
- `6210b9a` - chore: 프로젝트 설정 및 유틸리티 파일 추가

---

### 3. 문서화

#### 추가된 문서

**1. SETUP_GUIDE.md**
- Xcode 프로젝트 설정 가이드
- 파일 구조 정리 방법
- Capabilities 설정
- Core Data 모델 설정
- 빌드 및 실행 가이드

**2. CHANGELOG.md**
- 버전 관리 및 변경 이력
- v0.1.0 릴리즈 노트

**3. CONTRIBUTING.md**
- 기여 가이드라인
- 코딩 스타일
- 커밋 메시지 컨벤션
- PR 프로세스

**4. LICENSE**
- MIT 라이선스

#### 관련 커밋
- `74a2555` - docs: Xcode 프로젝트 설정 가이드 추가
- `2363406` - test: 기본 테스트 파일 및 LICENSE 추가

---

### 4. Xcode 프로젝트 설정 (로컬)

#### 발생한 문제들

**문제 1: 프로젝트 파일 파싱 에러**
```
The project 'SmartLockBox' is damaged and cannot be opened 
due to a parse error.
```

**원인**: GitHub에 커밋된 `project.pbxproj` 파일이 간소화된 버전이라 Xcode가 파싱 불가

**해결**: 
- 손상된 프로젝트 파일 삭제
- Xcode에서 새 프로젝트 생성
- 기존 소스 파일 재사용

---

**문제 2: 중첩된 폴더 구조**
```
smartlock-box-ios/
└── SmartLockBox/
    ├── SmartLockBox.xcodeproj/  (잘못된 위치)
    └── SmartLockBox/            (중첩됨)
```

**해결**:
```bash
# 소스 폴더 임시 이름 변경
mv SmartLockBox SmartLockBox_sources

# Xcode에서 새 프로젝트 생성
# (저장 위치: ~/Desktop/smartlock-box-ios)

# 소스 파일들 복사
cp -r SmartLockBox_sources/{Models,Views,ViewModels,Services,Managers,Utils,Resources} SmartLockBox/

# 프로젝트 파일을 루트로 이동
mv SmartLockBox/SmartLockBox.xcodeproj .
```

---

**문제 3: Info.plist 중복 에러**
```
Multiple commands produce '.../SmartLockBox.app/Info.plist'
```

**원인**: 
- `Info.plist`가 Copy Bundle Resources에 포함됨
- Xcode가 자동으로 Info.plist 생성

**해결**:
1. **Build Phases** > **Copy Bundle Resources**에서 `Info.plist` 제거
2. **Build Settings** 설정:
   - `Info.plist File`: `SmartLockBox/Info.plist`
   - `Generate Info.plist File`: `NO`

---

**문제 4: Code Signing 에러**
```
Cannot code sign because the target does not have an Info.plist file
```

**해결**:
- **Build Settings** > **Info.plist File** 경로 설정
- Debug/Release 모두 `SmartLockBox/Info.plist`로 설정

---

#### 최종 프로젝트 구조

```
smartlock-box-ios/
├── .git/
├── .gitignore
├── README.md
├── REQUIREMENTS.md
├── SETUP_GUIDE.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
├── SmartLockBox.xcodeproj/      ← 루트에 위치
│   └── project.pbxproj
├── SmartLockBox/                 ← 소스 코드
│   ├── Models/
│   ├── Views/
│   ├── ViewModels/
│   ├── Services/
│   ├── Managers/
│   ├── Utils/
│   ├── Resources/
│   ├── Assets.xcassets
│   ├── Info.plist
│   └── SmartLockBox.xcdatamodeld
├── SmartLockBoxTests/
└── SmartLockBoxUITests/
```

---

### 5. Xcode 설정 완료

#### Capabilities 추가
- ✅ **Family Controls** (Screen Time API용)

#### Info.plist 권한
- ✅ `Privacy - Tracking Usage Description`

#### Build Settings
- ✅ Swift Language Version: Swift 5
- ✅ Info.plist File: `SmartLockBox/Info.plist`
- ✅ Generate Info.plist File: `NO`

#### 프로젝트 파일 추가
- ✅ Models 폴더 (2개 파일)
- ✅ Views 폴더 (5개 메인 + 4개 컴포넌트)
- ✅ ViewModels 폴더 (3개 파일)
- ✅ Services 폴더 (4개 파일)
- ✅ Managers 폴더 (2개 파일)
- ✅ Utils 폴더 (4개 파일)
- ✅ Resources 폴더 (1개 파일)
- ✅ Core Data 모델

**총 Swift 파일**: 26개

---

## 🎯 빌드 결과

### ✅ 빌드 성공!

```
▸ Build Succeeded
```

**빌드 환경**:
- Xcode 버전: 최신 (iOS 18.2 SDK)
- 타겟: iOS 15.0+
- 시뮬레이터: iPhone (iOS Simulator)

---

## 📊 프로젝트 통계

### 코드 통계
```
Swift 파일:        26개
뷰 컴포넌트:       9개
뷰모델:            3개
서비스 레이어:     4개
유틸리티:          4개
모델:              2개
매니저:            2개
```

### Git 통계
```
총 커밋:           6개
생성된 파일:       50개 이상
문서:              5개
```

---

## 🚧 남은 작업 (TODO)

### 필수 구현 사항

#### 1. API 연동
- [ ] OpenAI GPT-4 API 실제 구현
- [ ] Anthropic Claude API 실제 구현
- [ ] API 키 보안 저장 (Keychain)
- [ ] API 에러 처리
- [ ] Rate Limiting 구현

#### 2. Screen Time API
- [ ] FamilyControls 프레임워크 실제 연동
- [ ] DeviceActivity 모니터링 구현
- [ ] ManagedSettings 앱 차단 구현
- [ ] 사용 시간 추적
- [ ] 실제 기기에서 테스트

#### 3. 데이터 관리
- [ ] Core Data CRUD 구현
- [ ] UsageRecord 저장/조회
- [ ] UnlockAttempt 기록
- [ ] 데이터 마이그레이션 전략

#### 4. UI/UX 개선
- [ ] 애니메이션 추가
- [ ] 다크 모드 지원
- [ ] 접근성 개선
- [ ] 로딩 상태 표시
- [ ] 에러 상태 UI

#### 5. 단어 데이터베이스
- [ ] 20,000개 한국어 단어 수집
- [ ] 카테고리별 분류
- [ ] 난이도 설정
- [ ] JSON 파일 최적화

#### 6. 알림 시스템
- [ ] 목표 근접 알림 (10분 전)
- [ ] 잠금 알림
- [ ] 일일 리포트 알림
- [ ] 로컬 알림 스케줄링

#### 7. 테스트
- [ ] 단위 테스트 작성
- [ ] UI 테스트 작성
- [ ] 통합 테스트
- [ ] 실제 기기 테스트

#### 8. 배포 준비
- [ ] 앱 아이콘 디자인
- [ ] 스플래시 스크린
- [ ] 앱스토어 스크린샷
- [ ] 앱스토어 설명 작성
- [ ] Privacy Policy 작성
- [ ] TestFlight 베타 테스트

---

## 📝 학습 내용 및 인사이트

### Xcode 프로젝트 구조

1. **project.pbxproj의 중요성**
   - Xcode 프로젝트의 핵심 파일
   - 텍스트 기반이지만 복잡한 구조
   - Git으로 관리하기 어려운 파일
   - 수동 편집 시 파싱 에러 발생 가능

2. **올바른 프로젝트 구조**
   ```
   리포지토리 루트/
   ├── 프로젝트명.xcodeproj/  ← 루트에 위치
   └── 프로젝트명/            ← 소스 폴더
   ```

3. **Build Phases의 역할**
   - Copy Bundle Resources: 앱 번들에 포함될 리소스
   - Compile Sources: 컴파일할 소스 파일
   - Link Binary: 라이브러리 링킹

### SwiftUI + MVVM

1. **@StateObject vs @ObservedObject**
   - `@StateObject`: 뷰가 객체의 소유자
   - `@ObservedObject`: 다른 곳에서 생성된 객체 관찰

2. **Environment Objects**
   - 앱 전체에서 공유되는 상태
   - `@EnvironmentObject`로 주입

3. **Combine 프레임워크**
   - Publisher/Subscriber 패턴
   - 비동기 작업 처리
   - API 호출에 활용

### iOS 권한 관리

1. **Info.plist의 중요성**
   - 앱 메타데이터
   - 권한 요청 문구
   - 필수 설정 항목

2. **Capabilities**
   - Xcode에서 설정
   - Entitlements 파일 생성
   - App Store 리뷰 시 확인

---

## 🎓 문제 해결 경험

### 1. Git과 Xcode의 충돌

**문제**: Git으로 프로젝트 파일 관리의 어려움

**해결**:
- `.gitignore`에 빌드 산출물 제외
- `project.pbxproj`는 신중하게 관리
- 로컬에서 Xcode 프로젝트 재생성이 더 안전

### 2. 프로젝트 구조 이해

**핵심 개념**:
- Xcode 프로젝트 = 파일 참조의 집합
- 실제 파일 구조 ≠ Xcode 그룹 구조
- "Create groups" vs "Create folder references"

### 3. 빌드 시스템 이해

**Build Settings**:
- Target별 설정 가능
- Debug/Release 구분
- 조건부 설정 가능

---

## 📚 참고 자료

### 공식 문서
- [Apple Developer - Xcode](https://developer.apple.com/xcode/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Screen Time API](https://developer.apple.com/documentation/screentime)
- [Core Data](https://developer.apple.com/documentation/coredata)

### 커뮤니티
- Stack Overflow: Xcode 프로젝트 설정 관련 질문들
- GitHub Issues: 유사한 프로젝트 구조 문제 해결 사례

---

## 🎉 결론

### 성과

✅ **요구사항 문서 개선**: 사용자 동기부여를 위한 UI 재설계  
✅ **전체 앱 구조 생성**: 26개 Swift 파일, MVVM 아키텍처  
✅ **Xcode 프로젝트 설정**: 복잡한 문제들을 모두 해결  
✅ **빌드 성공**: 로컬 환경에서 정상 빌드 확인  
✅ **문서화 완료**: 5개 주요 문서 작성  

### 다음 단계

1. **API 연동**: OpenAI와 Anthropic API 실제 구현
2. **Screen Time 연동**: 실제 기기에서 테스트
3. **Core Data 구현**: 데이터 영속성 확보
4. **UI 개선**: 애니메이션 및 사용자 경험 향상
5. **테스트**: 단위 테스트 및 UI 테스트 작성

### 소요 시간

- 요구사항 분석 및 문서화: 1시간
- 코드 생성 및 GitHub 커밋: 1시간
- Xcode 프로젝트 설정 및 문제 해결: 2시간
- 문서 작성: 30분

**총 작업 시간**: 약 4.5시간

---

## 💬 메모

### 개발 환경
- macOS 버전: 최신
- Xcode 버전: 최신 (iOS 18.2 SDK)
- Swift 버전: 5.5+
- 개발 언어: Swift + SwiftUI

### 개발자 노트

> Xcode 프로젝트 파일(`project.pbxproj`)은 Git으로 관리하기 매우 까다로운 파일입니다. 
> 특히 자동 생성된 프로젝트 파일은 복잡한 참조 구조를 가지고 있어 수동으로 편집하면 
> 파싱 에러가 발생하기 쉽습니다.
> 
> 이번 프로젝트에서는 GitHub에서 코드를 가져온 후, 로컬에서 Xcode 프로젝트를 
> 새로 생성하고 소스 파일들을 참조하는 방식으로 해결했습니다.
> 
> 향후 프로젝트에서는 `.xcodeproj` 파일을 Git에 커밋하되, 충돌 발생 시 
> 로컬에서 재생성하는 전략을 사용하는 것이 좋겠습니다.

---

**작성자**: DevJihwan  
**작성일**: 2025년 10월 10일  
**문서 버전**: 1.0
