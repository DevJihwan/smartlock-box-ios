# SmartLockBox Design Requirements (디자인 요구사항 정의서)

## 📋 문서 정보
- **문서명**: SmartLockBox iOS 앱 디자인 요구사항
- **버전**: v1.1
- **작성일**: 2025년 11월 4일
- **타겟 사용자**: 자기관리를 철저히 하고 싶은 20-30대
- **디자인 철학**: 심플, 깔끔, 모던, 아이폰의 특색 유지

---

## 🎯 디자인 목표

### 핵심 가치
1. **Purposeful Minimalism (목적 있는 미니멀리즘)**: 불필요한 요소 제거하되, 기능성은 극대화
2. **iPhone Native Feel**: iOS의 디자인 언어를 자연스럽게 따르는 네이티브 느낌
3. **Achievement-Driven**: 사용자의 성취감을 극대화하는 시각적 피드백
4. **Adaptive & Flexible**: 사용자 환경(다크모드, 디바이스 색상)에 자연스럽게 적응

### 타겟 사용자 분석

#### 20-30대 자기관리 사용자 특징
```
연령: 20-30대
직업: 직장인, 대학생, 프리랜서
성향: 
  - 자기계발에 관심이 많음
  - 디지털 도구에 익숙함
  - 미니멀하고 깔끔한 디자인 선호
  - 성취감과 진행상황 가시화를 중요하게 여김
  - 브랜드 이미지와 UX에 민감함

앱 사용 패턴:
  - 하루 여러 번 확인 (5-10회)
  - 주로 아침, 점심, 저녁 시간대 사용
  - 빠른 정보 확인 선호
  - 복잡한 설정은 회피
```

---

## 🎨 2025 iOS 디자인 트렌드 적용

### 1. Exaggerated Minimalism (과장된 미니멀리즘)

**정의**: 미니멀리즘의 깔끔함 + 대담한 비주얼 요소의 조합

**적용 방안**:
```
✅ 넉넉한 여백 (White Space)
✅ 대담한 타이포그래피 (San Francisco Font 사용)
✅ 과감한 아이콘 크기
✅ 단순하지만 강렬한 색상 포인트
✅ 최소한의 UI 요소로 최대 효과
```

**실제 적용 예시**:
```swift
// 메인 화면의 "오늘의 목표" 텍스트
- Font: San Francisco Display Bold, 28pt
- Color: Dynamic (Light: .label / Dark: .label)
- Spacing: 24pt 상하 여백

// 주요 버튼
- Height: 56pt (터치하기 쉬운 크기)
- Corner Radius: 16pt (부드러운 모서리)
- Icon Size: 24×24pt (명확한 식별)
```

### 2. iOS Native Design Language

**SF Symbols 적극 활용**:
```
🔒 lock.fill - 잠금 아이콘
🗝️ key.fill - 해제 아이콘
📊 chart.bar.fill - 통계 아이콘
⚙️ gearshape.fill - 설정 아이콘
🎯 target - 목표 아이콘
📅 calendar - 캘린더 아이콘
🔥 flame.fill - 연속 달성 표시
```

**iOS 15+ Native Components 사용**:
```swift
- SwiftUI native controls
- Standard iOS navigation patterns
- Native gestures (swipe, long-press)
- System fonts (San Francisco)
- Standard spacing guidelines (8pt grid system)
```

### 3. Adaptive Color System (Dynamic Theming)

#### 기본 시스템 색상 사용
```swift
// Semantic Colors (자동 다크모드 지원)
background: .systemBackground
secondaryBackground: .secondarySystemBackground
label: .label
secondaryLabel: .secondaryLabel
separator: .separator

// Accent Colors (앱 정체성)
primary: .systemBlue (기본값, 사용자 커스터마이징 가능)
success: .systemGreen
warning: .systemOrange
error: .systemRed
```

### 4. Micro-interactions

**적용할 마이크로 인터랙션**:
```
1. 버튼 탭 시 Haptic Feedback
   - Impact style: .medium
   
2. 목표 달성 시 축하 애니메이션
   - 체크마크 + confetti 효과
   - Scale animation (1.0 → 1.2 → 1.0)
   
3. 잠금 활성화 시
   - 자물쇠 아이콘 회전 애니메이션
   - Duration: 0.3초
   
4. 히트맵 박스 탭 시
   - Gentle bounce effect
   - 상세 정보 모달 표시
   
5. 스와이프 제스처
   - 통계 화면 전환
   - Edge-to-edge swipe
```

---

## 🎨 색상 시스템 설계

### Color Palette Architecture

#### 1. Adaptive Color (Light/Dark Mode)

**Asset Catalog 구조**:
```
Colors.xcassets/
├── Primary/
│   ├── AppAccent (사용자 커스터마이징 가능)
│   │   ├── Any Appearance
│   │   └── Dark Appearance
│   ├── AppBackground
│   ├── CardBackground
│   └── AccentGradient
├── Semantic/
│   ├── Success
│   ├── Warning
│   ├── Error
│   └── Info
└── Neutral/
    ├── TextPrimary
    ├── TextSecondary
    ├── BorderLight
    └── Divider
```

#### 2. Dynamic Color Implementation

