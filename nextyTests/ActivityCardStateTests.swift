import XCTest
@testable import nexty

final class ActivityCardStateTests: XCTestCase {

    private func makeCard(isCurrent: Bool = false, isNext: Bool = false, isPast: Bool = false) -> ActivityCardState {
        ActivityCardState(
            activity: Activity(titleKey: "test", imageName: "icon", hour: 8, minute: 0),
            index: 0,
            language: .english,
            use24Hour: true,
            isCurrent: isCurrent,
            isNext: isNext,
            isPast: isPast
        )
    }

    // MARK: - Badge

    func testBadgeIsNowWhenCurrent() {
        let card = makeCard(isCurrent: true)
        XCTAssertEqual(card.badge, .now)
    }

    func testBadgeIsComingNextWhenNext() {
        let card = makeCard(isNext: true)
        XCTAssertEqual(card.badge, .comingNext)
    }

    func testBadgeIsNoneWhenNeitherCurrentNorNext() {
        let card = makeCard()
        XCTAssertEqual(card.badge, .none)
    }

    func testBadgeCurrentTakesPriorityOverNext() {
        let card = makeCard(isCurrent: true, isNext: true)
        XCTAssertEqual(card.badge, .now)
    }

    // MARK: - Opacity

    func testOpacityIsDimmedWhenPast() {
        let card = makeCard(isPast: true)
        XCTAssertEqual(card.opacity, 0.6)
    }

    func testOpacityIsFullWhenNotPast() {
        let card = makeCard()
        XCTAssertEqual(card.opacity, 1.0)
    }

    func testOpacityIsFullWhenCurrent() {
        let card = makeCard(isCurrent: true)
        XCTAssertEqual(card.opacity, 1.0)
    }

    // MARK: - Delegation

    func testTimeStringDelegates24Hour() {
        let card = ActivityCardState(
            activity: Activity(titleKey: "t", imageName: "i", hour: 14, minute: 30),
            index: 0, language: .english, use24Hour: true,
            isCurrent: false, isNext: false, isPast: false
        )
        XCTAssertEqual(card.timeString, "14:30")
    }

    func testTimeStringDelegates12Hour() {
        let card = ActivityCardState(
            activity: Activity(titleKey: "t", imageName: "i", hour: 14, minute: 30),
            index: 0, language: .english, use24Hour: false,
            isCurrent: false, isNext: false, isPast: false
        )
        XCTAssertEqual(card.timeString, "2:30 PM")
    }

    func testTitleUsesCustomTitle() {
        let card = ActivityCardState(
            activity: Activity(titleKey: "t", imageName: "i", hour: 8, minute: 0, customTitle: "My Task"),
            index: 0, language: .english, use24Hour: true,
            isCurrent: false, isNext: false, isPast: false
        )
        XCTAssertEqual(card.title, "My Task")
    }
}

extension ActivityCardState.Badge: Equatable {}
