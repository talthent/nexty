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
            let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
            let temp = Int(response.current.temperature2m.rounded())
            let symbol = Self.symbolName(for: response.current.weatherCode)
            await MainActor.run {
                temperature = temp
                symbolName = symbol
            }
            logger.info("Weather: \(temp)°, code \(response.current.weatherCode)")
        } catch {
            logger.error("Weather fetch error: \(error.localizedDescription)")
        }
    }

    private struct WeatherResponse: Decodable {
        let current: CurrentWeather
    }

    private struct CurrentWeather: Decodable {
        let temperature2m: Double
        let weatherCode: Int

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
            case weatherCode = "weather_code"
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
