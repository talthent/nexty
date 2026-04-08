import SwiftUI

struct DashboardSectionView: View {
    let dashboardURL: String?
    @Environment(\.appLanguage) private var language

    var body: some View {
        VStack(spacing: 20) {
            Text(LocalizedString(.settingsDashboard, language))
                .font(.system(size: 31, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

            if let url = dashboardURL {
                QRCodeView(url: url)
                Text(url)
                    .font(.system(size: 29, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.9))
                Text(LocalizedString(.settingsDashboardHint, language))
                    .font(.system(size: 29, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            } else {
                Text(LocalizedString(.settingsNoWifi, language))
                    .font(.system(size: 29, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(40)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 24))
    }
}
