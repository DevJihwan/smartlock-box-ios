//
//  ThemeManager.swift
//  SmartLockBox - Design System
//
//  Created by DevJihwan on 2025-11-04.
//  Theme management with iPhone device color matching
//

import SwiftUI
import Combine

/// Device Color Options matching iPhone colors
enum DeviceColor: String, CaseIterable, Identifiable {
    case systemDefault = "시스템 기본"
    case midnightBlue = "미드나잇 블루"
    case starlight = "스타라이트"
    case pink = "핑크"
    case blue = "블루"
    case purple = "퍼플"
    case yellow = "옐로우"
    case green = "그린"
    case red = "레드"
    case spaceBlack = "스페이스 블랙"
    case custom = "커스텀"

    var id: String { rawValue }

    /// Color representation
    var color: Color {
        switch self {
        case .systemDefault:
            return .blue
        case .midnightBlue:
            return Color(red: 0.08, green: 0.11, blue: 0.22)
        case .starlight:
            return Color(red: 0.97, green: 0.96, blue: 0.93)
        case .pink:
            return Color(red: 0.95, green: 0.76, blue: 0.82)
        case .blue:
            return Color(red: 0.42, green: 0.64, blue: 0.82)
        case .purple:
            return Color(red: 0.68, green: 0.55, blue: 0.84)
        case .yellow:
            return Color(red: 1.0, green: 0.93, blue: 0.53)
        case .green:
            return Color(red: 0.67, green: 0.82, blue: 0.62)
        case .red:
            return Color(red: 0.92, green: 0.38, blue: 0.38)
        case .spaceBlack:
            return Color(red: 0.12, green: 0.12, blue: 0.13)
        case .custom:
            return loadCustomColor()
        }
    }

    /// UIColor representation
    var uiColor: UIColor {
        UIColor(color)
    }

    /// Load custom color from UserDefaults
    private func loadCustomColor() -> Color {
        guard let data = UserDefaults.standard.data(forKey: "customThemeColor"),
              let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            return .blue
        }
        return Color(uiColor)
    }
}

/// Theme Manager
/// Manages app-wide theme and color customization
class ThemeManager: ObservableObject {

    // MARK: - Singleton

    static let shared = ThemeManager()

    // MARK: - Published Properties

    /// Currently selected device color
    @Published var selectedColor: DeviceColor {
        didSet {
            saveSelectedColor()
            applyTheme()
        }
    }

    /// Whether to match iPhone device color
    @Published var matchDeviceColor: Bool {
        didSet {
            UserDefaults.standard.set(matchDeviceColor, forKey: "matchDeviceColor")
        }
    }

    /// Custom color (when selectedColor is .custom)
    @Published var customColor: Color = .blue {
        didSet {
            if selectedColor == .custom {
                saveCustomColor()
                applyTheme()
            }
        }
    }

    // MARK: - Computed Properties

    /// Current theme color
    var themeColor: Color {
        selectedColor.color
    }

    /// Current theme UIColor
    var themeUIColor: UIColor {
        selectedColor.uiColor
    }

    // MARK: - Initialization

    private init() {
        // Load saved color
        if let savedColorRaw = UserDefaults.standard.string(forKey: "selectedDeviceColor"),
           let savedColor = DeviceColor(rawValue: savedColorRaw) {
            self.selectedColor = savedColor
        } else {
            self.selectedColor = .systemDefault
        }

        // Load match device color setting
        self.matchDeviceColor = UserDefaults.standard.bool(forKey: "matchDeviceColor")

        // Apply theme on init
        applyTheme()
    }

    // MARK: - Public Methods

    /// Change theme color
    func changeThemeColor(_ color: DeviceColor) {
        selectedColor = color
    }

    /// Save custom color
    func setCustomColor(_ color: Color) {
        customColor = color
        selectedColor = .custom
    }

    // MARK: - Private Methods

    /// Save selected color to UserDefaults
    private func saveSelectedColor() {
        UserDefaults.standard.set(selectedColor.rawValue, forKey: "selectedDeviceColor")
    }

    /// Save custom color to UserDefaults
    private func saveCustomColor() {
        let uiColor = UIColor(customColor)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false) {
            UserDefaults.standard.set(data, forKey: "customThemeColor")
        }
    }

    /// Apply theme to app
    private func applyTheme() {
        let color = themeUIColor

        // Update UIView tint color
        DispatchQueue.main.async {
            UIView.appearance().tintColor = color

            // Navigation Bar
            let navAppearance = UINavigationBarAppearance()
            navAppearance.configureWithDefaultBackground()
            navAppearance.largeTitleTextAttributes = [.foregroundColor: color]
            navAppearance.titleTextAttributes = [.foregroundColor: color]

            UINavigationBar.appearance().standardAppearance = navAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
            UINavigationBar.appearance().tintColor = color

            // Tab Bar
            let tabAppearance = UITabBarAppearance()
            tabAppearance.configureWithDefaultBackground()

            UITabBar.appearance().standardAppearance = tabAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
            UITabBar.appearance().tintColor = color

            // Progress View
            UIProgressView.appearance().progressTintColor = color

            // Switch
            UISwitch.appearance().onTintColor = color

            // Slider
            UISlider.appearance().minimumTrackTintColor = color
        }
    }
}

// MARK: - Theme Environment Key

struct ThemeColorKey: EnvironmentKey {
    static let defaultValue: Color = .blue
}

extension EnvironmentValues {
    var themeColor: Color {
        get { self[ThemeColorKey.self] }
        set { self[ThemeColorKey.self] = newValue }
    }
}

// MARK: - View Extension for Theme Access

extension View {
    /// Apply theme color to view
    func withThemeColor() -> some View {
        self.environment(\.themeColor, ThemeManager.shared.themeColor)
            .accentColor(ThemeManager.shared.themeColor)
    }
}

// MARK: - Usage Examples

/*
 Usage Examples:

 // In App entry point
 @main
 struct SmartLockBoxApp: App {
     @StateObject private var themeManager = ThemeManager.shared

     var body: some Scene {
         WindowGroup {
             ContentView()
                 .withThemeColor()
                 .environmentObject(themeManager)
         }
     }
 }

 // In any view
 struct SomeView: View {
     @EnvironmentObject var themeManager: ThemeManager
     @Environment(\.themeColor) var themeColor

     var body: some View {
         VStack {
             Text("Title")
                 .foregroundColor(themeColor)

             Button("Change to Pink") {
                 themeManager.changeThemeColor(.pink)
             }
         }
     }
 }

 // Set custom color
 themeManager.setCustomColor(Color(red: 0.5, green: 0.3, blue: 0.8))
 */
