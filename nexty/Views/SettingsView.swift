import SwiftUI

struct SettingsView: View {
    let state: SettingsViewState
    @Environment(\.dismiss) private var dismiss

    @State private var nameField = ""
    @State private var cityField = ""
    @State private var isGeocodingCity = false

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text(String(localized: String.LocalizationValue("settings.title"), bundle: state.language.bundle))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            HStack(alignment: .top, spacing: 60) {
                // MARK: - Left Column: Settings
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        NameSection(nameField: $nameField, language: state.language)
                        .focusSection()
                    LocationSection(
                        cityField: $cityField,
                        isGeocodingCity: isGeocodingCity,
                        language: state.language,
                        onSubmit: applyCity
                    )
                    .focusSection()
                    WallpaperSection(
                        selectedWallpaper: state.wallpaperBinding,
                        language: state.language
                    )
                    .focusSection()

                    LanguagePicker(
                        selectedLanguage: state.languageBinding
                    )
                    .focusSection()

                    SettingsRow(
                        title: String(localized: String.LocalizationValue("settings.clockFormat"), bundle: state.language.bundle),
                        value: state.use24Hour ? "24H" : "12H"
                    ) {
                        state.toggleClockFormat()
                    }
                    .focusSection()

                    SettingsRow(
                        title: String(localized: String.LocalizationValue("settings.temperatureUnit"), bundle: state.language.bundle),
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
                DashboardSection(dashboardURL: state.dashboardURL, language: state.language)
                    .frame(maxWidth: .infinity)
                    .focusSection()
            }
        }
        .padding(60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(state.wallpaper.gradient.ignoresSafeArea())
        .onAppear {
            nameField = state.appState.kidName
            cityField = state.cityName ?? ""
        }
        .onDisappear {
            state.applyName(nameField)
        }
        .onChange(of: state.cityName) { _, newCity in
            if let newCity { cityField = newCity }
        }
        .onChange(of: state.appState.locationService.latitude) { _, _ in
            state.fetchWeather()
        }
        .onChange(of: state.language) { _, newLang in
            Task {
                await state.onLanguageChanged(newLang)
            }
        }
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
    let language: Language

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: String.LocalizationValue("settings.childName"), bundle: language.bundle))
                .font(.system(size: 31, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.leading)
                .foregroundStyle(.white.opacity(0.8))

            TextField(String(localized: String.LocalizationValue("settings.namePlaceholder"), bundle: language.bundle), text: $nameField)
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
    let language: Language
    let onSubmit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: String.LocalizationValue("settings.location"), bundle: language.bundle))
                .font(.system(size: 31, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            HStack(spacing: 16) {
                TextField(String(localized: String.LocalizationValue("settings.cityPlaceholder"), bundle: language.bundle), text: $cityField)
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
    let language: Language
    @State private var showPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(String(localized: String.LocalizationValue("settings.wallpaper"), bundle: language.bundle))
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
                WallpaperPickerView(selectedWallpaper: $selectedWallpaper, language: language)
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
            Text(String(localized: String.LocalizationValue("settings.language"), bundle: selectedLanguage.bundle))
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
                    Text(String(localized: String.LocalizationValue("settings.language"), bundle: selectedLanguage.bundle))
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
    let language: Language

    var body: some View {
        VStack(spacing: 20) {
            Text(String(localized: String.LocalizationValue("settings.dashboard"), bundle: language.bundle))
                .font(.system(size: 31, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            if let url = dashboardURL {
                QRCodeView(url: url)
                Text(url)
                    .font(.system(size: 29, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.9))
                Text(String(localized: String.LocalizationValue("settings.dashboardHint"), bundle: language.bundle))
                    .font(.system(size: 29, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            } else {
                Text(String(localized: String.LocalizationValue("settings.noWifi"), bundle: language.bundle))
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