```swift
// Colors.swift Extension
extension Color {
    // 사용자 커스터마이징 가능한 앱 테마 색상
    static var appAccent: Color {
        Color(uiColor: UIColor(named: "AppAccent") ?? .systemBlue)
    }
    
    // iPhone 기기 색상에 맞춘 테마 (iOS 14+)
    static func accentForDevice(_ deviceColor: DeviceColor) -> Color {
        switch deviceColor {
        case .midnightBlue:
            return Color(red: 0.08, green: 0.11, blue: 0.22)
        case .pinkGold:
            return Color(red: 0.90, green: 0.68, blue: 0.68)
        case .silverWhite:
            return Color(red: 0.95, green: 0.95, blue: 0.97)
        case .spaceBlack:
            return Color(red: 0.12, green: 0.12, blue: 0.13)
        case .custom(let color):
            return color
        }
    }
}

// UIKit 버전
extension UIColor {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}
```

### 3. 기본 색상 팔레트

**Light Mode**:
```
Primary: #007AFF (System Blue)
Success: #34C759 (System Green)
Warning: #FF9500 (System Orange)
Error: #FF3B30 (System Red)

Background: #FFFFFF
SecondaryBackground: #F2F2F7
CardBackground: #FFFFFF with shadow

TextPrimary: #000000 (alpha: 0.87)
TextSecondary: #000000 (alpha: 0.6)
```

**Dark Mode**:
```
Primary: #0A84FF
Success: #32D74B
Warning: #FF9F0A
Error: #FF453A

Background: #000000
SecondaryBackground: #1C1C1E
CardBackground: #2C2C2E

TextPrimary: #FFFFFF (alpha: 0.87)
TextSecondary: #FFFFFF (alpha: 0.6)
```

---

## 📱 화면별 디자인 요구사항

### 0. 동기부여 메시지 시스템 (Motivational Message Banner) 💪 **NEW**

#### 개요
사용자의 사용 일수와 이전 날짜의 목표 달성 여부에 따라 맞춤형 동기부여 메시지를 메인 화면 상단에 표시하여 지속적인 사용을 유도하고 성취감을 극대화합니다.

#### 메시지 표시 위치
```
┌─────────────────────────────────────┐
│  [Logo]  바보상자자물쇠    [KR|EN]  │ 
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │ ← 동기부여 메시지 배너
│  │ 💪 오늘부터 당신의 시간을    │   │   (NEW 추가)
│  │    되찾아보세요!            │   │
│  └─────────────────────────────┘   │
├─────────────────────────────────────┤
│  🎯 오늘의 목표 달성률               │
│  ...                                │
```

#### 메시지 표시 로직

**1일차 (첫 접속)**
```
메시지: "오늘부터 당신의 시간을 되찾아보세요!"
아이콘: 💪 또는 🎯
배경색: 시스템 기본 액센트 색상 (투명도 10%)
표시 조건: 앱 최초 실행 또는 데이터 초기화 후 첫 접속
```

**2일차 이후 - 이전 날 성공 시**
```
메시지: "어제도 목표 달성! 멋져요!"
아이콘: 🎉 또는 ⭐️
배경색: Success 색상 (투명도 10%)
표시 조건: 이전 날짜의 목표 달성률 >= 100%
```

**2일차 이후 - 이전 날 실패 시**
```
메시지: "괜찮아요, 오늘 다시 도전해봐요!"
아이콘: 💙 또는 🤗
배경색: Info 색상 (투명도 10%)
표시 조건: 이전 날짜의 목표 달성률 < 100%
```

**연속 달성 시 (3일 이상)**
```
메시지: "🔥 연속 {n}일"
서브 메시지: "어제도 목표 달성! 멋져요!" (작은 폰트)
배경색: Gradient (Success → Warning)
표시 조건: 연속으로 목표를 달성한 일수가 3일 이상
특별 효과: 
  - 7일 달성 시: "🔥 연속 7일! 한 주 완주!"
  - 30일 달성 시: "🔥 연속 30일! 대단해요!"
  - 100일 달성 시: "🔥 연속 100일! 레전드!"
```

#### 디자인 스펙

**메시지 배너 컴포넌트**:
```swift
struct MotivationalMessageBanner: View {
    var message: String
    var icon: String // SF Symbol or Emoji
    var streakDays: Int? // 연속 달성 일수 (옵션)
    var messageType: MessageType
    
    enum MessageType {
        case welcome      // 1일차
        case success      // 성공
        case retry        // 재도전
        case streak       // 연속 달성
        
        var backgroundColor: Color {
            switch self {
            case .welcome:
                return Color.appAccent.opacity(0.1)
            case .success:
                return Color.systemGreen.opacity(0.1)
            case .retry:
                return Color.systemBlue.opacity(0.1)
            case .streak:
                return LinearGradient(
                    colors: [Color.systemGreen.opacity(0.1), 
                             Color.systemOrange.opacity(0.1)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // 아이콘
            Text(icon)
                .font(.system(size: 24))
            
            VStack(alignment: .leading, spacing: 4) {
                // 메인 메시지
                if let streak = streakDays, messageType == .streak {
                    HStack(spacing: 8) {
                        Text("🔥 연속 \(streak)일")
                            .font(.system(size: 18, weight: .bold))
                        
                        Spacer()
                    }
                }
                
                Text(message)
                    .font(.system(size: messageType == .streak ? 14 : 16, 
                                  weight: messageType == .streak ? .medium : .semibold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(messageType.backgroundColor)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: message)
    }
}
```

