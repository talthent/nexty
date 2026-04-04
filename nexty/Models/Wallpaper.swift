import SwiftUI

enum Wallpaper: String, CaseIterable, Codable, Identifiable {
    case softBlue = "softBlue"
    case minions = "minions"
    case minionsGroup = "minionsGroup"
    case minionsParty = "minionsParty"
    case bluey = "bluey"
    case gabby = "gabby"
    case gru = "gru"
    case minionCoffee = "minionCoffee"
    case minionsSwimming = "minionsSwimming"
    case minionCat = "minionCat"
    case minionsLunch = "minionsLunch"

    var id: String { rawValue }

    var imageName: String? {
        switch self {
        case .softBlue: nil
        case .minions: "Minions"
        case .minionsGroup: "MinionsGroup"
        case .minionsParty: "MinionsParty"
        case .bluey: "Bluey"
        case .gabby: "Gabby"
        case .gru: "Gru"
        case .minionCoffee: "MinionCoffee"
        case .minionsSwimming: "MinionsSwimming"
        case .minionCat: "MinionCat"
        case .minionsLunch: "MinionsLunch"
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .softBlue:
            LinearGradient(
                colors: [Color(red: 0.68, green: 0.82, blue: 0.95), Color(red: 0.42, green: 0.56, blue: 0.78)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .minions, .minionsGroup, .minionsParty, .minionCoffee, .minionsSwimming, .minionCat, .minionsLunch:
            LinearGradient(
                colors: [Color(red: 0.95, green: 0.85, blue: 0.30), Color(red: 0.40, green: 0.55, blue: 0.75)],
                startPoint: .top, endPoint: .bottom
            )
        case .gru:
            LinearGradient(
                colors: [Color(red: 0.10, green: 0.15, blue: 0.30), Color(red: 0.05, green: 0.08, blue: 0.18)],
                startPoint: .top, endPoint: .bottom
            )
        case .bluey:
            LinearGradient(
                colors: [Color(red: 0.53, green: 0.81, blue: 0.92), Color(red: 0.36, green: 0.54, blue: 0.66)],
                startPoint: .top, endPoint: .bottom
            )
        case .gabby:
            LinearGradient(
                colors: [Color(red: 0.78, green: 0.56, blue: 0.85), Color(red: 0.55, green: 0.36, blue: 0.65)],
                startPoint: .top, endPoint: .bottom
            )
        }
    }

    var titleKey: String {
        switch self {
        case .softBlue: "wallpaper.softBlue"
        case .minions: "wallpaper.minions"
        case .minionsGroup: "wallpaper.minionsGroup"
        case .minionsParty: "wallpaper.minionsParty"
        case .bluey: "wallpaper.bluey"
        case .gabby: "wallpaper.gabby"
        case .gru: "wallpaper.gru"
        case .minionCoffee: "wallpaper.minionCoffee"
        case .minionsSwimming: "wallpaper.minionsSwimming"
        case .minionCat: "wallpaper.minionCat"
        case .minionsLunch: "wallpaper.minionsLunch"
        }
    }

    func title(for language: Language) -> String {
        titleKey.localized(language)
    }

}
