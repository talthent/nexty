import SwiftUI

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case hebrew = "he"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: "English"
        case .hebrew: "עברית"
        }
    }

    var isRTL: Bool { self == .hebrew }

    var bundle: Bundle {
        guard let path = Bundle.main.path(forResource: rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else { return .main }
        return bundle
    }
}

// MARK: - String Localization Helper

extension String {
    func localized(_ language: Language) -> String {
        String(localized: String.LocalizationValue(self), bundle: language.bundle)
    }
}

// MARK: - Environment

private struct AppLanguageKey: EnvironmentKey {
    static let defaultValue: Language = .english
}

extension EnvironmentValues {
    var appLanguage: Language {
        get { self[AppLanguageKey.self] }
        set { self[AppLanguageKey.self] = newValue }
    }
}
