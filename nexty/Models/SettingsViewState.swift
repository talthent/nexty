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
    var kidName: String { appState.kidName }
    var use24Hour: Bool { appState.use24Hour }
    var useCelsius: Bool { appState.useCelsius }

    // MARK: - Bindings

    var wallpaperBinding: Binding<Wallpaper> {
        Binding(
            get: { appState.selectedWallpaper },
            set: { appState.selectedWallpaper = $0 }
        )
    }

    var languageBinding: Binding<Language> {
        Binding(
            get: { appState.selectedLanguage },
            set: { appState.selectedLanguage = $0 }
        )
    }

    // MARK: - Actions

    func applyName(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty { appState.kidName = trimmed }
    }

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

    func fetchWeather() {
        appState.fetchWeather()
    }
}
