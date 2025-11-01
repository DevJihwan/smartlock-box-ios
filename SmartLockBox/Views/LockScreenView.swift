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
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    @State private var timer: Timer?
    
    // Animation states
    @State private var pulseAnimation = false
    @State private var rotationAnimation = false
    @State private var buttonScale: CGFloat = 1.0
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            backgroundView
            particlesView
            mainContent
        }
        .onAppear {
            startAnimations()
            updateTimeRemaining()
            startTimer()
            scheduleNotification()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    // MARK: - Background
    
    private var backgroundView: some View {
        AppColors.lockScreenGradient
            .ignoresSafeArea()
    }
    
    // MARK: - Animated Particles
    
    private var particlesView: some View {
        ForEach(0..<20, id: \.self) { _ in
            LockParticle(isDarkMode: colorScheme == .dark)
        }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        VStack(spacing: 40) {
            headerView
            Spacer()
            lockIconView
            titleSection
            timeRemainingCard
            Spacer()
            unlockChallengeButton
            emergencyButton
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        HStack {
            Spacer()
            LanguageSwitcher()
        }
        .padding(.horizontal)
    }
    
    // MARK: - Lock Icon
    
    private var lockIconView: some View {
        AnimatedLockView(
            isLocked: .constant(true),
            size: 150,
            lockColor: AppColors.lock,
            unlockColor: AppColors.unlock
        )
        .scaleEffect(pulseAnimation ? 1.05 : 1.0)
        .rotationEffect(Angle(degrees: rotationAnimation ? 10 : -10))
    }
    
    // MARK: - Title Section
    
    private var titleSection: some View {
        VStack(spacing: 16) {
            Text("lock_screen_title".localized)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(AppColors.text)
            
            Text("lock_screen_usage".localized(with: formatTime(appState.todayUsageMinutes)))
                .font(.title3)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding()
    }
    
    // MARK: - Time Remaining Card
    
    private var timeRemainingCard: some View {
        VStack(spacing: 24) {
            Text("lock_screen_remaining".localized)
                .font(.headline)
                .foregroundColor(AppColors.text)
            
            HStack(spacing: 5) {
                TimeDigitView(value: hours, label: "hours".localized)
                TimeSeparator()
                TimeDigitView(value: minutes, label: "minutes".localized)
                TimeSeparator()
                TimeDigitView(value: seconds, label: "seconds".localized)
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .adaptiveShadow()
        )
    }
    
    // MARK: - Unlock Challenge Button
    
    private var unlockChallengeButton: some View {
        Button(action: handleUnlockButtonTap) {
            HStack {
                Image(systemName: "key.fill")
                    .font(.title2)
                Text("lock_screen_challenge".localized)
                    .font(.headline)
            }
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.primaryGradient)
            .cornerRadius(15)
            .shadow(radius: 5)
            .scaleEffect(buttonScale)
        }
        .padding(.horizontal, 40)
    }
    
    // MARK: - Emergency Button
    
    private var emergencyButton: some View {
        Button(action: handleEmergencyCall) {
            HStack {
                Image(systemName: "phone.fill")
                Text("lock_screen_emergency".localized)
            }
            .font(.subheadline)
            .foregroundColor(AppColors.secondaryText)
        }
        .padding(.bottom, 40)
    }
    
    // MARK: - Animation Methods
    
    private func startAnimations() {
        withAnimation(
            Animation
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
        ) {
            pulseAnimation = true
        }
        
        withAnimation(
            Animation
                .easeInOut(duration: 3)
                .repeatForever(autoreverses: true)
        ) {
            rotationAnimation = true
        }
    }
    
    // MARK: - Timer Methods
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateTimeRemaining()
        }
    }
    
    private func updateTimeRemaining() {
        guard let unlockTime = appState.unlockTime else {
            timeRemaining = "lock_screen_calculating".localized
            return
        }
        
        let now = Date()
        let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: now, to: unlockTime)
        
        if let h = difference.hour, let m = difference.minute, let s = difference.second {
            // If time is passed, unlock
            if h <= 0 && m <= 0 && s <= 0 {
                unlockApp()
                return
            }
            
            // Update display values
            self.hours = max(0, h)
            self.minutes = max(0, m)
            self.seconds = max(0, s)
            
            // Format string for accessibility
            updateTimeRemainingString(hours: self.hours, minutes: self.minutes, seconds: self.seconds)
        }
    }
    
    private func updateTimeRemainingString(hours: Int, minutes: Int, seconds: Int) {
        if hours > 0 {
            timeRemaining = "\(hours)\("hours".localized) \(minutes)\("minutes".localized)"
        } else if minutes > 0 {
            timeRemaining = "\(minutes)\("minutes".localized) \(seconds)\("seconds".localized)"
        } else {
            timeRemaining = "\(seconds)\("seconds".localized)"
        }
    }
    
    // MARK: - Action Methods
    
    private func handleUnlockButtonTap() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            buttonScale = 0.95
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // After animation, start challenge
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                buttonScale = 1.0
            }
            
            NotificationManager.shared.scheduleLockNotification()
            appState.startUnlockChallenge()
        }
    }
    
    private func handleEmergencyCall() {
        if let url = URL(string: "tel://112"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func unlockApp() {
        appState.disableLock()
        NotificationManager.shared.scheduleUnlockNotification(isCreative: false)
    }
    
    private func scheduleNotification() {
        NotificationManager.shared.scheduleLockNotification()
    }
    
    // MARK: - Helper Methods
    
    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)\("hours".localized) \(mins)\("minutes".localized)"
    }
}

// MARK: - Time Digit View

struct TimeDigitView: View {
    let value: Int
    let label: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .frame(width: 60, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.secondaryBackground)
                )
                .foregroundColor(AppColors.text)
            
            Text(label)
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
        }
    }
}

// MARK: - Time Separator

struct TimeSeparator: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Text(":")
            .font(.system(size: 32, weight: .bold))
            .foregroundColor(AppColors.secondaryText)
            .offset(y: -12)
    }
}

// MARK: - Lock Particle

struct LockParticle: View {
    @State private var position = CGPoint(
        x: CGFloat.random(in: 50...UIScreen.main.bounds.width-50),
        y: CGFloat.random(in: 50...UIScreen.main.bounds.height-50)
    )
    @State private var scale: CGFloat = CGFloat.random(in: 0.2...0.5)
    @State private var opacity: Double = Double.random(in: 0.1...0.3)
    @State private var rotation: Double = Double.random(in: 0...360)
    @State private var speed: TimeInterval = TimeInterval.random(in: 5...10)
    
    let isDarkMode: Bool
    
    var color: Color {
        isDarkMode ? Color.red.opacity(0.7) : Color.red.opacity(0.5)
    }
    
    init(isDarkMode: Bool = false) {
        self.isDarkMode = isDarkMode
    }
    
    var body: some View {
        Image(systemName: "lock.fill")
            .font(.system(size: 20))
            .foregroundColor(color)
            .opacity(opacity)
            .scaleEffect(scale)
            .rotationEffect(Angle(degrees: rotation))
            .position(position)
            .onAppear {
                withAnimation(Animation.linear(duration: speed).repeatForever()) {
                    position = CGPoint(
                        x: CGFloat.random(in: 50...UIScreen.main.bounds.width-50),
                        y: CGFloat.random(in: 50...UIScreen.main.bounds.height-50)
                    )
                    rotation += 180
                }
            }
    }
}

// MARK: - Previews

struct LockScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LockScreenView()
                .environmentObject(AppStateManager())
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
            
            LockScreenView()
                .environmentObject(AppStateManager())
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
