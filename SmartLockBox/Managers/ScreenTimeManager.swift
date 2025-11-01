//
//  ScreenTimeManager.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

/// Screen Time API를 사용하여 앱 사용 시간을 모니터링하고 제어하는 매니저
class ScreenTimeManager: ObservableObject {
    static let shared = ScreenTimeManager()
    
    private let center = AuthorizationCenter.shared
    private let store = ManagedSettingsStore()
    
    // 사용 시간 관련
    @Published var isLocked: Bool = false
    @Published var todayUsageMinutes: Int = 0
    @Published var goalMinutes: Int = 180 // 기본 3시간
    
    // FamilyActivitySelection - 사용자가 선택한 앱과 도메인
    @Published var activitySelection = FamilyActivitySelection()
    
    // DeviceActivity 관련
    private let deviceActivityCenter = DeviceActivityCenter()
    private let monitorName = DeviceActivityName("smartLockBoxMonitor")
    
    // UserDefaults keys
    private let isLockedKey = "isLockedState"
    private let goalMinutesKey = "goalMinutes"
    private let lockStartTimeKey = "lockStartTime"
    
    // 잠금 시작 시간
    private var lockStartTime: Date? {
        get {
            UserDefaults.standard.object(forKey: lockStartTimeKey) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lockStartTimeKey)
        }
    }
    
    private init() {
        loadSettings()
    }
    
    // MARK: - Settings
    
    private func loadSettings() {
        isLocked = UserDefaults.standard.bool(forKey: isLockedKey)
        goalMinutes = UserDefaults.standard.integer(forKey: goalMinutesKey)
        if goalMinutes == 0 {
            goalMinutes = 180 // 기본값
        }
    }
    
    func setGoalMinutes(_ minutes: Int) {
        goalMinutes = minutes
        UserDefaults.standard.set(minutes, forKey: goalMinutesKey)
        
        // 모니터링 재시작
        if authorizationStatus == .approved {
            startMonitoring(goalMinutes: minutes)
        }
    }
    
    // MARK: - Authorization
    
    /// Screen Time 권한 요청
    @MainActor
    func requestAuthorization() async throws {
        try await center.requestAuthorization(for: .individual)
        print("✅ Screen Time 권한 승인됨")
    }
    
    /// 권한 상태 확인
    var authorizationStatus: AuthorizationStatus {
        return center.authorizationStatus
    }
    
    var isAuthorized: Bool {
        return authorizationStatus == .approved
    }
    
    // MARK: - App Blocking
    
    /// 앱 차단 활성화 (잠금)
    func enableAppBlocking() {
        guard isAuthorized else {
            print("⚠️ Screen Time 권한이 필요합니다")
            return
        }
        
        // 사용자가 선택한 앱과 도메인 차단
        if !activitySelection.applicationTokens.isEmpty {
            store.shield.applications = activitySelection.applicationTokens
        }
        
        if !activitySelection.webDomainTokens.isEmpty {
            store.shield.webDomains = activitySelection.webDomainTokens
        }
        
        if !activitySelection.categoryTokens.isEmpty {
            store.shield.applicationCategories = .specific(activitySelection.categoryTokens)
            store.shield.webDomainCategories = .specific(activitySelection.categoryTokens)
        }
        
        // 앱 제거 방지
        store.application.denyAppRemoval = true
        
        isLocked = true
        lockStartTime = Date()
        UserDefaults.standard.set(true, forKey: isLockedKey)
        
        print("🔒 앱 차단 활성화")
        print("차단된 앱: \(activitySelection.applicationTokens.count)개")
        print("차단된 도메인: \(activitySelection.webDomainTokens.count)개")
        
        // 자동 해제 타이머 설정
        scheduleAutoUnlock()
    }
    
    /// 앱 차단 해제 (잠금 해제)
    func disableAppBlocking() {
        store.clearAllSettings()
        
        isLocked = false
        lockStartTime = nil
        UserDefaults.standard.set(false, forKey: isLockedKey)
        
        // 자동 해제 타이머 취소
        cancelAutoUnlock()
        
        print("🔓 앱 차단 해제")
    }
    
    /// FamilyActivitySelection 업데이트
    func updateActivitySelection(_ selection: FamilyActivitySelection) {
        self.activitySelection = selection
        
        // 현재 잠금 상태라면 즉시 적용
        if isLocked {
            enableAppBlocking()
        }
        
        print("✅ 차단 대상 업데이트됨")
        print("앱: \(selection.applicationTokens.count)개")
        print("도메인: \(selection.webDomainTokens.count)개")
        print("카테고리: \(selection.categoryTokens.count)개")
    }
    
    // MARK: - Usage Monitoring
    
    /// 사용 시간 모니터링 시작
    func startMonitoring(goalMinutes: Int) {
        guard isAuthorized else {
            print("⚠️ Screen Time 권한이 필요합니다")
            return
        }
        
        self.goalMinutes = goalMinutes
        
        // DeviceActivity 스케줄 설정
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )
        
        do {
            try deviceActivityCenter.startMonitoring(monitorName, during: schedule)
            print("✅ 사용 시간 모니터링 시작 (목표: \(goalMinutes)분)")
        } catch {
            print("❌ 모니터링 시작 실패: \(error.localizedDescription)")
        }
    }
    
    /// 사용 시간 모니터링 중지
    func stopMonitoring() {
        deviceActivityCenter.stopMonitoring([monitorName])
        print("⏹️ 사용 시간 모니터링 중지")
    }
    
    /// 현재 사용 시간 가져오기 (분 단위)
    /// 주의: 실제 DeviceActivity API는 비동기이며 Extension에서 처리됨
    func getCurrentUsageMinutes() async -> Int {
        // TODO: DeviceActivity Extension에서 실제 사용 시간 데이터를 가져오는 로직
        // 현재는 UserDefaults를 통해 Extension과 통신
        let usage = UserDefaults.standard.integer(forKey: "todayUsageMinutes")
        await MainActor.run {
            self.todayUsageMinutes = usage
        }
        return usage
    }
    
    /// 목표 시간 초과 여부
    var isGoalExceeded: Bool {
        return todayUsageMinutes >= goalMinutes
    }
    
    /// 남은 사용 시간 (분)
    var remainingMinutes: Int {
        return max(0, goalMinutes - todayUsageMinutes)
    }
    
    /// 남은 사용 시간 (초)
    var remainingSeconds: Int {
        return remainingMinutes * 60
    }
    
    // MARK: - Auto Unlock
    
    /// 자동 해제 타이머 설정
    private func scheduleAutoUnlock() {
        // 다음날 0시 또는 사용자 설정 시간에 자동 해제
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.day! += 1  // 다음날
        components.hour = 0
        components.minute = 0
        
        if let unlockTime = calendar.date(from: components) {
            let timeInterval = unlockTime.timeIntervalSinceNow
            
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
                self?.disableAppBlocking()
                print("🔓 자동 해제 (다음날 0시)")
            }
        }
    }
    
    /// 자동 해제 타이머 취소
    private func cancelAutoUnlock() {
        // Timer 취소 로직
        // 실제로는 타이머를 인스턴스 변수로 저장해야 함
    }
    
    /// 해제까지 남은 시간
    func timeUntilUnlock() -> TimeInterval? {
        guard let lockTime = lockStartTime else { return nil }
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: lockTime)
        components.day! += 1  // 다음날
        components.hour = 0
        components.minute = 0
        
        if let unlockTime = calendar.date(from: components) {
            return unlockTime.timeIntervalSinceNow
        }
        return nil
    }
    
    // MARK: - Helpers
    
    /// 목표 시간 도달 시 호출 (Extension에서 호출)
    func onGoalReached() {
        DispatchQueue.main.async {
            self.enableAppBlocking()
        }
    }
    
    /// 앱 차단 상태 체크
    func checkLockState() async {
        // 잠금 상태이고 해제 시간이 지났으면 자동 해제
        if isLocked, let timeRemaining = timeUntilUnlock(), timeRemaining <= 0 {
            await MainActor.run {
                disableAppBlocking()
            }
        }
    }
}

