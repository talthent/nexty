import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()
    @State private var showSettings = false

    var body: some View {
        Group {
            if appState.isReady {
                HomeView(
                    state: HomeState(appState: appState),
                    actions: HomeActions(
                        settingsTapped: { showSettings = true },
                        kidSelected: { appState.selectedKidIndex = $0 },
                        addKid: { name, avatar in
                            appState.addKid(name: name, avatar: avatar)
                            appState.selectedKidIndex = appState.kids.count - 1
                        },
                        updateKidName: { appState.updateKidName($0, at: $1) },
                        updateKidAvatar: { appState.updateKidAvatar($0, at: $1) },
                        updateKidWallpaper: { appState.updateKidWallpaper($0, at: $1) },
                        removeKid: { appState.removeKid(at: $0) },
                        addActivity: { appState.addActivity($0) },
                        updateActivity: { appState.updateActivity($0) },
                        removeActivity: { appState.removeActivity($0) }
                    )
                )
            } else {
                LoadingView(headerState: HeaderViewState(appState: appState))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            if let imageName = appState.selectedWallpaper.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            } else {
                appState.selectedWallpaper.gradient
                    .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView(state: SettingsViewState(appState: appState))
        }
        .onAppear {
            appState.start()
        }
        .onChange(of: appState.locationService.latitude) { _, _ in
            appState.fetchWeather()
        }
        .environment(\.appLanguage, appState.selectedLanguage)
        .environment(\.layoutDirection, appState.selectedLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    ContentView()
}
