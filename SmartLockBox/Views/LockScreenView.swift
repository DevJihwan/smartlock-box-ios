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
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.red.opacity(0.2), Color.orange.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated particles
            ForEach(0..<20) { _ in
                LockParticle()
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
                    lockColor: .red,
                    unlockColor: .green
                )
                .scaleEffect(pulseAnimation ? 1.05 : 1.0)
                .rotationEffect(Angle(degrees: rotationAnimation ? 10 : -10))
                
                VStack(spacing: 16) {
                    Text("lock_screen_title".localized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("lock_screen_usage".localized(with: formatTime(appState.todayUsageMinutes)))
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Remaining time until auto-unlock
                VStack(spacing: 24) {
                    Text("lock_screen_remaining".localized)
                        .font(.headline)
                    
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
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
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
                    .foregroundColor(.secondary)
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
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .frame(width: 60, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                )
                .foregroundColor(.primary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// Time separator component
struct TimeSeparator: View {
    var body: some View {
        Text(":")
            .font(.system(size: 32, weight: .bold))
            .foregroundColor(Color(.systemGray))
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
    
    var body: some View {
        Image(systemName: "lock.fill")
            .font(.system(size: 20))
            .foregroundColor(.red)
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
        LockScreenView()
            .environmentObject(AppStateManager())
    }
}
