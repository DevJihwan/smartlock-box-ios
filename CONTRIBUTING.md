# 기여 가이드

바보상자자물쇠 프로젝트에 기여해주셔서 감사합니다! 🎉

## 시작하기 전에

1. [README.md](README.md)를 읽어 프로젝트를 이해하세요
2. [REQUIREMENTS.md](REQUIREMENTS.md)에서 요구사항을 확인하세요
3. 이슈 트래커에서 작업할 이슈를 찾거나 새로운 이슈를 생성하세요

## 개발 환경 설정

### 필수 요구사항

- macOS 12.0 이상
- Xcode 14.0 이상
- Git

### 설치 단계

```bash
# 저장소 포크 및 클론
git clone https://github.com/YOUR_USERNAME/smartlock-box-ios.git
cd smartlock-box-ios

# Xcode에서 프로젝트 열기
open SmartLockBox.xcodeproj
```

## 코딩 스타일

### Swift 스타일 가이드

- Swift API Design Guidelines를 따릅니다
- 들여쓰기: 4 스페이스
- 최대 줄 길이: 120자
- 의미 있는 변수명 사용

### 코드 예시

```swift
// Good ✅
func calculateRemainingMinutes(current: Int, goal: Int) -> Int {
    return max(0, goal - current)
}

// Bad ❌
func calc(c: Int, g: Int) -> Int {
    return g - c
}
```

### 주석

- 복잡한 로직에는 반드시 주석 추가
- 공개 API에는 문서 주석 작성

```swift
/// 사용자의 일일 목표 시간을 계산합니다.
/// 
/// - Parameters:
///   - usageMinutes: 현재까지 사용한 시간 (분)
///   - goalMinutes: 목표 시간 (분)
/// - Returns: 남은 사용 가능 시간 (분)
func calculateRemainingTime(usageMinutes: Int, goalMinutes: Int) -> Int {
    return max(0, goalMinutes - usageMinutes)
}
```

## 커밋 메시지 컨벤션

### 형식

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type

- `feat`: 새로운 기능
- `fix`: 버그 수정
- `docs`: 문서 변경
- `style`: 코드 스타일 변경 (포맷팅, 세미콜론 누락 등)
- `refactor`: 코드 리팩토링
- `test`: 테스트 추가 또는 수정
- `chore`: 빌드 프로세스 또는 보조 도구 변경

### 예시

```bash
feat(main): 월간 히트맵 컴포넌트 추가

GitHub 스타일의 월간 목표 달성 히트맵을 구현했습니다.
- 30일 데이터 표시
- 터치 시 상세 정보 표시
- 달성률 계산

Closes #123
```

## 브랜치 전략

### 브랜치 명명 규칙

- `feature/기능명`: 새로운 기능 개발
- `bugfix/버그명`: 버그 수정
- `hotfix/긴급수정명`: 긴급 수정
- `refactor/리팩토링명`: 코드 리팩토링

### 예시

```bash
# 새 기능 브랜치 생성
git checkout -b feature/weekly-stats-chart

# 버그 수정 브랜치 생성
git checkout -b bugfix/heatmap-date-calculation
```

## Pull Request 프로세스

1. **브랜치 생성**: `main`에서 새 브랜치 생성
2. **개발**: 기능 개발 및 테스트
3. **커밋**: 의미 있는 단위로 커밋
4. **푸시**: 원격 저장소에 푸시
5. **PR 생성**: GitHub에서 Pull Request 생성
6. **코드 리뷰**: 리뷰어의 피드백 반영
7. **병합**: 승인 후 `main`에 병합

### PR 템플릿

```markdown
## 변경 사항

- [ ] 기능 A 추가
- [ ] 버그 B 수정

## 테스트

- [ ] 수동 테스트 완료
- [ ] 단위 테스트 추가

## 스크린샷 (UI 변경 시)

[스크린샷 추가]

## 관련 이슈

Closes #123
```

## 테스트

### 단위 테스트

- 모든 새로운 기능에는 테스트 작성
- `XCTest` 프레임워크 사용

```swift
import XCTest
@testable import SmartLockBox

class TimeFormatterTests: XCTestCase {
    func testFormatMinutes() {
        let result = TimeFormatter.format(minutes: 150)
        XCTAssertEqual(result, "2시간 30분")
    }
}
```

### UI 테스트

- 주요 사용자 흐름에 대한 UI 테스트 작성

## 이슈 보고

### 버그 리포트

```markdown
**환경**
- iOS 버전: 
- 기기: 
- 앱 버전: 

**재현 방법**
1. 
2. 
3. 

**예상 동작**


**실제 동작**


**스크린샷**
```

### 기능 제안

```markdown
**제안하는 기능**


**동기 및 배경**


**예상 구현 방법**


**대안**

```

## 코드 리뷰 가이드라인

### 리뷰어

- 코드의 정확성, 성능, 가독성 검토
- 건설적인 피드백 제공
- 빠른 응답 (24시간 이내)

### 작성자

- 피드백을 열린 마음으로 수용
- 변경 사항 설명
- 필요시 추가 정보 제공

## 질문이 있나요?

- GitHub Issues에 질문 올리기
- [이메일 주소] 로 연락하기

---

다시 한번 기여해주셔서 감사합니다! 🙏
