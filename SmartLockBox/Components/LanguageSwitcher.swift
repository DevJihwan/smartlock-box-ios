//
//  LanguageSwitcher.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-01.
//

import SwiftUI

/// 간단한 언어 전환 토글 버튼 (KR | EN)
struct LanguageSwitcher: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 4) {
            languageButton(.korean, text: "KR")
            
            Text("|")
                .foregroundColor(.gray)
                .font(.caption)
            
            languageButton(.english, text: "EN")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .scaleEffect(isAnimating ? 1.05 : 1.0)
    }
    
    private func languageButton(_ language: AppLanguage, text: String) -> some View {
        Button(action: {
            changeLanguage(to: language)
        }) {
            Text(text)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(localizationManager.currentLanguage == language ? .blue : .gray)
                .scaleEffect(localizationManager.currentLanguage == language ? 1.1 : 1.0)
        }
    }
    
    private func changeLanguage(to language: AppLanguage) {
        guard localizationManager.currentLanguage != language else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            isAnimating = true
        }
        
        // 햅틱 피드백
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // 언어 변경
        localizationManager.changeLanguage(to: language)
        
        // 애니메이션 완료
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                isAnimating = false
            }
        }
    }
}

/// 설정 화면용 상세 언어 선택기
struct LanguagePickerView: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(AppLanguage.allCases) { language in
                languageRow(language)
                
                if language != AppLanguage.allCases.last {
                    Divider()
                        .padding(.leading, 60)
                }
            }
        }
    }
    
    private func languageRow(_ language: AppLanguage) -> some View {
        Button(action: {
            changeLanguage(to: language)
        }) {
            HStack {
                Text(language.displayName)
                    .font(.body)
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                if localizationManager.currentLanguage == language {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 12)
            .background(Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func changeLanguage(to language: AppLanguage) {
        guard localizationManager.currentLanguage != language else { return }
        
        // 햅틱 피드백
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // 언어 변경
        withAnimation {
            localizationManager.changeLanguage(to: language)
        }
    }
}

// MARK: - Previews

struct LanguageSwitcher_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            LanguageSwitcher()
            
            LanguagePickerView()
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
