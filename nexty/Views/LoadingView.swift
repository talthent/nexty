import SwiftUI

struct LoadingView: View {
    let headerState: HeaderViewState

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(headerState.headlineText)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.5), radius: 12, y: 4)

                HStack(spacing: 10) {
                    Image(systemName: headerState.weatherSymbol ?? "sun.max.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                    Text(headerState.weatherTemperature != nil ? headerState.temperatureText : "--\u{00B0}\(headerState.useCelsius ? "C" : "F")")
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(.white.opacity(0.9))
                .shadow(color: .black.opacity(0.5), radius: 10, y: 3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 80)
            .padding(.top, 40)

            Spacer()
            ProgressView()
                .tint(.white)
            Spacer()
        }
    }
}
