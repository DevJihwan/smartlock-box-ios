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
            // Background gradient - adapt to dark mode
            AppColors.lockScreenGradient
                .ignoresSafeArea()
            
            // Animated particles
            ForEach(0..<20) { _ in
                LockParticle(isDarkMode: colorScheme == .dark)
            }
            
            VStack(spacing: 40) {
                // Language switcher in top-right
                HStack {
                    Spacer()
                    LanguageSwitcher()
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Animated lock icon
                AnimatedLockView(
                    isLocked: .constant(true),
                    size: 150,
                    lockColor: AppColors.lock,
                    unlockColor: AppColors.unlock
                )
                .scaleEffect(pulseAnimation ? 1.05 : 1.0)
                .rotationEffect(Angle(degrees: rotationAnimation ? 10 : -10))
                
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
                
                // Remaining time until auto-unlock
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
                
                Spacer()
                
                // Unlock challenge button
                Button(action: {
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
                        
                        // Create and schedule notification
                        NotificationManager.shared.scheduleLockNotification()
                        
                        // Navigate to challenge
                        appState.startUnlockChallenge()
                    }
                }) {
                    HStack {
                        Image(systemName: "key.fill")
                            .font(.title2)
                        Text("lock_screen_challenge".localized)
                            .font(.headline)
                    }
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        AppColors.primaryGradient
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .scaleEffect(buttonScale)
                }
                .padding(.horizontal, 40)
                
                // Emergency contact button
                Button(action: {
                    // Handle emergency call
                    if let url = URL(string: "tel://112"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("lock_screen_emergency".localized)
                    }
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            startAnimations()
            updateTimeRemaining()
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                updateTimeRemaining()
            }
            
            // Schedule notification if locked
            NotificationManager.shared.scheduleLockNotification()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startAnimations() {
        // Continuous pulse animation
        withAnimation(
            Animation
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
        ) {
            pulseAnimation = true
        }
        
        // Continuous rotation animation
        withAnimation(
            Animation
                .easeInOut(duration: 3)
                .repeatForever(autoreverses: true)
        ) {
            rotationAnimation = true
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
                appState.isLocked = false
                NotificationManager.shared.scheduleUnlockNotification(isCreative: false)
                return
            }
            
            // Update display values
            self.hours = max(0, h)
            self.minutes = max(0, m)
            self.seconds = max(0, s)
            
            // Format string for accessibility
            if hours > 0 {
                timeRemaining = "\(hours)\("hours".localized) \(minutes)\("minutes".localized)"
            } else if minutes > 0 {
                timeRemaining = "\(minutes)\("minutes".localized) \(seconds)\("seconds".localized)"
            } else {
                timeRemaining = "\(seconds)\("seconds".localized)"
            }
        }
    }
    
    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)\("hours".localized) \(mins)\("minutes".localized)"
    }
}

// Time digit component with animation
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

// Time separator component
struct TimeSeparator: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Text(":")
            .font(.system(size: 32, weight: .bold))
            .foregroundColor(AppColors.secondaryText)
            .offset(y: -12)
    }
}

// Animated floating particle
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
    
    // Specify color explicitly so we can control opacity separately
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
                    // Random movement
                    position = CGPoint(
                        x: CGFloat.random(in: 50...UIScreen.main.bounds.width-50),
                        y: CGFloat.random(in: 50...UIScreen.main.bounds.height-50)
                    )
                    rotation += 180
                }
            }
    }
}

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
