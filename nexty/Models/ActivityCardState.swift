import Foundation

struct ActivityCardState {
    let activity: Activity
    let language: Language
    let use24Hour: Bool
    let isCurrent: Bool
    let isNext: Bool
    let isPast: Bool

    var timeString: String {
        activity.timeString(use24Hour: use24Hour)
    }

    var title: String {
        activity.title(for: language)
    }

    var imageName: String {
        activity.imageName
    }

    var opacity: Double {
        isPast ? 0.6 : 1.0
    }

    enum Badge {
        case now, comingNext, none
    }

    var badge: Badge {
        if isCurrent { return .now }
        if isNext { return .comingNext }
        return .none
    }
}

extension ActivityCardState {
    init(activity: Activity, index: Int, appState: AppState) {
        self.activity = activity
        self.language = appState.selectedLanguage
        self.use24Hour = appState.use24Hour
        self.isCurrent = index == appState.currentActivityIndex
        self.isNext = index == appState.nextActivityIndex
        self.isPast = index < (appState.currentActivityIndex ?? 0)
    }
}
