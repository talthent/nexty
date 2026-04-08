import SwiftUI

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
                Text(LocalizedString(.profilesChooseAvatar, language))
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
