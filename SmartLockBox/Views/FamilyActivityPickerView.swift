//
//  FamilyActivityPickerView.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-03.
//

import SwiftUI
import FamilyControls

/// 차단할 앱과 웹사이트를 선택하는 FamilyActivityPicker 뷰
struct FamilyActivityPickerView: View {
    @ObservedObject var screenTimeManager = ScreenTimeManager.shared
    @State private var isPresented = false
    @State private var selection = FamilyActivitySelection()
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("blocked_apps_title".localized)
                        .font(.headline)
                        .foregroundColor(AppColors.text)
                    
                    Text("blocked_apps_description".localized)
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
            }
            
            // Selected apps count
            if !selection.applicationTokens.isEmpty || !selection.webDomainTokens.isEmpty {
                HStack {
                    Image(systemName: "app.badge.checkmark")
                        .foregroundColor(AppColors.accent)
                    
                    Text("blocked_apps_selected".localized(
                        with: selection.applicationTokens.count,
                        selection.webDomainTokens.count
                    ))
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(8)
            }
            
            // Picker Button
            Button(action: { isPresented = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("blocked_apps_select".localized)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(AppColors.accent)
                .cornerRadius(12)
            }
            
            // Save Button
            if !selection.applicationTokens.isEmpty || !selection.webDomainTokens.isEmpty {
                Button(action: saveSelection) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("blocked_apps_save".localized)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(12)
                }
            }
            
            // Info
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    Text("blocked_apps_info".localized)
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding()
            .background(AppColors.cardBackground)
            .cornerRadius(8)
        }
        .familyActivityPicker(isPresented: $isPresented, selection: $selection)
        .onAppear {
            // Load existing selection
            selection = screenTimeManager.activitySelection
        }
    }
    
    private func saveSelection() {
        screenTimeManager.updateActivitySelection(selection)
        
        // Success feedback
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
    }
}

// MARK: - Previews

struct FamilyActivityPickerView_Previews: PreviewProvider {
    static var previews: some View {
        FamilyActivityPickerView()
            .padding()
            .background(AppColors.background)
    }
}
