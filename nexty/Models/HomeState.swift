import Foundation

struct HomeState {
    let headerState: HeaderViewState
    let activityCards: [ActivityCardState]
    let currentActivityIndex: Int?
    let nextActivityIndex: Int?
}

extension HomeState {
    init(appState: AppState) {
        self.headerState = HeaderViewState(appState: appState)
        self.currentActivityIndex = appState.currentActivityIndex
        self.nextActivityIndex = appState.nextActivityIndex
        self.activityCards = appState.activities.enumerated().map { index, activity in
            ActivityCardState(activity: activity, index: index, appState: appState)
        }
    }
}
