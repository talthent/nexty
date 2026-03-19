import Foundation

enum Avatar: String, CaseIterable, Codable, Identifiable {
    case bear = "Bear"
    case bunny = "Bunny"
    case cat = "Cat"
    case dinosaur = "Dinosaur"
    case fox = "Fox"
    case lion = "Lion"
    case owl = "Owl"
    case penguin = "Penguin"
    case robot = "Robot"
    case unicorn = "Unicorn"

    var id: String { rawValue }
    var imageName: String { rawValue }

    /// Animated video file name in the bundle, if available
    var animatedVideoName: String? {
        switch self {
        case .penguin: return "owl_animated"
        case .robot: return "robot_animated"
        default: return nil
        }
    }
}

struct Kid: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var avatar: Avatar
    var wallpaper: Wallpaper
    var activities: [Activity]

    init(id: UUID = UUID(), name: String, avatar: Avatar = .bear, wallpaper: Wallpaper = .softBlue, activities: [Activity] = Activity.defaultSchedule) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.wallpaper = wallpaper
        self.activities = activities
    }
}
