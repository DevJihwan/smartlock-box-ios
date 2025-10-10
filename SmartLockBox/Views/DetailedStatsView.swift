//
//  DetailedStatsView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

struct DetailedStatsView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var selectedPeriod: StatsPeriod = .week
    
    enum StatsPeriod: String, CaseIterable {
        case week = "주간"
        case month = "월간"
        case year = "연간"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 기간 선택
                Picker("기간 선택", selection: $selectedPeriod) {
                    ForEach(StatsPeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // 통계 카드
                VStack(spacing: 16) {
                    StatCard(
                        title: "총 사용 시간",
                        value: "18시간 30분",
                        icon: "clock.fill",
                        color: .blue
                    )
                    
                    StatCard(
                        title: "목표 달성률",
                        value: "87%",
                        icon: "target",
                        color: .green
                    )
                    
                    StatCard(
                        title: "일평균 사용",
                        value: "2시간 38분",
                        icon: "chart.bar.fill",
                        color: .orange
                    )
                    
                    StatCard(
                        title: "최장 연속 달성",
                        value: "12일",
                        icon: "flame.fill",
                        color: .red
                    )
                }
                .padding(.horizontal)
                
                // 사용 패턴 그래프
                VStack(alignment: .leading, spacing: 12) {
                    Text("주간 사용 패턴")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // TODO: 차트 라이브러리 사용하여 그래프 구현
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay(
                            Text("차트가 여기에 표시됩니다")
                                .foregroundColor(.secondary)
                        )
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                // 상세 리스트
                VStack(alignment: .leading, spacing: 12) {
                    Text("일별 상세 기록")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(0..<7) { day in
                        DailyRecordRow(
                            date: Calendar.current.date(byAdding: .day, value: -day, to: Date()) ?? Date(),
                            usageMinutes: Int.random(in: 120...200),
                            goalMinutes: 180
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("상세 통계")
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.2))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

struct DailyRecordRow: View {
    let date: Date
    let usageMinutes: Int
    let goalMinutes: Int
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        return formatter
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(dateFormatter.string(from: date))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(formatTime(usageMinutes)) / \(formatTime(goalMinutes))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if usageMinutes <= goalMinutes {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        return "\(hours)시간 \(mins)분"
    }
}

struct DetailedStatsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailedStatsView()
        }
    }
}