// MARK: - 주의사항 및 설정 가이드
/*
 Screen Time API 사용을 위한 필수 설정:
 
 1. **Capabilities 추가** (Xcode 프로젝트 설정):
    - Signing & Capabilities 탭으로 이동
    - "+ Capability" 클릭
    - "Family Controls" 추가
 
 2. **Info.plist 권한 추가**:
    - NSUserTrackingUsageDescription: "앱 사용 시간을 추적하여 목표 관리를 돕습니다"
    - (이미 추가되어 있음)
 
 3. **DeviceActivity Extension 생성** (필수):
    - File > New > Target > Device Activity Monitor Extension
    - 이 Extension에서 실제 사용 시간 데이터를 처리
    - Extension과 Main App 간 데이터 공유는 App Group 사용
 
 4. **App Group 설정**:
    - 두 타겟(Main App, Extension) 모두에 동일한 App Group 추가
    - 예: "group.com.devjihwan.smartlockbox"
 
 5. **FamilyActivityPicker 사용**:
    - 사용자가 차단할 앱을 직접 선택하도록 FamilyActivityPicker 사용
    - 선택된 앱을 FamilyActivitySelection으로 저장
    - ManagedSettingsStore를 통해 차단 적용
 
 6. **실제 기기 테스트**:
    - Screen Time API는 시뮬레이터에서 제한적으로만 동작
    - 실제 iOS 기기에서 테스트 필요
 
 7. **앱스토어 제출 시**:
    - Screen Time API 사용 목적 명확히 설명
    - Privacy Policy 철저히 작성
    - 데이터는 기기 내부에만 저장됨을 명시
 
 참고 문서:
 - https://developer.apple.com/documentation/familycontrols
 - https://developer.apple.com/documentation/deviceactivity
 - https://developer.apple.com/documentation/managedsettings
 
 주요 변경사항 (이 버전):
 
 1. **FamilyActivitySelection 추가**:
    - 사용자가 FamilyActivityPicker를 통해 선택한 앱/도메인을 저장
    - updateActivitySelection() 메서드로 선택 항목 업데이트
 
 2. **더 이상 .all() 사용 안 함**:
    - iOS 16+ 에서는 .all() API가 deprecated 되었거나 제거됨
    - 대신 FamilyActivitySelection의 토큰을 직접 사용
 
 3. **카테고리 차단 지원**:
    - .specific() 을 사용하여 카테고리 단위 차단 가능
 
 실제 프로덕션 앱에서 구현해야 할 사항:
 
 1. FamilyActivityPicker를 사용한 UI 구현
 2. FamilyActivitySelection 영구 저장 (UserDefaults/CoreData)
 3. DeviceActivityMonitor Extension 구현
 4. App Group을 통한 데이터 동기화
 5. ShieldConfiguration을 통한 차단 화면 커스터마이징
 6. 사용 통계 추적 및 표시
*/
