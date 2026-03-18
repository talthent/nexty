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
    @State private var scrollProxy: ScrollViewProxy?
    @State private var idleTimer: Timer?

    @FocusState private var focusedIndex: Int?
    @State private var lastFocusedIndex: Int?
    var body: some View {
        VStack(spacing: 30) {
            headerBar
                .focusSection()
            activityRail
                .focusSection()
            progressDots
        }
        .padding(.top, 40)
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
            SettingsView(
                kidName: Binding(
                    get: { appState.kidName },
                    set: { appState.kidName = $0 }
                ),
                selectedWallpaper: Binding(
                    get: { appState.selectedWallpaper },
                    set: { appState.selectedWallpaper = $0 }
                ),
                selectedLanguage: Binding(
                    get: { appState.selectedLanguage },
                    set: { appState.selectedLanguage = $0 }
                ),
                use24Hour: Binding(
                    get: { appState.use24Hour },
                    set: { appState.use24Hour = $0 }
                ),
                useCelsius: Binding(
                    get: { appState.useCelsius },
                    set: { appState.useCelsius = $0 }
                ),
                locationService: appState.locationService,
                onLocationChanged: appState.fetchWeather,
                dashboardURL: appState.dashboardURL
            )
        }
        .onAppear {
            appState.start()
        }
        .onChange(of: appState.locationService.latitude) { _, _ in
            appState.fetchWeather()
        }
        .onChange(of: focusedIndex) { oldValue, newValue in
            if let newValue {
                lastFocusedIndex = newValue
            } else if let oldValue {
                lastFocusedIndex = oldValue
            }
            resetIdleTimer()
        }
        .onMoveCommand { direction in
            if direction == .down, focusedIndex == nil, let last = lastFocusedIndex {
                focusedIndex = last
            }
        }
        .environment(\.layoutDirection, appState.selectedLanguage.isRTL ? .rightToLeft : .leftToRight)
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
            HeaderView(
                greeting: appState.greeting,
                kidName: appState.kidName,
                timeString: appState.timeString,
                language: appState.selectedLanguage,
                weatherTemperature: appState.weatherService.temperature,
                weatherSymbol: appState.weatherService.symbolName,
                useCelsius: appState.useCelsius
            )

            Spacer()

            Button { showSettings = true } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .padding(.horizontal, 80)
    }

    // MARK: - Activity Rail

    private var activityRail: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 32) {
                    ForEach(Array(appState.activities.enumerated()), id: \.element.id) { index, activity in
                        ActivityCardView(
                            activity: activity,
                            language: appState.selectedLanguage,
                            use24Hour: appState.use24Hour,
                            isCurrent: index == appState.currentActivityIndex,
                            isNext: index == appState.nextActivityIndex,
                            isPast: index < (appState.currentActivityIndex ?? 0)
                        )
                        .focused($focusedIndex, equals: index)
                        .id(index)
                    }
                }
                .scrollTargetLayout()
                .padding(.vertical, 30)
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, 80)
            .onAppear {
                scrollProxy = proxy
                focusedIndex = appState.currentActivityIndex
                scrollToNow()
            }
        }
    }

    // MARK: - Progress Dots

    private var progressDots: some View {
        HStack(spacing: 12) {
            ForEach(0..<appState.activities.count, id: \.self) { i in
                Circle()
                    .fill(i == appState.currentActivityIndex ? Color.yellow : Color.white.opacity(0.3))
                    .frame(width: 16, height: 16)
            }
        }
        .padding(.bottom, 20)
    }

    // MARK: - Actions

    private func scrollToNow() {
        guard let idx = appState.currentActivityIndex else { return }
        withAnimation(.easeInOut(duration: 0.5)) {
            scrollProxy?.scrollTo(idx, anchor: .center)
        }
    }

    private func resetIdleTimer() {
        idleTimer?.invalidate()
        idleTimer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: false) { _ in
            Task { @MainActor in
                scrollToNow()
            }
        }
    }
}

#Preview {
    ContentView()
}
