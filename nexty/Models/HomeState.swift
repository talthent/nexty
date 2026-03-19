import Foundation

struct HomeState {
    let headerState: HeaderViewState
    let activityCards: [ActivityCardState]
    let currentActivityIndex: Int?
    let nextActivityIndex: Int?
    let wallpaper: Wallpaper
    let isRTL: Bool
}

extension HomeState {
    init(appState: AppState) {
        self.headerState = HeaderViewState(appState: appState)
        self.currentActivityIndex = appState.currentActivityIndex
        self.nextActivityIndex = appState.nextActivityIndex
        self.wallpaper = appState.selectedWallpaper
        self.isRTL = appState.selectedLanguage.isRTL
        self.activityCards = appState.activities.enumerated().map { index, activity in
            ActivityCardState(activity: activity, index: index, appState: appState)
        }
    }
}
