import SwiftUI

struct SettingsView: View {
    let state: SettingsViewState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appLanguage) private var language

    @State private var cityField = ""
    @State private var isGeocodingCity = false

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text(LocalizedString(.settingsTitle, language))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            HStack(alignment: .top, spacing: 60) {
                // MARK: - Left Column: Settings
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        LocationSection(
                            cityField: $cityField,
                            isGeocodingCity: isGeocodingCity,
                            onSubmit: applyCity
                        )
                        .focusSection()

                        LanguagePickerView(selectedLanguage: state.languageBinding)
                            .focusSection()

                        SettingsRow(
                            title: LocalizedString(.settingsClockFormat, language),
                            value: state.use24Hour ? "24H" : "12H"
                        ) {
                            state.toggleClockFormat()
                        }
                        .focusSection()

                        SettingsRow(
                            title: LocalizedString(.settingsTemperatureUnit, language),
                            value: state.useCelsius ? "\u{00B0}C" : "\u{00B0}F"
                        ) {
                            state.toggleTemperatureUnit()
                        }
                        .focusSection()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                }
                .scrollClipDisabled()
                .focusSection()

                // MARK: - Right Column: Dashboard
                DashboardSectionView(dashboardURL: state.dashboardURL)
                    .frame(maxWidth: .infinity)
                    .focusSection()
            }
        }
        .padding(60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(state.wallpaper.gradient.ignoresSafeArea())
        .onAppear {
            cityField = state.cityName ?? ""
        }
        .onChange(of: state.cityName) { _, newCity in
            if let newCity { cityField = newCity }
        }
        .onChange(of: state.language) { _, newLang in
            Task {
                await state.onLanguageChanged(newLang)
            }
        }
        .environment(\.appLanguage, state.language)
        .environment(\.layoutDirection, state.language.isRTL ? .rightToLeft : .leftToRight)
    }

    private func applyCity() {
        let city = cityField.trimmingCharacters(in: .whitespaces)
        guard !city.isEmpty else { return }
        isGeocodingCity = true
        Task {
            _ = await state.geocodeCity(city)
            isGeocodingCity = false
        }
    }
}

#Preview {
    SettingsView(state: SettingsViewState(appState: AppState()))
}

// MARK: - Private Subviews

private struct LocationSection: View {
    @Binding var cityField: String
    let isGeocodingCity: Bool
    let onSubmit: () -> Void
    @Environment(\.appLanguage) private var language

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedString(.settingsLocation, language))
                .font(.system(size: 31, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            HStack(spacing: 16) {
                TextField(LocalizedString(.settingsCityPlaceholder, language), text: $cityField)
                    .font(.system(size: 32, design: .rounded))
                    .frame(height: 66)
                    .onSubmit(onSubmit)

                if isGeocodingCity {
                    ProgressView()
                        .tint(.white)
                }
            }
            .frame(maxWidth: 600, alignment: .leading)
        }
    }
}

private struct SettingsRow: View {
    let title: String
    let value: String
    let action: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 31, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            Spacer()

            Button(action: action) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.card)
        }
        .frame(maxWidth: 600)
    }
}
