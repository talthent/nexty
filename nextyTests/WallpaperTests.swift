import XCTest
@testable import nexty

final class WallpaperTests: XCTestCase {

    // MARK: - imageName

    func testSoftBlueHasNoImage() {
        XCTAssertNil(Wallpaper.softBlue.imageName)
    }

    func testAllImageWallpapersHaveImageName() {
        for wallpaper in Wallpaper.allCases where wallpaper != .softBlue {
            XCTAssertNotNil(wallpaper.imageName, "\(wallpaper.rawValue) should have an image name")
        }
    }

    func testImageNameMapping() {
        XCTAssertEqual(Wallpaper.bluey.imageName, "Bluey")
        XCTAssertEqual(Wallpaper.minions.imageName, "Minions")
        XCTAssertEqual(Wallpaper.spidey.imageName, "Spidey")
    }

    // MARK: - titleKey

    func testTitleKeyFormat() {
        XCTAssertEqual(Wallpaper.softBlue.rawValue, "softBlue")
        XCTAssertEqual(Wallpaper.bluey.rawValue, "bluey")
    }

    // MARK: - Wallpaper count

    func testWallpaperCount() {
        XCTAssertEqual(Wallpaper.allCases.count, 24)
    }

    // MARK: - Encoding/decoding

    func testWallpaperRoundTrip() throws {
        for wallpaper in Wallpaper.allCases {
            let data = try JSONEncoder().encode(wallpaper)
            let decoded = try JSONDecoder().decode(Wallpaper.self, from: data)
            XCTAssertEqual(decoded, wallpaper)
        }
    }
}
