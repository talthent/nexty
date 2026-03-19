import SwiftUI

struct SettingsViewState {
    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    // MARK: - Read-Only

    var language: Language { appState.selectedLanguage }
    var wallpaper: Wallpaper { appState.selectedWallpaper }
    var dashboardURL: String? { appState.dashboardURL }
    var cityName: String? { appState.locationService.cityName }
    var use24Hour: Bool { appState.use24Hour }
    var useCelsius: Bool { appState.useCelsius }

    // MARK: - Bindings

    var languageBinding: Binding<Language> {
        Binding(
            get: { appState.selectedLanguage },
            set: { appState.selectedLanguage = $0 }
        )
    }

    // MARK: - Actions

    func toggleClockFormat() {
        appState.use24Hour.toggle()
    }

    func toggleTemperatureUnit() {
        appState.useCelsius.toggle()
    }

    func geocodeCity(_ name: String) async -> Bool {
        let locale = Locale(identifier: language.rawValue)
        return await appState.locationService.geocodeCity(name, locale: locale)
    }

    func onLanguageChanged(_ newLang: Language) async {
        appState.locationService.preferredLocale = Locale(identifier: newLang.rawValue)
        guard let lat = appState.locationService.latitude,
              let lon = appState.locationService.longitude else { return }
        await appState.locationService.reverseGeocode(latitude: lat, longitude: lon)
    }
}
