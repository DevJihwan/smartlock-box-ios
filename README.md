# 🔒 바보상자자물쇠 (SmartLock Box)

> 창의력으로 해제하는 스마트 디지털 디톡스 앱

## 🎯 프로젝트 개요

바보상자자물쇠는 iOS 사용자들이 건강한 디지털 라이프스타일을 유지할 수 있도록 돕는 혁신적인 스마트폰 사용 시간 관리 앱입니다.

### 주요 특징

- 📊 **동기부여 중심 UI**: GitHub 커밋 히트맵 스타일의 월간 목표 달성 현황 시각화
- 🎯 **실시간 모니터링**: 오늘 사용시간, 주간 통계, 잠금까지 남은 시간 표시
- 🧠 **AI 기반 창의적 해제**: ChatGPT와 Claude의 이중 검증 시스템
- 🔒 **스마트 잠금**: 설정 시간 초과 시 자동 잠금
- 📊 **상세 통계**: 일별/주별/월별 사용 패턴 분석

## 🛠 기술 스택

- **플랫폼**: iOS 15.0+
- **언어**: Swift 5.5+
- **UI 프레임워크**: SwiftUI
- **아키텍처**: MVVM (Model-View-ViewModel)
- **데이터 저장**: Core Data
- **API**: 
  - OpenAI GPT-4 API
  - Anthropic Claude API
  - iOS Screen Time API

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
- 랜덤 단어 2개 제시
- 창의적 문장 입력
- AI 평가 진행 상황 표시
- 평가 결과 표시

### 4. 설정 화면
- 일일 목표 시간 설정
- 자동 해제 시간 설정
- 알림 설정
- Screen Time 권한 관리

### 5. 상세 통계 화면
- 기간별 통계 (주간/월간/연간)
- 사용 패턴 그래프
- 일별 상세 기록

## 📚 프로젝트 구조

```
SmartLockBox/
├── SmartLockBoxApp.swift          # 앱 진입점
├── ContentView.swift              # 메인 컨텐츠 뷰
├── Models/                        # 데이터 모델
│   ├── AppState.swift
│   └── UnlockChallenge.swift
├── ViewModels/                    # 뷰모델
│   ├── AppStateManager.swift
│   ├── MainViewModel.swift
│   └── UnlockChallengeViewModel.swift
├── Views/                         # 뷰
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
├── Services/                      # 서비스 레이어
│   ├── WordService.swift
│   ├── AIEvaluationService.swift
│   ├── UsageDataService.swift
│   └── PersistenceController.swift
├── Resources/                     # 리소스 파일
│   └── Words.json
└── SmartLockBox.xcdatamodeld/    # Core Data 모델

```

## 🚀 시작하기

### 전제 조건

- Xcode 14.0 이상
- iOS 15.0 이상
- OpenAI API 키
- Anthropic API 키

### 설치 및 실행

1. 리포지토리 클론
```bash
git clone https://github.com/DevJihwan/smartlock-box-ios.git
cd smartlock-box-ios
```

2. Xcode로 프로젝트 열기
```bash
open SmartLockBox.xcodeproj
```

3. API 키 설정
- `AIEvaluationService.swift` 파일에서 API 키 설정
- 또는 환경 변수로 관리

4. 빌드 및 실행
- Xcode에서 `Cmd + R` 누르기

## 📝 TODO

- [ ] Screen Time API 실제 연동
- [ ] OpenAI API 실제 구현
- [ ] Anthropic Claude API 실제 구현
- [ ] Core Data 저장 로직 완성
- [ ] 20,000개 한국어 단어 데이터베이스 구축
- [ ] 차트 라이브러리 연동 (사용 패턴 그래프)
- [ ] 알림 기능 구현
- [ ] 단위 테스트 작성
- [ ] UI/UX 테스트 및 개선

## 📄 문서

자세한 요구사항은 [REQUIREMENTS.md](REQUIREMENTS.md)를 참조하세요.

## 📝 라이선스

MIT License

## 👤 개발자

**DevJihwan**
- GitHub: [@DevJihwan](https://github.com/DevJihwan)

---

❤️ Made with passion for digital wellbeing
