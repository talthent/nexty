import SwiftUI

@Observable
final class AppState {
    // MARK: - Persisted Settings

    var kidName: String {
        get { UserDefaults.standard.string(forKey: "kidName") ?? "Buddy" }
        set { UserDefaults.standard.set(newValue, forKey: "kidName") }
    }

    var selectedWallpaper: Wallpaper {
        get { Wallpaper(rawValue: UserDefaults.standard.string(forKey: "wallpaper") ?? "") ?? .softBlue }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "wallpaper") }
    }

    var selectedLanguage: Language {
        get { Language(rawValue: UserDefaults.standard.string(forKey: "language") ?? "") ?? .english }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "language") }
    }

    var use24Hour: Bool {
        get { UserDefaults.standard.object(forKey: "use24Hour") as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: "use24Hour") }
    }

    var useCelsius: Bool {
        get { UserDefaults.standard.object(forKey: "useCelsius") as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: "useCelsius") }
    }

    // MARK: - Activities

    let activities = Activity.defaultSchedule

    // MARK: - Time

    private(set) var currentTime = Date()
    private var clockTimer: Timer?

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        let key: String
        if hour < 12 { key = "greeting.morning" }
        else if hour < 17 { key = "greeting.afternoon" }
        else { key = "greeting.evening" }
        return String(localized: String.LocalizationValue(key), bundle: selectedLanguage.bundle)
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = use24Hour ? "H:mm" : "h:mm a"
        return formatter.string(from: currentTime)
    }

    var currentActivityIndex: Int? {
        let cal = Calendar.current
        let nowMinutes = cal.component(.hour, from: currentTime) * 60
            + cal.component(.minute, from: currentTime)

        var result: Int?
        for (index, activity) in activities.enumerated() {
            if nowMinutes >= activity.hour * 60 + activity.minute {
                result = index
            }
        }
        return result
    }

    var nextActivityIndex: Int? {
        guard let current = currentActivityIndex,
              current + 1 < activities.count else { return nil }
        return current + 1
    }

    // MARK: - Weather & Location

    let weatherService = WeatherService()
    let locationService = LocationService()

    func fetchWeather() {
        guard let lat = locationService.latitude,
              let lon = locationService.longitude else { return }
        Task { await weatherService.fetch(latitude: lat, longitude: lon) }
    }

    // MARK: - Lifecycle

    func start() {
        locationService.requestLocation()
        startClock()
    }

    private func startClock() {
        clockTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.currentTime = Date()
        }
    }
}
