import Foundation

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
