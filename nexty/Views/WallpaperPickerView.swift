import SwiftUI

struct WallpaperPickerView: View {
    @Binding var selectedWallpaper: Wallpaper
    let language: Language

    var body: some View {
        HStack(spacing: 20) {
            ForEach(Wallpaper.allCases) { wallpaper in
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        selectedWallpaper = wallpaper
                    }
                } label: {
                    VStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(wallpaper.gradient)
                                .frame(width: 100, height: 70)

                            Image(systemName: wallpaper.iconName)
                                .font(.system(size: 28))
                                .foregroundStyle(.white)
                        }

                        Text(wallpaper.title(for: language))
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(12)
                }
                .buttonStyle(.card)
            }
        }
    }
}

#Preview {
    WallpaperPickerView(selectedWallpaper: .constant(.minions), language: .english)
        .padding(40)
        .background(Color(red: 0.42, green: 0.56, blue: 0.78))
}

#Preview("Hebrew") {
    WallpaperPickerView(selectedWallpaper: .constant(.bluey), language: .hebrew)
        .padding(40)
        .background(Color(red: 0.42, green: 0.56, blue: 0.78))
        .environment(\.layoutDirection, .rightToLeft)
}
