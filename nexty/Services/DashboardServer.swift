import Foundation
import Network

final class DashboardServer: Sendable {
    private let networkQueue = DispatchQueue(label: "com.talthent.nexty.dashboard")
    let port: UInt16 = 8080

    private nonisolated(unsafe) var listener: NWListener?
    private nonisolated(unsafe) weak var appState: AppState?

    private static let defaults = UserDefaults.standard

    @MainActor func start(appState: AppState) {
        self.appState = appState
        promoteTomorrowIfNeeded()
        Self.pruneOldWeekDays()
        guard let nwPort = NWEndpoint.Port(rawValue: port) else { return }
        do {
            listener = try NWListener(using: .tcp, on: nwPort)
        } catch { return }

        listener?.newConnectionHandler = { [weak self] connection in
            self?.handleConnection(connection)
        }
        listener?.start(queue: networkQueue)
    }

    @MainActor func stop() {
        listener?.cancel()
        listener = nil
    }

    // MARK: - Tomorrow Storage (per-kid)

    @MainActor private func promoteTomorrowIfNeeded() {
        guard let appState else { return }
        let today = Self.todayString()
        for (index, kid) in appState.kids.enumerated() {
            let dateKey = "tomorrow.\(kid.id.uuidString).date"
            let dataKey = "tomorrow.\(kid.id.uuidString).activities"
            guard let savedDate = Self.defaults.string(forKey: dateKey) else { continue }
            if savedDate <= today {
                if let data = Self.defaults.data(forKey: dataKey),
                   let activities = try? JSONDecoder().decode([Activity].self, from: data),
                   !activities.isEmpty {
                    appState.replaceActivities(activities, forKidAt: index)
                }
                Self.defaults.removeObject(forKey: dateKey)
                Self.defaults.removeObject(forKey: dataKey)
            }
        }
    }

