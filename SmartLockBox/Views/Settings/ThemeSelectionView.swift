//
//  ThemeSelectionView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-05.
//  iPhone color matching theme selection
//

import SwiftUI

struct ThemeSelectionView: View {

    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var showColorPicker = false
    @State private var tempCustomColor: Color = .blue
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        List {
            deviceColorSection
            presetColorsSection
            customColorSection
        }
        .navigationTitle("theme_title".localized)
        .background(AppColors.background)
        .sheet(isPresented: $showColorPicker) {
            CustomColorPickerView(selectedColor: $tempCustomColor, onConfirm: {
                themeManager.setCustomColor(tempCustomColor)
                showColorPicker = false
            })
        }
    }

    // MARK: - Device Color Section

    private var deviceColorSection: some View {
        Section(header: sectionHeader("theme_device_color_header".localized)) {
            Toggle("theme_match_device_color".localized, isOn: $themeManager.matchDeviceColor)
                .foregroundColor(AppColors.text)
                .toggleStyle(SwitchToggleStyle(tint: themeManager.themeColor))

            Text("theme_match_device_description".localized)
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
        }
    }

    // MARK: - Preset Colors Section

    private var presetColorsSection: some View {
        Section(header: sectionHeader("theme_preset_colors".localized)) {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 70), spacing: 16)
            ], spacing: 20) {
                ForEach(DeviceColor.allCases.filter { $0 != .custom }) { deviceColor in
                    ColorCircleButton(
                        color: deviceColor.color,
                        isSelected: themeManager.selectedColor == deviceColor,
                        label: deviceColor.rawValue
                    ) {
                        themeManager.changeThemeColor(deviceColor)
                    }
                }
            }
            .padding(.vertical, 12)
        }
    }

    // MARK: - Custom Color Section

    private var customColorSection: some View {
        Section(header: sectionHeader("theme_custom_color".localized)) {
            Button(action: {
                tempCustomColor = themeManager.customColor
                showColorPicker = true
            }) {
                HStack {
                    Image(systemName: "paintpalette.fill")
                        .foregroundColor(themeManager.themeColor)

                    Text("theme_select_custom_color".localized)
                        .foregroundColor(AppColors.text)

                    Spacer()

                    if themeManager.selectedColor == .custom {
                        Image(systemName: "checkmark")
                            .foregroundColor(themeManager.themeColor)
                    }
                }
            }
        }
    }

    // MARK: - Helper Views

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .foregroundColor(themeManager.themeColor)
    }
}

// MARK: - Color Circle Button

struct ColorCircleButton: View {

    var color: Color
    var isSelected: Bool
    var label: String
    var action: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                        )

                    if isSelected {
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 3)
                            .frame(width: 60, height: 60)

                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            Text(label)
                .font(.caption2)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 70)
        }
    }
}

// MARK: - Custom Color Picker View

struct CustomColorPickerView: View {

    @Binding var selectedColor: Color
    var onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Preview
                VStack(spacing: 16) {
                    Text("theme_preview".localized)
                        .font(.headline)
                        .foregroundColor(AppColors.text)

                    Circle()
                        .fill(selectedColor)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                }
                .padding(.top, 40)

                // Color Picker
                ColorPicker("theme_select_color".localized, selection: $selectedColor, supportsOpacity: false)
                    .padding(.horizontal, 24)

                Spacer()

                // Confirm Button
                Button(action: onConfirm) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("confirm".localized)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedColor)
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

// MARK: - Previews

struct ThemeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ThemeSelectionView()
            }
            .preferredColorScheme(.light)
            .previewDisplayName("Light Mode")

            NavigationView {
                ThemeSelectionView()
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
