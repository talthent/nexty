import SwiftUI

enum Wallpaper: String, CaseIterable, Codable, Identifiable {
    // Gradient only
    case softBlue = "softBlue"

    // Minions / Despicable Me
    case minions = "minions"
    case minionsGroup = "minionsGroup"
    case minionsParty = "minionsParty"
    case minionCoffee = "minionCoffee"
    case minionsSwimming = "minionsSwimming"
    case minionCat = "minionCat"
    case minionsLunch = "minionsLunch"
    case gru = "gru"

    // Bluey
    case bluey = "bluey"
    case blueyBeach = "blueyBeach"
    case blueyCity = "blueyCity"
    case blueyNight = "blueyNight"
    case blueyParty = "blueyParty"

    // Gabby's Dollhouse
    case gabby = "gabby"
    case gabbyCats = "gabbyCats"
    case gabbyGroup = "gabbyGroup"

    // Paw Patrol
    case pawPatrol = "pawPatrol"
    case pawPatrolSuper = "pawPatrolSuper"

    // Smurfs
    case smurfs = "smurfs"
    case smurfsClassic = "smurfsClassic"

    // Spidey & His Amazing Friends
    case spidey = "spidey"
    case spideySwing = "spideySwing"
    case spideyConfetti = "spideyConfetti"

    var id: String { rawValue }

    var imageName: String? {
        switch self {
        case .softBlue: nil
        case .minions: "Minions"
        case .minionsGroup: "MinionsGroup"
        case .minionsParty: "MinionsParty"
        case .minionCoffee: "MinionCoffee"
        case .minionsSwimming: "MinionsSwimming"
        case .minionCat: "MinionCat"
        case .minionsLunch: "MinionsLunch"
        case .gru: "Gru"
        case .bluey: "Bluey"
        case .blueyBeach: "BlueyBeach"
        case .blueyCity: "BlueyCity"
        case .blueyNight: "BlueyNight"
        case .blueyParty: "BlueyParty"
        case .gabby: "Gabby"
        case .gabbyCats: "GabbyCats"
        case .gabbyGroup: "GabbyGroup"
        case .pawPatrol: "PawPatrol"
        case .pawPatrolSuper: "PawPatrolSuper"
        case .smurfs: "Smurfs"
        case .smurfsClassic: "SmurfsClassic"
        case .spidey: "Spidey"
        case .spideySwing: "SpideySwing"
        case .spideyConfetti: "SpideyConfetti"
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
        case .bluey, .blueyBeach, .blueyCity:
            LinearGradient(
                colors: [Color(red: 0.53, green: 0.81, blue: 0.92), Color(red: 0.36, green: 0.54, blue: 0.66)],
                startPoint: .top, endPoint: .bottom
            )
        case .blueyNight:
            LinearGradient(
                colors: [Color(red: 0.30, green: 0.25, blue: 0.50), Color(red: 0.15, green: 0.12, blue: 0.30)],
                startPoint: .top, endPoint: .bottom
            )
        case .blueyParty:
            LinearGradient(
                colors: [Color(red: 0.55, green: 0.30, blue: 0.75), Color(red: 0.35, green: 0.15, blue: 0.55)],
                startPoint: .top, endPoint: .bottom
            )
        case .gabby, .gabbyGroup:
            LinearGradient(
                colors: [Color(red: 0.78, green: 0.56, blue: 0.85), Color(red: 0.55, green: 0.36, blue: 0.65)],
                startPoint: .top, endPoint: .bottom
            )
        case .gabbyCats:
            LinearGradient(
                colors: [Color(red: 0.60, green: 0.85, blue: 0.55), Color(red: 0.45, green: 0.65, blue: 0.80)],
                startPoint: .top, endPoint: .bottom
            )
        case .pawPatrol:
            LinearGradient(
                colors: [Color(red: 0.55, green: 0.75, blue: 0.90), Color(red: 0.85, green: 0.65, blue: 0.40)],
                startPoint: .top, endPoint: .bottom
            )
        case .pawPatrolSuper:
            LinearGradient(
                colors: [Color(red: 0.10, green: 0.45, blue: 0.70), Color(red: 0.05, green: 0.25, blue: 0.50)],
                startPoint: .top, endPoint: .bottom
            )
        case .smurfs:
            LinearGradient(
                colors: [Color(red: 0.55, green: 0.80, blue: 0.92), Color(red: 0.40, green: 0.60, blue: 0.75)],
                startPoint: .top, endPoint: .bottom
            )
        case .smurfsClassic:
            LinearGradient(
                colors: [Color(red: 0.45, green: 0.70, blue: 0.45), Color(red: 0.30, green: 0.50, blue: 0.35)],
                startPoint: .top, endPoint: .bottom
            )
        case .spidey, .spideySwing, .spideyConfetti:
            LinearGradient(
                colors: [Color(red: 0.45, green: 0.72, blue: 0.90), Color(red: 0.30, green: 0.50, blue: 0.75)],
                startPoint: .top, endPoint: .bottom
            )
        }
    }

    var titleKey: String {
        "wallpaper.\(rawValue)"
    }

    func title(for language: Language) -> String {
        titleKey.localized(language)
    }
}
