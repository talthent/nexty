//
//  ContentProvider.swift
//  topShelf
//
//  Created by Tal Cohen on 18/03/2026.
//

import TVServices

class ContentProvider: TVTopShelfContentProvider {
    override func loadTopShelfContent() async -> (any TVTopShelfContent)? {
        let activities = Self.loadActivities()
        guard !activities.isEmpty else { return nil }

        let now = Date()
        let cal = Calendar.current
        let nowMinutes = cal.component(.hour, from: now) * 60 + cal.component(.minute, from: now)

        var currentIdx: Int?
        for (i, a) in activities.enumerated() {
            if nowMinutes >= a.hour * 60 + a.minute {
                currentIdx = i
            }
        }

        var items: [TVTopShelfSectionedItem] = []

        if let idx = currentIdx {
            let current = activities[idx]
            let item = TVTopShelfSectionedItem(identifier: "current")
            item.title = "NOW: \(current.titleKey)"
            items.append(item)

            if idx + 1 < activities.count {
                let next = activities[idx + 1]
                let nextItem = TVTopShelfSectionedItem(identifier: "next")
                nextItem.title = "NEXT: \(next.titleKey)"
                items.append(nextItem)
            }
        }

        let section = TVTopShelfItemCollection(items: items)
        section.title = "Nexty Schedule"
        return TVTopShelfSectionedContent(sections: [section])
    }

    private static func loadActivities() -> [CodableActivity] {
        guard let defaults = UserDefaults(suiteName: "group.com.talthent.nexty"),
              let data = defaults.data(forKey: "activities"),
              let decoded = try? JSONDecoder().decode([CodableActivity].self, from: data) else {
            return []
        }
        return decoded
    }
}

private struct CodableActivity: Codable {
    let id: String
    let titleKey: String
    let imageName: String
    let hour: Int
    let minute: Int
}
