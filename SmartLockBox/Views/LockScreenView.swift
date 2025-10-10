//
//  LockScreenView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

struct LockScreenView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var timeRemaining: String = ""
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            // 배경 그라데이션
            LinearGradient(
                gradient: Gradient(colors: [Color.red.opacity(0.3), Color.orange.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // 자물쇠 아이콘
                Image(systemName: "lock.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.red)
                    .shadow(color: .red.opacity(0.5), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 16) {
                    Text("스마트폰이 잠겨있습니다")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("오늘 \(formatTime(appState.todayUsageMinutes)) 사용 완료")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                // 해제까지 남은 시간
                VStack(spacing: 8) {
                    Text(timeRemaining)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.red)
                    
                    Text("후 자동 해제")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .shadow(radius: 5)
                
                Spacer()
                
                // 열쇠 버튼
                Button(action: {
                    appState.startUnlockChallenge()
                }) {
                    HStack {
                        Image(systemName: "key.fill")
                            .font(.title2)
                        Text("창의력으로 해제하기")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .padding(.horizontal, 40)
                
                // 응급 통화 버튼
                Button(action: {
                    // 응급 통화 화면으로 이동
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("응급상황 연락")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            updateTimeRemaining()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                updateTimeRemaining()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func updateTimeRemaining() {
        guard let unlockTime = appState.unlockTime else {
            timeRemaining = "계산 중..."
            return
        }
        
        let now = Date()
        let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: now, to: unlockTime)
        
        if let hours = difference.hour, let minutes = difference.minute, let seconds = difference.second {
            if hours > 0 {
                timeRemaining = "\(hours)시간 \(minutes)분"
            } else if minutes > 0 {
                timeRemaining = "\(minutes)분 \(seconds)초"
            } else {
                timeRemaining = "\(seconds)초"
            }
        }
    }
    
    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)시간 \(mins)분"
    }
}

struct LockScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenView()
            .environmentObject(AppStateManager())
    }
}
