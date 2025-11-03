//
//  PremiumTierSettingsView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-03.
//

import SwiftUI

struct PremiumTierSettingsView: View {
    @ObservedObject var subscriptionManager = SubscriptionManager.shared
    @State private var showAddTimeSlot = false
    @State private var editingTimeSlot: TimeSlot?
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 24) {
            // Header
            headerSection

            // Time Slots List
            if subscriptionManager.premiumTierSettings.timeSlots.isEmpty {
                emptyStateView
            } else {
                timeSlotsListSection
            }

            // Add Time Slot Button
            if subscriptionManager.canAddTimeSlot() {
                addTimeSlotButton
            }

            // Tips & Info
            tipsSection
        }
        .padding()
        .sheet(isPresented: $showAddTimeSlot) {
            TimeSlotEditorView(
                timeSlot: nil,
                isPresented: $showAddTimeSlot,
                onSave: handleAddTimeSlot
            )
        }
        .sheet(item: $editingTimeSlot) { timeSlot in
            TimeSlotEditorView(
                timeSlot: timeSlot,
                isPresented: Binding(
                    get: { editingTimeSlot != nil },
                    set: { if !$0 { editingTimeSlot = nil } }
                ),
                onSave: handleUpdateTimeSlot
            )
        }
        .alert("error".localized, isPresented: $showError) {
            Button("ok".localized, role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                Text("premium_title".localized)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.text)
            }

            Text("premium_slots_usage".localized(
                with: subscriptionManager.premiumTierSettings.timeSlots.count,
                subscriptionManager.currentTier.maxTimeSlots
            ))
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.badge.plus")
                .font(.system(size: 50))
                .foregroundColor(AppColors.secondaryText.opacity(0.5))

            Text("premium_add_time_slot".localized)
                .font(.headline)
                .foregroundColor(AppColors.secondaryText)

            Text("premium_tip".localized)
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }

    // MARK: - Time Slots List

    private var timeSlotsListSection: some View {
        VStack(spacing: 12) {
            ForEach(subscriptionManager.premiumTierSettings.timeSlots) { timeSlot in
                TimeSlotCardView(
                    timeSlot: timeSlot,
                    onEdit: { editingTimeSlot = timeSlot },
                    onDelete: { handleDeleteTimeSlot(timeSlot) }
                )
            }
        }
    }

    // MARK: - Add Time Slot Button

    private var addTimeSlotButton: some View {
        Button(action: { showAddTimeSlot = true }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("premium_add_time_slot".localized)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
        }
    }

    // MARK: - Tips Section

    private var tipsSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("premium_tip".localized)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }

            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("premium_no_overlap_warning".localized)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }

    // MARK: - Actions

    private func handleAddTimeSlot(_ timeSlot: TimeSlot) {
        do {
            try subscriptionManager.addTimeSlot(timeSlot)
            showAddTimeSlot = false

            // Success feedback
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.success)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    private func handleUpdateTimeSlot(_ timeSlot: TimeSlot) {
        do {
            try subscriptionManager.updateTimeSlot(timeSlot)
            editingTimeSlot = nil

            // Success feedback
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.success)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    private func handleDeleteTimeSlot(_ timeSlot: TimeSlot) {
        subscriptionManager.removeTimeSlot(timeSlot)

        // Success feedback
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
    }
}

// MARK: - Time Slot Card View

struct TimeSlotCardView: View {
    let timeSlot: TimeSlot
    let onEdit: () -> Void
    let onDelete: () -> Void
    @EnvironmentObject var appState: AppStateManager

    var usageForSlot: TimeInterval {
        appState.dailyUsageRecord.usage(for: timeSlot.id)
    }

    var usagePercentage: Double {
        guard timeSlot.allowedDuration > 0 else { return 0 }
        return min(1.0, usageForSlot / timeSlot.allowedDuration)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(timeSlot.name)
                    .font(.headline)
                    .foregroundColor(AppColors.text)

                Spacer()

                // Edit Button
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                }

                // Delete Button
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
            }

            // Time Range
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(AppColors.accent)
                Text(timeSlot.formattedTimeRange)
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
            }

            // Allowed Duration
            HStack {
                Image(systemName: "hourglass")
                    .foregroundColor(AppColors.accent)
                Text("time_slot_allowed_duration".localized + ": " + formatDuration(timeSlot.allowedDuration))
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
            }

            // Usage Rate
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(formatDuration(usageForSlot))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(usagePercentage > 0.9 ? .red : AppColors.accent)

                    Text("/ \(formatDuration(timeSlot.allowedDuration))")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)

                    Spacer()

                    Text("\(Int(usagePercentage * 100))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(usagePercentage > 0.9 ? .red : AppColors.accent)
                }

                ProgressView(value: usagePercentage)
                    .accentColor(usagePercentage > 0.9 ? .red : AppColors.accent)
                    .padding(.top, 2)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60

        if minutes == 0 {
            return "\(hours)h"
        } else {
            return "\(hours)h \(minutes)m"
        }
    }
}

// MARK: - Previews

struct PremiumTierSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumTierSettingsView()
            .preferredColorScheme(.light)
    }
}
