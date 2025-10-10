//
//  WeeklyStatsCard.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

struct WeeklyStatsCard: View {
    let stats: WeeklyStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("📊 이번 주 사용 현황")
                    .font(.headline)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("총")
                        .foregroundColor(.secondary)
                    Text(formatTime(stats.totalMinutes))
                        .fontWeight(.semibold)
                    Text("/")
                        .foregroundColor(.secondary)
                    Text(formatTime(stats.goalMinutes))
                        .foregroundColor(.secondary)
                }
                .font(.body)
                
                HStack {
                    Text("평균:")
                        .foregroundColor(.secondary)
                    Text(formatTime(Int(stats.averageMinutesPerDay)) + "/일")
                        .fontWeight(.semibold)
                }
                .font(.body)
            }
            .padding(.vertical, 4)
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
}
