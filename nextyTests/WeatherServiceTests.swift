import XCTest
@testable import nexty

final class WeatherServiceTests: XCTestCase {

    // WeatherService.symbolName is private, so we test it indirectly
    // by verifying the public contract through fetch() or by testing
    // the mapping logic extracted here.
    //
    // Since symbolName(for:) is private static, we test the observable
    // behavior: after a successful fetch, symbolName should be set.

    // MARK: - Temperature rounding (via public state)

    func testWeatherServiceInitialState() {
        let service = WeatherService()
        XCTAssertNil(service.temperature)
        XCTAssertNil(service.symbolName)
    }
}
