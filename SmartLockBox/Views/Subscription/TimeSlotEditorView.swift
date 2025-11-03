//
//  TimeSlotEditorView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-03.
//

import SwiftUI

struct TimeSlotEditorView: View {
    let timeSlot: TimeSlot?
    @Binding var isPresented: Bool
    let onSave: (TimeSlot) -> Void

    @State private var name: String
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var allowedHours: Double

    private var isEditMode: Bool {
        timeSlot != nil
    }

    init(timeSlot: TimeSlot?, isPresented: Binding<Bool>, onSave: @escaping (TimeSlot) -> Void) {
        self.timeSlot = timeSlot
        self._isPresented = isPresented
        self.onSave = onSave

        // Initialize state
        if let timeSlot = timeSlot {
            _name = State(initialValue: timeSlot.name)

            var startComponents = DateComponents()
            startComponents.hour = timeSlot.startHour
            startComponents.minute = timeSlot.startMinute
            _startTime = State(initialValue: Calendar.current.date(from: startComponents) ?? Date())

            var endComponents = DateComponents()
            endComponents.hour = timeSlot.endHour
            endComponents.minute = timeSlot.endMinute
            _endTime = State(initialValue: Calendar.current.date(from: endComponents) ?? Date())

            _allowedHours = State(initialValue: timeSlot.allowedDurationHours)
        } else {
            _name = State(initialValue: "")

            var startComponents = DateComponents()
            startComponents.hour = 9
            startComponents.minute = 0
            _startTime = State(initialValue: Calendar.current.date(from: startComponents) ?? Date())

            var endComponents = DateComponents()
            endComponents.hour = 17
            endComponents.minute = 0
            _endTime = State(initialValue: Calendar.current.date(from: endComponents) ?? Date())

            _allowedHours = State(initialValue: 2.0)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                nameSection
                timeRangeSection
                allowedDurationSection
                infoSection
            }
            .navigationTitle(isEditMode ? "edit_time_slot".localized : "add_time_slot".localized)
            .navigationBarItems(
                leading: cancelButton,
                trailing: saveButton
            )
        }
    }

    // MARK: - Name Section

    private var nameSection: some View {
        Section(header: Text("time_slot_name".localized)) {
            TextField("time_slot_name_placeholder".localized, text: $name)
        }
    }

    // MARK: - Time Range Section

    private var timeRangeSection: some View {
        Section(header: Text("time_slot_time_range".localized)) {
            DatePicker(
                "time_slot_start_time".localized,
                selection: $startTime,
                displayedComponents: .hourAndMinute
            )

            DatePicker(
                "time_slot_end_time".localized,
                selection: $endTime,
                displayedComponents: .hourAndMinute
            )

            HStack {
                Text("time_slot_duration".localized(with: formatSlotDuration()))
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }

    // MARK: - Allowed Duration Section

    private var allowedDurationSection: some View {
        Section(header: Text("time_slot_allowed".localized)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Spacer()
                    Text(formatAllowedDuration())
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.accent)
                    Spacer()
                }

                Slider(value: $allowedHours, in: 0.5...maxAllowedHours(), step: 0.5)
                    .accentColor(AppColors.accent)

                HStack {
                    Text("0.5h")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                    Spacer()
                    Text("\(formatMaxHours())")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
    }

    // MARK: - Info Section

    private var infoSection: some View {
        Section {
            HStack(spacing: 8) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                Text("subscription_error_min_duration".localized)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }

    // MARK: - Navigation Buttons

    private var cancelButton: some View {
        Button("cancel".localized) {
            isPresented = false
        }
    }

    private var saveButton: some View {
        Button("save".localized) {
            saveTimeSlot()
        }
        .disabled(!isValidInput)
    }

    // MARK: - Validation

    private var isValidInput: Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }

        let startComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime)
        let endComponents = Calendar.current.dateComponents([.hour, .minute], from: endTime)

        guard let startHour = startComponents.hour,
              let startMinute = startComponents.minute,
              let endHour = endComponents.hour,
              let endMinute = endComponents.minute else {
            return false
        }

        let startInMinutes = startHour * 60 + startMinute
        let endInMinutes = endHour * 60 + endMinute

        // Start must be before end
        guard startInMinutes < endInMinutes else {
            return false
        }

        // Must be at least 1 hour
        let durationMinutes = endInMinutes - startInMinutes
        guard durationMinutes >= 60 else {
            return false
        }

        return true
    }

    // MARK: - Helper Methods

    private func maxAllowedHours() -> Double {
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)

        guard let startHour = startComponents.hour,
              let startMinute = startComponents.minute,
              let endHour = endComponents.hour,
              let endMinute = endComponents.minute else {
            return 8.0
        }

        let durationMinutes = (endHour * 60 + endMinute) - (startHour * 60 + startMinute)
        let maxHours = Double(durationMinutes) / 60.0

        return max(0.5, maxHours)
    }

    private func formatSlotDuration() -> String {
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)

        guard let startHour = startComponents.hour,
              let startMinute = startComponents.minute,
              let endHour = endComponents.hour,
              let endMinute = endComponents.minute else {
            return "0h"
        }

        let durationMinutes = (endHour * 60 + endMinute) - (startHour * 60 + startMinute)
        let hours = durationMinutes / 60
        let minutes = durationMinutes % 60

        if minutes == 0 {
            return "\(hours)h"
        } else {
            return "\(hours)h \(minutes)m"
        }
    }

    private func formatAllowedDuration() -> String {
        let h = Int(allowedHours)
        let m = Int((allowedHours - Double(h)) * 60)

        if m == 0 {
            return "\(h)h"
        } else {
            return "\(h)h \(m)m"
        }
    }

    private func formatMaxHours() -> String {
        let maxHours = maxAllowedHours()
        let h = Int(maxHours)
        let m = Int((maxHours - Double(h)) * 60)

        if m == 0 {
            return "\(h)h"
        } else {
            return "\(h)h \(m)m"
        }
    }

    private func saveTimeSlot() {
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)

        guard let startHour = startComponents.hour,
              let startMinute = startComponents.minute,
              let endHour = endComponents.hour,
              let endMinute = endComponents.minute else {
            return
        }

        let newTimeSlot = TimeSlot(
            id: timeSlot?.id ?? UUID(),
            name: name.trimmingCharacters(in: .whitespaces),
            startHour: startHour,
            startMinute: startMinute,
            endHour: endHour,
            endMinute: endMinute,
            allowedDuration: allowedHours * 3600.0,
            createdAt: timeSlot?.createdAt ?? Date()
        )

        onSave(newTimeSlot)
    }
}

// MARK: - Previews

struct TimeSlotEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSlotEditorView(
            timeSlot: nil,
            isPresented: .constant(true),
            onSave: { _ in }
        )
    }
}
