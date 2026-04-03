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
        let format = "header.time".localized(language)
        return String(format: format, greeting, kidName, timeString)
    }

    var temperatureText: String {
        let unit = useCelsius ? "C" : "F"
        guard let temp = weatherTemperature else { return "--\u{00B0}\(unit)" }
        let displayTemp = useCelsius ? temp : Int(Double(temp) * 9.0 / 5.0 + 32)
        return "\(displayTemp)\u{00B0}\(unit)"
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
