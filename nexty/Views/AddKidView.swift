import SwiftUI

struct AddKidView: View {
    let onAdd: (String, Avatar) -> Void
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appLanguage) private var language

    @State private var name = ""
    @State private var selectedAvatar: Avatar = .bear
    @State private var showAvatarPicker = false
    @FocusState private var nameFieldFocused: Bool

    var body: some View {
        VStack(spacing: 40) {
            Text(LocalizedString(.profilesAddTitle, language))
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

            Text(LocalizedString(.profilesTapToChangeAvatar, language))
                .font(.system(size: 24, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))

            TextField(LocalizedString(.settingsNamePlaceholder, language), text: $name)
                .font(.system(size: 36, design: .rounded))
                .frame(height: 70)
                .frame(maxWidth: 400)
                .focused($nameFieldFocused)

            HStack(spacing: 30) {
                Button { dismiss() } label: {
                    Text(LocalizedString(.profilesCancel, language))
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
                    Text(LocalizedString(.profilesAdd, language))
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
