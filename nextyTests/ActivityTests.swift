import XCTest
@testable import nexty

final class ActivityTests: XCTestCase {

    // MARK: - isCustom

    func testIsCustomReturnsTrueWhenCustomTitleSet() {
        let activity = Activity(titleKey: "test", imageName: "icon", hour: 8, minute: 0, customTitle: "My Task")
        XCTAssertTrue(activity.isCustom)
    }

    func testIsCustomReturnsFalseWhenCustomTitleNil() {
        let activity = Activity(titleKey: "test", imageName: "icon", hour: 8, minute: 0)
        XCTAssertFalse(activity.isCustom)
    }

    // MARK: - title(for:)

    func testTitleReturnsCustomTitleWhenSet() {
        let activity = Activity(titleKey: "activity.wakeUp", imageName: "sun", hour: 7, minute: 0, customTitle: "Custom")
        XCTAssertEqual(activity.title(for: .english), "Custom")
    }

    // MARK: - timeString 24-hour

    func testTimeString24HourMorning() {
        let activity = Activity(titleKey: "t", imageName: "i", hour: 8, minute: 15)
        XCTAssertEqual(activity.timeString(use24Hour: true), "8:15")
    }

    func testTimeString24HourMidnight() {
        let activity = Activity(titleKey: "t", imageName: "i", hour: 0, minute: 0)
        XCTAssertEqual(activity.timeString(use24Hour: true), "0:00")
    }

    func testTimeString24HourNoon() {
        let activity = Activity(titleKey: "t", imageName: "i", hour: 12, minute: 0)
        XCTAssertEqual(activity.timeString(use24Hour: true), "12:00")
    }

    func testTimeString24HourAfternoon() {
        let activity = Activity(titleKey: "t", imageName: "i", hour: 14, minute: 30)
        XCTAssertEqual(activity.timeString(use24Hour: true), "14:30")
    }

    func testTimeString24HourPadsMinutes() {
        let activity = Activity(titleKey: "t", imageName: "i", hour: 9, minute: 5)
        XCTAssertEqual(activity.timeString(use24Hour: true), "9:05")
    }

    // MARK: - timeString 12-hour

    func testTimeString12HourMorning() {
        let activity = Activity(titleKey: "t", imageName: "i", hour: 8, minute: 15)
        XCTAssertEqual(activity.timeString(use24Hour: false), "8:15 AM")
    }

    func testTimeString12HourMidnight() {
        let activity = Activity(titleKey: "t", imageName: "i", hour: 0, minute: 0)
        XCTAssertEqual(activity.timeString(use24Hour: false), "12:00 AM")
    }

    func testTimeString12HourNoon() {
        let activity = Activity(titleKey: "t", imageName: "i", hour: 12, minute: 0)
        XCTAssertEqual(activity.timeString(use24Hour: false), "12:00 PM")
    }

    func testTimeString12HourAfternoon() {
        let activity = Activity(titleKey: "t", imageName: "i", hour: 14, minute: 30)
        XCTAssertEqual(activity.timeString(use24Hour: false), "2:30 PM")
    }

    func testTimeString12HourElevenPM() {
        let activity = Activity(titleKey: "t", imageName: "i", hour: 23, minute: 59)
        XCTAssertEqual(activity.timeString(use24Hour: false), "11:59 PM")
    }

    func testTimeString12HourOneAM() {
        let activity = Activity(titleKey: "t", imageName: "i", hour: 1, minute: 0)
        XCTAssertEqual(activity.timeString(use24Hour: false), "1:00 AM")
    }

    // MARK: - currentIndex

    private func makeDate(hour: Int, minute: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }

    private func makeSortedActivities() -> [Activity] {
        [
            Activity(titleKey: "wake", imageName: "i", hour: 7, minute: 0),
            Activity(titleKey: "breakfast", imageName: "i", hour: 7, minute: 30),
            Activity(titleKey: "school", imageName: "i", hour: 8, minute: 30),
            Activity(titleKey: "lunch", imageName: "i", hour: 12, minute: 0),
            Activity(titleKey: "sleep", imageName: "i", hour: 19, minute: 30),
        ]
    }

    func testCurrentIndexEmptyActivities() {
        XCTAssertNil(Activity.currentIndex(in: [], at: makeDate(hour: 12, minute: 0)))
    }

    func testCurrentIndexBeforeFirstActivity() {
        let activities = makeSortedActivities()
        XCTAssertNil(Activity.currentIndex(in: activities, at: makeDate(hour: 6, minute: 0)))
    }

    func testCurrentIndexExactlyAtFirstActivity() {
        let activities = makeSortedActivities()
        XCTAssertEqual(Activity.currentIndex(in: activities, at: makeDate(hour: 7, minute: 0)), 0)
    }

    func testCurrentIndexBetweenActivities() {
        let activities = makeSortedActivities()
        XCTAssertEqual(Activity.currentIndex(in: activities, at: makeDate(hour: 10, minute: 0)), 2)
    }

    func testCurrentIndexAfterLastActivity() {
        let activities = makeSortedActivities()
        XCTAssertEqual(Activity.currentIndex(in: activities, at: makeDate(hour: 22, minute: 0)), 4)
    }

    func testCurrentIndexExactlyAtLastActivity() {
        let activities = makeSortedActivities()
        XCTAssertEqual(Activity.currentIndex(in: activities, at: makeDate(hour: 19, minute: 30)), 4)
    }

    func testCurrentIndexOneMinuteBeforeActivity() {
        let activities = makeSortedActivities()
        // 7:29 is still on the first activity (7:00), not the second (7:30)
        XCTAssertEqual(Activity.currentIndex(in: activities, at: makeDate(hour: 7, minute: 29)), 0)
    }
}
