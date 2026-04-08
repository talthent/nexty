import SwiftUI

struct ProfileEditPanel: View {
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
                        Text(LocalizedString(.settingsChildName, language))
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))

                        TextField(LocalizedString(.settingsNamePlaceholder, language), text: $nameField)
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
                    Text(LocalizedString(.settingsWallpaper, language))
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
                            Text(LocalizedString(.profilesDelete, language))
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