    private static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    private static func tomorrowString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
    }

    private static func loadTomorrow(kidId: String) -> [Activity] {
        guard let data = defaults.data(forKey: "tomorrow.\(kidId).activities"),
              let decoded = try? JSONDecoder().decode([Activity].self, from: data) else {
            return []
        }
        return decoded
    }

    private static func saveTomorrow(_ activities: [Activity], kidId: String) {
        guard let data = try? JSONEncoder().encode(activities) else { return }
        defaults.set(data, forKey: "tomorrow.\(kidId).activities")
        defaults.set(tomorrowString(), forKey: "tomorrow.\(kidId).date")
    }

    // MARK: - Weekly Template Storage (per-kid)

    private static func loadTemplate(kidId: String, day: Int) -> [Activity] {
        guard let data = defaults.data(forKey: "weekTemplate.\(kidId).\(day)"),
              let decoded = try? JSONDecoder().decode([Activity].self, from: data) else {
            return Activity.defaultSchedule
        }
        return decoded
    }

    private static func saveTemplate(_ activities: [Activity], kidId: String, day: Int) {
        guard let data = try? JSONEncoder().encode(activities) else { return }
        defaults.set(data, forKey: "weekTemplate.\(kidId).\(day)")
    }

    private static func loadAllTemplates(kidId: String) -> [Int: [Activity]] {
        var result: [Int: [Activity]] = [:]
        for day in 0..<7 {
            result[day] = loadTemplate(kidId: kidId, day: day)
        }
        return result
    }

    // MARK: - Weekly Day Storage (per-kid, per-date)

    private static func loadWeekDay(kidId: String, date: String) -> [Activity]? {
        guard let data = defaults.data(forKey: "weekDay.\(kidId).\(date)"),
              let decoded = try? JSONDecoder().decode([Activity].self, from: data) else {
            return nil
        }
        return decoded
    }

    private static func saveWeekDay(_ activities: [Activity], kidId: String, date: String) {
        guard let data = try? JSONEncoder().encode(activities) else { return }
        defaults.set(data, forKey: "weekDay.\(kidId).\(date)")
    }

    // MARK: - Date Helpers

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    private static func weekdayIndex(from dateString: String) -> Int? {
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        // Calendar weekday: 1=Sun, 7=Sat → convert to 0=Sun, 6=Sat
        return Calendar.current.component(.weekday, from: date) - 1
    }

    private static func weekDates(from weekStart: String) -> [String] {
        guard let start = dateFormatter.date(from: weekStart) else { return [] }
        return (0..<7).compactMap { offset in
            Calendar.current.date(byAdding: .day, value: offset, to: start).map { dateFormatter.string(from: $0) }
        }
    }

    private static func pruneOldWeekDays() {
        let cutoff = Calendar.current.date(byAdding: .day, value: -14, to: Date())!
        let cutoffString = dateFormatter.string(from: cutoff)
        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix("weekDay.") {
            let parts = key.components(separatedBy: ".")
            // weekDay.<kidId>.<yyyy-MM-dd>
            if parts.count == 3, parts[2] < cutoffString {
                defaults.removeObject(forKey: key)
            }
        }
    }

    // MARK: - HTTP

    private nonisolated func handleConnection(_ connection: NWConnection) {
        connection.start(queue: networkQueue)
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] data, _, _, _ in
            guard let self, let data else {
                connection.cancel()
                return
            }
            let parsed = Self.parseRequest(data)
            Task { @MainActor [weak self] in
                guard let self else { return }
                let response = self.route(method: parsed.method, path: parsed.path, query: parsed.query, body: parsed.body)
                Self.sendResponse(connection, status: response.status, contentType: response.contentType, body: response.body)
            }
        }
    }

    private static func parseRequest(_ data: Data) -> (method: String, path: String, query: [String: String], body: Data?) {
        guard let str = String(data: data, encoding: .utf8) else {
            return ("GET", "/", [:], nil)
        }
        let parts = str.components(separatedBy: "\r\n\r\n")
        let headerSection = parts.first ?? ""
        let body = parts.count > 1 ? parts.dropFirst().joined(separator: "\r\n\r\n").data(using: .utf8) : nil
        let firstLine = headerSection.components(separatedBy: "\r\n").first ?? ""
        let tokens = firstLine.components(separatedBy: " ")
        let method = tokens.count > 0 ? tokens[0] : "GET"
        let rawPath = tokens.count > 1 ? tokens[1] : "/"

        // Split path and query string
        let pathParts = rawPath.components(separatedBy: "?")
        let path = pathParts[0]
        var query: [String: String] = [:]
        if pathParts.count > 1 {
            for param in pathParts[1].components(separatedBy: "&") {
                let kv = param.components(separatedBy: "=")
                if kv.count == 2 { query[kv[0]] = kv[1].removingPercentEncoding ?? kv[1] }
            }
        }
        return (method, path, query, body)
    }

    @MainActor private func kidIndex(from query: [String: String]) -> Int {
        guard let appState else { return 0 }
        if let kidId = query["kid"],
           let index = appState.kids.firstIndex(where: { $0.id.uuidString == kidId }) {
            return index
        }
        return appState.selectedKidIndex
    }

    @MainActor private func route(method: String, path: String, query: [String: String], body: Data?) -> (status: String, contentType: String, body: Data) {
        switch (method, path) {
        case ("GET", "/"):
            return ("200 OK", "text/html; charset=utf-8", Data(DashboardHTML.html.utf8))

        case ("GET", "/kids"):
            let kids = appState?.kids.map { ["id": $0.id.uuidString, "name": $0.name] } ?? []
            let data = (try? JSONSerialization.data(withJSONObject: kids)) ?? Data("[]".utf8)
            return ("200 OK", "application/json", data)

        case ("GET", "/activities"):
            let idx = kidIndex(from: query)
            let activities = appState?.kids[safe: idx]?.activities ?? []
            let data = (try? JSONEncoder().encode(activities)) ?? Data("[]".utf8)
            return ("200 OK", "application/json", data)

        case ("PUT", "/activities"):
            if let body, let decoded = try? JSONDecoder().decode([Activity].self, from: body) {
                let idx = kidIndex(from: query)
                appState?.replaceActivities(decoded, forKidAt: idx)
                return ("200 OK", "application/json", Data("{\"ok\":true}".utf8))
            }
            return ("400 Bad Request", "application/json", Data("{\"error\":\"invalid json\"}".utf8))

        case ("GET", "/activities/tomorrow"):
            let idx = kidIndex(from: query)
            let kidId = appState?.kids[safe: idx]?.id.uuidString ?? ""
            let activities = Self.loadTomorrow(kidId: kidId)
            let data = (try? JSONEncoder().encode(activities)) ?? Data("[]".utf8)
            return ("200 OK", "application/json", data)

        case ("PUT", "/activities/tomorrow"):
            if let body, let decoded = try? JSONDecoder().decode([Activity].self, from: body) {
                let idx = kidIndex(from: query)
                let kidId = appState?.kids[safe: idx]?.id.uuidString ?? ""
                if !kidId.isEmpty { Self.saveTomorrow(decoded, kidId: kidId) }
                return ("200 OK", "application/json", Data("{\"ok\":true}".utf8))
            }
            return ("400 Bad Request", "application/json", Data("{\"error\":\"invalid json\"}".utf8))

        // MARK: Weekly Template
        case ("GET", "/weekly/template/all"):
            let idx = kidIndex(from: query)
            let kidId = appState?.kids[safe: idx]?.id.uuidString ?? ""
            let templates = Self.loadAllTemplates(kidId: kidId)
            var dict: [String: [[String: Any]]] = [:]
            for (day, activities) in templates {
                if let encoded = try? JSONEncoder().encode(activities),
                   let arr = try? JSONSerialization.jsonObject(with: encoded) as? [[String: Any]] {
                    dict["\(day)"] = arr
                } else {
                    dict["\(day)"] = []
                }
            }
            let data = (try? JSONSerialization.data(withJSONObject: dict)) ?? Data("{}".utf8)
            return ("200 OK", "application/json", data)

        case ("PUT", "/weekly/template"):
            if let body, let decoded = try? JSONDecoder().decode([Activity].self, from: body),
               let dayStr = query["day"], let day = Int(dayStr), (0..<7).contains(day) {
                let idx = kidIndex(from: query)
                let kidId = appState?.kids[safe: idx]?.id.uuidString ?? ""
                if !kidId.isEmpty { Self.saveTemplate(decoded, kidId: kidId, day: day) }
                return ("200 OK", "application/json", Data("{\"ok\":true}".utf8))
            }
            return ("400 Bad Request", "application/json", Data("{\"error\":\"invalid request\"}".utf8))

        // MARK: Weekly Days
        case ("GET", "/weekly/week"):
            let idx = kidIndex(from: query)
            let kidId = appState?.kids[safe: idx]?.id.uuidString ?? ""
            let weekStart = query["weekStart"] ?? ""
            let dates = Self.weekDates(from: weekStart)
            let today = Self.todayString()
            let templates = Self.loadAllTemplates(kidId: kidId)
            var dict: [String: [[String: Any]]] = [:]
            for dateStr in dates {
                let acts: [Activity]
                if dateStr == today {
                    acts = appState?.kids[safe: idx]?.activities ?? []
                } else if let stored = Self.loadWeekDay(kidId: kidId, date: dateStr) {
                    acts = stored
                } else if let dayIdx = Self.weekdayIndex(from: dateStr) {
                    acts = templates[dayIdx] ?? []
                } else {
                    acts = []
                }
                if let encoded = try? JSONEncoder().encode(acts),
                   let arr = try? JSONSerialization.jsonObject(with: encoded) as? [[String: Any]] {
                    dict[dateStr] = arr
                } else {
                    dict[dateStr] = []
                }
            }
            let data = (try? JSONSerialization.data(withJSONObject: dict)) ?? Data("{}".utf8)
            return ("200 OK", "application/json", data)

        case ("PUT", "/weekly/day"):
            if let body, let decoded = try? JSONDecoder().decode([Activity].self, from: body),
               let dateStr = query["date"], !dateStr.isEmpty {
                let idx = kidIndex(from: query)
                let kidId = appState?.kids[safe: idx]?.id.uuidString ?? ""
                if !kidId.isEmpty {
                    if dateStr == Self.todayString() {
                        appState?.replaceActivities(decoded, forKidAt: idx)
                    } else {
                        Self.saveWeekDay(decoded, kidId: kidId, date: dateStr)
                    }
                }
                return ("200 OK", "application/json", Data("{\"ok\":true}".utf8))
            }
            return ("400 Bad Request", "application/json", Data("{\"error\":\"invalid request\"}".utf8))

        default:
            return ("404 Not Found", "text/plain", Data("Not Found".utf8))
        }
    }

    private static func sendResponse(_ connection: NWConnection, status: String, contentType: String, body: Data) {
        let header = "HTTP/1.1 \(status)\r\nContent-Type: \(contentType)\r\nContent-Length: \(body.count)\r\nAccess-Control-Allow-Origin: *\r\nConnection: close\r\n\r\n"
        var responseData = Data(header.utf8)
        responseData.append(body)
        connection.send(content: responseData, completion: .contentProcessed { _ in
            connection.cancel()
        })
    }
}

// MARK: - Safe Array Access

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
