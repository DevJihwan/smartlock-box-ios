# 씽크프리 (ThinkFree) - 앱 디자인 시스템 가이드

## 📋 목차
1. [Figma 시작하기](#figma-시작하기)
2. [디자인 시스템 기본](#디자인-시스템-기본)
3. [메인 UI 개선 제안](#메인-ui-개선-제안)
4. [전체 화면 디자인 스펙](#전체-화면-디자인-스펙)
5. [앱 아이콘 디자인](#앱-아이콘-디자인)
6. [앱스토어 에셋](#앱스토어-에셋)

---

## 🎯 Figma 시작하기

### 1단계: Figma 계정 생성
1. https://figma.com 접속
2. "Sign up" 클릭
3. 이메일 또는 Google 계정으로 가입
4. 무료 Starter 플랜 선택

### 2단계: 새 디자인 파일 만들기
1. 대시보드에서 "New design file" 클릭
2. 파일 이름: "ThinkFree App Design"

### 3단계: 프레임(Frame) 생성
```
단축키: F (Frame tool)

추천 프레임:
- iPhone 14 Pro: 393 × 852 px
- App Icon: 1024 × 1024 px
- App Store Screenshot: 1290 × 2796 px
```

### 4단계: 기본 도구 익히기
```
V - 선택 도구 (Move)
F - 프레임 도구 (Frame)
R - 사각형 도구 (Rectangle)
O - 원 도구 (Ellipse)
T - 텍스트 도구 (Text)
P - 펜 도구 (Pen)

Cmd/Ctrl + D - 복제
Cmd/Ctrl + G - 그룹
Cmd/Ctrl + / - 검색
```

---

## 🎨 디자인 시스템 기본

### Color Palette (색상 팔레트)

#### Primary Colors (주요 색상)
```
🔵 Primary Blue
- Light: #5AB9EA (90, 185, 234)
- Main: #34AADC (52, 170, 220)
- Dark: #2890C4 (40, 144, 196)

💡 용도: 메인 액션 버튼, 아이콘 배경, 활성 상태
```

#### Secondary Colors (보조 색상)
```
🟢 Success Green
- Light: #4ADE80 (74, 222, 128)
- Main: #22C55E (34, 197, 94)
- Dark: #16A34A (22, 163, 74)
💡 용도: 목표 달성, 성공 메시지, 안전 구간 (0-60%)

🟡 Warning Yellow
- Light: #FDE047 (253, 224, 71)
- Main: #FACC15 (250, 204, 21)
- Dark: #EAB308 (234, 179, 8)
💡 용도: 주의 알림, 경고 구간 (61-85%)

🔴 Danger Red
- Light: #FB7185 (251, 113, 133)
- Main: #F43F5E (244, 63, 94)
- Dark: #E11D48 (225, 29, 72)
💡 용도: 위험 구간 (86-100%), 잠금 상태
```

#### Neutral Colors (중성 색상)
```
⚫ Grayscale
- Gray 900 (Text Primary): #111827
- Gray 700 (Text Secondary): #374151
- Gray 500 (Text Tertiary): #6B7280
- Gray 300 (Border): #D1D5DB
- Gray 100 (Background Light): #F3F4F6
- Gray 50 (Background): #F9FAFB
- White: #FFFFFF

💡 용도: 텍스트, 배경, 구분선
```

#### Figma에서 색상 저장하기
1. 사각형 그리기 (R)
2. Fill 색상 선택
3. 색상 피커에서 HEX 코드 입력
4. 우측 "Styles" 탭 클릭
5. "+" 버튼으로 Color Style 생성
6. 이름: "Primary/Blue/Main" 형식으로 저장

---

### Typography (타이포그래피)

#### Font Family (폰트)
```
iOS 기본 폰트: SF Pro
- SF Pro Display (큰 텍스트용)
- SF Pro Text (작은 텍스트용)

한글 폰트: 
- Pretendard (추천) - 무료
- Apple SD Gothic Neo (시스템 기본)
```

#### Figma에서 Pretendard 폰트 설치
1. https://github.com/orioncactus/pretendard/releases
2. "Pretendard-X.X.X.zip" 다운로드
3. 압축 해제 후 .otf 또는 .ttf 설치
4. Figma 재시작

#### Text Styles (텍스트 스타일)

```css
/* Heading 1 - 화면 제목 */
Font: Pretendard Bold
Size: 34px
Line Height: 41px (1.2)
Color: Gray 900

/* Heading 2 - 섹션 제목 */
Font: Pretendard SemiBold
Size: 24px
Line Height: 32px (1.33)
Color: Gray 900

/* Heading 3 - 카드 제목 */
Font: Pretendard SemiBold
Size: 20px
Line Height: 28px (1.4)
Color: Gray 900

/* Body Large - 본문 강조 */
Font: Pretendard Medium
Size: 17px
Line Height: 24px (1.41)
Color: Gray 700

/* Body - 일반 본문 */
Font: Pretendard Regular
Size: 15px
Line Height: 22px (1.47)
Color: Gray 700

/* Caption - 보조 텍스트 */
Font: Pretendard Regular
Size: 13px
Line Height: 18px (1.38)
Color: Gray 500

/* Button - 버튼 텍스트 */
Font: Pretendard SemiBold
Size: 16px
Line Height: 24px (1.5)
Color: White / Primary
```

#### Figma에서 Text Style 저장
1. 텍스트 입력 (T)
2. 폰트, 크기, 색상 설정
3. 우측 "Text" 패널에서 "..." 클릭
4. "Create text style" 선택
5. 이름: "Heading 1" 형식으로 저장

---

### Spacing System (간격 시스템)

```
4px 단위 시스템 (8point grid)

4px - 최소 간격 (아이콘-텍스트)
8px - 작은 간격 (버튼 내부 패딩)
12px - 기본 간격 (텍스트 간격)
16px - 일반 간격 (카드 내부 패딩)
20px - 중간 간격 (섹션 간격)
24px - 큰 간격 (화면 여백)
32px - 매우 큰 간격 (주요 섹션)
40px - 특별 간격 (화면 상하단)
```

#### Figma Auto Layout 사용
1. 요소들 선택 (Shift + 클릭)
2. Shift + A (Auto Layout 적용)
3. 우측 패널에서 Spacing 설정
4. 패딩, 간격 자동 관리

---

### Corner Radius (모서리 둥글기)

```
Small: 8px - 작은 버튼, 태그
Medium: 12px - 카드, 입력 필드
Large: 16px - 큰 카드, 모달
Extra Large: 20px - 특별 요소
Circle: 50% - 아이콘 버튼, 프로필
```

---

### Shadow (그림자)

```css
/* Small Shadow - 작은 카드 */
X: 0px, Y: 1px, Blur: 2px
Color: #00000014 (Gray 900 at 8%)

/* Medium Shadow - 일반 카드 */
X: 0px, Y: 4px, Blur: 6px
Color: #0000001F (Gray 900 at 12%)

/* Large Shadow - 플로팅 요소 */
X: 0px, Y: 10px, Blur: 15px
Color: #00000029 (Gray 900 at 16%)
```

---

## 🚀 메인 UI 개선 제안

### 현재 문제점 분석

기존 REQUIREMENTS.md의 메인 화면은:
- ❌ 정보가 너무 많음 (복잡함)
- ❌ 시각적 계층이 불명확
- ❌ v2.0 심플 철학과 맞지 않음
- ❌ 미니멀하지 않음

---

## 💎 개선안: 3가지 디자인 옵션

---

## 디자인 옵션 1: 미니멀 포커스 (추천 ⭐)

### 컨셉
"필요한 정보만, 단 하나의 화면에"

### 레이아웃
```
┌─────────────────────────────────────┐
│ ThinkFree              [KR] [EN] 🌙│ ← 24px padding
├─────────────────────────────────────┤
│                                     │
│                                     │ 
│         [크고 명확한 상태]           │ ← 40px top
│                                     │
│          ⏰ 오전 9:00                │ ← H1: 34px
│            ~                        │
│          오후 6:00                  │
│                                     │
│         2시간 제한                  │ ← Body: 17px, Gray 500
│                                     │
│   ──────────────────────────────   │ ← 32px margin
│                                     │
│       [원형 프로그레스]              │
│                                     │
│         1h 23m                      │ ← H1: 48px, Bold
│         ─────                       │
│         2h 00m                      │ ← Body: 20px
│                                     │
│        37분 남음                    │ ← Caption: 15px, Gray 500
│                                     │
│   ──────────────────────────────   │ ← 32px margin
│                                     │
│     [●─────────────] OFF           │ ← 큰 토글 스위치
│                                     │
│         제어 비활성                  │ ← Caption
│                                     │
│                                     │
│                                     │
│                                     │
│        [⚙️ 설정]                    │ ← 40px bottom
│                                     │
└─────────────────────────────────────┘
```

### 핵심 특징
- ✅ 한눈에 들어오는 정보
- ✅ 큰 타이포그래피
- ✅ 원형 프로그레스 (직관적)
- ✅ 여백 충분 (미니멀)
- ✅ 색상 최소화

### 색상 사용
```
배경: White
주요 텍스트: Gray 900
보조 텍스트: Gray 500
프로그레스: 
  - 0-60%: Green
  - 61-85%: Yellow
  - 86-100%: Red
토글 ON: Primary Blue
```

### Figma 작업 순서
1. iPhone 14 Pro 프레임 생성 (393×852)
2. Auto Layout 컨테이너 생성 (24px padding)
3. 헤더: Text "ThinkFree" + 언어 버튼 + 다크모드 아이콘
4. 시간대 텍스트 (Center align)
5. Circle Progress (플러그인: "Figma CircleProgressbar" 추천)
6. 토글 스위치 (Rectangle + Circle)
7. 설정 버튼 (Text + Icon)

---

## 디자인 옵션 2: 카드 기반

### 컨셉
"정보를 카드로 구분"

### 레이아웃
```
┌─────────────────────────────────────┐
│ ThinkFree              [KR] [EN] 🌙│
├─────────────────────────────────────┤
│                                     │
│   ┌─────────────────────────────┐  │ ← Card 1
│   │  ⏰ 제어 시간대              │  │
│   │                             │  │
│   │  오전 9:00 ~ 오후 6:00      │  │
│   │  2시간 제한                 │  │
│   │                             │  │
│   │  [●─────────] OFF          │  │
│   └─────────────────────────────┘  │
│                                     │
│   ┌─────────────────────────────┐  │ ← Card 2
│   │  📊 오늘 사용 현황           │  │
│   │                             │  │
│   │     1시간 23분 / 2시간      │  │
│   │  ████████░░░░░░░░ 69%      │  │
│   │                             │  │
│   │  ⚠️ 37분 남음               │  │
│   └─────────────────────────────┘  │
│                                     │
│   ┌─────────────────────────────┐  │ ← Card 3
│   │  잠금까지 00:37:24          │  │
│   └─────────────────────────────┘  │
│                                     │
│                                     │
│        [⚙️ 설정]                    │
│                                     │
└─────────────────────────────────────┘
```

### 핵심 특징
- ✅ 정보 그룹화
- ✅ 카드로 시각적 구분
- ✅ 그림자로 깊이감
- ✅ 스크롤 가능 (필요시)

### 카드 스타일
```
배경: White
테두리: 없음
모서리: 16px
그림자: Medium Shadow
패딩: 20px
간격: 16px
```

---

## 디자인 옵션 3: 시각적 임팩트

### 컨셉
"큰 비주얼로 즉각적 인지"

### 레이아웃
```
┌─────────────────────────────────────┐
│ ThinkFree              [KR] [EN] 🌙│
├─────────────────────────────────────┤
│                                     │
│                                     │
│       [큰 원형 프로그레스]           │
│          (200×200)                  │
│                                     │
│          1:23                       │ ← 큰 시간 표시
│          ───                        │
│          2:00                       │
│                                     │
│        69% 사용 중                  │
│                                     │
│                                     │
│   ⏰ 오전 9:00 ~ 오후 6:00          │
│   2시간 제한                        │
│                                     │
│   ──────────────────────────────   │
│                                     │
│   ⚠️ 37분 후 잠금됩니다             │
│                                     │
│   ──────────────────────────────   │
│                                     │
│   제어 [─────────●] ON             │
│                                     │
│                                     │
│        [⚙️ 설정]                    │
│                                     │
└─────────────────────────────────────┘
```

### 핵심 특징
- ✅ 시각적으로 강렬
- ✅ 사용 현황 즉시 파악
- ✅ 색상으로 상태 표현
- ✅ 단순하고 직관적

---

## 🎯 최종 추천: 옵션 1 (미니멀 포커스)

### 추천 이유
1. ✅ v2.0 "One Feature, Done Right" 철학과 완벽히 일치
2. ✅ 가장 심플하고 이해하기 쉬움
3. ✅ 여백이 많아 미니멀함 강조
4. ✅ 구현하기 가장 쉬움
5. ✅ iOS 디자인 가이드라인 준수

---

**문서 버전**: 1.0  
**작성일**: 2025년 11월 14일  
**작성자**: DevJihwan  
**앱 이름**: 씽크프리 (ThinkFree)
