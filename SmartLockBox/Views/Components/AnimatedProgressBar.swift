//
//  AnimatedProgressBar.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-16.
//

import SwiftUI

struct AnimatedProgressBar: View {
    let value: Double
    let maxValue: Double
    let backgroundColor: Color
    let foregroundColor: Color
    let height: CGFloat
    let labelFont: Font
    
    @State private var animatedValue: Double = 0
    
    init(
        value: Double,
        maxValue: Double = 100,
        backgroundColor: Color = Color(.systemGray5),
        foregroundColor: Color = .blue,
        height: CGFloat = 20,
        labelFont: Font = .caption.bold()
    ) {
        self.value = min(max(0, value), maxValue)
        self.maxValue = maxValue
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.height = height
        self.labelFont = labelFont
    }
    
    var percentage: Int {
        return Int((value / maxValue) * 100)
    }
    
    var displayValue: String {
        return "\(percentage)%"
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(backgroundColor)
                    .frame(height: height)
                
                // Foreground (Progress)
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                foregroundColor.opacity(0.8),
                                foregroundColor
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(geometry.size.width * CGFloat(animatedValue / maxValue), 0), height: height)
                
                // Glow effect on the edge
                if animatedValue > 0 {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(foregroundColor)
                        .frame(width: 10, height: height)
                        .blur(radius: 4)
                        .offset(x: max(geometry.size.width * CGFloat(animatedValue / maxValue) - 5, 0))
                        .mask(
                            RoundedRectangle(cornerRadius: height / 2)
                                .frame(width: max(geometry.size.width * CGFloat(animatedValue / maxValue), 0), height: height)
                        )
                }
                
                // Value Label
                Text(displayValue)
                    .font(labelFont)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .frame(height: height)
                    .allowsHitTesting(false)
                    .opacity(animatedValue > maxValue * 0.15 ? 1 : 0)
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animatedValue)
        }
        .frame(height: height)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                self.animatedValue = self.value
            }
        }
        .onChange(of: value) { newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                self.animatedValue = newValue
            }
        }
    }
}

struct AnimatedProgressBarWithLabel: View {
    let value: Double
    let maxValue: Double
    let title: String
    let subtitle: String?
    let backgroundColor: Color
    let foregroundColor: Color
    
    init(
        value: Double,
        maxValue: Double = 100,
        title: String,
        subtitle: String? = nil,
        backgroundColor: Color = Color(.systemGray5),
        foregroundColor: Color = .blue
    ) {
        self.value = value
        self.maxValue = maxValue
        self.title = title
        self.subtitle = subtitle
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Text("\(Int(value))/\(Int(maxValue))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            AnimatedProgressBar(
                value: value,
                maxValue: maxValue,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor
            )
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        AnimatedProgressBar(value: 75, foregroundColor: .blue)
            .frame(height: 20)
        
        AnimatedProgressBarWithLabel(
            value: 160,
            maxValue: 240,
            title: "일일 사용 시간",
            subtitle: "목표까지 80분 남음",
            foregroundColor: .green
        )
        
        AnimatedProgressBarWithLabel(
            value: 210,
            maxValue: 200,
            title: "일일 사용 시간",
            subtitle: "목표를 초과했습니다!",
            foregroundColor: .red
        )
    }
    .padding()
}
