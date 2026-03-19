import SwiftUI
import AVKit

struct ProfileView: View {
    let kids: [Kid]
    let selectedIndex: Int
    let onSelect: (Int) -> Void
    let onAdd: (String, Avatar) -> Void
    let onUpdateName: (String, Int) -> Void
    let onUpdateAvatar: (Avatar, Int) -> Void
    let onUpdateWallpaper: (Wallpaper, Int) -> Void
    let onRemove: (Int) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.appLanguage) private var language

    @State private var editingIndex: Int?
    @State private var showAddSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("profiles.title".localized(language))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            // Two-column layout
            HStack(alignment: .top, spacing: 60) {
                // MARK: - Leading Column: Profile List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(kids.enumerated()), id: \.element.id) { index, kid in
                            Button {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    editingIndex = index
                                }
                                onSelect(index)
                            } label: {
                                HStack(spacing: 16) {
                                    Image(kid.avatar.imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 64, height: 64)
                                        .clipShape(Circle())

                                    Text(kid.name)
                                        .font(.system(size: 28, weight: index == selectedIndex ? .bold : .medium, design: .rounded))
                                        .foregroundStyle(.white)
                                        .lineLimit(1)

                                    Spacer()

                                    if index == editingIndex {
                                        Image(systemName: "chevron.forward")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundStyle(.white.opacity(0.4))
                                    }
                                }
                                .padding(16)
                                .background(
                                    index == editingIndex ? AnyShapeStyle(.thinMaterial) : AnyShapeStyle(.clear),
                                    in: .rect(cornerRadius: 16)
                                )
                            }
                            .buttonStyle(.card)
                        }

                        // Add Kid
                        Button { showAddSheet = true } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.15))
                                        .frame(width: 64, height: 64)
                                    Image(systemName: "plus")
                                        .font(.system(size: 26, weight: .bold))
                                        .foregroundStyle(.white.opacity(0.6))
                                }

                                Text("settings.addKid".localized(language))
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.6))

                                Spacer()
                            }
                            .padding(16)
                        }
                        .buttonStyle(.card)
                        .fullScreenCover(isPresented: $showAddSheet) {
                            AddKidView(onAdd: { name, avatar in
                                onAdd(name, avatar)
                                showAddSheet = false
                                editingIndex = kids.count
                            })
                        }
                    }
                    .padding(20)
                }
                .scrollClipDisabled()
                .frame(maxWidth: 420)
                .focusSection()

                // MARK: - Trailing Column: Edit Panel
                if let editIdx = editingIndex, kids.indices.contains(editIdx) {
                    EditPanel(
                        kid: kids[editIdx],
                        canDelete: kids.count > 1,
                        onUpdateName: { onUpdateName($0, editIdx) },
                        onUpdateAvatar: { onUpdateAvatar($0, editIdx) },
                        onUpdateWallpaper: { onUpdateWallpaper($0, editIdx) },
                        onDelete: {
                            editingIndex = nil
                            onRemove(editIdx)
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .focusSection()
                    .transition(.opacity)
                } else {
                    VStack {
                        Spacer()
                        Text("profiles.selectToEdit".localized(language))
                            .font(.system(size: 28, design: .rounded))
                            .foregroundStyle(.white.opacity(0.4))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            kids[safe: selectedIndex].map { kid in
                Group {
                    if let imageName = kid.wallpaper.imageName {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .ignoresSafeArea()
                    } else {
                        kid.wallpaper.gradient
                            .ignoresSafeArea()
                    }
                }
            }
        }
        .environment(\.layoutDirection, language.isRTL ? .rightToLeft : .leftToRight)
        .onAppear {
            editingIndex = selectedIndex
        }
    }
}

// MARK: - Edit Panel

private struct EditPanel: View {
    let kid: Kid
    let canDelete: Bool
    let onUpdateName: (String) -> Void
    let onUpdateAvatar: (Avatar) -> Void
    let onUpdateWallpaper: (Wallpaper) -> Void
    let onDelete: () -> Void

    @State private var nameField = ""
    @State private var showAvatarPicker = false
    @State private var showWallpaperPicker = false
    @Environment(\.appLanguage) private var language

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 36) {
                // Avatar (tappable) + name
                HStack(spacing: 24) {
                    Button { showAvatarPicker = true } label: {
                        Image(kid.avatar.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                    }
                    .clipShape(Circle())
                    .buttonStyle(.card)
                    .fullScreenCover(isPresented: $showAvatarPicker) {
                        AvatarPickerView(
                            selectedAvatar: kid.avatar,
                            onSelect: { avatar in
                                onUpdateAvatar(avatar)
                                showAvatarPicker = false
                            }
                        )
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("settings.childName".localized(language))
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))

                        TextField("settings.namePlaceholder".localized(language), text: $nameField)
                            .font(.system(size: 30, design: .rounded))
                            .frame(height: 54)
                            .frame(maxWidth: 400)
                            .onAppear { nameField = kid.name }
                            .onChange(of: kid.name) { _, val in nameField = val }
                            .onChange(of: nameField) { _, val in onUpdateName(val) }
                    }
                }

                // Wallpaper
                VStack(alignment: .leading, spacing: 14) {
                    Text("settings.wallpaper".localized(language))
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))

                    Button { showWallpaperPicker = true } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                if let imageName = kid.wallpaper.imageName {
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 50)
                                        .clipped()
                                } else {
                                    kid.wallpaper.gradient
                                }
                            }
                            .frame(width: 80, height: 50)
                            .clipShape(.rect(cornerRadius: 10))

                            Text(kid.wallpaper.title(for: language))
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.card)
                    .fullScreenCover(isPresented: $showWallpaperPicker) {
                        WallpaperPickerView(selectedWallpaper: Binding(
                            get: { kid.wallpaper },
                            set: { onUpdateWallpaper($0) }
                        ))
                    }
                }

                // Delete
                if canDelete {
                    Button(action: onDelete) {
                        HStack(spacing: 10) {
                            Image(systemName: "trash")
                                .font(.system(size: 22))
                            Text("profiles.delete".localized(language))
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.red)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.card)
                }
            }
            .padding(30)
        }
        .scrollClipDisabled()
        .background(.thinMaterial, in: .rect(cornerRadius: 24))
    }
}

