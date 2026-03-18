import Foundation

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case hebrew = "he"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: "English"
        case .hebrew: "עברית"
        }
    }

    var isRTL: Bool { self == .hebrew }

    var bundle: Bundle {
        guard let path = Bundle.main.path(forResource: rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else { return .main }
        return bundle
    }
}

struct Activity: Identifiable, Equatable, Codable {
    var id: UUID
    var titleKey: String
    var imageName: String
    var hour: Int
    var minute: Int

    init(id: UUID = UUID(), titleKey: String, imageName: String, hour: Int, minute: Int) {
        self.id = id
        self.titleKey = titleKey
        self.imageName = imageName
        self.hour = hour
        self.minute = minute
    }

    func title(for language: Language) -> String {
        String(localized: String.LocalizationValue(titleKey), bundle: language.bundle)
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

    static let defaultSchedule: [Activity] = [
        Activity(titleKey: "activity.wakeUp", imageName: "sun.max.fill", hour: 7, minute: 0),
        Activity(titleKey: "activity.breakfast", imageName: "fork.knife", hour: 7, minute: 30),
        Activity(titleKey: "activity.teeth", imageName: "mouth.fill", hour: 8, minute: 0),
        Activity(titleKey: "activity.getDressed", imageName: "tshirt.fill", hour: 8, minute: 15),
        Activity(titleKey: "activity.school", imageName: "backpack.fill", hour: 8, minute: 30),
        Activity(titleKey: "activity.lunch", imageName: "carrot.fill", hour: 12, minute: 30),
        Activity(titleKey: "activity.play", imageName: "gamecontroller.fill", hour: 15, minute: 0),
        Activity(titleKey: "activity.judo", imageName: "figure.martial.arts", hour: 17, minute: 0),
        Activity(titleKey: "activity.dinner", imageName: "fork.knife", hour: 18, minute: 0),
        Activity(titleKey: "activity.bath", imageName: "bathtub.fill", hour: 18, minute: 30),
        Activity(titleKey: "activity.story", imageName: "book.fill", hour: 19, minute: 0),
        Activity(titleKey: "activity.sleep", imageName: "moon.zzz.fill", hour: 19, minute: 30),
    ]
}
