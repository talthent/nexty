import XCTest
@testable import nexty

final class LanguageTests: XCTestCase {

    // MARK: - RTL

    func testHebrewIsRTL() {
        XCTAssertTrue(Language.hebrew.isRTL)
    }

    func testEnglishIsNotRTL() {
        XCTAssertFalse(Language.english.isRTL)
    }

    // MARK: - Display name

    func testEnglishDisplayName() {
        XCTAssertEqual(Language.english.displayName, "English")
    }

    func testHebrewDisplayName() {
        XCTAssertEqual(Language.hebrew.displayName, "עברית")
    }

    // MARK: - Raw value

    func testEnglishRawValue() {
        XCTAssertEqual(Language.english.rawValue, "en")
    }

    func testHebrewRawValue() {
        XCTAssertEqual(Language.hebrew.rawValue, "he")
    }

    // MARK: - All cases

    func testLanguageCount() {
        XCTAssertEqual(Language.allCases.count, 2)
    }
}
