//
//  LanguageManager.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-10-10.
//

import Foundation
import SwiftUI

// MARK: - Language Enum

enum Language: String, CaseIterable, Codable {
    case korean = "ko"
    case english = "en"
    
    var displayName: String {
        switch self {
        case .korean: return "한국어"
        case .english: return "English"
        }
    }
    
    var shortCode: String {
        switch self {
        case .korean: return "KO"
        case .english: return "EN"
        }
    }
    
    var flag: String {
        switch self {
        case .korean: return "🇰🇷"
        case .english: return "🇺🇸"
        }
    }
}

// MARK: - LanguageManager

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: Language {
        didSet {
            saveLanguage()
            // 언어 변경 알림
            NotificationCenter.default.post(name: .languageDidChange, object: nil)
        }
    }
    
    private let languageKey = "selectedLanguage"
    
    private init() {
        // 저장된 언어 불러오기
        if let savedLanguage = UserDefaults.standard.string(forKey: languageKey),
           let language = Language(rawValue: savedLanguage) {
            self.currentLanguage = language
        } else {
            // 기본값: 시스템 언어 기반
            let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            self.currentLanguage = systemLanguage.starts(with: "ko") ? .korean : .english
        }
    }
    
    /// 언어 저장
    private func saveLanguage() {
        UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
    }
    
    /// 언어 변경
    func setLanguage(_ language: Language) {
        currentLanguage = language
    }
    
    /// 번역 키로 텍스트 가져오기
    func localized(_ key: String) -> String {
        let bundle = getBundle()
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
    
    /// 현재 언어에 맞는 Bundle 가져오기
    private func getBundle() -> Bundle {
        guard let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return Bundle.main
        }
        return bundle
    }
}

// MARK: - Notification Extension

extension Notification.Name {
    static let languageDidChange = Notification.Name("languageDidChange")
}

// MARK: - String Extension for Localization

extension String {
    /// 현재 선택된 언어로 번역된 문자열 반환
    var localized: String {
        return LanguageManager.shared.localized(self)
    }
    
    /// 매개변수가 있는 번역
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

// MARK: - SwiftUI Environment Extension

private struct LanguageManagerKey: EnvironmentKey {
    static let defaultValue = LanguageManager.shared
}

extension EnvironmentValues {
    var languageManager: LanguageManager {
        get { self[LanguageManagerKey.self] }
        set { self[LanguageManagerKey.self] = newValue }
    }
}

extension View {
    func languageManager(_ manager: LanguageManager) -> some View {
        environment(\.languageManager, manager)
    }
}
