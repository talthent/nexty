//
//  ContentView.swift
//  nexty
//
//  Created by Tal Cohen on 18/03/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()
    @State private var showSettings = false

    var body: some View {
        Group {
            if appState.isReady {
                HomeView(state: HomeState(appState: appState)) {
                    showSettings = true
                }
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
        .environment(\.layoutDirection, appState.selectedLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    ContentView()
}
