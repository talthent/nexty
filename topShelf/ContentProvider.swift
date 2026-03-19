import TVServices

class ContentProvider: TVTopShelfContentProvider {
    override func loadTopShelfContent() async -> (any TVTopShelfContent)? {
        let defaults = UserDefaults(suiteName: "group.com.talthent.nexty")
        let kids = Self.loadKids(from: defaults)
        guard !kids.isEmpty else { return nil }

        let langRaw = defaults?.string(forKey: "language") ?? "en"
        let language = Language(rawValue: langRaw) ?? .english

        var sections: [TVTopShelfItemCollection<TVTopShelfSectionedItem>] = []

        for kid in kids {
            guard let currentIdx = Activity.currentIndex(in: kid.activities, at: Date()) else { continue }

            var items: [TVTopShelfSectionedItem] = []

            let current = kid.activities[currentIdx]
            let currentItem = TVTopShelfSectionedItem(identifier: "\(kid.id)-current")
            currentItem.title = "NOW: \(current.title(for: language))"
            items.append(currentItem)

            if currentIdx + 1 < kid.activities.count {
                let next = kid.activities[currentIdx + 1]
                let nextItem = TVTopShelfSectionedItem(identifier: "\(kid.id)-next")
                nextItem.title = "NEXT: \(next.title(for: language))"
                items.append(nextItem)
            }

            let section = TVTopShelfItemCollection(items: items)
            section.title = kid.name
            sections.append(section)
        }

        guard !sections.isEmpty else { return nil }
        return TVTopShelfSectionedContent(sections: sections)
    }

    private static func loadKids(from defaults: UserDefaults?) -> [Kid] {
        guard let data = defaults?.data(forKey: "kids"),
              let decoded = try? JSONDecoder().decode([Kid].self, from: data),
              !decoded.isEmpty else {
            // Fallback: try legacy single-kid format
            return loadLegacy(from: defaults)
        }
        return decoded
    }

    private static func loadLegacy(from defaults: UserDefaults?) -> [Kid] {
        guard let data = defaults?.data(forKey: "activities"),
              let activities = try? JSONDecoder().decode([Activity].self, from: data) else {
            return []
        }
        return [Kid(name: "Buddy", activities: activities)]
    }
}