**사용 예시**:
```swift
struct MainView: View {
    @StateObject private var motivationManager = MotivationManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 동기부여 메시지 배너
                if let motivation = motivationManager.currentMotivation {
                    MotivationalMessageBanner(
                        message: motivation.message,
                        icon: motivation.icon,
                        streakDays: motivation.streakDays,
                        messageType: motivation.type
                    )
                }
                
                // 나머지 메인 화면 컴포넌트들
                // ...
            }
        }
    }
}
```

#### 애니메이션 효과

**배너 등장 애니메이션**:
```swift
// 화면 진입 시
.onAppear {
    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
        showBanner = true
    }
}

// Slide in from top + Fade in
.transition(.asymmetric(
    insertion: .move(edge: .top).combined(with: .opacity),
    removal: .opacity
))
```

**연속 달성 특수 효과**:
```swift
// 3일 이상 연속 달성 시 불꽃 애니메이션
if streakDays >= 3 {
    Image(systemName: "flame.fill")
        .foregroundColor(.systemOrange)
        .scaleEffect(isAnimating ? 1.2 : 1.0)
        .animation(
            .easeInOut(duration: 0.6)
            .repeatForever(autoreverses: true),
            value: isAnimating
        )
}

// 7일, 30일, 100일 마일스톤 달성 시 confetti 효과
if isMilestone {
    ConfettiView()
        .transition(.scale)
}
```

#### 다국어 지원

**한국어 (KR)**:
```
1일차: "오늘부터 당신의 시간을 되찾아보세요!"
성공: "어제도 목표 달성! 멋져요!"
재도전: "괜찮아요, 오늘 다시 도전해봐요!"
연속: "🔥 연속 {n}일"
```

**영어 (EN)**:
```
1일차: "Let's start taking back your time!"
성공: "Great job yesterday! You nailed it!"
재도전: "It's okay, let's try again today!"
연속: "🔥 {n} day streak"
```

**Localizable.strings 키**:
```
"motivation.day1" = "오늘부터 당신의 시간을 되찾아보세요!";
"motivation.success" = "어제도 목표 달성! 멋져요!";
"motivation.retry" = "괜찮아요, 오늘 다시 도전해봐요!";
"motivation.streak" = "🔥 연속 %d일";
"motivation.streak_week" = "🔥 연속 %d일! 한 주 완주!";
"motivation.streak_month" = "🔥 연속 %d일! 대단해요!";
"motivation.streak_hundred" = "🔥 연속 %d일! 레전드!";
```

#### 데이터 관리

**MotivationManager.swift**:
```swift
class MotivationManager: ObservableObject {
    @Published var currentMotivation: Motivation?
    
    struct Motivation {
        let message: String
        let icon: String
        let type: MotivationalMessageBanner.MessageType
        let streakDays: Int?
    }
    
    func updateMotivation() {
        let usageDays = UserDefaults.standard.integer(forKey: "totalUsageDays")
        let yesterdayAchieved = UserDefaults.standard.bool(forKey: "yesterdayAchieved")
        let streakDays = UserDefaults.standard.integer(forKey: "consecutiveAchievementDays")
        
        if usageDays == 1 {
            // 1일차
            currentMotivation = Motivation(
                message: "motivation.day1".localized,
                icon: "💪",
                type: .welcome,
                streakDays: nil
            )
        } else if streakDays >= 3 {
            // 연속 달성
            let streakMessage = getStreakMessage(for: streakDays)
            currentMotivation = Motivation(
                message: "motivation.success".localized,
                icon: "🔥",
                type: .streak,
                streakDays: streakDays
            )
        } else if yesterdayAchieved {
            // 어제 성공
            currentMotivation = Motivation(
                message: "motivation.success".localized,
                icon: "🎉",
                type: .success,
                streakDays: nil
            )
        } else {
            // 어제 실패
            currentMotivation = Motivation(
                message: "motivation.retry".localized,
                icon: "💙",
                type: .retry,
                streakDays: nil
            )
        }
    }
    
    private func getStreakMessage(for days: Int) -> String {
        switch days {
        case 7:
            return String(format: "motivation.streak_week".localized, days)
        case 30:
            return String(format: "motivation.streak_month".localized, days)
        case 100:
            return String(format: "motivation.streak_hundred".localized, days)
        default:
            return String(format: "motivation.streak".localized, days)
        }
    }
}
```

#### 사용자 경험 고려사항

1. **비침입적 디자인**: 
   - 메시지가 화면의 주요 정보를 가리지 않도록 적절한 크기 유지
   - 부드러운 배경색과 투명도 사용

2. **자동 해제 옵션** (선택사항):
   - 사용자가 메시지를 읽은 후 5초 후 자동으로 페이드 아웃
   - 또는 스와이프 제스처로 수동 해제 가능

3. **개인화**:
   - 설정에서 동기부여 메시지 활성화/비활성화 옵션 제공
   - 메시지 스타일 선택 (격려형/간결형/유머형)

4. **성취감 극대화**:
   - 연속 달성 일수는 눈에 띄게 강조
   - 마일스톤 달성 시 특별한 시각 효과 추가

---

