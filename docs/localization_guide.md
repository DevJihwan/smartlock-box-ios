# 다국어 지원 가이드 (Localization Guide)

**작성일**: 2025년 10월 12일  
**작성자**: DevJihwan  
**Phase**: 1.5

---

## 📋 개요

SmartLock Box는 처음부터 글로벌 시장을 고려하여 다국어 지원 시스템을 구축했습니다.

### 지원 언어
- 🇰🇷 **한국어** (Korean) - `ko`
- 🇺🇸 **영어** (English) - `en`

---

## 🎯 주요 기능

### 1. 자동 언어 감지
- 앱 최초 실행 시 시스템 언어를 자동으로 감지
- 한국어 시스템 → 한국어로 시작
- 기타 언어 → 영어로 시작

### 2. 실시간 언어 전환
- 앱 재시작 없이 즉시 언어 변경
- 모든 화면에서 실시간 반영
- 설정 자동 저장

### 3. 두 가지 UI 컴포넌트
- **LanguageSwitcher**: 컴팩트한 KO | EN 토글 (메인 화면용)
- **LanguagePickerView**: 상세한 언어 선택 (설정 화면용)

---

## 🏗 구조

### 파일 구조

```
SmartLockBox/
├── Utils/
│   └── LocalizationManager.swift       # 다국어 관리 매니저
├── Views/Components/
│   └── LanguageSwitcher.swift          # 언어 선택 UI
└── Resources/
    ├── ko.lproj/
    │   └── Localizable.strings         # 한국어 번역
    └── en.lproj/
        └── Localizable.strings         # 영어 번역
```

### 아키텍처

```
┌─────────────────────┐
│  LocalizationManager │ ← Singleton
│  - currentLanguage   │
│  - bundle           │
└──────────┬──────────┘
           │
           ├── UserDefaults (언어 저장)
           │
           ├── Bundle (리소스 로드)
           │
           └── NotificationCenter (변경 알림)
```

---

## 💻 사용 방법

### 1. UI에서 언어 전환 버튼 추가

#### 메인 화면 상단에 추가
```swift
import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            HStack {
                Text("app_name".localized)
                    .font(.largeTitle.bold())
                
                Spacer()
                
                // 언어 전환 버튼
                LanguageSwitcher()
            }
            .padding()
            
            // 나머지 컨텐츠...
        }
    }
}
```

#### 설정 화면에 추가
```swift
struct SettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("language".localized)) {
                LanguagePickerView()
            }
        }
    }
}
```

### 2. 텍스트 다국어화

#### 기본 사용법
```swift
// ❌ 하드코딩 (나쁜 예)
Text("오늘의 목표")

// ✅ 다국어 지원 (좋은 예)
Text("today_goal".localized)
```

#### 포맷이 있는 문자열
```swift
// 시간 표시 예: "3시간 30분"
let hours = 3
let minutes = 30
Text("time_format".localized(with: hours, minutes))
```

#### LocalizationKey 사용 (권장)
```swift
// 상수로 정의된 키 사용
Text(LocalizationKey.todayGoal.localized)
Text(LocalizationKey.timeUntilLock.localized)
```

### 3. 프로그래밍 방식 언어 변경

```swift
// 언어 변경
LocalizationManager.shared.changeLanguage(to: .korean)
LocalizationManager.shared.changeLanguage(to: .english)

// 현재 언어 확인
let currentLanguage = LocalizationManager.shared.currentLanguage
print(currentLanguage.displayName) // "한국어" or "English"
```

### 4. 언어 변경 감지

```swift
class MyViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 언어 변경 알림 구독
        NotificationCenter.default
            .publisher(for: .languageDidChange)
            .sink { [weak self] _ in
                self?.onLanguageChanged()
            }
            .store(in: &cancellables)
    }
    
    private func onLanguageChanged() {
        // 언어 변경 시 필요한 작업
        print("언어가 변경되었습니다")
    }
}
```

---

## 📝 번역 추가하기

### 1. 새로운 키 추가

#### LocalizationManager.swift에 키 정의
```swift
struct LocalizationKey {
    // 새로운 키 추가
    static let newFeature = "new_feature"
}
```

#### ko.lproj/Localizable.strings에 한국어 추가
```
"new_feature" = "새로운 기능";
```

#### en.lproj/Localizable.strings에 영어 추가
```
"new_feature" = "New Feature";
```

### 2. 사용
```swift
Text(LocalizationKey.newFeature.localized)
```

---

## 🎨 UI 컴포넌트 상세

### LanguageSwitcher

**위치**: 메인 화면 상단 우측  
**스타일**: 컴팩트한 토글 버튼

```
┌────────┐
│ KO | EN │  ← 선택된 언어는 파란 배경
└────────┘
```

