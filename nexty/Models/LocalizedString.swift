import SwiftUI

enum LocalizedStringKey: String {
    // MARK: - Header
    case headerTime = "header.time"

    // MARK: - Activity
    case activityEdit = "activity.edit"
    case activityDelete = "activity.delete"
    case activitySave = "activity.save"
    case now
    case comingNext

    // MARK: - Add Activity
    case addActivityTitle = "addActivity.title"
    case addActivityCustom = "addActivity.custom"
    case addActivityNamePlaceholder = "addActivity.namePlaceholder"
    case addActivityBack = "addActivity.back"

    // MARK: - Profiles
    case profilesTitle = "profiles.title"
    case profilesCancel = "profiles.cancel"
    case profilesAdd = "profiles.add"
    case profilesAddTitle = "profiles.addTitle"
    case profilesDelete = "profiles.delete"
    case profilesSelectToEdit = "profiles.selectToEdit"
    case profilesChooseAvatar = "profiles.chooseAvatar"
    case profilesTapToChangeAvatar = "profiles.tapToChangeAvatar"

    // MARK: - Settings
    case settingsTitle = "settings.title"
    case settingsAddKid = "settings.addKid"
    case settingsChildName = "settings.childName"
    case settingsNamePlaceholder = "settings.namePlaceholder"
    case settingsWallpaper = "settings.wallpaper"
    case settingsClockFormat = "settings.clockFormat"
    case settingsTemperatureUnit = "settings.temperatureUnit"
    case settingsLocation = "settings.location"
    case settingsCityPlaceholder = "settings.cityPlaceholder"
    case settingsLanguage = "settings.language"
    case settingsDashboard = "settings.dashboard"
    case settingsDashboardHint = "settings.dashboardHint"
    case settingsNoWifi = "settings.noWifi"

    // MARK: - Wallpaper Picker
    case wallpickerSelect = "wallpicker.select"

    func localized(_ language: Language) -> String {
        rawValue.localized(language)
    }
}

// Convenience for LocalizedString(.key, language) syntax
func LocalizedString(_ key: LocalizedStringKey, _ language: Language) -> String {
    key.localized(language)
}