### 1. 메인 화면 (Main View)

#### 레이아웃 구조
```
┌─────────────────────────────────────┐
│  [Logo]  바보상자자물쇠    [KR|EN]  │ 
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │ ← 동기부여 메시지 (NEW)
│  │ 💪 오늘부터 당신의 시간을    │   │
│  │    되찾아보세요!            │   │
│  └─────────────────────────────┘   │
├─────────────────────────────────────┤
│  🎯 오늘의 목표 달성률               │ ← SF Display Bold 28pt
│  ┌─────────────────────────────┐   │
│  │ 2시간 30분 / 3시간           │   │ ← SF Text Semibold 20pt
│  │                              │   │
│  │ ████████████░░░░ 83%         │   │ ← Progress Bar 8pt height
│  │                              │   │
│  └─────────────────────────────┘   │
│                                     │
│  ⏰ 잠금까지                         │ ← SF Text Medium 18pt
│  ┌─────────────────────────────┐   │
│  │        30분                  │   │ ← SF Display Bold 36pt
│  │  오후 6시 30분 잠금 예정      │   │ ← SF Text Regular 14pt
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  📊 이번 주 사용 현황                │
│  ┌─────────────────────────────┐   │
│  │  18h 30m / 21h               │   │
│  │  ████████████████░░░ 88%     │   │
│  │  평균 2h 38m/일               │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  📅 월간 달성 현황                   │
│  ┌─────────────────────────────┐   │
│  │  Mon ■ ■ □ ■ ■              │   │ ← GitHub 스타일 히트맵
│  │  Tue ■ ■ ■ □ ■              │   │   각 박스 16×16pt
│  │  Wed ■ □ ■ ■ ■              │   │   Spacing: 4pt
│  │  Thu ■ ■ ■ ■ ■              │   │
│  │  Fri □ ■ ■ ■ □              │   │
│  │  Sat ■ ■ □ ■ ■              │   │
│  │  Sun ■ ■ ■ ■ ■              │   │
│  │                              │   │
│  │  달성률: 87% (26/30일)        │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

#### 디자인 스펙

**카드 컴포넌트** (재사용):
```swift
struct CardView: View {
    var cornerRadius: CGFloat = 16
    var shadowRadius: CGFloat = 8
    var shadowOpacity: CGFloat = 0.1
    
    var body: some View {
        // Card content
            .background(Color("CardBackground"))
            .cornerRadius(cornerRadius)
            .shadow(
                color: Color.black.opacity(shadowOpacity),
                radius: shadowRadius,
                x: 0,
                y: 4
            )
            .padding(.horizontal, 16)
    }
}
```

**Progress Bar**:
```swift
struct AdaptiveProgressBar: View {
    var progress: Double // 0.0 ~ 1.0
    
    var progressColor: Color {
        switch progress {
        case 0..<0.6: return .systemGreen
        case 0.6..<0.85: return .systemOrange
        default: return .systemRed
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.2))
                
                // Progress
                RoundedRectangle(cornerRadius: 4)
                    .fill(progressColor)
                    .frame(width: geometry.size.width * progress)
                    .animation(.spring(response: 0.5), value: progress)
            }
        }
        .frame(height: 8)
    }
}
```

**히트맵 셀**:
```swift
struct HeatmapCell: View {
    var isAchieved: Bool
    var date: Date
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(isAchieved ? Color.appAccent : Color.secondary.opacity(0.2))
            .frame(width: 16, height: 16)
            .onTapGesture {
                // 상세 정보 표시
                showDetail(for: date)
            }
    }
}
```

### 2. 잠금 화면 (Lock Screen View)

```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│          🔒                         │ ← SF Symbol 80pt
│                                     │
│     스마트폰이 잠겨있습니다          │ ← SF Display Bold 24pt
│                                     │
│     오늘 3시간 사용 완료             │ ← SF Text Regular 16pt
│                                     │
├─────────────────────────────────────┤
│                                     │
│  ⏰ 자동 해제까지                    │
│                                     │
│      9시간 30분                     │ ← SF Display Bold 48pt
│                                     │ ← Real-time countdown
│      (내일 오전 6시)                │ ← SF Text Regular 14pt
│                                     │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │  🗝️  창의력으로 해제하기     │   │ ← Primary Button
│  └─────────────────────────────┘   │   Height: 56pt
│                                     │
│  ┌─────────────────────────────┐   │
│  │  📞  응급 통화               │   │ ← Secondary Button
│  └─────────────────────────────┘   │   Height: 44pt
│                                     │
└─────────────────────────────────────┘
```

**애니메이션 효과**:
```swift
// 자물쇠 아이콘 펄스 효과
LockIcon()
    .scaleEffect(isLocked ? 1.0 : 0.95)
    .animation(
        .easeInOut(duration: 1.5)
        .repeatForever(autoreverses: true),
        value: isLocked
    )

// 카운트다운 숫자 변경 시 애니메이션
Text(timeRemaining)
    .transition(.scale)
    .animation(.spring(response: 0.3), value: timeRemaining)
