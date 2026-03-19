import TVServices

class ContentProvider: TVTopShelfContentProvider {
    override func loadTopShelfContent() async -> (any TVTopShelfContent)? {
        let defaults = UserDefaults(suiteName: "group.com.talthent.nexty")
        let activities = Self.loadActivities(from: defaults)
        guard !activities.isEmpty else { return nil }

        let langRaw = defaults?.string(forKey: "language") ?? "en"
        let language = Language(rawValue: langRaw) ?? .english

        guard let currentIdx = Activity.currentIndex(in: activities, at: Date()) else { return nil }

        var items: [TVTopShelfSectionedItem] = []

        let current = activities[currentIdx]
        let currentItem = TVTopShelfSectionedItem(identifier: "current")
        currentItem.title = "NOW: \(current.title(for: language))"
        items.append(currentItem)

        if currentIdx + 1 < activities.count {
            let next = activities[currentIdx + 1]
            let nextItem = TVTopShelfSectionedItem(identifier: "next")
            nextItem.title = "NEXT: \(next.title(for: language))"
            items.append(nextItem)
        }

        let section = TVTopShelfItemCollection(items: items)
        section.title = "Nexty Schedule"
        return TVTopShelfSectionedContent(sections: [section])
    }

    private static func loadActivities(from defaults: UserDefaults?) -> [Activity] {
        guard let data = defaults?.data(forKey: "activities"),
              let decoded = try? JSONDecoder().decode([Activity].self, from: data) else {
            return []
        }
        return decoded
    }
}
