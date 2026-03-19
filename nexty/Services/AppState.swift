import SwiftUI

@Observable
final class AppState {
    var isReady = false

    // MARK: - Persisted Settings

    var kidName: String {
        didSet { UserDefaults.standard.set(kidName, forKey: "kidName") }
    }

    var selectedWallpaper: Wallpaper {
        didSet { UserDefaults.standard.set(selectedWallpaper.rawValue, forKey: "wallpaper") }
    }

    var selectedLanguage: Language {
        didSet { UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "language") }
    }

    var use24Hour: Bool {
        didSet { UserDefaults.standard.set(use24Hour, forKey: "use24Hour") }
    }

    var useCelsius: Bool {
        didSet { UserDefaults.standard.set(useCelsius, forKey: "useCelsius") }
    }

    // MARK: - Activities

    var activities: [Activity] {
        didSet { saveActivities() }
    }

    private static let sharedDefaults = UserDefaults(suiteName: "group.com.talthent.nexty") ?? .standard

    private func saveActivities() {
        guard let data = try? JSONEncoder().encode(activities) else { return }
        Self.sharedDefaults.set(data, forKey: "activities")
        UserDefaults.standard.set(data, forKey: "activities")
    }

    private static func loadActivities() -> [Activity] {
        let data = sharedDefaults.data(forKey: "activities") ?? UserDefaults.standard.data(forKey: "activities")
        guard let data,
              let decoded = try? JSONDecoder().decode([Activity].self, from: data),
              !decoded.isEmpty else {
            return Activity.defaultSchedule
        }
        return decoded
    }

    func replaceActivities(_ new: [Activity]) {
        activities = new
    }

    // MARK: - Time

    private(set) var currentTime = Date()
    private var clockTimer: Timer?

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        let key: String
        if hour < 5 { key = "greeting.night" }
        else if hour < 12 { key = "greeting.morning" }
        else if hour < 17 { key = "greeting.afternoon" }
        else if hour < 21 { key = "greeting.evening" }
        else { key = "greeting.night" }
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
        guard let current = currentActivityIndex else {
            return activities.isEmpty ? nil : 0
        }
        return current + 1 < activities.count ? current + 1 : nil
    }

    // MARK: - Weather & Location

    let weatherService = WeatherService()
    let locationService = LocationService()

    func fetchWeather() {
        guard let lat = locationService.latitude,
              let lon = locationService.longitude else { return }
        Task { await weatherService.fetch(latitude: lat, longitude: lon) }
    }

    // MARK: - Dashboard

    let dashboardServer = DashboardServer()

    private(set) var dashboardURL: String?

    private func updateDashboardURL() {
        Task.detached {
            let ip = NetworkInfo.localIPAddress()
            await MainActor.run {
                if let ip {
                    self.dashboardURL = "http://\(ip):\(self.dashboardServer.port)"
                } else {
                    self.dashboardURL = nil
                }
            }
        }
    }

    // MARK: - Lifecycle

    init() {
        kidName = UserDefaults.standard.string(forKey: "kidName") ?? "Buddy"
        selectedWallpaper = Wallpaper(rawValue: UserDefaults.standard.string(forKey: "wallpaper") ?? "") ?? .softBlue
        selectedLanguage = Language(rawValue: UserDefaults.standard.string(forKey: "language") ?? "") ?? .english
        use24Hour = UserDefaults.standard.object(forKey: "use24Hour") as? Bool ?? true
        useCelsius = UserDefaults.standard.object(forKey: "useCelsius") as? Bool ?? true
        activities = Self.loadActivities()
    }

    func start() {
        startClock()
        locationService.preferredLocale = Locale(identifier: selectedLanguage.rawValue)
        if locationService.hasLocation {
            fetchWeather()
            if locationService.needsLocaleUpdate {
                Task {
                    guard let lat = locationService.latitude,
                          let lon = locationService.longitude else { return }
                    await locationService.reverseGeocode(latitude: lat, longitude: lon)
                }
            }
        } else {
            Task {
                await locationService.resolveFromDeviceRegion()
                fetchWeather()
            }
        }
        DispatchQueue.main.async {
            self.dashboardServer.start(appState: self)
            self.updateDashboardURL()
            self.isReady = true
        }
    }

    private func startClock() {
        clockTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.currentTime = Date()
        }
    }
}