```

### 3. 창의적 해제 화면 (Unlock Challenge View)

```
┌─────────────────────────────────────┐
│  🗝️ 창의적 해제 도전                 │ ← Navigation Title
├─────────────────────────────────────┤
│                                     │
│  제시된 단어를 모두 포함한          │ ← SF Text Regular 16pt
│  창의적인 문장을 만들어보세요       │
│                                     │
├─────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐       │
│  │  바다    │  │  꿈      │       │ ← Word Pills
│  └──────────┘  └──────────┘       │   Height: 44pt
│                                     │   Corner Radius: 22pt
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ 여기에 문장을 입력하세요...  │   │ ← Text Editor
│  │                              │   │   Min Height: 120pt
│  │                              │   │   Corner Radius: 12pt
│  │                              │   │
│  └─────────────────────────────┘   │
│                                     │
│  최소 10글자 (현재: 0글자)          │ ← Character Count
│                                     │   Dynamic color
│                                     │
├─────────────────────────────────────┤
│  [↻ 다른 단어로 변경]  [✓ 제출]    │ ← Action Buttons
└─────────────────────────────────────┘
```

**단어 Pill 디자인**:
```swift
struct WordPillView: View {
    var word: String
    
    var body: some View {
        Text(word)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color.appAccent)
                    .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            )
    }
}
```

**AI 평가 진행 화면**:
```
┌─────────────────────────────────────┐
│  🤖 AI 평가 중...                   │
├─────────────────────────────────────┤
│                                     │
│  입력하신 문장:                      │
│  "바다에서 꿈같은 일몰을 보았다"     │
│                                     │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ ChatGPT  ⏳ 평가 중...       │   │ ← Progress Indicator
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Claude   ⏳ 대기 중...       │   │
│  └─────────────────────────────┘   │
│                                     │
│       [Loading Spinner]             │ ← System Activity Indicator
│                                     │
└─────────────────────────────────────┘
```

### 4. 설정 화면 (Settings View)

**네이티브 iOS Settings 스타일**:
```swift
Form {
    Section(header: Text("목표 설정")) {
        HStack {
            Text("일일 목표")
            Spacer()
            Text("\(goalHours)시간")
                .foregroundColor(.secondary)
        }
        
        Slider(value: $goalHours, in: 1...12, step: 0.5)
            .accentColor(.appAccent)
    }
    
    Section(header: Text("테마")) {
        NavigationLink(destination: ThemeSelectionView()) {
            HStack {
                Text("앱 테마 색상")
                Spacer()
                Circle()
                    .fill(Color.appAccent)
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    Section(header: Text("언어")) {
        LanguagePickerView()
    }
    
    Section(header: Text("동기부여")) {
        Toggle("동기부여 메시지 표시", isOn: $showMotivation)
    }
}
```

---

## 🎨 사용자 커스터마이징: 아이폰 색상 매칭

### Device Color Matching System

#### 1. 시스템 아키텍처

```swift
// DeviceColorManager.swift
class DeviceColorManager: ObservableObject {
    @Published var selectedColor: DeviceColor = .systemDefault
    @Published var matchDeviceColor: Bool = false
    
    enum DeviceColor: String, CaseIterable, Identifiable {
        case systemDefault = "시스템 기본"
        case midnightBlue = "미드나잇 블루"
        case starlight = "스타라이트"
        case pink = "핑크"
        case blue = "블루"
        case purple = "퍼플"
        case yellow = "옐로우"
        case green = "그린"
        case red = "레드"
        case custom = "커스텀"
        
        var id: String { rawValue }
        
        var color: Color {
            switch self {
            case .systemDefault:
                return .systemBlue
            case .midnightBlue:
                return Color(red: 0.08, green: 0.11, blue: 0.22)
            case .starlight:
                return Color(red: 0.97, green: 0.96, blue: 0.93)
            case .pink:
                return Color(red: 0.95, green: 0.76, blue: 0.82)
            case .blue:
                return Color(red: 0.42, green: 0.64, blue: 0.82)
            case .purple:
                return Color(red: 0.68, green: 0.55, blue: 0.84)
            case .yellow:
                return Color(red: 1.0, green: 0.93, blue: 0.53)
            case .green:
                return Color(red: 0.67, green: 0.82, blue: 0.62)
            case .red:
                return Color(red: 0.92, green: 0.38, blue: 0.38)
            case .custom:
                return loadCustomColor()
            }
        }
    }
    
    // UserDefaults에 저장
    func saveSelectedColor(_ color: DeviceColor) {
        selectedColor = color
        UserDefaults.standard.set(color.rawValue, forKey: "selectedDeviceColor")
        applyColorToApp(color.color)
    }
    
    // 앱 전체에 색상 적용
    private func applyColorToApp(_ color: Color) {
        // Global Accent Color 업데이트
        UIView.appearance().tintColor = UIColor(color)
        
        // Navigation Bar
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
        UINavigationBar.appearance().standardAppearance = appearance
        
        // Tab Bar
        UITabBar.appearance().tintColor = UIColor(color)
    }
}
```

#### 2. 테마 선택 UI

```swift
struct ThemeSelectionView: View {
    @StateObject private var colorManager = DeviceColorManager()
    @State private var showColorPicker = false
    
    var body: some View {
        List {
            Section(header: Text("아이폰 색상 매칭")) {
                Toggle("내 아이폰 색상과 매칭", isOn: $colorManager.matchDeviceColor)
                    .onChange(of: colorManager.matchDeviceColor) { newValue in
                        if newValue {
                            detectDeviceColor()
                        }
                    }
                
                Text("앱의 메인 색상이 아이폰 기기 색상과 조화롭게 변경됩니다")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("프리셋 색상")) {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 60))
                ], spacing: 16) {
                    ForEach(DeviceColorManager.DeviceColor.allCases) { deviceColor in
                        ColorCircleButton(
                            color: deviceColor.color,
                            isSelected: colorManager.selectedColor == deviceColor,
                            label: deviceColor.rawValue
                        ) {
                            colorManager.saveSelectedColor(deviceColor)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section(header: Text("커스텀 색상")) {
                Button(action: {
                    showColorPicker = true
                }) {
                    HStack {
                        Text("커스텀 색상 선택")
                        Spacer()
                        Image(systemName: "paintpalette")
                    }
                }
            }
        }
        .navigationTitle("앱 테마")
        .sheet(isPresented: $showColorPicker) {
            CustomColorPickerView(selectedColor: $colorManager.customColor)
        }
    }
    
    private func detectDeviceColor() {
        // iOS 16+ 디바이스 색상 감지 로직
        // 실제로는 시스템 API가 제한적이므로 사용자가 선택하도록 유도
    }
}

struct ColorCircleButton: View {
    var color: Color
    var isSelected: Bool
    var label: String
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(
                                    isSelected ? Color.primary : Color.clear,
                                    lineWidth: 3
                                )
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .bold))
                    }
                }
            }
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
}
```

#### 3. Dynamic Theming with SwiftUI Environment

```swift
// ThemeEnvironment.swift
struct ThemeKey: EnvironmentKey {
    static let defaultValue: Color = .systemBlue
}

