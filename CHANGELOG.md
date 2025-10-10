# Changelog

모든 주목할 만한 변경 사항은 이 파일에 문서화됩니다.

## [Unreleased]

### 계획된 기능
- Screen Time API 실제 연동
- OpenAI GPT-4 API 실제 구현
- Anthropic Claude API 실제 구현
- 20,000개 한국어 단어 데이터베이스
- 차트 라이브러리 연동
- 알림 기능 완성
- 단위 테스트 및 UI 테스트

## [0.1.0] - 2025-10-10

### Added
- 초기 프로젝트 구조 생성
- SwiftUI + MVVM 아키텍처 구현
- 메인 화면 UI (오늘 목표, 주간 통계, 월간 히트맵)
- 잠금 화면 UI
- 창의적 해제 시스템 UI
- 설정 화면
- 상세 통계 화면
- Core Data 모델 정의
- 서비스 레이어 구현
  - WordService (단어 관리)
  - AIEvaluationService (AI 평가 - 목 구현)
  - UsageDataService (사용 통계)
  - PersistenceController (Core Data)
- 유틸리티 클래스
  - DateExtensions
  - ColorExtensions
  - TimeFormatter
  - Constants
- 매니저 클래스
  - NotificationManager
  - ScreenTimeManager (준비 단계)
- 재사용 가능한 컴포넌트
  - TodayGoalCard
  - TimeUntilLockCard
  - WeeklyStatsCard
  - MonthlyHeatmapCard
- README.md 및 문서화
- .gitignore 파일

### Technical Details
- iOS 15.0+ 지원
- Swift 5.5+
- SwiftUI 프레임워크
- Core Data 영구 저장소
- Combine 프레임워크 활용

### Known Issues
- Screen Time API가 실제로 연동되지 않음 (권한 요청만 구현)
- AI API는 목(mock) 응답만 반환
- 단어 데이터베이스가 100개 미만의 샘플만 포함
- 차트가 플레이스홀더로 표시됨

---

## 버전 관리 규칙

- **MAJOR**: 호환되지 않는 API 변경
- **MINOR**: 하위 호환되는 기능 추가
- **PATCH**: 하위 호환되는 버그 수정

[Unreleased]: https://github.com/DevJihwan/smartlock-box-ios/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/DevJihwan/smartlock-box-ios/releases/tag/v0.1.0
