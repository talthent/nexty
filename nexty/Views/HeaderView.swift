import SwiftUI

struct HeaderView: View {
    let state: HeaderViewState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(state.headlineText)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.5), radius: 12, y: 4)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.6), value: state.timeString)

            HStack(spacing: 10) {
                Image(systemName: state.weatherSymbol ?? "sun.max.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 30))
                    .transition(.scale.combined(with: .opacity))
                Text(state.weatherTemperature != nil ? state.temperatureText : "--\u{00B0}\(state.useCelsius ? "C" : "F")")
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .contentTransition(.numericText())
            }
            .foregroundStyle(.white.opacity(0.9))
            .shadow(color: .black.opacity(0.5), radius: 10, y: 3)
            .animation(.easeInOut(duration: 0.8), value: state.weatherSymbol)
        }
    }
}

#Preview("English with weather") {
    HeaderView(state: HeaderViewState(
        greeting: "Good morning",
        kidName: "Ariel",
        timeString: "8:30",
        language: .english,
        weatherTemperature: 22,
        weatherSymbol: "sun.max.fill",
        useCelsius: true
    ))
    .padding(60)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background {
        Image("Bluey")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}

#Preview("Hebrew") {
    HeaderView(state: HeaderViewState(
        greeting: "בוקר טוב",
        kidName: "אריאל",
        timeString: "8:30",
        language: .hebrew,
        weatherTemperature: 22,
        weatherSymbol: "cloud.sun.fill",
        useCelsius: true
    ))
    .padding(60)
    .frame(maxWidth: .infinity, alignment: .trailing)
    .background {
        Image("Minions")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
    .environment(\.layoutDirection, .rightToLeft)
}

#Preview("No weather") {
    HeaderView(state: HeaderViewState(
        greeting: "Good afternoon",
        kidName: "Ariel",
        timeString: "2:15 PM",
        language: .english,
        weatherTemperature: nil,
        weatherSymbol: nil,
        useCelsius: false
    ))
    .padding(60)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color(red: 0.42, green: 0.56, blue: 0.78))
}
