# 다국어 설정 가이드 (Localization Setup Guide)

## 📋 개요
SmartLockBox 앱에 한국어(KR)와 영어(EN) 다국어 지원을 추가하는 가이드입니다.

## 🔧 Xcode에서 Localizable.strings 파일 생성

### 1단계: 한국어 Localizable.strings 생성

1. **Xcode에서 SmartLockBox 프로젝트 열기**

2. **새 파일 생성**:
   - 메뉴: `File` → `New` → `File...`
   - `Strings File` 선택
   - 이름: `Localizable.strings`
   - 위치: `SmartLockBox/Resources/` 디렉토리 (없으면 생성)

3. **파일 저장 후, File Inspector 열기** (⌘ + ⌥ + 1):
   - 우측 패널의 `Localize...` 버튼 클릭
   - `Korean` 선택 후 `Localize` 클릭

4. **English 추가**:
   - File Inspector에서 `Localization` 섹션
   - `English` 체크박스 선택

5. **최종 구조**:
   ```
   SmartLockBox/
   ├── Resources/
   │   ├── ko.lproj/
   │   │   └── Localizable.strings
   │   └── en.lproj/
   │       └── Localizable.strings
   ```

### 2단계: 번역 내용 입력

#### `ko.lproj/Localizable.strings` (한국어)

```strings
/* 앱 공통 */
"app_name" = "바보상자자물쇠";
"ok" = "확인";
"cancel" = "취소";
"confirm" = "확인";
"delete" = "삭제";
"save" = "저장";
"close" = "닫기";
"settings" = "설정";

/* 메인 화면 */
"today_goal" = "오늘의 목표";
"usage_minutes" = "%d분 사용";
"remaining_minutes" = "%d분 남음";
"goal_exceeded" = "목표 %d분 초과";
"status_locked" = "잠김";
"status_unlocked" = "잠금 해제";
"tap_to_unlock" = "탭하여 해제";
"auto_locks" = "%d%% 사용 시 자동 잠금";
"time_until_lock" = "잠금까지 남은 시간";
"expected_lock_time" = "%@ 잠금 예정";
"weekly_stats" = "주간 사용 현황";
"monthly_heatmap" = "월간 달성 현황";

/* 시간 단위 */
"hours" = "시간";
"minutes" = "분";
"seconds" = "초";
"hours_short" = "시";
"minutes_short" = "분";
"seconds_short" = "초";

/* 잠금 화면 */
"lock_screen_title" = "스마트폰이 잠겨있습니다";
"lock_screen_usage" = "오늘 %@분 사용 완료";
"lock_screen_remaining" = "자동 해제까지 남은 시간";
"lock_screen_challenge" = "창의력으로 해제하기";
"lock_screen_emergency" = "응급상황 연락";
"lock_screen_calculating" = "계산 중...";

/* 해제 챌린지 */
"unlock_challenge" = "창의적 해제 도전";
"challenge_description" = "제시단어 2개를 포함한 창의적인\n문장을 만들어 자물쇠를 풀어보세요!";
"enter_sentence" = "여기에 문장을 입력하세요...";
"minimum_characters" = "최소 10글자 이상 (현재: %d글자)";
"change_words" = "다른 단어로 변경";
"submit" = "제출하기";
"evaluating" = "AI가 평가 중입니다";
"unlock_success" = "해제 성공!";
"unlock_failed" = "해제 실패";
"both_ai_required" = "두 AI 모두 통과해야 해제됩니다";
"try_again" = "다시 도전하기";
"back_to_lock_screen" = "잠금 화면으로";

/* 설정 */
"settings_title" = "설정";
"settings_goal_header" = "목표 설정";
"settings_daily_goal" = "일일 목표: %d시간";
"settings_goal_slider" = "목표 시간 슬라이더";
"settings_goal_explanation" = "%d시간 사용 후 자동으로 잠깁니다";
"settings_unlock_header" = "잠금 해제 설정";
"settings_auto_unlock_time" = "자동 해제 시간";
"settings_auto_unlock_explanation" = "매일 설정한 시간에 자동으로 잠금이 해제됩니다";
"settings_challenge_header" = "창의적 해제 설정";
"settings_enable_creative" = "창의적 해제 활성화";
"settings_daily_attempts" = "일일 시도 횟수";
"settings_word_refresh" = "단어 변경 횟수";
"settings_language_header" = "언어 설정";
"settings_app_info_header" = "앱 정보";
"settings_version" = "버전";
"settings_screen_time_permission" = "Screen Time 권한 요청";
"settings_reset_data" = "모든 데이터 초기화";
"settings_reset_confirm_title" = "데이터 초기화";
"settings_reset_confirm_message" = "모든 사용 기록과 설정이 삭제됩니다. 계속하시겠습니까?";
"settings_reset_confirm_button" = "초기화";
"settings_reset_cancel_button" = "취소";

/* 알림 */
"notification_permission_title" = "알림 권한 필요";
"notification_permission_required" = "잠금 알림을 받으려면 알림 권한이 필요합니다.";
"notification_request" = "권한 요청";

/* 요일 */
"monday" = "월";
"tuesday" = "화";
"wednesday" = "수";
"thursday" = "목";
"friday" = "금";
"saturday" = "토";
"sunday" = "일";

/* 에러 메시지 */
"error" = "오류";
"network_error" = "네트워크 오류";
"api_error" = "API 오류";
"permission_denied" = "권한 거부됨";
"unknown_error" = "알 수 없는 오류";
```

#### `en.lproj/Localizable.strings` (영어)

