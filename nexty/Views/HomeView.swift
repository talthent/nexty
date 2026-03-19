import SwiftUI

struct HomeView: View {
    let state: HomeState
    var onSettingsTapped: () -> Void = {}
    var onKidSelected: (Int) -> Void = { _ in }
    var onAddKid: (String, Avatar) -> Void = { _, _ in }
    var onUpdateKidName: (String, Int) -> Void = { _, _ in }
    var onUpdateKidAvatar: (Avatar, Int) -> Void = { _, _ in }
    var onUpdateKidWallpaper: (Wallpaper, Int) -> Void = { _, _ in }
    var onRemoveKid: (Int) -> Void = { _ in }

    @FocusState private var focusedIndex: Int?
    @State private var lastFocusedIndex: Int?
    @State private var scrollProxy: ScrollViewProxy?
    @State private var idleTimer: Timer?
    @State private var visibleCards: Set<Int> = []
    @State private var showProfiles = false

    var body: some View {
        VStack(spacing: 30) {
            headerBar
                .focusSection()
            activityRail
                .focusSection()
            progressDots
                .opacity(visibleCards.count == state.activityCards.count ? 1 : 0)
        }
        .padding(.top, 40)
        .onAppear {
            for index in state.activityCards.indices {
                _ = withAnimation(.spring(duration: 0.6, bounce: 0.3).delay(Double(index) * 0.08)) {
                    visibleCards.insert(index)
                }
            }
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
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
            HeaderView(state: state.headerState)

            Spacer()

            HStack(spacing: 30) {
                Button { showProfiles = true } label: {
                    Image(state.kids[state.selectedKidIndex].avatar.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                        .padding(10)
                        .background(.thinMaterial)
                }
                .buttonStyle(.card)
                .fullScreenCover(isPresented: $showProfiles) {
                    ProfileView(
                        kids: state.kids,
                        selectedIndex: state.selectedKidIndex,
                        onSelect: { index in
                            onKidSelected(index)
                            showProfiles = false
                        },
                        onAdd: { name, avatar in
                            onAddKid(name, avatar)
                            showProfiles = false
                        },
                        onUpdateName: onUpdateKidName,
                        onUpdateAvatar: onUpdateKidAvatar,
                        onUpdateWallpaper: onUpdateKidWallpaper,
                        onRemove: { index in
                            onRemoveKid(index)
                            showProfiles = false
                        }
                    )
                }

                Button(action: onSettingsTapped) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(16)
                        .background(.thinMaterial)
                }
                .buttonStyle(.card)
            }
        }
        .padding(.horizontal, 80)
    }

    // MARK: - Activity Rail

    private var activityRail: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 32) {
                    ForEach(Array(state.activityCards.enumerated()), id: \.offset) { index, card in
                        ActivityCardView(state: card)
                            .focused($focusedIndex, equals: index)
                            .id(index)
                            .scaleEffect(visibleCards.contains(index) ? 1 : 0.7)
                            .opacity(visibleCards.contains(index) ? 1 : 0)
                    }
                }
                .scrollTargetLayout()
                .padding(.vertical, 30)
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, 80)
            .onAppear {
                scrollProxy = proxy
                let target = state.currentActivityIndex ?? state.nextActivityIndex
                if let target {
                    proxy.scrollTo(target, anchor: .center)
                }
                DispatchQueue.main.async {
                    focusedIndex = target
                }
            }
        }
    }

    // MARK: - Progress Dots

    private var progressDots: some View {
        HStack(spacing: 12) {
            ForEach(0..<state.activityCards.count, id: \.self) { i in
                Circle()
                    .fill(i == state.currentActivityIndex ? Color.yellow : Color.white.opacity(0.3))
                    .frame(width: 16, height: 16)
            }
        }
        .padding(.bottom, 20)
    }

    // MARK: - Actions

    private func scrollToNow() {
        guard let idx = state.currentActivityIndex else { return }
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
