//
//  LanguageSwitcher.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import SwiftUI

/// 언어 선택 UI 컴포넌트
struct LanguageSwitcher: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(AppLanguage.allCases) { language in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        localizationManager.changeLanguage(to: language)
                    }
                }) {
                    Text(language.shortCode)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(
                            localizationManager.currentLanguage == language
                                ? .white
                                : .gray
                        )
                        .frame(width: 36, height: 28)
                        .background(
                            localizationManager.currentLanguage == language
                                ? Color.blue
                                : Color.clear
                        )
                        .cornerRadius(6)
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: localizationManager.currentLanguage)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
    }
}

/// 언어 선택 드롭다운 (설정 화면용)
struct LanguagePickerView: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizationKey.language.localized)
                .font(.headline)
            
            ForEach(AppLanguage.allCases) { language in
                Button(action: {
                    withAnimation {
                        localizationManager.changeLanguage(to: language)
                    }
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(language.displayName)
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Text(language.shortCode)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if localizationManager.currentLanguage == language {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .font(.body.weight(.semibold))
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                localizationManager.currentLanguage == language
                                    ? Color.blue.opacity(0.1)
                                    : Color(.systemGray6)
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                localizationManager.currentLanguage == language
                                    ? Color.blue
                                    : Color.clear,
                                lineWidth: 2
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Previews

struct LanguageSwitcher_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            // 컴팩트 스위처
            LanguageSwitcher()
            
            Divider()
            
            // 설정 화면용 피커
            LanguagePickerView()
                .padding()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
