import SwiftUI

struct LanguagePickerView: View {
    @Binding var selectedLanguage: Language
    @State private var showPicker = false

    var body: some View {
        HStack {
            Text(LocalizedString(.settingsLanguage, selectedLanguage))
                .font(.system(size: 31, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            Spacer()

            Button {
                showPicker = true
            } label: {
                Text(selectedLanguage.displayName)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.card)
            .sheet(isPresented: $showPicker) {
                VStack(spacing: 30) {
                    Text(LocalizedString(.settingsLanguage, selectedLanguage))
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    ForEach(Language.allCases) { lang in
                        Button {
                            selectedLanguage = lang
                            showPicker = false
                        } label: {
                            Text(lang.displayName)
                                .font(.system(size: 32, weight: selectedLanguage == lang ? .bold : .regular, design: .rounded))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 14)
                        }
                        .buttonStyle(.card)
                    }
                }
                .padding(60)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
            }
        }
        .frame(maxWidth: 600)
    }
}
