import SwiftUI

struct SettingsView: View {
    let state: SettingsViewState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appLanguage) private var language

    @State private var nameField = ""
    @State private var cityField = ""
    @State private var isGeocodingCity = false

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("settings.title".localized(language))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            HStack(alignment: .top, spacing: 60) {
                // MARK: - Left Column: Settings
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        NameSection(nameField: $nameField)
                        .focusSection()
                    LocationSection(
                        cityField: $cityField,
                        isGeocodingCity: isGeocodingCity,
                        onSubmit: applyCity
                    )
                    .focusSection()
                    WallpaperSection(selectedWallpaper: state.wallpaperBinding)
                    .focusSection()

                    LanguagePicker(selectedLanguage: state.languageBinding)
                    .focusSection()

                    SettingsRow(
                        title: "settings.clockFormat".localized(language),
                        value: state.use24Hour ? "24H" : "12H"
                    ) {
                        state.toggleClockFormat()
                    }
                    .focusSection()

                    SettingsRow(
                        title: "settings.temperatureUnit".localized(language),
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
                DashboardSection(dashboardURL: state.dashboardURL)
                    .frame(maxWidth: .infinity)
                    .focusSection()
            }
        }
        .padding(60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(state.wallpaper.gradient.ignoresSafeArea())
        .onAppear {
            nameField = state.kidName
            cityField = state.cityName ?? ""
        }
        .onDisappear {
            state.applyName(nameField)
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

// MARK: - Extracted Subviews

private struct NameSection: View {
    @Binding var nameField: String
    @Environment(\.appLanguage) private var language

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("settings.childName".localized(language))
                .font(.system(size: 31, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.leading)
                .foregroundStyle(.white.opacity(0.8))

            TextField("settings.namePlaceholder".localized(language), text: $nameField)
                .font(.system(size: 32, design: .rounded))
                .multilineTextAlignment(.leading)
                .frame(height: 66)
                .frame(maxWidth: 600, alignment: .leading)
        }
    }
}

private struct LocationSection: View {
    @Binding var cityField: String
    let isGeocodingCity: Bool
    let onSubmit: () -> Void
    @Environment(\.appLanguage) private var language

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("settings.location".localized(language))
                .font(.system(size: 31, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            HStack(spacing: 16) {
                TextField("settings.cityPlaceholder".localized(language), text: $cityField)
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

private struct WallpaperSection: View {
    @Binding var selectedWallpaper: Wallpaper
    @Environment(\.appLanguage) private var language
    @State private var showPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("settings.wallpaper".localized(language))
                .font(.system(size: 31, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            Button { showPicker = true } label: {
                HStack(spacing: 14) {
                    ZStack {
                        if let imageName = selectedWallpaper.imageName {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 50)
                                .clipped()
                        } else {
                            selectedWallpaper.gradient
                        }
                    }
                    .frame(width: 80, height: 50)
                    .clipShape(.rect(cornerRadius: 10))

                    Text(selectedWallpaper.title(for: language))
                        .font(.system(size: 29, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
            }
            .buttonStyle(.card)
            .fullScreenCover(isPresented: $showPicker) {
                WallpaperPickerView(selectedWallpaper: $selectedWallpaper)
            }
        }
    }
}

#Preview {
    SettingsView(state: SettingsViewState(appState: AppState()))
}

private struct LanguagePicker: View {
    @Binding var selectedLanguage: Language
    @State private var showPicker = false

    var body: some View {
        HStack {
            Text("settings.language".localized(selectedLanguage))
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
                    Text("settings.language".localized(selectedLanguage))
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

private struct DashboardSection: View {
    let dashboardURL: String?
    @Environment(\.appLanguage) private var language

    var body: some View {
        VStack(spacing: 20) {
            Text("settings.dashboard".localized(language))
                .font(.system(size: 31, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            if let url = dashboardURL {
                QRCodeView(url: url)
                Text(url)
                    .font(.system(size: 29, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.9))
                Text("settings.dashboardHint".localized(language))
                    .font(.system(size: 29, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            } else {
                Text("settings.noWifi".localized(language))
                    .font(.system(size: 29, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(40)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 24))
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
