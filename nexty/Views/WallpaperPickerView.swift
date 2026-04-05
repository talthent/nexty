import SwiftUI
import UIKit

struct WallpaperPickerView: View {
    @Binding var selectedWallpaper: Wallpaper
    @Environment(\.appLanguage) private var language
    @Environment(\.dismiss) private var dismiss

    @State private var previewWallpaper: Wallpaper
    @State private var previewImage: UIImage?
    @FocusState private var focusedWallpaper: Wallpaper?

    private let wallpapers = Wallpaper.allCases
    private let columns = Array(repeating: GridItem(.fixed(120), spacing: 12), count: 6)

    init(selectedWallpaper: Binding<Wallpaper>) {
        self._selectedWallpaper = selectedWallpaper
        self._previewWallpaper = State(initialValue: selectedWallpaper.wrappedValue)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Title
            Text(previewWallpaper.title(for: language))
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.4), radius: 8, y: 4)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.3), value: previewWallpaper)
                .padding(.top, 40)

            Spacer()

            // Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(wallpapers) { wallpaper in
                        Button {
                            selectedWallpaper = wallpaper
                            dismiss()
                        } label: {
                            ZStack {
                                if let imageName = wallpaper.imageName {
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 68)
                                        .clipped()
                                } else {
                                    wallpaper.gradient
                                }
                            }
                            .frame(width: 120, height: 68)
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(wallpaper == selectedWallpaper ? Color.yellow : Color.clear, lineWidth: 3)
                            )
                        }
                        .buttonStyle(.card)
                        .focused($focusedWallpaper, equals: wallpaper)
                    }
                }
                .padding(.horizontal, 24)
            }
            .scrollClipDisabled()

            Spacer()

            // CTA
            Button {
                selectedWallpaper = previewWallpaper
                dismiss()
            } label: {
                Text("wallpicker.select".localized(language))
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.card)
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            ZStack {
                Color.black.ignoresSafeArea()
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                        .transition(.opacity)
                } else if previewWallpaper.imageName == nil {
                    previewWallpaper.gradient.ignoresSafeArea()
                }
                Color.black.opacity(0.3).ignoresSafeArea()
            }
            .animation(.easeInOut(duration: 0.4), value: previewImage)
            .animation(.easeInOut(duration: 0.4), value: previewWallpaper)
        }
        .task(id: previewWallpaper) {
            await loadPreviewImage(for: previewWallpaper)
        }
        .onChange(of: focusedWallpaper) { _, newValue in
            if let newValue {
                previewWallpaper = newValue
            }
        }
        .environment(\.layoutDirection, language.isRTL ? .rightToLeft : .leftToRight)
    }

    private func loadPreviewImage(for wallpaper: Wallpaper) async {
        guard let imageName = wallpaper.imageName else {
            previewImage = nil
            return
        }
        guard let uiImage = UIImage(named: imageName) else { return }
        if let prepared = await uiImage.byPreparingForDisplay() {
            // Only update if we're still showing this wallpaper
            if previewWallpaper == wallpaper {
                previewImage = prepared
            }
        }
    }
}

#Preview {
    WallpaperPickerView(selectedWallpaper: .constant(.minions))
        .environment(\.appLanguage, .english)
}

#Preview("Hebrew") {
    WallpaperPickerView(selectedWallpaper: .constant(.bluey))
        .environment(\.appLanguage, .hebrew)
        .environment(\.layoutDirection, .rightToLeft)
}
