import SwiftUI

struct WallpaperPickerView: View {
    @Binding var selectedWallpaper: Wallpaper
    let language: Language
    @Environment(\.dismiss) private var dismiss

    @State private var previewIndex: Int

    private let wallpapers = Wallpaper.allCases

    init(selectedWallpaper: Binding<Wallpaper>, language: Language) {
        self._selectedWallpaper = selectedWallpaper
        self.language = language
        let idx = Wallpaper.allCases.firstIndex(of: selectedWallpaper.wrappedValue) ?? 0
        self._previewIndex = State(initialValue: idx)
    }

    private var currentWallpaper: Wallpaper {
        wallpapers[previewIndex]
    }

    var body: some View {
        VStack {
            Spacer()

            Text(currentWallpaper.title(for: language))
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.4), radius: 8, y: 4)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.3), value: previewIndex)

            Spacer()

            HStack(spacing: 16) {
                ForEach(Array(wallpapers.enumerated()), id: \.element.id) { index, wallpaper in
                    ZStack {
                        if let imageName = wallpaper.imageName {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 70)
                                .clipped()
                        } else {
                            wallpaper.gradient
                        }
                    }
                    .frame(width: 120, height: 70)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(index == previewIndex ? Color.white : Color.clear, lineWidth: 3)
                    )
                    .opacity(index == previewIndex ? 1 : 0.5)
                    .scaleEffect(index == previewIndex ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.25), value: previewIndex)
                }
            }
            .padding(.bottom, 16)

            Text("\(previewIndex + 1) / \(wallpapers.count)")
                .font(.system(size: 29, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                if let imageName = currentWallpaper.imageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                } else {
                    currentWallpaper.gradient
                        .ignoresSafeArea()
                }
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
            }
            .animation(.easeInOut(duration: 0.4), value: previewIndex)
        }
        .onMoveCommand { direction in
            withAnimation {
                switch direction {
                case .left:
                    if previewIndex > 0 { previewIndex -= 1 }
                case .right:
                    if previewIndex < wallpapers.count - 1 { previewIndex += 1 }
                default:
                    break
                }
            }
            selectedWallpaper = currentWallpaper
        }
    }
}

#Preview {
    WallpaperPickerView(selectedWallpaper: .constant(.minions), language: .english)
}

#Preview("Hebrew") {
    WallpaperPickerView(selectedWallpaper: .constant(.bluey), language: .hebrew)
        .environment(\.layoutDirection, .rightToLeft)
}
