import Foundation

struct HeaderViewState {
    let greeting: String
    let kidName: String
    let timeString: String
    let language: Language
    let weatherTemperature: Int?
    let weatherSymbol: String?
    let useCelsius: Bool

    var headlineText: String {
        let format = String(localized: String.LocalizationValue("header.time"), bundle: language.bundle)
        return String(format: format, greeting, kidName, timeString)
    }

    var temperatureText: String {
        guard let temp = weatherTemperature else { return "" }
        let displayTemp = useCelsius ? temp : Int(Double(temp) * 9.0 / 5.0 + 32)
        return "\(displayTemp)\u{00B0}\(useCelsius ? "C" : "F")"
    }
}

extension HeaderViewState {
    init(appState: AppState) {
        self.greeting = appState.greeting
        self.kidName = appState.kidName
        self.timeString = appState.timeString
        self.language = appState.selectedLanguage
        self.weatherTemperature = appState.weatherService.temperature
        self.weatherSymbol = appState.weatherService.symbolName
        self.useCelsius = appState.useCelsius
    }
}
