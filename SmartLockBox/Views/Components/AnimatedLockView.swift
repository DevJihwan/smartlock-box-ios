//
//  AnimatedLockView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-16.
//

import SwiftUI
import Combine

struct AnimatedLockView: View {
    @Binding var isLocked: Bool
    let size: CGFloat
    let lockColor: Color
    let unlockColor: Color
    let animationDuration: Double
    
    @State private var shakeOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var glowOpacity: Double = 0
    
    init(
        isLocked: Binding<Bool>,
        size: CGFloat = 120,
        lockColor: Color = .red,
        unlockColor: Color = .green,
        animationDuration: Double = 0.5
    ) {
        self._isLocked = isLocked
        self.size = size
        self.lockColor = lockColor
        self.unlockColor = unlockColor
        self.animationDuration = animationDuration
    }
    
    var body: some View {
        ZStack {
            // Glow effect
            Circle()
                .fill(isLocked ? lockColor : unlockColor)
                .frame(width: size * 1.2, height: size * 1.2)
                .blur(radius: 20)
                .opacity(glowOpacity)
            
            // Background circle
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            (isLocked ? lockColor : unlockColor).opacity(0.7),
                            isLocked ? lockColor : unlockColor
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: (isLocked ? lockColor : unlockColor).opacity(0.5), radius: 10, x: 0, y: 5)
            
            // Lock icon
            Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: size * 0.5, height: size * 0.5)
                .offset(x: shakeOffset)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
        }
        .onChange(of: isLocked) { oldValue, newValue in
            animateLockState(isLocked: newValue)
        }
        .onAppear {
            // Initial animation
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                glowOpacity = 0.6
            }
        }
    }
    
    private func animateLockState(isLocked: Bool) {
        // Start animation
        withAnimation(.easeInOut(duration: animationDuration / 2)) {
            isAnimating = true
            glowOpacity = 0.8
        }
        
        // Shake animation if locking
        if isLocked {
            let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
            var cancellable: AnyCancellable? = timer.sink { _ in
                withAnimation(.linear(duration: 0.05)) {
                    self.shakeOffset = CGFloat.random(in: -5...5)
                }
            }
            
            // Stop shake after a brief period
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration * 0.7) {
                cancellable?.cancel()
                cancellable = nil
                
                // Reset position
                withAnimation(.spring()) {
                    self.shakeOffset = 0
                }
            }
        }
        
        // End animation
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            withAnimation(.easeInOut(duration: animationDuration / 2)) {
                isAnimating = false
                glowOpacity = 0.6
            }
        }
    }
}

struct PulsatingLockButton: View {
    @Binding var isLocked: Bool
    @State private var pulsateAmount: CGFloat = 1.0
    @State private var rotationAmount: Double = 0
    
    var onTap: (() -> Void)?
    var size: CGFloat = 80
    
    var body: some View {
        Button(action: {
            onTap?()
            
            // Extra animation on tap
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                rotationAmount += 360
            }
        }) {
            AnimatedLockView(
                isLocked: $isLocked,
                size: size,
                lockColor: .red,
                unlockColor: .green
            )
            .rotationEffect(.degrees(rotationAmount))
            .scaleEffect(pulsateAmount)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            // Continuous pulsating animation
            withAnimation(
                Animation
                    .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                pulsateAmount = 1.05
            }
        }
    }
}

#Preview {
    ZStack {
        Color(.systemGray6)
            .ignoresSafeArea()
        
        VStack(spacing: 50) {
            AnimatedLockView(
                isLocked: .constant(true),
                size: 120
            )
            
            AnimatedLockView(
                isLocked: .constant(false),
                size: 120
            )
            
            PulsatingLockButton(
                isLocked: .constant(true),
                onTap: { print("Lock button tapped") },
                size: 80
            )
        }
    }
}
