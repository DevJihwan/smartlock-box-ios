# App Store 배포 가이드 - ThinkFree

> 번들 ID 변경부터 App Store 제출까지 완벽 가이드

**앱 이름**: 씽크프리 (ThinkFree)  
**권장 번들 ID**: `com.devjihwan.thinkfree`  
**작성일**: 2025년 11월 18일

---

## 📋 목차

1. [번들 ID 변경](#1-번들-id-변경)
2. [Apple Developer 계정 설정](#2-apple-developer-계정-설정)
3. [App Store Connect 앱 등록](#3-app-store-connect-앱-등록)
4. [Xcode 프로젝트 설정](#4-xcode-프로젝트-설정)
5. [인증서 및 프로비저닝 프로파일](#5-인증서-및-프로비저닝-프로파일)
6. [빌드 및 아카이브](#6-빌드-및-아카이브)
7. [App Store 제출](#7-app-store-제출)
8. [체크리스트](#8-최종-체크리스트)

---

## 1. 번들 ID 변경

### 1.1 권장 번들 ID
```
com.devjihwan.thinkfree
```

**현재 번들 ID (변경 필요)**:
```
com.devjihwan.cardnewsapp.SmartLockBox  ❌
```

### 1.2 Xcode에서 번들 ID 변경

#### Step 1: 프로젝트 선택
1. Xcode에서 프로젝트 열기
2. 왼쪽 네비게이터에서 최상단 **SmartLockBox** 프로젝트 클릭
3. **TARGETS** → **SmartLockBox** 선택

#### Step 2: Bundle Identifier 변경
1. **General** 탭으로 이동
2. **Identity** 섹션 찾기
3. **Bundle Identifier** 필드를 다음으로 변경:
   ```
   com.devjihwan.thinkfree
   ```

#### Step 3: 테스트 타겟도 변경
1. **TARGETS** → **SmartLockBoxTests** 선택
2. Bundle Identifier 변경:
   ```
   com.devjihwan.thinkfree.tests
   ```

3. **TARGETS** → **SmartLockBoxUITests** 선택
4. Bundle Identifier 변경:
   ```
   com.devjihwan.thinkfree.uitests
   ```

#### Step 4: Entitlements 파일 확인
```bash
# SmartLockBox/SmartLockBox.entitlements 파일 확인
# Family Controls 권한이 올바르게 설정되어 있는지 확인
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.family-controls</key>
    <true/>
</dict>
</plist>
```

### 1.3 Info.plist 확인

**필수 설정 항목:**
```xml
<key>CFBundleDisplayName</key>
<string>씽크프리</string>

<key>CFBundleName</key>
<string>ThinkFree</string>

<key>NSUserTrackingUsageDescription</key>
<string>앱 사용 시간을 모니터링하기 위해 Screen Time 권한이 필요합니다.</string>

<key>NSFamilyActivityUsageDescription</key>
<string>스마트폰 사용 시간을 제한하기 위해 Screen Time API 접근이 필요합니다.</string>
```

---

## 2. Apple Developer 계정 설정

### 2.1 Apple Developer Program 가입
1. [https://developer.apple.com](https://developer.apple.com) 접속
2. **Account** → **Enroll** 클릭
3. 연간 $99 (약 130,000원) 결제
4. 승인 대기 (보통 24-48시간)

### 2.2 Apple Developer 계정 확인
- 계정 타입: Individual 또는 Organization
- Team ID 확인: **JVUXYR66CL** (프로젝트에서 확인됨)

---

## 3. App Store Connect 앱 등록

### 3.1 새 앱 생성
1. [App Store Connect](https://appstoreconnect.apple.com) 접속
2. **My Apps** → **+** 버튼 → **New App** 클릭

### 3.2 앱 정보 입력

**플랫폼**: iOS

**이름**: 씽크프리

**기본 언어**: Korean (한국어)

**번들 ID**: `com.devjihwan.thinkfree` (드롭다운에서 선택)

**SKU**: `THINKFREE-001` (고유 식별자, 사용자에게 보이지 않음)

**사용자 액세스**: Full Access

### 3.3 앱 정보 세부 입력

#### 3.3.1 기본 정보
```
이름: 씽크프리 - 디지털 디톡스 집중 타이머
부제: AI 창의력으로 여는 스마트폰 집중 관리
```

#### 3.3.2 카테고리
```
Primary Category: Productivity (생산성)
Secondary Category: Health & Fitness (건강 및 피트니스)
```

#### 3.3.3 연령 등급
```
4+ (모든 연령 적합)
- 무제한 또는 무료 웹 액세스: 없음
- 만화/판타지 폭력: 없음
- 사실적 폭력: 없음
- 성적/선정적 콘텐츠: 없음
- 욕설/저속한 유머: 없음
- 알코올/담배/마약: 없음
- 의료/치료 정보: 없음
- 공포/충격 테마: 없음
- 도박: 없음
```

---

## 4. Xcode 프로젝트 설정

### 4.1 일반 설정 (General Tab)

#### Identity
```
Display Name: 씽크프리
Bundle Identifier: com.devjihwan.thinkfree
Version: 1.0
Build: 1
```

#### Deployment Info
```
iOS Deployment Target: 17.0 (권장)
iPhone Orientation: Portrait, Landscape Left, Landscape Right
iPad Orientation: All
```

**중요**: iOS 18.2는 너무 최신이므로 17.0으로 낮추는 것을 권장합니다.
```swift
// project.pbxproj에서 변경
IPHONEOS_DEPLOYMENT_TARGET = 17.0;
```

#### Frameworks, Libraries, and Embedded Content
```
- FamilyControls.framework (Screen Time API)
- Foundation.framework
- SwiftUI.framework
```

### 4.2 서명 및 기능 (Signing & Capabilities)

#### Signing (Debug)
```
Automatically manage signing: ✅ 체크
Team: DevJihwan (JVUXYR66CL)
Provisioning Profile: Xcode Managed Profile
Signing Certificate: Apple Development
```

#### Signing (Release)
```
Automatically manage signing: ✅ 체크
Team: DevJihwan (JVUXYR66CL)
Provisioning Profile: Xcode Managed Profile
Signing Certificate: Apple Distribution
```

#### Capabilities 추가

**필수 권한:**

1. **Family Controls** ⭐ 가장 중요!
   - **+Capability** 클릭
   - **Family Controls** 검색 및 추가
   - Entitlements 파일에 자동 추가됨

2. **Background Modes** (선택사항)
   - Background fetch
   - Remote notifications (푸시 알림 사용 시)

### 4.3 빌드 설정 (Build Settings)

#### 중요 설정 확인
```
Code Signing Identity (Debug): Apple Development
Code Signing Identity (Release): Apple Distribution
Development Team: JVUXYR66CL
Enable Bitcode: NO (iOS 14 이후 불필요)
```

#### 최적화 설정
```
Swift Compiler - Code Generation:
- Optimization Level (Debug): No Optimization [-Onone]
- Optimization Level (Release): Optimize for Speed [-O]

Apple Clang - Code Generation:
- Optimization Level (Debug): None [-O0]
- Optimization Level (Release): Fastest, Smallest [-Os]
```

### 4.4 Info.plist 최종 확인

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- 앱 기본 정보 -->
    <key>CFBundleDisplayName</key>
    <string>씽크프리</string>
    
    <key>CFBundleName</key>
    <string>ThinkFree</string>
    
    <key>CFBundleIdentifier</key>
    <string>com.devjihwan.thinkfree</string>
    
    <key>CFBundleVersion</key>
    <string>1</string>
    
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    
    <!-- 권한 설명 -->
    <key>NSUserTrackingUsageDescription</key>
    <string>앱 사용 시간을 모니터링하기 위해 Screen Time 권한이 필요합니다.</string>
    
    <key>NSFamilyActivityUsageDescription</key>
    <string>스마트폰 사용 시간을 제한하기 위해 Screen Time API 접근이 필요합니다.</string>
    
    <!-- UI 설정 -->
    <key>UILaunchScreen</key>
    <dict>
        <key>UIImageName</key>
        <string>LaunchImage</string>
    </dict>
    
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    
    <!-- 앱 전송 보안 -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <false/>
    </dict>
    
    <!-- Scene 설정 -->
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <true/>
    </dict>
</dict>
</plist>
```

---

## 5. 인증서 및 프로비저닝 프로파일

### 5.1 자동 서명 (권장)

Xcode의 **Automatically manage signing** 기능 사용:

**장점:**
- ✅ 간편한 관리
- ✅ 자동 갱신
- ✅ 에러 자동 해결

**설정:**
1. Xcode → Targets → Signing & Capabilities
2. "Automatically manage signing" 체크
3. Team 선택: DevJihwan (JVUXYR66CL)

### 5.2 수동 서명 (고급)

Apple Developer Portal에서 직접 관리:

#### 5.2.1 인증서 생성
1. [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/certificates) 접속
2. **Certificates** → **+** 버튼
3. **iOS App Development** (개발용) 선택
4. CSR 파일 업로드
5. 인증서 다운로드 및 설치

#### 5.2.2 App ID 등록
1. **Identifiers** → **+** 버튼
2. **App IDs** 선택
3. 설정:
   ```
   Description: ThinkFree iOS App
   Bundle ID: Explicit - com.devjihwan.thinkfree
   Capabilities: Family Controls ✅
   ```

#### 5.2.3 프로비저닝 프로파일 생성
1. **Profiles** → **+** 버튼
2. **iOS App Development** (개발용) 선택
3. App ID: com.devjihwan.thinkfree 선택
4. 인증서 선택
5. 디바이스 선택 (테스트용)
6. 프로파일 이름: ThinkFree Development
7. 다운로드 및 Xcode에 추가

---

## 6. 빌드 및 아카이브

### 6.1 테스트 빌드 (Debug)

#### 시뮬레이터 테스트
```bash
# 시뮬레이터 선택 후
⌘ + R (Run)
```

#### 실제 기기 테스트
1. iPhone 연결
2. Xcode 상단에서 디바이스 선택
3. ⌘ + R 실행
4. 처음 실행 시 기기에서 "신뢰" 필요

### 6.2 릴리즈 빌드 (Archive)

#### Step 1: Scheme 설정
1. **Product** → **Scheme** → **Edit Scheme...**
2. **Run** → **Build Configuration**: Debug
3. **Archive** → **Build Configuration**: Release
4. Close

#### Step 2: 버전 업데이트
```
Version: 1.0
Build: 1
```

**중요**: App Store 제출 시마다 Build 번호를 증가시켜야 합니다.
- 첫 제출: 1.0 (1)
- 버그 수정: 1.0 (2)
- 기능 업데이트: 1.1 (1)

#### Step 3: 아카이브 생성
1. 타겟 변경: **Any iOS Device (arm64)** 선택
   - ❌ 시뮬레이터 선택 시 Archive 불가능
2. **Product** → **Clean Build Folder** (⇧⌘K)
3. **Product** → **Archive** (⌥⌘B)
4. 빌드 완료 대기 (5-10분)

#### Step 4: 아카이브 확인
1. 빌드 성공 시 Organizer 창 자동 열림
2. 왼쪽에서 생성된 아카이브 확인
3. 우측 상단 **Validate App** 클릭

### 6.3 앱 검증 (Validation)

#### 검증 항목
- ✅ 번들 ID 일치
- ✅ 서명 인증서 유효
- ✅ 권한 설정 올바름
- ✅ 앱 아이콘 포함
- ✅ 빌드 설정 올바름

#### 검증 실행
1. **Validate App** 클릭
2. Distribution Method: **App Store Connect**
3. Destination: **Upload**
4. Distribution Options:
   - ✅ Strip Swift symbols
   - ✅ Upload your app's symbols
   - ❌ Manage Version and Build Number
5. **Next** → 자동 서명 선택 → **Validate**

#### 검증 결과
- ✅ 성공: "No issues found"
- ❌ 실패: 에러 메시지 확인 후 수정

---

## 7. App Store 제출

### 7.1 앱 업로드

#### Step 1: Organizer에서 업로드
1. **Distribute App** 클릭
2. **App Store Connect** 선택
3. **Upload** 선택
4. Distribution Options 확인
5. **Next** → **Upload**
6. 업로드 완료 대기 (10-30분)

#### Step 2: App Store Connect 확인
1. [App Store Connect](https://appstoreconnect.apple.com) 접속
2. **My Apps** → **씽크프리** 선택
3. **TestFlight** 탭에서 빌드 확인 (처리 중)
4. 처리 완료 대기 (30분-2시간)

### 7.2 App Store Connect 정보 입력

#### 7.2.1 앱 정보 (App Information)

**카테고리:**
```
Primary: Productivity
Secondary: Health & Fitness
```

**콘텐츠 권한:**
```
Third-Party Content: No
```

#### 7.2.2 가격 및 사용 가능 여부

**가격:**
```
Price: Free (무료)
Available: All countries (모든 국가)
```

#### 7.2.3 앱 개인 정보 보호

**데이터 수집:**
```
No (데이터 수집 안 함)
- 사용 시간 데이터는 기기 로컬에만 저장
- 외부 서버로 전송 없음
```

**개인정보 처리방침 URL:**
```
https://devjihwan.github.io/thinkfree-privacy/privacy-policy.html
```

#### 7.2.4 버전 정보

**이름 (한국어):**
```
씽크프리 - 디지털 디톡스 집중 타이머
```

**부제 (한국어):**
```
AI 창의력으로 여는 스마트폰 집중 관리
```

**설명 (한국어):**
```
[APP_STORE_DESCRIPTION.md 파일의 한국어 설명 복사]
```

**키워드 (한국어):**
```
디지털 디톡스, 집중 타이머, 스마트폰 잠금, 생산성, 집중력, 시간 관리, AI, 창의력, 업무 집중, 공부 집중, 스크린타임, 스마트폰 중독, 자기계발, 습관, 포모도로
```

**홍보 텍스트 (선택):**
```
업무·공부 시간에만 스마트폰 사용 제한! AI가 평가하는 창의적 문장으로 해제하는 디지털 디톡스 앱. 시간대별 집중 타이머로 생산성 향상.
```

**지원 URL:**
```
https://github.com/DevJihwan/smartlock-box-ios
```

**마케팅 URL (선택):**
```
https://devjihwan.github.io/thinkfree
```

#### 7.2.5 영어 버전 추가

**App Store Connect** → **Version Information** → **+ (Add Language)**

```
Language: English (U.S.)
Name: ThinkFree - Focus Timer Digital Detox
Subtitle: AI-Powered Focus & Digital Detox
Description: [APP_STORE_DESCRIPTION.md의 영어 설명 복사]
Keywords: digital detox, focus timer, phone lock, productivity...
```

### 7.3 스크린샷 준비

#### 필수 사이즈
```
6.9" Display (iPhone 16 Pro Max, 15 Pro Max):
- 1320 x 2868 pixels (3장 이상 필수)

6.7" Display (iPhone 14 Pro Max, 13 Pro Max):
- 1290 x 2796 pixels (3장 이상 필수)
```

#### 권장 스크린샷 구성
1. **메인 화면**: 시간대 설정 UI
2. **실시간 모니터링**: 사용 시간 추적
3. **잠금 화면**: 창의적 해제 챌린지
4. **AI 평가**: 이중 AI 평가 시스템
5. **해제 성공**: 성공 화면

#### 스크린샷 캡처 방법
```swift
// 시뮬레이터에서 실행 후
⌘ + S (스크린샷 저장)

// 또는 실제 기기에서
⌘ + Shift + 4 → 시뮬레이터 창 캡처
```

#### 스크린샷 최적화 도구
- [Figma](https://www.figma.com) - 디자인
- [App Store Screenshot](https://www.appstorescreenshot.com/) - 템플릿
- [Shotbot](https://shotbot.io/) - 자동 생성

### 7.4 앱 미리보기 비디오 (선택사항)

**규격:**
```
길이: 15-30초
해상도: 1080 x 1920 (세로)
포맷: .mp4 또는 .mov
파일 크기: 500MB 이하
```

**콘텐츠 권장:**
1. 앱 시작 (2초)
2. 주요 기능 시연 (20초)
3. 결과 화면 (3초)

### 7.5 앱 아이콘

**필수 사이즈:**
```
1024 x 1024 pixels
- PNG 포맷
- 알파 채널 없음
- 투명도 없음
```

**현재 위치:**
```
SmartLockBox/Assets.xcassets/AppIcon.appiconset/
```

### 7.6 빌드 선택 및 제출

#### Step 1: 빌드 선택
1. **App Store Connect** → **씽크프리** → **1.0 Prepare for Submission**
2. **Build** 섹션 → **Select a build before you submit your app**
3. 처리 완료된 빌드 선택 (1.0 - Build 1)

#### Step 2: 내보내기 준수 정보
```
Export Compliance: No (암호화 미사용)
```

#### Step 3: 광고 식별자
```
Advertising Identifier (IDFA): No (광고 미사용)
```

#### Step 4: 콘텐츠 권한 및 연령 등급
```
Age Rating: 4+ (모든 연령 적합)
```

#### Step 5: 제출
1. 모든 항목 ✅ 체크 확인
2. **Save** 버튼 클릭
3. **Add for Review** 클릭
4. **Submit for Review** 클릭

---

## 8. 최종 체크리스트

### 8.1 제출 전 필수 체크리스트

#### Xcode 설정
- [ ] 번들 ID 변경: `com.devjihwan.thinkfree`
- [ ] Display Name: "씽크프리"
- [ ] Version: 1.0, Build: 1
- [ ] Deployment Target: 17.0
- [ ] Family Controls 권한 추가
- [ ] Info.plist 권한 설명 추가
- [ ] Entitlements 파일 확인
- [ ] 실제 기기 테스트 완료

#### App Store Connect
- [ ] 앱 기본 정보 입력
- [ ] 가격: Free
- [ ] 카테고리: Productivity + Health & Fitness
- [ ] 한국어 설명 입력
- [ ] 영어 설명 입력
- [ ] 키워드 입력
- [ ] 스크린샷 업로드 (최소 3장)
- [ ] 앱 아이콘 1024x1024
- [ ] 개인정보 처리방침 URL
- [ ] 지원 URL
- [ ] 연령 등급 설정

#### 빌드 및 업로드
- [ ] Archive 생성 성공
- [ ] Validation 통과
- [ ] App Store Connect 업로드 완료
- [ ] 빌드 처리 완료 확인
- [ ] Export Compliance 완료
- [ ] 빌드 선택 완료

#### 최종 제출
- [ ] 모든 필수 항목 작성 완료
- [ ] 스크린샷 품질 확인
- [ ] 설명 오타 확인
- [ ] 개인정보 처리방침 페이지 작동 확인
- [ ] Submit for Review 클릭

### 8.2 제출 후 프로세스

#### 심사 단계
1. **Waiting for Review** (대기 중): 1-2일
2. **In Review** (심사 중): 1-2일
3. **Pending Developer Release** (승인 완료): 즉시 출시 가능
4. **Ready for Sale** (출시 완료): App Store 검색 가능

#### 심사 거부 대응
- **일반적인 거부 사유:**
  - 스크린샷과 실제 기능 불일치
  - 개인정보 처리방침 누락
  - 권한 설명 불충분
  - Family Controls 사용 목적 불명확

- **대응 방법:**
  1. Resolution Center에서 거부 사유 확인
  2. 문제 수정 또는 추가 설명 작성
  3. 필요시 새 빌드 업로드
  4. 재제출

### 8.3 출시 후 관리

#### 버전 업데이트 프로세스
```
버그 수정: 1.0 → 1.0.1 (Build 2)
작은 기능 추가: 1.0 → 1.1 (Build 1)
큰 업데이트: 1.0 → 2.0 (Build 1)
```

#### 업데이트 제출
1. Xcode에서 버전/빌드 번호 증가
2. 변경사항 구현 및 테스트
3. Archive → Validate → Upload
4. App Store Connect에서 "What's New" 작성
5. Submit for Review

---

## 9. 문제 해결 (Troubleshooting)

### 9.1 일반적인 에러

#### 에러 1: "No Provisioning Profile Found"
**원인**: 자동 서명 실패

**해결:**
```
1. Xcode → Preferences → Accounts
2. Apple ID 다시 로그인
3. Team 선택 → Download Manual Profiles
4. Clean Build Folder (⇧⌘K)
5. 다시 빌드
```

#### 에러 2: "Entitlements are not valid"
**원인**: Family Controls 권한 설정 오류

**해결:**
```
1. Developer Portal에서 App ID 확인
2. Family Controls 권한 활성화 확인
3. Xcode에서 Capability 다시 추가
4. Provisioning Profile 재생성
```

#### 에러 3: "Archive 실행 불가"
**원인**: 시뮬레이터 선택됨

**해결:**
```
Xcode 상단에서 "Any iOS Device (arm64)" 선택
```

#### 에러 4: "Invalid Binary"
**원인**: 빌드 설정 오류

**해결:**
```
Build Settings 확인:
- Valid Architectures: arm64
- Build Active Architecture Only: NO (Release)
- Enable Bitcode: NO
```

### 9.2 심사 거부 대응

#### 거부 사유 1: "Guideline 2.1 - Performance"
**문제**: 앱이 충돌하거나 작동하지 않음

**해결:**
```
1. 테스트 계정 제공
2. 상세한 사용 가이드 작성
3. 필요한 권한 명확히 설명
4. 데모 비디오 제공
```

#### 거부 사유 2: "Guideline 5.1.1 - Privacy"
**문제**: 개인정보 처리방침 미흡

**해결:**
```
1. 명확한 개인정보 처리방침 작성
2. 데이터 수집 항목 상세 설명
3. 로컬 저장만 사용함을 명시
4. 개인정보 처리방침 URL 업데이트
```

#### 거부 사유 3: "Guideline 4.0 - Design"
**문제**: 스크린샷과 실제 기능 불일치

**해결:**
```
1. 실제 앱 화면으로 스크린샷 재촬영
2. 과장된 표현 제거
3. 모든 기능 실제 구현 확인
```

### 9.3 Family Controls 권한 문제

#### 권한 요청 실패
**증상**: 권한 요청 다이얼로그가 나타나지 않음

**해결:**
```swift
// AuthorizationCenter 초기화 확인
import FamilyControls

let center = AuthorizationCenter.shared

Task {
    do {
        try await center.requestAuthorization(for: .individual)
        print("✅ 권한 승인 성공")
    } catch {
        print("❌ 권한 승인 실패: \(error)")
    }
}
```

---

## 10. 추가 리소스

### 10.1 공식 문서
- [App Store Connect 가이드](https://developer.apple.com/app-store-connect/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Family Controls Documentation](https://developer.apple.com/documentation/familycontrols)

### 10.2 유용한 도구
- [App Store Screenshot Generator](https://www.appstorescreenshot.com/)
- [ASO Tool](https://appradar.com/)
- [App Review Time Tracker](https://appreviewtimes.com/)
- [TestFlight](https://testflight.apple.com/) - 베타 테스트

### 10.3 커뮤니티
- [Apple Developer Forums](https://developer.apple.com/forums/)
- [Stack Overflow - iOS](https://stackoverflow.com/questions/tagged/ios)
- [Reddit - r/iOSProgramming](https://www.reddit.com/r/iOSProgramming/)

---

## 📝 다음 단계

### 즉시 실행
1. ✅ 번들 ID 변경: `com.devjihwan.thinkfree`
2. ✅ Deployment Target 변경: 17.0
3. ✅ Info.plist 권한 설명 추가
4. ✅ 실제 기기 테스트

### 단기 (1주일 내)
1. ✅ App Store Connect 앱 등록
2. ✅ 스크린샷 5장 촬영
3. ✅ 앱 아이콘 최종 디자인
4. ✅ 개인정보 처리방침 작성

### 중기 (2주일 내)
1. ✅ Archive 및 Validation
2. ✅ App Store Connect 정보 입력
3. ✅ 제출 및 심사 대기

---

**문서 버전**: 1.0  
**최종 수정**: 2025년 11월 18일  
**작성자**: DevJihwan  
**앱**: 씽크프리 (ThinkFree)

**중요**: 이 문서는 계속 업데이트됩니다. 변경사항이 있을 때마다 문서를 갱신하세요.
