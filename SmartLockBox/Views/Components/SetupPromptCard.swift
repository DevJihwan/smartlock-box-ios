//
//  SetupPromptCard.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-05.
//  Initial setup prompt card for time control
//

import SwiftUI

/// Setup Prompt Card
/// Encourages users to set up time control when not configured
struct SetupPromptCard: View {

    // MARK: - Properties

    @EnvironmentObject var appState: AppStateManager
    @State private var selectedHours: Double = 3.0
    @State private var showGoalPicker: Bool = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            // Icon
            Image(systemName: "clock.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding(.top, 16)

            // Title
            Text("setup_time_control_title".localized)
                .font(.title2.bold())
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            // Message
            Text("setup_time_control_message".localized)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            // Setup Button
            Button(action: {
                showGoalPicker = true
            }) {
                HStack {
                    Image(systemName: "timer")
                    Text("setup_time_control_button".localized)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)

            // Skip for now
            Button(action: {
                // User can skip setup
            }) {
                Text("setup_time_control_skip".localized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .padding(.horizontal, 16)
        .sheet(isPresented: $showGoalPicker) {
            GoalSelectionView(
                selectedHours: $selectedHours,
                onConfirm: {
                    appState.dailyGoalMinutes = Int(selectedHours * 60)
                    showGoalPicker = false
                }
            )
        }
    }
}

/// Goal Selection Sheet
struct GoalSelectionView: View {

    @Binding var selectedHours: Double
    var onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Illustration
                Image(systemName: "hourglass")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding(.top, 40)

                // Title
                Text("setup_goal_picker_title".localized)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                // Current selection
                VStack(spacing: 8) {
                    Text(String(format: "%.1f", selectedHours))
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.blue)

                    Text("setup_goal_picker_hours".localized)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 20)

                // Slider
                VStack(alignment: .leading, spacing: 8) {
                    Text("setup_goal_picker_subtitle".localized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Slider(value: $selectedHours, in: 1...8, step: 0.5)
                        .accentColor(.blue)

                    HStack {
                        Text("1h")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("8h")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                // Confirm Button
                Button(action: {
                    onConfirm()
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("setup_goal_confirm".localized)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel".localized) {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Setup Prompt") {
    SetupPromptCard()
        .environmentObject(AppStateManager())
        .padding(.vertical)
}

#Preview("Goal Selection") {
    GoalSelectionView(
        selectedHours: .constant(3.0),
        onConfirm: {}
    )
}
