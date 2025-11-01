//
//  String+Localization.swift
//  SmartLockBox
//
//  Created by DevJihwan on 2025-11-01.
//

import Foundation

extension String {
    /// 현재 선택된 언어로 번역된 문자열을 반환
    var localized: String {
        return LocalizationManager.shared.localizedString(self)
    }
    
    /// 파라미터를 포함한 번역된 문자열을 반환
    /// - Parameter arguments: 포맷 파라미터
    /// - Returns: 포맷팅된 번역 문자열
    func localized(with arguments: CVarArg...) -> String {
        let localizedString = LocalizationManager.shared.localizedString(self)
        return String(format: localizedString, arguments: arguments)
    }
    
    /// 복수형 처리를 위한 로컬라이제이션
    /// - Parameters:
    ///   - count: 개수
    ///   - key: 로컬라이제이션 키
    /// - Returns: 복수형 처리된 문자열
    func localizedPlural(count: Int) -> String {
        let key = count == 1 ? self + "_singular" : self + "_plural"
        let localizedString = LocalizationManager.shared.localizedString(key)
        return String(format: localizedString, count)
    }
}

// MARK: - Notification Extension

extension Notification.Name {
    /// 언어 변경 알림
    static let languageDidChange = Notification.Name("languageDidChange")
}
