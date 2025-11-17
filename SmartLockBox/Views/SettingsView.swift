//
//  SettingsView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI
import FamilyControls

struct SettingsView: View {
    @EnvironmentObject var appState: AppStateManager
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @ObservedObject private var screenTimeManager = ScreenTimeManager.shared
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @State private var showAppPicker = false
    @State private var isRequestingAuth = false
    @State private var showTimeSlotPicker = false
    @State private var showLimitTimePicker = false

    var body: some View {
        NavigationView {
            List {
                // Usage Settings Section
                Section {
                    // Control Enable Toggle
                    controlEnableRow

                    // Time Slot
                    timeSlotRow

                    // Limit Time
                    limitTimeRow
                } header: {
                    Text("사용 설정")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "999999"))
                        .textCase(nil)
                }

                // Screen Time Section
                Section {
                    // Screen Time Permission
                    screenTimePermissionRow

                    // Blocked Apps
                    blockedAppsRow
                } header: {
                    Text("앱 차단")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "999999"))
                        .textCase(nil)
                }

                // Language Section
                Section {
                    languageRow
                } header: {
                    Text("알림 및 언어")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "999999"))
                        .textCase(nil)
                }

                // Other Section
                Section {
                    versionRow
                } header: {
                    Text("기타")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "999999"))
                        .textCase(nil)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
            .familyActivityPicker(
                isPresented: $showAppPicker,
                selection: $screenTimeManager.activitySelection
            )
        }
    }

    // MARK: - Row Views

    private var controlEnableRow: some View {
        Toggle(isOn: $appState.isControlEnabled) {
            HStack(spacing: 12) {
                Image(systemName: "power.circle.fill")
                    .foregroundColor(Color(red: 0.4, green: 0.7, blue: 1.0))
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 2) {
                    Text("제어 활성화")
                        .foregroundColor(.primary)
                        .font(.system(size: 16))

                    Text(appState.isControlEnabled ? "활성화됨" : "비활성화됨")
                        .foregroundColor(Color(hex: "999999"))
                        .font(.system(size: 13))
                }
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.4, green: 0.7, blue: 1.0)))
        .onChange(of: appState.isControlEnabled) { _ in appState.saveSettings() }
    }

    private var timeSlotRow: some View {
        Button(action: {
            showTimeSlotPicker = true
        }) {
            HStack(spacing: 12) {
                Image(systemName: "clock.fill")
                    .foregroundColor(Color(red: 0.4, green: 0.7, blue: 1.0))
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 2) {
                    Text("시간대")
                        .foregroundColor(.primary)
                        .font(.system(size: 16))

                    Text(formatTimeSlot())
                        .foregroundColor(Color(hex: "999999"))
                        .font(.system(size: 13))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "CCCCCC"))
                    .font(.system(size: 14))
            }
        }
        .sheet(isPresented: $showTimeSlotPicker) {
            TimeSlotPickerView(appState: appState)
        }
    }

    private var limitTimeRow: some View {
        Button(action: {
            showLimitTimePicker = true
        }) {
            HStack(spacing: 12) {
                Image(systemName: "hourglass")
                    .foregroundColor(Color(red: 0.4, green: 0.7, blue: 1.0))
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 2) {
                    Text("일일 목표 시간")
                        .foregroundColor(.primary)
                        .font(.system(size: 16))

                    Text(formatLimitTime())
                        .foregroundColor(Color(hex: "999999"))
                        .font(.system(size: 13))
                }

                Spacer()

                Text(formatLimitTime())
                    .foregroundColor(.primary)
                    .font(.system(size: 16, weight: .medium))
            }
        }
        .sheet(isPresented: $showLimitTimePicker) {
            LimitTimePickerView(appState: appState)
        }
    }

    private var screenTimePermissionRow: some View {
        Button(action: {
            if !screenTimeManager.isAuthorized {
                isRequestingAuth = true
                Task {
                    do {
                        try await screenTimeManager.requestAuthorization()
                        isRequestingAuth = false
                    } catch {
                        print("❌ Authorization failed: \(error)")
                        isRequestingAuth = false
                    }
                }
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "hand.raised.fill")
                    .foregroundColor(Color(red: 0.4, green: 0.7, blue: 1.0))
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Screen Time 권한")
                        .foregroundColor(.primary)
                        .font(.system(size: 16))

                    Text(screenTimeManager.isAuthorized ? "승인됨" : "권한 필요")
                        .foregroundColor(screenTimeManager.isAuthorized ? .green : .orange)
                        .font(.system(size: 13))
                }

                Spacer()

                if isRequestingAuth {
                    ProgressView()
                } else if !screenTimeManager.isAuthorized {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(hex: "CCCCCC"))
                        .font(.system(size: 14))
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                }
            }
        }
        .disabled(screenTimeManager.isAuthorized || isRequestingAuth)
    }

    private var blockedAppsRow: some View {
        Button(action: {
            if screenTimeManager.isAuthorized {
                showAppPicker = true
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "app.badge")
                    .foregroundColor(Color(red: 0.4, green: 0.7, blue: 1.0))
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 2) {
                    Text("차단할 앱")
                        .foregroundColor(.primary)
                        .font(.system(size: 16))

                    Text("\(screenTimeManager.activitySelection.applicationTokens.count)개 앱 선택됨")
                        .foregroundColor(Color(hex: "999999"))
                        .font(.system(size: 13))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "CCCCCC"))
                    .font(.system(size: 14))
            }
        }
        .disabled(!screenTimeManager.isAuthorized)
        .opacity(screenTimeManager.isAuthorized ? 1.0 : 0.5)
    }

    private var languageRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "globe")
                .foregroundColor(Color(red: 0.4, green: 0.7, blue: 1.0))
                .font(.system(size: 24))

            VStack(alignment: .leading, spacing: 2) {
                Text("언어")
                    .foregroundColor(.primary)
                    .font(.system(size: 16))

                Text("앱 표시 언어")
                    .foregroundColor(Color(hex: "999999"))
                    .font(.system(size: 13))
            }

            Spacer()

            LanguageSwitcher()
        }
    }

    private var versionRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle")
                .foregroundColor(Color(red: 0.4, green: 0.7, blue: 1.0))
                .font(.system(size: 24))

            VStack(alignment: .leading, spacing: 2) {
                Text("도움말")
                    .foregroundColor(.primary)
                    .font(.system(size: 16))

                Text("v2.0.0")
                    .foregroundColor(Color(hex: "999999"))
                    .font(.system(size: 13))
            }

            Spacer()
        }
    }

    // MARK: - Helper Methods

    private func formatTimeSlot() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let start = formatter.string(from: appState.slotStartTime)
        let end = formatter.string(from: appState.slotEndTime)
        return "\(start) - \(end)"
    }

    private func formatLimitTime() -> String {
        let hours = appState.limitMinutes / 60
        let minutes = appState.limitMinutes % 60
        if minutes == 0 {
            return "\(hours)시간"
        } else {
            return "\(hours)시간 \(minutes)분"
        }
    }
}

