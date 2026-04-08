import SwiftUI

struct ProfileActions {
    let select: (Int) -> Void
    let add: (String, Avatar) -> Void
    let updateName: (String, Int) -> Void
    let updateAvatar: (Avatar, Int) -> Void
    let updateWallpaper: (Wallpaper, Int) -> Void
    let remove: (Int) -> Void
}

struct ProfileView: View {
    let kids: [Kid]
    let selectedIndex: Int
    let actions: ProfileActions

    @Environment(\.dismiss) private var dismiss
    @Environment(\.appLanguage) private var language

    @State private var editingIndex: Int?
    @State private var showAddSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text(LocalizedString(.profilesTitle, language))
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
                                actions.select(index)
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

                                Text(LocalizedString(.settingsAddKid, language))
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.6))

                                Spacer()
                            }
                            .padding(16)
                        }
                        .buttonStyle(.card)
                        .fullScreenCover(isPresented: $showAddSheet) {
                            AddKidView(onAdd: { name, avatar in
                                actions.add(name, avatar)
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
                    ProfileEditPanel(
                        kid: kids[editIdx],
                        canDelete: kids.count > 1,
                        onUpdateName: { actions.updateName($0, editIdx) },
                        onUpdateAvatar: { actions.updateAvatar($0, editIdx) },
                        onUpdateWallpaper: { actions.updateWallpaper($0, editIdx) },
                        onDelete: {
                            editingIndex = nil
                            actions.remove(editIdx)
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .focusSection()
                    .transition(.opacity)
                } else {
                    VStack {
                        Spacer()
                        Text(LocalizedString(.profilesSelectToEdit, language))
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
