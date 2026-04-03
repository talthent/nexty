import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()
    @State private var showSettings = false

    var body: some View {
        Group {
            if appState.isReady {
                HomeView(
                    state: HomeState(appState: appState),
                    onSettingsTapped: { showSettings = true },
                    onKidSelected: { appState.selectedKidIndex = $0 },
                    onAddKid: { name, avatar in
                        appState.addKid(name: name, avatar: avatar)
                        appState.selectedKidIndex = appState.kids.count - 1
                    },
                    onUpdateKidName: { appState.updateKidName($0, at: $1) },
                    onUpdateKidAvatar: { appState.updateKidAvatar($0, at: $1) },
                    onUpdateKidWallpaper: { appState.updateKidWallpaper($0, at: $1) },
                    onRemoveKid: { appState.removeKid(at: $0) },
                    onAddActivity: { appState.addActivity($0) },
                    onUpdateActivity: { appState.updateActivity($0) },
                    onRemoveActivity: { appState.removeActivity($0) }
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