// MARK: - Time Slot Picker View

struct TimeSlotPickerView: View {
    @ObservedObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("시작 시간", selection: $appState.slotStartTime, displayedComponents: .hourAndMinute)
                    DatePicker("종료 시간", selection: $appState.slotEndTime, displayedComponents: .hourAndMinute)
                }
            }
            .navigationTitle("시간대 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        appState.saveSettings()
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Limit Time Picker View

struct LimitTimePickerView: View {
    @ObservedObject var appState: AppStateManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("시간", selection: Binding(
                        get: { appState.limitMinutes / 60 },
                        set: { appState.limitMinutes = $0 * 60 + (appState.limitMinutes % 60) }
                    )) {
                        ForEach(0..<9) { hour in
                            Text("\(hour)시간").tag(hour)
                        }
                    }

                    Picker("분", selection: Binding(
                        get: { appState.limitMinutes % 60 },
                        set: { appState.limitMinutes = (appState.limitMinutes / 60) * 60 + $0 }
                    )) {
                        ForEach([0, 15, 30, 45], id: \.self) { minute in
                            Text("\(minute)분").tag(minute)
                        }
                    }
                } header: {
                    Text("일일 목표 시간")
                }
            }
            .navigationTitle("목표 시간 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        appState.saveSettings()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppStateManager())
    }
}
