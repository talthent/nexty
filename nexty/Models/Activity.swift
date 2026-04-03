import Foundation

struct Activity: Identifiable, Equatable, Codable {
    var id: UUID
    var titleKey: String
    var imageName: String
    var hour: Int
    var minute: Int
    var customTitle: String?

    init(id: UUID = UUID(), titleKey: String, imageName: String, hour: Int, minute: Int, customTitle: String? = nil) {
        self.id = id
        self.titleKey = titleKey
        self.imageName = imageName
        self.hour = hour
        self.minute = minute
        self.customTitle = customTitle
    }

    var isCustom: Bool { customTitle != nil }

    func title(for language: Language) -> String {
        if let customTitle { return customTitle }
        return titleKey.localized(language)
    }

    func timeString(use24Hour: Bool) -> String {
        if use24Hour {
            return String(format: "%d:%02d", hour, minute)
        } else {
            let displayHour = hour % 12 == 0 ? 12 : hour % 12
            let period = hour < 12 ? "AM" : "PM"
            return String(format: "%d:%02d %@", displayHour, minute, period)
        }
    }

    static func currentIndex(in activities: [Activity], at date: Date) -> Int? {
        let cal = Calendar.current
        let minutes = cal.component(.hour, from: date) * 60 + cal.component(.minute, from: date)
        var result: Int?
        for (index, activity) in activities.enumerated() {
            if minutes >= activity.hour * 60 + activity.minute {
                result = index
            }
        }
        return result
    }

    // MARK: - Presets & Catalog

    struct Preset: Identifiable, Equatable {
        let titleKey: String
        let imageName: String
        var id: String { titleKey }

        func title(for language: Language) -> String {
            titleKey.localized(language)
        }
    }

    static let presets: [Preset] = [
        Preset(titleKey: "activity.wakeUp", imageName: "sun"),
        Preset(titleKey: "activity.breakfast", imageName: "utensils"),
        Preset(titleKey: "activity.teeth", imageName: "sparkles"),
        Preset(titleKey: "activity.getDressed", imageName: "shirt"),
        Preset(titleKey: "activity.kindergarten", imageName: "backpack"),
        Preset(titleKey: "activity.lunch", imageName: "carrot"),
        Preset(titleKey: "activity.play", imageName: "gamepad-2"),
        Preset(titleKey: "activity.judo", imageName: "swords"),
        Preset(titleKey: "activity.dinner", imageName: "utensils"),
        Preset(titleKey: "activity.bath", imageName: "bath"),
        Preset(titleKey: "activity.story", imageName: "book-open"),
        Preset(titleKey: "activity.sleep", imageName: "moon"),
    ]

    static let customIcons: [String] = [
        "star", "heart", "paintbrush", "music",
        "bike", "footprints", "person-standing", "waves",
        "circle-dot", "trophy", "dumbbell", "mountain",
        "ruler", "puzzle", "drama", "piano",
        "shopping-cart", "house", "car", "bus",
        "leaf", "dog", "cat", "paw-print",
    ]

    static let defaultSchedule: [Activity] = [
        Activity(titleKey: "activity.wakeUp", imageName: "sun", hour: 7, minute: 0),
        Activity(titleKey: "activity.breakfast", imageName: "utensils", hour: 7, minute: 30),
        Activity(titleKey: "activity.teeth", imageName: "sparkles", hour: 8, minute: 0),
        Activity(titleKey: "activity.getDressed", imageName: "shirt", hour: 8, minute: 15),
        Activity(titleKey: "activity.kindergarten", imageName: "backpack", hour: 8, minute: 30),
        Activity(titleKey: "activity.lunch", imageName: "carrot", hour: 12, minute: 30),
        Activity(titleKey: "activity.play", imageName: "gamepad-2", hour: 15, minute: 0),
        Activity(titleKey: "activity.judo", imageName: "swords", hour: 17, minute: 0),
        Activity(titleKey: "activity.dinner", imageName: "utensils", hour: 18, minute: 0),
        Activity(titleKey: "activity.bath", imageName: "bath", hour: 18, minute: 30),
        Activity(titleKey: "activity.story", imageName: "book-open", hour: 19, minute: 0),
        Activity(titleKey: "activity.sleep", imageName: "moon", hour: 19, minute: 30),
    ]
}