extension EnvironmentValues {
    var themeColor: Color {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// 사용 예시
struct ContentView: View {
    @StateObject private var colorManager = DeviceColorManager()
    
    var body: some View {
        MainView()
            .environment(\.themeColor, colorManager.selectedColor.color)
            .accentColor(colorManager.selectedColor.color)
    }
}

// 하위 뷰에서 사용
struct SomeChildView: View {
    @Environment(\.themeColor) var themeColor
    
    var body: some View {
        Button("Action") {
            // ...
        }
        .foregroundColor(themeColor)
    }
}
```

---

## 📐 Typography System

### San Francisco Font 사용 가이드

```swift
extension Font {
    // Display (큰 제목)
    static let displayLarge = Font.system(size: 48, weight: .bold, design: .default)
    static let displayMedium = Font.system(size: 36, weight: .bold, design: .default)
    static let displaySmall = Font.system(size: 28, weight: .bold, design: .default)
    
    // Title (섹션 제목)
    static let titleLarge = Font.system(size: 24, weight: .semibold, design: .default)
    static let titleMedium = Font.system(size: 20, weight: .semibold, design: .default)
    static let titleSmall = Font.system(size: 18, weight: .medium, design: .default)
    
    // Body (본문)
    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)
    
    // Caption (보조 텍스트)
    static let captionLarge = Font.system(size: 12, weight: .regular, design: .default)
    static let captionSmall = Font.system(size: 11, weight: .regular, design: .default)
}
```

### 사용 예시

```
메인 화면 타이틀: .displaySmall (28pt Bold)
카드 제목: .titleMedium (20pt Semibold)
본문 텍스트: .bodyLarge (17pt Regular)
시간 표시: .displayMedium (36pt Bold) - 숫자
통계 수치: .titleLarge (24pt Semibold)
캡션/설명: .captionLarge (12pt Regular)
동기부여 메시지: .titleSmall (18pt Medium) 또는 .bodyLarge (17pt Semibold)
```

---

## 🎭 Animation Guidelines

### 1. 애니메이션 원칙

```
Duration: 0.2~0.5초 (빠른 피드백)
Easing: .spring (자연스러운 움직임)
Overshoot: 최소화 (전문적인 느낌)
```

### 2. 애니메이션 라이브러리

```swift
extension Animation {
    // 표준 애니메이션
    static let standardSpring = Animation.spring(
        response: 0.3,
        dampingFraction: 0.7
    )
    
    // 부드러운 애니메이션
    static let smoothEaseOut = Animation.easeOut(duration: 0.3)
    