```strings
/* App Common */
"app_name" = "SmartLock Box";
"ok" = "OK";
"cancel" = "Cancel";
"confirm" = "Confirm";
"delete" = "Delete";
"save" = "Save";
"close" = "Close";
"settings" = "Settings";

/* Main Screen */
"today_goal" = "Today's Goal";
"usage_minutes" = "%d min used";
"remaining_minutes" = "%d min left";
"goal_exceeded" = "%d min over goal";
"status_locked" = "Locked";
"status_unlocked" = "Unlocked";
"tap_to_unlock" = "Tap to unlock";
"auto_locks" = "Auto-locks at %d%%";
"time_until_lock" = "Time Until Lock";
"expected_lock_time" = "Locks at %@";
"weekly_stats" = "Weekly Usage";
"monthly_heatmap" = "Monthly Achievement";

/* Time Units */
"hours" = "hours";
"minutes" = "minutes";
"seconds" = "seconds";
"hours_short" = "h";
"minutes_short" = "m";
"seconds_short" = "s";

/* Lock Screen */
"lock_screen_title" = "Phone is Locked";
"lock_screen_usage" = "Used %@ min today";
"lock_screen_remaining" = "Time Until Auto-Unlock";
"lock_screen_challenge" = "Unlock with Creativity";
"lock_screen_emergency" = "Emergency Call";
"lock_screen_calculating" = "Calculating...";

/* Unlock Challenge */
"unlock_challenge" = "Creative Unlock Challenge";
"challenge_description" = "Create a creative sentence using\nboth given words to unlock!";
"enter_sentence" = "Enter your sentence here...";
"minimum_characters" = "Min 10 characters (current: %d)";
"change_words" = "Change Words";
"submit" = "Submit";
"evaluating" = "AI is Evaluating";
"unlock_success" = "Unlock Successful!";
"unlock_failed" = "Unlock Failed";
"both_ai_required" = "Both AIs must approve to unlock";
"try_again" = "Try Again";
"back_to_lock_screen" = "Back to Lock Screen";

/* Settings */
"settings_title" = "Settings";
"settings_goal_header" = "Goal Settings";
"settings_daily_goal" = "Daily Goal: %d hours";
"settings_goal_slider" = "Goal Time Slider";
"settings_goal_explanation" = "Automatically locks after %d hours of use";
"settings_unlock_header" = "Unlock Settings";
"settings_auto_unlock_time" = "Auto-Unlock Time";
"settings_auto_unlock_explanation" = "Automatically unlocks every day at the set time";
"settings_challenge_header" = "Creative Unlock Settings";
"settings_enable_creative" = "Enable Creative Unlock";
"settings_daily_attempts" = "Daily Attempts";
"settings_word_refresh" = "Word Refresh Count";
"settings_language_header" = "Language";
"settings_app_info_header" = "App Info";
"settings_version" = "Version";
"settings_screen_time_permission" = "Request Screen Time Permission";
"settings_reset_data" = "Reset All Data";
"settings_reset_confirm_title" = "Reset Data";
"settings_reset_confirm_message" = "All usage history and settings will be deleted. Continue?";
"settings_reset_confirm_button" = "Reset";
"settings_reset_cancel_button" = "Cancel";

/* Notifications */
"notification_permission_title" = "Notification Permission Required";
"notification_permission_required" = "Notification permission is required to receive lock alerts.";
"notification_request" = "Request Permission";

/* Days of Week */
"monday" = "Mon";
"tuesday" = "Tue";
"wednesday" = "Wed";
"thursday" = "Thu";
"friday" = "Fri";
"saturday" = "Sat";
"sunday" = "Sun";

/* Error Messages */
"error" = "Error";
"network_error" = "Network Error";
"api_error" = "API Error";
"permission_denied" = "Permission Denied";
"unknown_error" = "Unknown Error";
```

### 3단계: 프로젝트 설정 확인

1. **Project Settings** (⌘ + 1):
   - 프로젝트 선택
   - `Info` 탭
   - `Localizations` 섹션에서 `Korean`과 `English`가 모두 체크되어 있는지 확인

2. **Base Language 설정**:
   - Development Language: `Korean` (기본값)

## 📝 사용 예시

### 코드에서 사용

```swift
// 기본 사용
Text("app_name".localized)

// 파라미터 포함
Text("usage_minutes".localized(with: 30))  // "30분 사용" or "30 min used"

// 복수형 (선택사항)
Text("hours".localizedPlural(count: 1))  // "1 hour" vs "2 hours"
```

### 언어 전환 버튼 추가

```swift
// 메인 화면 우측 상단
HStack {
    Spacer()
    LanguageSwitcher()
}

// 설정 화면
Section(header: Text("settings_language_header".localized)) {
    LanguagePickerView()
}
```

## ✅ 검증 체크리스트

- [ ] `ko.lproj/Localizable.strings` 파일 생성 완료
- [ ] `en.lproj/Localizable.strings` 파일 생성 완료
- [ ] 모든 번역 키 입력 완료
- [ ] 프로젝트 설정에서 Korean/English 확인
- [ ] 빌드 성공 확인
- [ ] 언어 전환 버튼 작동 확인
- [ ] 모든 화면에서 언어 전환 테스트

## 🚀 다음 단계

1. **git pull**로 최신 코드 가져오기
2. 위 가이드대로 `Localizable.strings` 파일 생성
3. 빌드 및 테스트
4. 누락된 번역 키 추가

---

**작성일**: 2025년 11월 1일  
**작성자**: DevJihwan
