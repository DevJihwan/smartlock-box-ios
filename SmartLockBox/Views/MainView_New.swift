//
//  MainView_New.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-15.
//  New design from Figma
//

import SwiftUI

struct MainView_New: View {
    @EnvironmentObject var appState: AppStateManager
    @StateObject private var viewModel = MainViewModel()
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @State private var showSettings = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerView
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                // Main content
                homeContent

                // Bottom navigation
                bottomNavigationBar
            }
        }
        .onAppear {
            appState.loadSettings()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(appState)
        }
    }

    // MARK: - Home Content

    private var homeContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                Spacer().frame(height: 20)

                // Today's usage card
                todayUsageCard

                // Streak card
                streakCard

                Spacer().frame(height: 100)
            }
            .padding(.horizontal, 24)
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack(spacing: 12) {
            // ThinkFree logo with lock icon
            HStack(spacing: 12) {
                Image(systemName: "lock.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(red: 0.4, green: 0.7, blue: 1.0))

                Text("ThinkFree")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.black)
            }

            Spacer()

            // Language switcher
            LanguageSwitcher()
        }
    }

    // MARK: - Today's Usage Card

    private var todayUsageCard: some View {
        VStack(spacing: 16) {
            // Date
            Text(formattedDate())
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "666666"))

            // Time display
            Text(formatUsageTime())
                .font(.system(size: 48, weight: .regular))
                .foregroundColor(.black)

            // Progress text
            Text(progressText())
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "999999"))

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(hex: "E0E0E0"))
                        .frame(height: 6)

                    // Progress
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(red: 0.4, green: 0.7, blue: 1.0))
                        .frame(
                            width: geometry.size.width * CGFloat(min(Double(appState.usagePercentage) / 100.0, 1.0)),
                            height: 6
                        )
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 40)
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
        )
    }

    // MARK: - Streak Card

    private var streakCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("streak_record".localized)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "333333"))
                .padding(.horizontal, 16)

            VStack(spacing: 8) {
                Text("\(appState.currentStreak)")
                    .font(.system(size: 56, weight: .regular))
                    .foregroundColor(.black)

                Text("streak_days".localized)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "666666"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "F5F5F5"))
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
        )
    }

    // MARK: - Bottom Navigation

    private var bottomNavigationBar: some View {
        HStack(spacing: 0) {
            // Home button
            Button(action: {
                // Already on home
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.4, green: 0.7, blue: 1.0))
                }
                .frame(maxWidth: .infinity)
            }

            // Settings button
            Button(action: {
                showSettings = true
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color.gray)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 16)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -2)
        )
    }

    // MARK: - Helper Methods

    private func formattedDate() -> String {
        // Force view to update when language changes
        let _ = localizationManager.currentLanguage

        let formatter = DateFormatter()
        if localizationManager.currentLanguage.rawValue == "ko" {
            formatter.dateFormat = "yyyy년 M월 d일"
            formatter.locale = Locale(identifier: "ko_KR")
        } else {
            formatter.dateFormat = "MMM d, yyyy"
            formatter.locale = Locale(identifier: "en_US")
        }
        return formatter.string(from: Date())
    }

    private func formatUsageTime() -> String {
        let hours = appState.todayUsageMinutes / 60
        let minutes = appState.todayUsageMinutes % 60
        return "\(hours)h \(minutes)m"
    }

    private func progressText() -> String {
        let goalHours = appState.limitMinutes / 60
        let percentage = appState.usagePercentage

        if localizationManager.currentLanguage.rawValue == "ko" {
            return "목표 \(goalHours)시간 중 \(percentage)%"
        } else {
            return "\(percentage)% of \(goalHours) hour goal"
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview

struct MainView_New_Previews: PreviewProvider {
    static var previews: some View {
        MainView_New()
            .environmentObject(AppStateManager())
    }
}
