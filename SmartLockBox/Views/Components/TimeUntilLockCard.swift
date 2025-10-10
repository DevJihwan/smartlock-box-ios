//
//  TimeUntilLockCard.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

struct TimeUntilLockCard: View {
    let remainingMinutes: Int
    let expectedLockTime: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("⏰ 잠금까지 남은 시간")
                    .font(.headline)
                Spacer()
            }
            
            VStack(spacing: 8) {
                Text(formatRemainingTime(remainingMinutes))
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(remainingMinutes <= 10 ? .red : .primary)
                
                Text(expectedLockTime)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func formatRemainingTime(_ minutes: Int) -> String {
        if minutes <= 0 {
            return "곧 잠금"
        }
        let hours = minutes / 60
        let mins = minutes % 60
        
        if hours > 0 {
            return "\(hours)시간 \(mins)분"
        } else {
            return "\(mins)분"
        }
    }
}
