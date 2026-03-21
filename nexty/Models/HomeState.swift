import Foundation

struct HomeState {
    let headerState: HeaderViewState
    let activityCards: [ActivityCardState]
    let currentActivityIndex: Int?
    let nextActivityIndex: Int?
    let kids: [Kid]
    let selectedKidIndex: Int
}

extension HomeState {
    init(appState: AppState) {
        self.headerState = HeaderViewState(appState: appState)
        self.kids = appState.kids
        self.selectedKidIndex = appState.selectedKidIndex
        let sortedActivities = appState.activities.sorted { a, b in
            (a.hour * 60 + a.minute) < (b.hour * 60 + b.minute)
        }
        let currentIndex = Activity.currentIndex(in: sortedActivities, at: appState.currentTime)
        self.currentActivityIndex = currentIndex
        if let current = currentIndex {
            self.nextActivityIndex = current + 1 < sortedActivities.count ? current + 1 : nil
        } else {
            self.nextActivityIndex = sortedActivities.isEmpty ? nil : 0
        }
        let nextIndex = self.nextActivityIndex
        self.activityCards = sortedActivities.enumerated().map { index, activity in
            ActivityCardState(
                activity: activity,
                index: index,
                language: appState.selectedLanguage,
                use24Hour: appState.use24Hour,
                isCurrent: index == currentIndex,
                isNext: index == nextIndex,
                isPast: index < (currentIndex ?? 0)
            )
        }
    }
}
