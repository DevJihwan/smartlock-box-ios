# 🔒 바보상자자물쇠 (SmartLock Box)

> 창의력으로 해제하는 스마트 디지털 디톡스 앱

[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)](https://www.apple.com/ios)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🎯 프로젝트 개요

바보상자자물쇠는 iOS 사용자들이 건강한 디지털 라이프스타일을 유지할 수 있도록 돕는 혁신적인 스마트폰 사용 시간 관리 앱입니다.

### 주요 특징

- 📊 **동기부여 중심 UI**: GitHub 커밋 히트맵 스타일의 월간 목표 달성 현황 시각화
- 🎯 **실시간 모니터링**: 오늘 사용시간, 주간 통계, 잠금까지 남은 시간 표시
- 🧠 **AI 기반 창의적 해제**: ChatGPT와 Claude의 이중 검증 시스템
- 🔒 **스마트 잠금**: Screen Time API를 활용한 실제 앱 차단
- 📊 **상세 통계**: 일별/주별/월별 사용 패턴 분석

---

## 🚀 개발 진행 상황

### Phase 1: 핵심 기능 구현 (완료 ✅)

**진행률**: 100% ████████████

- ✅ 단어 데이터베이스 구축 (120개)
- ✅ WordService 완전 구현
- ✅ AI API 연동 (OpenAI + Claude)
- ✅ Screen Time Manager 구현
- ✅ Core Data CRUD 완성
- ✅ PersistenceController 구현

**완료일**: 2025년 10월 10일

### Phase 2: 기능 보완 (예정)

**진행률**: 0% ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜

- [ ] 알림 시스템 구현
- [ ] UI/UX 애니메이션 추가
- [ ] 에러 처리 강화
- [ ] 설정 화면 완성

**예상 완료**: 2025년 10월 31일

### Phase 3: 완성도 향상 (예정)

**진행률**: 0% ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜

- [ ] 단위 테스트 작성
- [ ] 다크 모드 지원
- [ ] 앱 아이콘 디자인
- [ ] TestFlight 베타 테스트

**예상 완료**: 2025년 11월 7일

---

## 🛠 기술 스택

- **플랫폼**: iOS 15.0+
- **언어**: Swift 5.5+
- **UI 프레임워크**: SwiftUI
- **아키텍처**: MVVM (Model-View-ViewModel)
- **비동기**: async/await, Combine
- **데이터 저장**: Core Data
- **주요 API**: 
  - OpenAI GPT-4 API ✅
  - Anthropic Claude API ✅
  - iOS Screen Time API (FamilyControls, DeviceActivity, ManagedSettings) ✅

---

## 📱 화면 구성

### 1. 메인 화면
- 오늘의 목표 달성률 (실시간 업데이트)
- 잠금까지 남은 시간 카운트다운
- 이번 주 사용 현황
- 월간 목표 달성 히트맵 (GitHub 스타일)

### 2. 잠금 화면
- 자물쇠 상태 표시
- 자동 해제까지 남은 시간
- 창의적 해제 버튼
- 응급 통화 버튼

### 3. 창의적 해제 화면
- 랜덤 단어 2개 제시 (하루 3회 새로고침 가능)
- 창의적 문장 입력 (최소 10글자)
- AI 평가 진행 상황 표시
- 평가 결과 표시 (OpenAI + Claude 이중 검증)

### 4. 설정 화면
- 일일 목표 시간 설정
- 자동 해제 시간 설정
- 알림 설정
- Screen Time 권한 관리

### 5. 상세 통계 화면
- 기간별 통계 (주간/월간/연간)
- 사용 패턴 그래프
- 일별 상세 기록

---

## 📚 프로젝트 구조

```
SmartLockBox/
├── App/
│   ├── SmartLockBoxApp.swift          # 앱 진입점
│   └── ContentView.swift              # 메인 컨텐츠 뷰
├── Models/                            # 데이터 모델
│   ├── AppState.swift
│   └── UnlockChallenge.swift
├── ViewModels/                        # 뷰모델
│   ├── AppStateManager.swift
│   ├── MainViewModel.swift
│   └── UnlockChallengeViewModel.swift
├── Views/                             # 뷰
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
├── Services/                          # 서비스 레이어 ✅
│   ├── WordService.swift              ✅ 완성
│   ├── AIEvaluationService.swift      ✅ 완성
│   ├── UsageDataService.swift         ✅ 완성
│   └── PersistenceController.swift    ✅ 완성
├── Managers/                          # 매니저 ✅
│   ├── NotificationManager.swift
│   └── ScreenTimeManager.swift        ✅ 완성
├── Utils/                             # 유틸리티
│   ├── DateExtensions.swift
│   ├── ColorExtensions.swift
│   ├── TimeFormatter.swift
│   └── Constants.swift
├── Resources/                         # 리소스 ✅
│   └── Words.json                     ✅ 120개 단어
├── Config.example.plist               ✅ API 키 템플릿
└── SmartLockBox.xcdatamodeld/         # Core Data 모델

```

---

## 🚀 시작하기

### 전제 조건

- Xcode 14.0 이상
- iOS 15.0 이상
- OpenAI API 키 (선택)
- Anthropic API 키 (선택)

> 💡 **개발 모드**: API 키 없이도 테스트 가능 (랜덤 결과 반환)

### 설치 및 실행

1. **리포지토리 클론**
```bash
git clone https://github.com/DevJihwan/smartlock-box-ios.git
cd smartlock-box-ios
```

2. **Xcode로 프로젝트 열기**
```bash
open SmartLockBox.xcodeproj
```

3. **API 키 설정 (선택)**
```bash
# Config.example.plist를 복사
cp SmartLockBox/Config.example.plist SmartLockBox/Config.plist

# Config.plist 파일을 열고 API 키 입력
# - OPENAI_API_KEY: your-openai-key
# - ANTHROPIC_API_KEY: your-claude-key
```

4. **Capabilities 설정**
- Xcode에서 프로젝트 선택
- Signing & Capabilities 탭
- `+ Capability` → **Family Controls** 추가

5. **빌드 및 실행**
- 실제 iOS 기기 연결 (Screen Time API는 시뮬레이터에서 제한적)
- Xcode에서 `Cmd + R` 누르기

---

## 📖 문서

- [📋 요구사항 정의서](REQUIREMENTS.md) - 상세한 프로젝트 요구사항
- [✅ TODO 리스트](docs/todolist_251010.md) - 전체 개발 계획
- [📝 작업 일지](docs/working_251010.md) - 초기 작업 일지
- [🎉 Phase 1 완료 보고](docs/phase1_completed_251010.md) - 핵심 기능 구현 완료
- [⚙️ 설정 가이드](SETUP_GUIDE.md) - Xcode 프로젝트 설정

---

## 🔑 주요 기능 설명

### 1. 단어 시스템
- 120개 한국어 단어 (명사, 동사, 형용사, 추상명사)
- 중복 없는 랜덤 선택
- 일일 3회 새로고침 제한
- 카테고리/난이도별 필터링

### 2. AI 평가 시스템
- OpenAI GPT-4 + Anthropic Claude 이중 검증
- 5가지 평가 기준:
  1. 두 단어 모두 포함
  2. 창의성 및 독창성
  3. 문법적 정확성
  4. 의미적 연관성
  5. 의미 있는 문장 구성
- 일일 10회 평가 제한
- 개발 모드 지원

### 3. 앱 차단 시스템
- Screen Time API 통합
- 예외 앱 관리 (전화, SMS, 건강, 지도 등)
- 자동 해제 타이머 (다음날 0시)
- 실시간 사용 시간 추적

### 4. 데이터 관리
- Core Data 기반 영속성
- 주간/월간 통계 자동 계산
- 해제 시도 이력 관리
- 백그라운드 작업 지원

---

## 🧪 테스트

### 단위 테스트 실행
```bash
# Xcode에서
Cmd + U
```

### 실제 기기에서 테스트
Screen Time API는 실제 기기에서만 완전히 동작합니다.

---

## 🤝 기여하기

기여는 언제나 환영합니다! [CONTRIBUTING.md](CONTRIBUTING.md)를 참조하세요.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 라이선스

MIT License - 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

---

## 👤 개발자

**DevJihwan**
- GitHub: [@DevJihwan](https://github.com/DevJihwan)

---

## 📞 문의

프로젝트에 대한 질문이나 제안사항이 있으시면 Issue를 생성해주세요.

---

## 🙏 감사의 말

- OpenAI GPT-4 API
- Anthropic Claude API
- Apple Screen Time API
- SwiftUI Community

---

❤️ Made with passion for digital wellbeing
