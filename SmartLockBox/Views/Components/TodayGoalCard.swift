//
//  TodayGoalCard.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

struct TodayGoalCard: View {
    let usageMinutes: Int
    let goalMinutes: Int
    let percentage: Double
    let progressColor: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🎯 오늘의 목표 달성률")
                    .font(.headline)
                Spacer()
            }
            
            // 사용시간 표시
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(formatTime(usageMinutes))
                    .font(.system(size: 32, weight: .bold))
                Text("/")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Text(formatTime(goalMinutes))
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            
            // 프로그레스바
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 20)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(getProgressColor())
                        .frame(width: geometry.size.width * min(CGFloat(percentage) / 100, 1.0), height: 20)
                        .animation(.spring(), value: percentage)
                }
            }
            .frame(height: 20)
            
            // 퍼센트 표시
            Text("\(Int(percentage))%")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(getProgressColor())
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)시간 \(mins)분"
    }
    
    private func getProgressColor() -> Color {
        switch progressColor {
        case "green":
            return .green
        case "yellow":
            return .yellow
        case "red":
            return .red
        default:
            return .blue
        }
    }
}
