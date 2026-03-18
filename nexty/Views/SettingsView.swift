import SwiftUI

struct SettingsView: View {
    @Binding var kidName: String
    @Binding var selectedWallpaper: Wallpaper
    @Binding var selectedLanguage: Language
    @Binding var use24Hour: Bool
    @Binding var useCelsius: Bool
    let locationService: LocationService
    let onLocationChanged: () -> Void
    var dashboardURL: String?
    @Environment(\.dismiss) private var dismiss

    @State private var nameField = ""
    @State private var cityField = ""
    @State private var isGeocodingCity = false

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text(String(localized: String.LocalizationValue("settings.title"), bundle: selectedLanguage.bundle))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                NameSection(nameField: $nameField, language: selectedLanguage)
                    .focusSection()
                LocationSection(
                    cityField: $cityField,
                    isGeocodingCity: isGeocodingCity,
                    language: selectedLanguage,
                    onSubmit: applyCity
                )
                .focusSection()
                WallpaperSection(selectedWallpaper: $selectedWallpaper, language: selectedLanguage)
                    .focusSection()

                HStack(spacing: 30) {
                    LanguagePicker(
                        selectedLanguage: $selectedLanguage
                    )

                    ToggleSetting(
                        title: String(localized: String.LocalizationValue("settings.clockFormat"), bundle: selectedLanguage.bundle),
                        value: use24Hour ? "24H" : "12H"
                    ) {
                        use24Hour.toggle()
                    }

                    ToggleSetting(
                        title: String(localized: String.LocalizationValue("settings.temperatureUnit"), bundle: selectedLanguage.bundle),
                        value: useCelsius ? "\u{00B0}C" : "\u{00B0}F"
                    ) {
                        useCelsius.toggle()
                    }
                }
                .focusSection()

                DashboardSection(dashboardURL: dashboardURL, language: selectedLanguage)
                    .focusSection()

                Button {
                    let trimmed = nameField.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty { kidName = trimmed }
                    dismiss()
                } label: {
                    Text(String(localized: String.LocalizationValue("settings.done"), bundle: selectedLanguage.bundle))
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.card)
                .padding(.top, 20)
            }
            .padding(60)
        }
        .background(selectedWallpaper.gradient.ignoresSafeArea())
        .onAppear {
            nameField = kidName
            cityField = locationService.cityName ?? ""
        }
        .environment(\.layoutDirection, selectedLanguage.isRTL ? .rightToLeft : .leftToRight)
    }

    private func applyCity() {
        let city = cityField.trimmingCharacters(in: .whitespaces)
        guard !city.isEmpty else { return }
        isGeocodingCity = true
        Task {
            let success = await locationService.geocodeCity(city)
            isGeocodingCity = false
            if success { onLocationChanged() }
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
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            TextField(String(localized: String.LocalizationValue("settings.namePlaceholder"), bundle: language.bundle), text: $nameField)
                .font(.system(size: 32, design: .rounded))
                .frame(height: 66)
        }
        .frame(maxWidth: 600)
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
                .font(.system(size: 28, weight: .semibold, design: .rounded))
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
        }
        .frame(maxWidth: 600)
    }
}

private struct WallpaperSection: View {
    @Binding var selectedWallpaper: Wallpaper
    let language: Language

    var body: some View {
        VStack(spacing: 16) {
            Text(String(localized: String.LocalizationValue("settings.wallpaper"), bundle: language.bundle))
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            WallpaperPickerView(selectedWallpaper: $selectedWallpaper, language: language)
        }
    }
}

#Preview {
    SettingsView(
        kidName: .constant("Buddy"),
        selectedWallpaper: .constant(.softBlue),
        selectedLanguage: .constant(.english),
        use24Hour: .constant(true),
        useCelsius: .constant(true),
        locationService: LocationService(),
        onLocationChanged: {},
        dashboardURL: "http://192.168.1.42:8080"
    )
}

#Preview("Hebrew") {
    SettingsView(
        kidName: .constant("חברה"),
        selectedWallpaper: .constant(.softBlue),
        selectedLanguage: .constant(.hebrew),
        use24Hour: .constant(true),
        useCelsius: .constant(true),
        locationService: LocationService(),
        onLocationChanged: {},
        dashboardURL: "http://192.168.1.42:8080"
    )
}

private struct LanguagePicker: View {
    @Binding var selectedLanguage: Language
    @State private var showPicker = false

    var body: some View {
        VStack(spacing: 12) {
            Text(String(localized: String.LocalizationValue("settings.language"), bundle: selectedLanguage.bundle))
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

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
    }
}

private struct DashboardSection: View {
    let dashboardURL: String?
    let language: Language

    var body: some View {
        VStack(spacing: 16) {
            Text(String(localized: String.LocalizationValue("settings.dashboard"), bundle: language.bundle))
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            if let url = dashboardURL {
                QRCodeView(url: url)
                Text(url)
                    .font(.system(size: 22, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.9))
                Text(String(localized: String.LocalizationValue("settings.dashboardHint"), bundle: language.bundle))
                    .font(.system(size: 20, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            } else {
                Text(String(localized: String.LocalizationValue("settings.noWifi"), bundle: language.bundle))
                    .font(.system(size: 22, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }
}

private struct ToggleSetting: View {
    let title: String
    let value: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            Button {
                action()
            } label: {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.card)
        }
    }
}
