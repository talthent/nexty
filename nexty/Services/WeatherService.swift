import Foundation
import os

private let logger = Logger(subsystem: "com.talthent.nexty", category: "WeatherService")

@Observable
final class WeatherService {
    var temperature: Int?
    var symbolName: String?

    func fetch(latitude: Double, longitude: Double) async {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,weather_code"
        logger.info("Fetching weather: \(urlString)")
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            guard let current = json?["current"] as? [String: Any],
                  let temp = current["temperature_2m"] as? Double,
                  let code = current["weather_code"] as? Int else {
                logger.error("Failed to parse weather JSON")
                return
            }

            temperature = Int(temp.rounded())
            symbolName = Self.symbolName(for: code)
            logger.info("Weather: \(self.temperature ?? 0)°, code \(code)")
        } catch {
            logger.error("Weather fetch error: \(error.localizedDescription)")
        }
    }

    private static func symbolName(for code: Int) -> String {
        switch code {
        case 0: "sun.max.fill"
        case 1, 2, 3: "cloud.sun.fill"
        case 45, 48: "cloud.fog.fill"
        case 51, 53, 55: "cloud.drizzle.fill"
        case 56, 57: "cloud.sleet.fill"
        case 61, 63, 65: "cloud.rain.fill"
        case 66, 67: "cloud.sleet.fill"
        case 71, 73, 75, 77: "cloud.snow.fill"
        case 80, 81, 82: "cloud.heavyrain.fill"
        case 85, 86: "cloud.snow.fill"
        case 95, 96, 99: "cloud.bolt.fill"
        default: "cloud.fill"
        }
    }
}
