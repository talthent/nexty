import XCTest
@testable import nexty

final class HeaderViewStateTests: XCTestCase {

    private func makeState(temp: Int? = nil, useCelsius: Bool = true) -> HeaderViewState {
        HeaderViewState(
            greeting: "Good morning",
            kidName: "Buddy",
            timeString: "8:15",
            language: .english,
            weatherTemperature: temp,
            weatherSymbol: "sun.max.fill",
            useCelsius: useCelsius
        )
    }

    // MARK: - temperatureText

    func testTemperatureTextCelsius() {
        let state = makeState(temp: 22)
        XCTAssertEqual(state.temperatureText, "22°C")
    }

    func testTemperatureTextFahrenheit() {
        let state = makeState(temp: 0, useCelsius: false)
        XCTAssertEqual(state.temperatureText, "32°F")
    }

    func testTemperatureTextFahrenheitConversion() {
        let state = makeState(temp: 100, useCelsius: false)
        XCTAssertEqual(state.temperatureText, "212°F")
    }

    func testTemperatureTextNegativeCelsius() {
        let state = makeState(temp: -5)
        XCTAssertEqual(state.temperatureText, "-5°C")
    }

    func testTemperatureTextNegativeFahrenheit() {
        // -40°C = -40°F
        let state = makeState(temp: -40, useCelsius: false)
        XCTAssertEqual(state.temperatureText, "-40°F")
    }

    func testTemperatureTextNilCelsius() {
        let state = makeState(temp: nil, useCelsius: true)
        XCTAssertEqual(state.temperatureText, "--°C")
    }

    func testTemperatureTextNilFahrenheit() {
        let state = makeState(temp: nil, useCelsius: false)
        XCTAssertEqual(state.temperatureText, "--°F")
    }

    func testTemperatureTextZeroCelsius() {
        let state = makeState(temp: 0)
        XCTAssertEqual(state.temperatureText, "0°C")
    }
}
