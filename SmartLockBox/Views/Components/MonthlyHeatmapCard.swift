//
//  MonthlyHeatmapCard.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

struct MonthlyHeatmapCard: View {
    let stats: MonthlyStats
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("📅 월간 목표 달성 현황")
                    .font(.headline)
                Spacer()
            }
            
            // 히트맵
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(stats.dailyData.indices, id: \.self) { index in
                    HeatmapCell(data: stats.dailyData[index])
                }
            }
            .padding(.vertical, 8)
            
            // 범례
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.green)
                        .frame(width: 16, height: 16)
                    Text("목표 달성")
                        .font(.caption)
                }
                
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 16, height: 16)
                    Text("목표 미달성")
                        .font(.caption)
                }
            }
            
            // 통계
            Text("이번 달 달성률: \(Int(stats.achievementRate))% (\(stats.achievedDays)/\(stats.totalDays)일)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct HeatmapCell: View {
    let data: UsageData
    @State private var showDetail = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(data.achieved ? Color.green : Color.gray.opacity(0.3))
            .frame(height: 30)
            .onTapGesture {
                showDetail.toggle()
            }
            .alert(isPresented: $showDetail) {
                Alert(
                    title: Text(dateFormatter.string(from: data.date)),
                    message: Text("사용: \(formatTime(data.usageMinutes))\n목표: \(formatTime(data.goalMinutes))\n달성: \(data.achieved ? "✅" : "❌")"),
                    dismissButton: .default(Text("확인"))
                )
            }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        return formatter
    }
    
    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)시간 \(mins)분"
    }
}