**특징**:
- 애니메이션 효과
- 미니멀 디자인
- 공간 효율적

### LanguagePickerView

**위치**: 설정 화면  
**스타일**: 상세한 리스트 선택

```
┌─────────────────────┐
│ 한국어              │
│ KO          ✓      │
└─────────────────────┘

┌─────────────────────┐
│ English             │
│ EN                  │
└─────────────────────┘
```

**특징**:
- 체크마크 표시
- 전체 이름 표시
- 선택 상태 강조

---

## 🧪 테스트

### 1. 수동 테스트
1. 앱 실행
2. 언어 전환 버튼 탭
3. 모든 화면의 텍스트 확인
4. 앱 재시작 후 언어 유지 확인

### 2. 시뮬레이터에서 테스트
```swift
// Scheme > Edit Scheme > Run > Options
// App Language: Korean / English
```

### 3. 실제 기기에서 테스트
```
설정 > 일반 > 언어 및 지역 > 앱 언어
```

---

## 🌍 새로운 언어 추가하기

### 1. Localizable.strings 생성
```
SmartLockBox/Resources/ja.lproj/Localizable.strings  # 일본어
SmartLockBox/Resources/zh-Hans.lproj/Localizable.strings  # 중국어
```

### 2. AppLanguage enum 업데이트
```swift
enum AppLanguage: String, CaseIterable {
    case korean = "ko"
    case english = "en"
    case japanese = "ja"  // 추가
    
    var displayName: String {
        switch self {
        case .korean: return "한국어"
        case .english: return "English"
        case .japanese: return "日本語"  // 추가
        }
    }
}
```

### 3. 모든 키 번역
- 기존 키들을 모두 새로운 언어로 번역
- 일관성 있는 톤 유지
- 네이티브 스피커 리뷰 권장

---

## 📊 번역 현황

| 카테고리 | 키 개수 | 한국어 | 영어 |
|---------|---------|--------|------|
| 공통 | 8 | ✅ | ✅ |
| 메인 화면 | 10 | ✅ | ✅ |
| 잠금 화면 | 6 | ✅ | ✅ |
| 해제 챌린지 | 15 | ✅ | ✅ |
| 설정 | 9 | ✅ | ✅ |
| 시간 | 6 | ✅ | ✅ |
| 요일 | 7 | ✅ | ✅ |
| 에러 | 5 | ✅ | ✅ |
| AI 평가 | 6 | ✅ | ✅ |

**총 번역 키**: 72개  
**완료율**: 100% ✅

---

## 🎯 모범 사례

### DO ✅
1. **항상 LocalizationKey 사용**
   ```swift
   Text(LocalizationKey.todayGoal.localized)
   ```

2. **포맷 문자열 활용**
   ```swift
   "used_today".localized(with: timeString)
   ```

3. **일관된 톤 유지**
   - 한국어: 존댓말 사용
   - 영어: 친근하고 명확하게

4. **짧고 명확한 키 이름**
   ```swift
   static let todayGoal = "today_goal"  // ✅
   static let t = "t"  // ❌
   ```

### DON'T ❌
1. **하드코딩 금지**
   ```swift
   Text("오늘의 목표")  // ❌
   ```

2. **Magic String 사용 금지**
   ```swift
   Text("today_goal".localized)  // ⚠️ 가능하지만 권장하지 않음
   Text(LocalizationKey.todayGoal.localized)  // ✅
   ```

3. **문장 조합 금지**
   ```swift
   // ❌ 나쁜 예
   Text("today".localized + " " + "goal".localized)
   
   // ✅ 좋은 예
   Text("today_goal".localized)
   ```

---

## 🐛 문제 해결

### Q: 언어가 변경되지 않아요
A: 
1. Localizable.strings 파일이 올바른 위치에 있는지 확인
2. Xcode에서 프로젝트에 파일이 추가되었는지 확인
3. Clean Build Folder (`Cmd + Shift + K`)

### Q: 번역이 안 나타나요
A:
1. 키 이름이 정확한지 확인
2. Localizable.strings 파일에 해당 키가 있는지 확인
3. 따옴표가 올바른지 확인 (`"key" = "value";`)

### Q: 앱 재시작 후 언어가 초기화돼요
A:
- UserDefaults가 제대로 저장되고 있는지 확인
- `LocalizationManager.shared`를 사용하고 있는지 확인

---

## 📚 참고 자료

- [Apple Localization Guide](https://developer.apple.com/documentation/xcode/localization)
- [SwiftUI Localization](https://developer.apple.com/documentation/swiftui/localization)
- [NSLocalizedString](https://developer.apple.com/documentation/foundation/nslocalizedstring)

---

**작성자**: DevJihwan  
**최종 수정일**: 2025년 10월 12일  
**문서 버전**: 1.0
