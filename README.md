# SmartLockBox iOS

iOS 앱 '바보상자자물쇠' - 창의적 사고를 통한 스마트폰 사용 제한 앱

## 빌드 오류 수정 (2025-10-16)

다음 빌드 오류들이 수정되었습니다:

1. **Colors.swift:126:35 오류**: `environment(\.colorScheme, _:)` 메서드 파라미터 구문 오류 수정
   - 해결: `@ViewBuilder func environment(key: EnvironmentKey, _ colorScheme: ColorScheme?)` 메서드로 수정하고 모디파이어를 추가함

2. **MainView.swift:18:13 오류**: NavigationView `init` 모호성 해결
   - 해결: 타입 명시적 선언

3. **MainView.swift:174 오류들**: AppStateManager의 currentView 사용 관련 오류
   - 해결: `appState.currentState`로 속성 참조 방식 변경 및 AppStateManager의 메서드(`startUnlockChallenge()`) 활용

4. **MainView.swift:187:36 오류**: localized 함수 모호성 
   - 해결: 문자열 확장 참조 방식 명확화

5. **UnlockAttempt+CoreDataProperties.swift:16:32 오류**: fetchRequest() 중복 선언 
   - 해결: `UnlockAttempt+CoreDataExtensions.swift` 파일 추가하여 `createFetchRequest()` 메서드 정의

## 기능 소개

1. **스마트폰 사용 제한**: 일일 목표 시간에 도달하면 자동으로 잠금
2. **창의적 해제 도전**: 주어진 두 단어를 창의적으로 연결하는 문장을 AI가 평가
3. **다국어 지원**: 한국어/영어 지원

## 주요 구성 요소

- **SwiftUI**: 최신 UI 프레임워크 활용
- **Core Data**: 사용 기록 및 해제 시도 데이터 저장
- **AI 평가 시스템**: ChatGPT와 Claude AI 연동