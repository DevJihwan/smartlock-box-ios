//
//  SettingsView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var dailyGoalHours: Double = 3
    @State private var autoUnlockTime: Date = Calendar.current.date(from: DateComponents(hour: 0, minute: 0))!
    
    var body: some View {
        Form {
            Section(header: Text("목표 설정")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("일일 목표 시간: \(Int(dailyGoalHours))시간")
                        .font(.headline)
                    
                    Slider(value: $dailyGoalHours, in: 1...8, step: 0.5) {
                        Text("목표 시간")
                    }
                    .onChange(of: dailyGoalHours) { newValue in
                        appState.dailyGoalMinutes = Int(newValue * 60)
                    }
                    
                    Text("하루 \(Int(dailyGoalHours))시간 사용 후 자동 잠금됩니다")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("자동 해제 시간")) {
                DatePicker("해제 시간", selection: $autoUnlockTime, displayedComponents: .hourAndMinute)
                
                Text("매일 설정한 시간에 자동으로 해제됩니다")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("창의적 해제 설정")) {
                Toggle("창의적 해제 활성화", isOn: .constant(true))
                
                HStack {
                    Text("일일 도전 횟수")
                    Spacer()
                    Text("10회")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("단어 변경 횟수")
                    Spacer()
                    Text("3회")
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("알림 설정")) {
                Toggle("목표 근접 알림 (10분 전)", isOn: .constant(true))
                Toggle("일일 리포트 알림", isOn: .constant(true))
            }
            
            Section(header: Text("앱 정보")) {
                HStack {
                    Text("버전")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                Button("Screen Time 권한 설정") {
                    // TODO: Screen Time 권한 요청
                }
                
                Button("데이터 초기화") {
                    // TODO: 데이터 초기화 확인
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("설정")
        .onAppear {
            dailyGoalHours = Double(appState.dailyGoalMinutes) / 60.0
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .environmentObject(AppStateManager())
        }
    }
}
