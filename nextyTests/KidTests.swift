import XCTest
@testable import nexty

final class KidTests: XCTestCase {

    // MARK: - Avatar animated video mapping

    func testAnimatedAvatarsHaveVideoName() {
        let animated: [Avatar] = [.bear, .bunny, .cat, .dinosaur, .fox, .lion, .owl, .penguin, .robot, .unicorn]
        for avatar in animated {
            XCTAssertNotNil(avatar.animatedVideoName, "\(avatar.rawValue) should have an animated video")
        }
    }

    func testAnimatedVideoNameFormat() {
        XCTAssertEqual(Avatar.cat.animatedVideoName, "cat_animated")
        XCTAssertEqual(Avatar.bear.animatedVideoName, "bear_animated")
    }

    func testAllAvatarsHaveImageName() {
        for avatar in Avatar.allCases {
            XCTAssertFalse(avatar.imageName.isEmpty)
        }
    }

    // MARK: - Kid defaults

    func testKidDefaultAvatar() {
        let kid = Kid(name: "Test")
        XCTAssertEqual(kid.avatar, .bear)
    }

    func testKidDefaultWallpaper() {
        let kid = Kid(name: "Test")
        XCTAssertEqual(kid.wallpaper, .softBlue)
    }

    func testKidDefaultActivitiesAreDefaultSchedule() {
        let kid = Kid(name: "Test")
        XCTAssertEqual(kid.activities.count, Activity.defaultSchedule.count)
    }

    // MARK: - Kid encoding/decoding

    func testKidRoundTrip() throws {
        let kid = Kid(name: "Test", avatar: .fox, wallpaper: .bluey)
        let data = try JSONEncoder().encode(kid)
        let decoded = try JSONDecoder().decode(Kid.self, from: data)
        XCTAssertEqual(decoded.name, kid.name)
        XCTAssertEqual(decoded.avatar, kid.avatar)
        XCTAssertEqual(decoded.wallpaper, kid.wallpaper)
        XCTAssertEqual(decoded.id, kid.id)
    }
}
