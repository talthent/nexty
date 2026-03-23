import SwiftUI

@Observable
final class AppState {
    var isReady = false

    // MARK: - Kids

    var kids: [Kid] {
        didSet { saveKids() }
    }

    var selectedKidIndex: Int {
        didSet {
            let clamped = min(max(selectedKidIndex, 0), kids.count - 1)
            if clamped != selectedKidIndex { selectedKidIndex = clamped }
            UserDefaults.standard.set(selectedKidIndex, forKey: "selectedKidIndex")
        }
    }

    var currentKid: Kid {
        get { kids[selectedKidIndex] }
        set { kids[selectedKidIndex] = newValue }
    }

    // Convenience proxies
    var kidName: String { currentKid.name }
    var selectedWallpaper: Wallpaper { currentKid.wallpaper }
    var activities: [Activity] { currentKid.activities }

    func addActivity(_ activity: Activity) {
        currentKid.activities.append(activity)
    }

    func updateActivity(_ activity: Activity) {
        guard let idx = currentKid.activities.firstIndex(where: { $0.id == activity.id }) else { return }
        currentKid.activities[idx] = activity
    }

    func removeActivity(_ activity: Activity) {
        currentKid.activities.removeAll { $0.id == activity.id }
    }

    func replaceActivities(_ new: [Activity]) {
        currentKid.activities = new
    }

    func replaceActivities(_ new: [Activity], forKidAt index: Int) {
        guard kids.indices.contains(index) else { return }
        kids[index].activities = new
    }

    // MARK: - Kid Management

    func addKid(name: String, avatar: Avatar = .bear) {
        kids.append(Kid(name: name, avatar: avatar))
    }

    func removeKid(at index: Int) {
        guard kids.count > 1, kids.indices.contains(index) else { return }
        kids.remove(at: index)
        if selectedKidIndex >= kids.count {
            selectedKidIndex = kids.count - 1
        }
    }

    func updateKidName(_ name: String, at index: Int) {
        guard kids.indices.contains(index) else { return }
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty { kids[index].name = trimmed }
    }

    func updateKidWallpaper(_ wallpaper: Wallpaper, at index: Int) {
        guard kids.indices.contains(index) else { return }
        kids[index].wallpaper = wallpaper
    }

    func updateKidAvatar(_ avatar: Avatar, at index: Int) {
        guard kids.indices.contains(index) else { return }
        kids[index].avatar = avatar
    }

    // MARK: - Persisted Global Settings

    var selectedLanguage: Language {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "language")
            Self.sharedDefaults.set(selectedLanguage.rawValue, forKey: "language")
        }
    }

    var use24Hour: Bool {
        didSet { UserDefaults.standard.set(use24Hour, forKey: "use24Hour") }
    }

    var useCelsius: Bool {
        didSet { UserDefaults.standard.set(useCelsius, forKey: "useCelsius") }
    }

    // MARK: - Persistence

    private static let sharedDefaults = UserDefaults(suiteName: "group.com.talthent.nexty") ?? .standard

    private func saveKids() {
        guard let data = try? JSONEncoder().encode(kids) else { return }
        Self.sharedDefaults.set(data, forKey: "kids")
        UserDefaults.standard.set(data, forKey: "kids")
    }

    private static func loadKids() -> [Kid] {
        let data = sharedDefaults.data(forKey: "kids") ?? UserDefaults.standard.data(forKey: "kids")
        if let data, let decoded = try? JSONDecoder().decode([Kid].self, from: data), !decoded.isEmpty {
            return decoded
        }
        return migrateFromSingleKid()
    }

    private static func migrateFromSingleKid() -> [Kid] {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "kidName") ?? "Buddy"
        let wallpaper = Wallpaper(rawValue: defaults.string(forKey: "wallpaper") ?? "") ?? .softBlue

        let activityData = sharedDefaults.data(forKey: "activities") ?? defaults.data(forKey: "activities")
        let activities: [Activity]
        if let activityData, let decoded = try? JSONDecoder().decode([Activity].self, from: activityData), !decoded.isEmpty {
            activities = decoded
        } else {
            activities = Activity.defaultSchedule
        }

        return [Kid(name: name, wallpaper: wallpaper, activities: activities)]
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
        return key.localized(selectedLanguage)
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = use24Hour ? "H:mm" : "h:mm a"
        return formatter.string(from: currentTime)
    }

    var currentActivityIndex: Int? {
        Activity.currentIndex(in: activities, at: currentTime)
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
        kids = Self.loadKids()
        selectedKidIndex = min(
            UserDefaults.standard.integer(forKey: "selectedKidIndex"),
            max(Self.loadKids().count - 1, 0)
        )
        selectedLanguage = Language(rawValue: UserDefaults.standard.string(forKey: "language") ?? "") ?? Language.fromSystem
        use24Hour = UserDefaults.standard.object(forKey: "use24Hour") as? Bool ?? true
        useCelsius = UserDefaults.standard.object(forKey: "useCelsius") as? Bool ?? true
    }

    deinit {
        clockTimer?.invalidate()
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
        Task { @MainActor in
            dashboardServer.start(appState: self)
            updateDashboardURL()
            isReady = true
        }
    }

    private func startClock() {
        clockTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.currentTime = Date()
        }
    }
}
