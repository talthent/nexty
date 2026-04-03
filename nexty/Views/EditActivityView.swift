import SwiftUI

struct EditActivityView: View {
    let activity: Activity
    let onSave: (Activity) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.appLanguage) private var language

    @State private var selectedHour: Int
    @State private var selectedMinute: Int
    @State private var customName: String
    @State private var customIcon: String

    init(activity: Activity, onSave: @escaping (Activity) -> Void) {
        self.activity = activity
        self.onSave = onSave
        self._selectedHour = State(initialValue: activity.hour)
        self._selectedMinute = State(initialValue: activity.minute)
        self._customName = State(initialValue: activity.customTitle ?? "")
        self._customIcon = State(initialValue: activity.imageName)
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("activity.edit".localized(language))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.top, 50)
                .padding(.bottom, 30)

            VStack(spacing: 40) {
                // Activity name display
                HStack(spacing: 16) {
                    Image("lucide-\(customIcon)")
                        .resizable().scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                    Text(activity.title(for: language))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

                // Custom name editing
                if activity.isCustom {
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
                        confirmSave()
                    } label: {
                        Text("activity.save".localized(language))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.card)

                    Button {
                        dismiss()
                    } label: {
                        Text("profiles.cancel".localized(language))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.card)
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
        .environment(\.layoutDirection, language.isRTL ? .rightToLeft : .leftToRight)
    }

    // MARK: - Actions

    private func confirmSave() {
        var updated = activity
        updated.hour = selectedHour
        updated.minute = selectedMinute
        if activity.isCustom {
            let trimmed = customName.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { return }
            updated.customTitle = trimmed
            updated.imageName = customIcon
        }
        onSave(updated)
        dismiss()
    }
}
