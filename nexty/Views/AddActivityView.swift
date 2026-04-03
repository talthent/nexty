import SwiftUI

struct AddActivityView: View {
    let onAdd: (Activity) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.appLanguage) private var language

    // nil = choosing type, non-nil = filling details
    @State private var selectedPreset: Activity.Preset?
    @State private var isCustom = false

    @State private var selectedHour = 12
    @State private var selectedMinute = 0
    @State private var customName = ""
    @State private var customIcon = Activity.customIcons[0]

    private var isDetailsMode: Bool { selectedPreset != nil || isCustom }

    var body: some View {
        VStack(spacing: 0) {
            Text("addActivity.title".localized(language))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.top, 50)
                .padding(.bottom, 30)

            if isDetailsMode {
                detailsSection
            } else {
                pickerSection
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
        .environment(\.layoutDirection, language.isRTL ? .rightToLeft : .leftToRight)
    }

    // MARK: - Picker (step 1)

    private var pickerSection: some View {
        VStack(spacing: 24) {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(200), spacing: 20), count: 6), spacing: 20) {
                ForEach(Activity.presets) { preset in
                    Button {
                        selectedPreset = preset
                    } label: {
                        VStack(spacing: 10) {
                            Image("lucide-\(preset.imageName)")
                                .resizable().scaledToFit()
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .frame(height: 44)
                            Text(preset.title(for: language))
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .frame(width: 180, height: 110)
                        .background(.ultraThinMaterial)
                    }
                    .buttonStyle(.card)
                }
            }
            .padding(.horizontal, 80)

            HStack(spacing: 30) {
                Button { isCustom = true } label: {
                    HStack(spacing: 12) {
                        Image("lucide-circle-plus")
                            .resizable().scaledToFit()
                            .foregroundStyle(.white)
                            .frame(width: 28, height: 28)
                        Text("addActivity.custom".localized(language))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.card)

                Button { dismiss() } label: {
                    Text("profiles.cancel".localized(language))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.card)
            }
        }
    }

    // MARK: - Details (step 2)

    private var detailsSection: some View {
        VStack(spacing: 40) {
            // Preview of selected activity
            if let preset = selectedPreset {
                HStack(spacing: 16) {
                    Image("lucide-\(preset.imageName)")
                        .resizable().scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                    Text(preset.title(for: language))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }

            // Custom name + icon
            if isCustom {
                TextField("addActivity.namePlaceholder".localized(language), text: $customName)
                    .font(.system(size: 32, design: .rounded))
                    .frame(height: 60)
                    .frame(maxWidth: 500)

                LazyVGrid(columns: Array(repeating: GridItem(.fixed(90), spacing: 20), count: 8), spacing: 20) {
                    ForEach(Activity.customIcons, id: \.self) { icon in
                        Button {
                            customIcon = icon
                        } label: {
                            Image("lucide-\(icon)")
                                .resizable().scaledToFit()
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                                .frame(width: 70, height: 70)
                                .background(customIcon == icon ? AnyShapeStyle(.white.opacity(0.3)) : AnyShapeStyle(.ultraThinMaterial))
                        }
                        .buttonStyle(.card)
                    }
                }
                .padding(.horizontal, 100)
            }

            // Time picker
            TimePickerView(hour: $selectedHour, minute: $selectedMinute)

            // Action buttons
            HStack(spacing: 30) {
                Button {
                    confirmAdd()
                } label: {
                    Text("profiles.add".localized(language))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.card)

                Button {
                    selectedPreset = nil
                    isCustom = false
                    customName = ""
                } label: {
                    Text("addActivity.back".localized(language))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.card)
            }
        }
    }

    // MARK: - Actions

    private func confirmAdd() {
        if let preset = selectedPreset {
            let activity = Activity(
                titleKey: preset.titleKey,
                imageName: preset.imageName,
                hour: selectedHour,
                minute: selectedMinute
            )
            onAdd(activity)
            dismiss()
        } else if isCustom {
            let trimmed = customName.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { return }
            let activity = Activity(
                titleKey: "custom",
                imageName: customIcon,
                hour: selectedHour,
                minute: selectedMinute,
                customTitle: trimmed
            )
            onAdd(activity)
            dismiss()
        }
    }
}