// MARK: - Avatar Picker (full-screen)

struct AvatarPickerView: View {
    let selectedAvatar: Avatar
    let onSelect: (Avatar) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.appLanguage) private var language
    @State private var previewAvatar: Avatar
    @FocusState private var isFocused: Bool

    init(selectedAvatar: Avatar, onSelect: @escaping (Avatar) -> Void) {
        self.selectedAvatar = selectedAvatar
        self.onSelect = onSelect
        self._previewAvatar = State(initialValue: selectedAvatar)
    }

    var body: some View {
        VStack(spacing: 36) {
            Spacer()

            // Large animated/static preview
            AvatarPreview(avatar: previewAvatar, size: 260)

            // Avatar grid — two rows of 5
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(100), spacing: 16), count: 5), spacing: 16) {
                ForEach(Avatar.allCases) { avatar in
                    Button {
                        previewAvatar = avatar
                    } label: {
                        Image(avatar.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 86, height: 86)
                            .overlay(
                                Circle().stroke(previewAvatar == avatar ? .white : .clear, lineWidth: 3)
                            )
                            .opacity(previewAvatar == avatar ? 1 : 0.5)
                    }
                    .clipShape(Circle())
                    .buttonStyle(.card)
                }
            }
            .padding(.horizontal, 80)

            // Select button
            Button {
                onSelect(previewAvatar)
            } label: {
                Text("profiles.chooseAvatar".localized(language))
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.card)
            .focused($isFocused)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
        .onAppear { isFocused = true }
    }
}

// MARK: - Add Kid View

private struct AddKidView: View {
    let onAdd: (String, Avatar) -> Void
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appLanguage) private var language

    @State private var name = ""
    @State private var selectedAvatar: Avatar = .bear
    @State private var showAvatarPicker = false
    @FocusState private var nameFieldFocused: Bool

    var body: some View {
        VStack(spacing: 40) {
            Text("profiles.addTitle".localized(language))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            // Tappable avatar
            Button { showAvatarPicker = true } label: {
                Image(selectedAvatar.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 160)
            }
            .clipShape(Circle())
            .buttonStyle(.card)
            .fullScreenCover(isPresented: $showAvatarPicker) {
                AvatarPickerView(
                    selectedAvatar: selectedAvatar,
                    onSelect: { avatar in
                        selectedAvatar = avatar
                        showAvatarPicker = false
                    }
                )
            }

            Text("profiles.tapToChangeAvatar".localized(language))
                .font(.system(size: 24, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))

            TextField("settings.namePlaceholder".localized(language), text: $name)
                .font(.system(size: 36, design: .rounded))
                .frame(height: 70)
                .frame(maxWidth: 400)
                .focused($nameFieldFocused)

            HStack(spacing: 30) {
                Button { dismiss() } label: {
                    Text("profiles.cancel".localized(language))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.card)

                Button {
                    let trimmed = name.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    onAdd(trimmed, selectedAvatar)
                } label: {
                    Text("profiles.add".localized(language))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.card)
            }
        }
        .padding(60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
        .environment(\.layoutDirection, language.isRTL ? .rightToLeft : .leftToRight)
        .onAppear { nameFieldFocused = true }
    }
}

// MARK: - Avatar Preview (static or animated)

struct AvatarPreview: View {
    let avatar: Avatar
    let size: CGFloat

    var body: some View {
        ZStack {
            Image(avatar.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)

            if let videoName = avatar.animatedVideoName,
               let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
                LoopingVideoView(url: url)
                    .frame(width: size, height: size)
            }
        }
        .clipShape(Circle())
        .id(avatar)
    }
}

private class PlayerUIView: UIView {
    private var player: AVQueuePlayer?
    private var looper: AVPlayerLooper?
    private var playerLayer: AVPlayerLayer?

    func configure(url: URL) {
        playerLayer?.removeFromSuperlayer()
        player?.pause()

        let player = AVQueuePlayer()
        let item = AVPlayerItem(url: url)
        let looper = AVPlayerLooper(player: player, templateItem: item)
        self.player = player
        self.looper = looper

        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(layer)
        self.playerLayer = layer

        player.isMuted = true
        player.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}

private struct LoopingVideoView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()
        view.backgroundColor = .clear
        view.configure(url: url)
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {}
}