    // 강조 애니메이션
    static let bouncy = Animation.spring(
        response: 0.5,
        dampingFraction: 0.6,
        blendDuration: 0.2
    )
}
```

### 3. 주요 애니메이션 패턴

**버튼 탭**:
```swift
@State private var isPressed = false

Button(action: action) {
    Text("탭하기")
}
.scaleEffect(isPressed ? 0.95 : 1.0)
.onLongPressGesture(minimumDuration: 0, pressing: { pressing in
    withAnimation(.smoothEaseOut) {
        isPressed = pressing
    }
}, perform: {})
```

**카드 등장**:
```swift
.transition(.asymmetric(
    insertion: .move(edge: .bottom).combined(with: .opacity),
    removal: .opacity
))
.animation(.standardSpring, value: isVisible)
```

**Progress Bar**:
```swift
RoundedRectangle(cornerRadius: 4)
    .fill(color)
    .frame(width: geometry.size.width * progress)
    .animation(.standardSpring, value: progress)
```

---

## 📏 Spacing & Layout System

### 8pt Grid System

```swift
enum Spacing {
    static let xxs: CGFloat = 4      // 0.5 × 8
    static let xs: CGFloat = 8       // 1 × 8
    static let sm: CGFloat = 12      // 1.5 × 8
    static let md: CGFloat = 16      // 2 × 8
    static let lg: CGFloat = 24      // 3 × 8
    static let xl: CGFloat = 32      // 4 × 8
    static let xxl: CGFloat = 48     // 6 × 8
    static let xxxl: CGFloat = 64    // 8 × 8
}
```

### Corner Radius

```swift
enum CornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 24
    static let pill: CGFloat = 999  // 완전한 캡슐 모양
}
```

### Shadow

```swift
extension View {
    func cardShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.1),
            radius: 8,
            x: 0,
            y: 4
        )
    }
    
    func lightShadow() -> some View {
        self.shadow(
            color: Color.black.opacity(0.05),
            radius: 4,
            x: 0,
            y: 2
        )
    }
}
```

---

## 🎯 사용자 경험 (UX) 원칙

### 1. Feedback First

**모든 인터랙션에 즉각적인 피드백**:
```
✓ 버튼 탭 → Haptic Feedback + Visual Change
✓ 입력 완료 → Success Animation
✓ 에러 발생 → Error Message + Suggestion
✓ 로딩 중 → Progress Indicator + Estimated Time
✓ 목표 달성 → 동기부여 메시지 + 축하 애니메이션
```

### 2. Predictable & Consistent

**일관된 패턴 유지**:
```
✓ 주요 액션 버튼은 항상 하단
✓ 뒤로가기는 좌측 상단
✓ 설정은 우측 상단
✓ 색상/아이콘의 의미 일관성
✓ 동기부여 메시지는 항상 상단
```

### 3. Accessibility

**접근성 필수 준수**:
```swift
// Dynamic Type 지원
Text("제목")
    .font(.title)
    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

// VoiceOver 지원
Button(action: {}) {
    Image(systemName: "lock.fill")
}
.accessibilityLabel("잠금 활성화")
.accessibilityHint("탭하면 앱이 잠깁니다")

// Color Contrast (최소 4.5:1)
.foregroundColor(.label) // 자동으로 대비 보장
```

### 4. Error Prevention

**에러 예방 디자인**:
```
✓ 중요한 액션에는 확인 다이얼로그
✓ 입력 실시간 검증 (글자 수 카운트)
✓ 비활성화 버튼은 명확한 이유 표시
✓ Undo 기능 제공
```

---

## 📱 디바이스 대응

### iPhone 모델별 최적화

```swift
enum DeviceType {
    case small    // iPhone SE, 12 mini
    case regular  // iPhone 13, 14
    case plus     // iPhone 13 Pro Max, 14 Plus
    case pro      // iPhone 14 Pro, 15 Pro
    
    static var current: DeviceType {
        let screen = UIScreen.main.bounds
        if screen.height <= 667 {
            return .small
        } else if screen.height <= 844 {
            return .regular
        } else if screen.height <= 926 {
            return .plus
        } else {
            return .pro
        }
    }
}
```

**Safe Area 처리**:
```swift
.safeAreaInset(edge: .bottom) {
    // Bottom button area
}
.ignoresSafeArea(.keyboard) // 키보드 위에 버튼 표시
```

---

## 🎨 아이콘 & 일러스트레이션

### SF Symbols 사용

**주요 아이콘 목록**:
```
🔒 lock.fill / lock.open.fill
🗝️ key.fill
🎯 target
📊 chart.bar.fill / chart.line.uptrend.xyaxis
⚙️ gearshape.fill
📅 calendar
🔥 flame.fill (연속 달성)
✓ checkmark.circle.fill (성공)
⚠️ exclamationmark.triangle.fill (경고)
✕ xmark.circle.fill (실패)
⏰ clock.fill
📱 iphone
🌙 moon.fill (다크모드)
☀️ sun.max.fill (라이트모드)
🔔 bell.fill (알림)
💪 hand.raised.fill (동기부여)
🎉 party.popper (축하)
```

### 커스텀 일러스트레이션

**스타일 가이드**:
```
- Flat design with subtle gradients
- Rounded corners (16pt default)
- Limited color palette (2-3 colors)
- Simple, recognizable shapes
- Consistent line weight (2-3pt)
```

---

## 📊 성능 & 최적화

### 렌더링 최적화

```swift
// LazyVStack/LazyHStack 사용
LazyVStack(spacing: Spacing.md) {
    ForEach(items) { item in
        CardView(item: item)
    }
}

// 이미지 최적화
AsyncImage(url: imageURL) { image in
    image
        .resizable()
        .aspectRatio(contentMode: .fill)
} placeholder: {
    ProgressView()
}
.frame(width: 60, height: 60)
.clipShape(Circle())
```

### Dark Mode 성능

```swift
// Asset Catalog 사용 (권장)
Color("AppAccent") // 자동으로 Light/Dark 전환

// 동적 생성 (성능 주의)
Color(UIColor { traitCollection in
    traitCollection.userInterfaceStyle == .dark ? darkColor : lightColor
})
```

---

## 🚀 개발 우선순위

### Phase 1: 기본 디자인 시스템 (Week 1-2)
```
✓ Color System 구축
  - Asset Catalog 설정
  - Dynamic Colors 정의
  - Theme Manager 구현

