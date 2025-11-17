//
//  LockScreenView_New.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-16.
//  New design from Figma lockpage(new)
//

import SwiftUI

struct LockScreenView_New: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var currentTime: String = ""
    @State private var currentDate: String = ""
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            // Background - blue gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.45, green: 0.75, blue: 0.95),
                    Color(red: 0.35, green: 0.65, blue: 0.85)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 8)

                // Time
                timeSection

                Spacer().frame(height: 16)

                // Date
                dateSection

                Spacer().frame(height: 80)

                // Lock icon
                lockIconSection

                Spacer().frame(height: 32)

                // ThinkFree title
                titleSection

                Spacer().frame(height: 48)

                // Usage info card
                usageInfoCard

                Spacer().frame(height: 40)

                // Description
                descriptionSection

                Spacer().frame(height: 32)

                // Unlock button
                unlockChallengeButton

                Spacer().frame(height: 16)

                // Emergency notice
                emergencyNotice

                Spacer().frame(height: 32)
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            updateCurrentTime()
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    // MARK: - Time

    private var timeSection: some View {
        Text(currentTime)
            .font(.system(size: 72, weight: .regular))
            .foregroundColor(.white)
    }

    // MARK: - Date

    private var dateSection: some View {
        Text(currentDate)
            .font(.system(size: 16))
            .foregroundColor(.white)
    }

    // MARK: - Lock Icon

    private var lockIconSection: some View {
        ZStack {
            // Outer glow circle
            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 100, height: 100)

            // Inner circle
            Circle()
                .fill(Color.white.opacity(0.25))
                .frame(width: 70, height: 70)

            // Lock icon
            Image(systemName: "lock.fill")
                .font(.system(size: 35))
                .foregroundColor(.white)
        }
    }

    // MARK: - Title

    private var titleSection: some View {
        Text("ThinkFree")
            .font(.system(size: 42, weight: .regular))
            .foregroundColor(.white)
    }

    // MARK: - Usage Info Card

    private var usageInfoCard: some View {
        VStack(spacing: 8) {
            Text("오늘의 사용 시간을 초과했습니다")
                .font(.system(size: 16))
                .foregroundColor(.white)

            Text(formatUsageTime())
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(.white)

            Text(formatUsagePercentage())
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 32)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.15))
        )
    }

    // MARK: - Description

    private var descriptionSection: some View {
        VStack(spacing: 4) {
            Text("창의적인 생각으로 잠금을 해제하세요")
                .font(.system(size: 16))
                .foregroundColor(.white)

            Text("AI가 평가하는 문장 만들기 챌린지")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
        }
    }

    // MARK: - Unlock Button

    private var unlockChallengeButton: some View {
        Button(action: handleUnlockButtonTap) {
            Text("창의력 챌린지 시작하기 🧠")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.2))
                )
        }
    }

    // MARK: - Emergency Notice

    private var emergencyNotice: some View {
        Text("긴급 전화 및 문자는 항상 사용 가능합니다")
            .font(.system(size: 12))
            .foregroundColor(.white.opacity(0.8))
    }

    // MARK: - Timer Methods

    private func startTimer() {
        // Update every second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateCurrentTime()
        }
    }

    private func updateCurrentTime() {
        let now = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        currentTime = timeFormatter.string(from: now)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일 EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        currentDate = dateFormatter.string(from: now)

        // Check if should auto-unlock
        if let unlockTime = appState.unlockTime, unlockTime <= now {
            appState.disableLock()
        }
    }

    // MARK: - Helper Methods

    private func formatUsageTime() -> String {
        let usedHours = appState.todayUsageMinutes / 60
        let usedMinutes = appState.todayUsageMinutes % 60
        let limitHours = appState.limitMinutes / 60
        let limitMinutes = appState.limitMinutes % 60

        return "\(usedHours)h \(usedMinutes)m / \(limitHours)h \(limitMinutes)m"
    }

    private func formatUsagePercentage() -> String {
        let percentage = appState.usagePercentage
        return "목표 시간 \(percentage)% 사용"
    }

    // MARK: - Action Methods

    private func handleUnlockButtonTap() {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()

        appState.startUnlockChallenge()
    }
}

// MARK: - Previews

struct LockScreenView_New_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenView_New()
            .environmentObject(AppStateManager())
    }
}
