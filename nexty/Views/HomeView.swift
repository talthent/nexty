import SwiftUI

private let idleTimeout: TimeInterval = 8

struct HomeActions {
    let settingsTapped: () -> Void
    let kidSelected: (Int) -> Void
    let addKid: (String, Avatar) -> Void
    let updateKidName: (String, Int) -> Void
    let updateKidAvatar: (Avatar, Int) -> Void
    let updateKidWallpaper: (Wallpaper, Int) -> Void
    let removeKid: (Int) -> Void
    let addActivity: (Activity) -> Void
    let updateActivity: (Activity) -> Void
    let removeActivity: (Activity) -> Void
}

struct HomeView: View {
    let state: HomeState
    let actions: HomeActions

    @FocusState private var focusedIndex: Int?
    @State private var lastFocusedIndex: Int?
    @State private var scrollProxy: ScrollViewProxy?
    @State private var idleTimer: Timer?
    @State private var visibleCards: Set<Int> = []
    @State private var showProfiles = false
    @State private var showAddActivity = false
    @State private var editingActivity: Activity?

    var body: some View {
        VStack(spacing: 30) {
            headerBar
                .focusSection()
            Spacer(minLength: 0)
            activityRail
                .focusSection()
            progressDots
                .opacity(visibleCards.count == state.activityCards.count ? 1 : 0)
            Spacer(minLength: 0)
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
                        actions: ProfileActions(
                            select: { index in
                                actions.kidSelected(index)
                                showProfiles = false
                            },
                            add: { name, avatar in
                                actions.addKid(name, avatar)
                                showProfiles = false
                            },
                            updateName: actions.updateKidName,
                            updateAvatar: actions.updateKidAvatar,
                            updateWallpaper: actions.updateKidWallpaper,
                            remove: { index in
                                actions.removeKid(index)
                                showProfiles = false
                            }
                        )
                    )
                }

                Button(action: actions.settingsTapped) {
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
                HStack(spacing: 32) {
                    ForEach(state.activityCards) { card in
                        ActivityCardView(
                            state: card,
                            onEdit: { editingActivity = $0 },
                            onDelete: { actions.removeActivity($0) }
                        )
                        .focused($focusedIndex, equals: card.index)
                        .scaleEffect(visibleCards.contains(card.index) ? 1 : 0.7)
                        .opacity(visibleCards.contains(card.index) ? 1 : 0)
                    }

                    Button { showAddActivity = true } label: {
                        VStack(spacing: 16) {
                            Image(systemName: "plus")
                                .font(.system(size: 50, weight: .medium))
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        .frame(width: CardLayout.width, height: CardLayout.height)
                        .background(.ultraThinMaterial.opacity(0.5))
                    }
                    .buttonStyle(.card)
                    .id("add")
                    .fullScreenCover(isPresented: $showAddActivity) {
                        AddActivityView(onAdd: actions.addActivity)
                    }
                }
                .scrollTargetLayout()
                .padding(.vertical, 30)
                .animation(.spring(duration: 0.5, bounce: 0.2), value: state.activityCards.map(\.id))
            }
            .scrollClipDisabled()
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, 80)
            .fullScreenCover(item: $editingActivity) { activity in
                EditActivityView(activity: activity) { updated in
                    actions.updateActivity(updated)
                }
            }
            .onAppear {
                scrollProxy = proxy
                let targetIndex = state.currentActivityIndex ?? state.nextActivityIndex
                if let targetIndex, let card = state.activityCards.first(where: { $0.index == targetIndex }) {
                    proxy.scrollTo(card.id, anchor: .center)
                }
                DispatchQueue.main.async {
                    focusedIndex = targetIndex
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
        guard let idx = state.currentActivityIndex,
              let card = state.activityCards.first(where: { $0.index == idx }) else { return }
        withAnimation(.easeInOut(duration: 0.5)) {
            scrollProxy?.scrollTo(card.id, anchor: .center)
        }
    }

    private func resetIdleTimer() {
        idleTimer?.invalidate()
        idleTimer = Timer.scheduledTimer(withTimeInterval: idleTimeout, repeats: false) { _ in
            Task { @MainActor in
                scrollToNow()
            }
        }
    }
}
