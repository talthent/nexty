import SwiftUI

struct HeaderView: View {
    let greeting: String
    let kidName: String
    let timeString: String
    let language: Language
    let weatherTemperature: Int?
    let weatherSymbol: String?
    let useCelsius: Bool

    private var headlineText: String {
        let format = String(localized: String.LocalizationValue("header.time"), bundle: language.bundle)
        return String(format: format, greeting, kidName, timeString)
    }

    private var temperatureText: String {
        guard let temp = weatherTemperature else { return "" }
        let displayTemp = useCelsius ? temp : Int(Double(temp) * 9.0 / 5.0 + 32)
        return "\(displayTemp)\u{00B0}\(useCelsius ? "C" : "F")"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(headlineText)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.6), value: timeString)

            if let symbol = weatherSymbol {
                HStack(spacing: 10) {
                    Image(systemName: symbol)
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .transition(.scale.combined(with: .opacity))
                    Text(temperatureText)
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                        .contentTransition(.numericText())
                }
                .foregroundStyle(.white.opacity(0.9))
                .animation(.easeInOut(duration: 0.8), value: symbol)
            }
        }
        .animation(.easeInOut(duration: 0.8), value: weatherSymbol)
    }
}

#Preview("English with weather") {
    HeaderView(
        greeting: "Good morning",
        kidName: "Ariel",
        timeString: "8:30",
        language: .english,
        weatherTemperature: 22,
        weatherSymbol: "sun.max.fill",
        useCelsius: true
    )
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
    HeaderView(
        greeting: "בוקר טוב",
        kidName: "אריאל",
        timeString: "8:30",
        language: .hebrew,
        weatherTemperature: 22,
        weatherSymbol: "cloud.sun.fill",
        useCelsius: true
    )
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
    HeaderView(
        greeting: "Good afternoon",
        kidName: "Ariel",
        timeString: "2:15 PM",
        language: .english,
        weatherTemperature: nil,
        weatherSymbol: nil,
        useCelsius: false
    )
    .padding(60)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color(red: 0.42, green: 0.56, blue: 0.78))
}