✓ Typography System
  - Font Extensions 생성
  - 일관된 폰트 사이즈 적용

✓ Component Library
  - Button Styles
  - Card Views
  - Progress Bars
  - Motivational Message Banner (NEW)
```

### Phase 2: 화면별 UI 구현 (Week 3-5)
```
✓ 메인 화면
  - 동기부여 메시지 배너 (NEW)
  - 카드 컴포넌트
  - 히트맵 구현
  - Progress 애니메이션

✓ 잠금 화면
  - 애니메이션 효과
  - 카운트다운 UI

✓ 창의적 해제 화면
  - 단어 Pill 디자인
  - AI 평가 UI
```

### Phase 3: 테마 커스터마이징 (Week 6)
```
✓ Device Color Matching
  - 색상 선택 UI
  - 테마 적용 로직
  - UserDefaults 저장

✓ 커스텀 컬러 피커
  - ColorPicker 통합
  - 미리보기 기능
```

### Phase 4: 폴리싱 & 최적화 (Week 7-8)
```
✓ 애니메이션 세밀 조정
✓ Accessibility 검증
✓ Dark Mode 테스트
✓ 다양한 디바이스 테스트
✓ 성능 최적화
✓ 동기부여 메시지 A/B 테스트 (NEW)
```

---

## 📚 참고 자료 & 영감

### Apple Design Resources
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [Apple Design Resources](https://developer.apple.com/design/resources/)

### 디자인 영감 앱
- **Things 3**: 깔끔한 투두 리스트
- **Streaks**: 습관 추적 히트맵
- **Forest**: 집중력 게이미피케이션
- **Headspace**: 명상 앱 미니멀리즘
- **Notion**: 유연한 레이아웃 시스템
- **Sunsama**: 시간 블로킹 UI
- **Apple Health**: 네이티브 iOS 디자인
- **Duolingo**: 동기부여 메시지 시스템 (NEW)

### 디자인 트렌드 리서치 (2025)
- **Exaggerated Minimalism**: 대담하면서도 심플한 디자인
- **Adaptive Interfaces**: 사용자 환경에 자동 적응
- **Micro-interactions**: 작지만 의미있는 피드백
- **Typography-driven**: 타이포그래피가 주도하는 UI
- **Soft UI (Neumorphism)**: 부드러운 그림자와 깊이감
- **Transparent Elements**: 블러 효과와 투명도 활용
- **Gamification & Motivation**: 게이미피케이션 요소를 통한 사용자 참여 유도 (NEW)

---

## ✅ 체크리스트

### 디자인 구현 전 체크
- [ ] Color System Asset Catalog 생성
- [ ] Typography Extensions 작성
- [ ] Component Library 기본 구조 설정
- [ ] Theme Manager 초기화
- [ ] SF Symbols 리스트 정리
- [ ] Motivational Message 텍스트 번역 (NEW)

### 화면별 구현 체크
- [ ] 메인 화면 - 동기부여 메시지 배너 (NEW)
- [ ] 메인 화면 - 카드 레이아웃
- [ ] 메인 화면 - 히트맵
- [ ] 메인 화면 - Progress Bar
- [ ] 잠금 화면 - 애니메이션
- [ ] 해제 화면 - 단어 Pill
- [ ] 해제 화면 - AI 평가 UI
- [ ] 설정 화면 - 테마 선택
- [ ] 설정 화면 - 동기부여 메시지 토글 (NEW)

### 테마 시스템 체크
- [ ] Device Color Detection
- [ ] Color Preset 8가지 이상
- [ ] Custom Color Picker
- [ ] Theme Persistence (UserDefaults)
- [ ] Real-time Theme Switching

### 동기부여 시스템 체크 (NEW)
- [ ] MotivationManager 구현
- [ ] 사용 일수 추적 로직
- [ ] 연속 달성 계산 로직
- [ ] 메시지 표시/숨김 토글
- [ ] 다국어 메시지 번역
- [ ] 마일스톤 애니메이션 효과

### 품질 보증 체크
- [ ] Light/Dark Mode 모두 테스트
- [ ] VoiceOver 접근성 검증
- [ ] Dynamic Type 지원 확인
- [ ] 다양한 기기 사이즈 테스트
- [ ] 애니메이션 성능 측정
- [ ] 색상 대비 비율 확인 (4.5:1)
- [ ] 동기부여 메시지 정확성 검증 (NEW)

---

## 📝 버전 히스토리

**v1.1 (2025-11-04)**
- 동기부여 메시지 시스템 추가
  - 1일차 환영 메시지
  - 성공/실패 피드백 메시지
  - 연속 달성 스트릭 표시
  - 마일스톤 축하 효과
- 메인 화면 레이아웃 업데이트
- 설정 화면에 동기부여 메시지 토글 추가

**v1.0 (2025-11-04)**
- 초기 디자인 요구사항 작성
- 2025 iOS 트렌드 리서치 반영
- Dynamic Color System 설계
- Device Color Matching 기능 명세
- 20-30대 타겟 사용자 중심 디자인

---

**작성자**: DevJihwan  
**최종 수정일**: 2025년 11월 4일  
**문서 상태**: v1.1 - 동기부여 시스템 추가
