import XCTest
@testable import nexty

@MainActor
final class AppStateTests: XCTestCase {

    private func makeAppState() -> AppState {
        let state = AppState()
        // Reset to known state
        state.kids = [
            Kid(name: "Alice", avatar: .cat),
            Kid(name: "Bob", avatar: .bear),
        ]
        state.selectedKidIndex = 0
        return state
    }

    // MARK: - selectedKidIndex clamping

    func testSelectedKidIndexClampsToMax() {
        let state = makeAppState()
        state.selectedKidIndex = 99
        XCTAssertEqual(state.selectedKidIndex, 1)
    }

    func testSelectedKidIndexClampsToZero() {
        let state = makeAppState()
        state.selectedKidIndex = -1
        XCTAssertEqual(state.selectedKidIndex, 0)
    }

    func testSelectedKidIndexValidValue() {
        let state = makeAppState()
        state.selectedKidIndex = 1
        XCTAssertEqual(state.selectedKidIndex, 1)
    }

    // MARK: - currentKid

    func testCurrentKidReturnsSelectedKid() {
        let state = makeAppState()
        XCTAssertEqual(state.currentKid.name, "Alice")
        state.selectedKidIndex = 1
        XCTAssertEqual(state.currentKid.name, "Bob")
    }

    // MARK: - Activity CRUD

    func testAddActivity() {
        let state = makeAppState()
        let count = state.activities.count
        state.addActivity(Activity(titleKey: "test", imageName: "icon", hour: 10, minute: 0))
        XCTAssertEqual(state.activities.count, count + 1)
    }

    func testUpdateActivityFindsById() {
        let state = makeAppState()
        let activity = state.activities[0]
        var updated = activity
        updated.hour = 23
        state.updateActivity(updated)
        XCTAssertEqual(state.activities.first(where: { $0.id == activity.id })?.hour, 23)
    }

    func testUpdateActivityNoMatchDoesNothing() {
        let state = makeAppState()
        let count = state.activities.count
        let orphan = Activity(titleKey: "orphan", imageName: "icon", hour: 0, minute: 0)
        state.updateActivity(orphan)
        XCTAssertEqual(state.activities.count, count)
    }

    func testRemoveActivity() {
        let state = makeAppState()
        let activity = state.activities[0]
        let count = state.activities.count
        state.removeActivity(activity)
        XCTAssertEqual(state.activities.count, count - 1)
        XCTAssertNil(state.activities.first(where: { $0.id == activity.id }))
    }

    func testReplaceActivities() {
        let state = makeAppState()
        let newActivities = [Activity(titleKey: "only", imageName: "i", hour: 9, minute: 0)]
        state.replaceActivities(newActivities)
        XCTAssertEqual(state.activities.count, 1)
        XCTAssertEqual(state.activities[0].titleKey, "only")
    }

    func testReplaceActivitiesForKidAtValidIndex() {
        let state = makeAppState()
        let newActivities = [Activity(titleKey: "bob-only", imageName: "i", hour: 9, minute: 0)]
        state.replaceActivities(newActivities, forKidAt: 1)
        XCTAssertEqual(state.kids[1].activities.count, 1)
    }

    func testReplaceActivitiesForKidAtInvalidIndex() {
        let state = makeAppState()
        let originalCount = state.kids[0].activities.count
        state.replaceActivities([], forKidAt: 99)
        XCTAssertEqual(state.kids[0].activities.count, originalCount)
    }

    // MARK: - Kid management

    func testAddKid() {
        let state = makeAppState()
        state.addKid(name: "Charlie")
        XCTAssertEqual(state.kids.count, 3)
        XCTAssertEqual(state.kids.last?.name, "Charlie")
        XCTAssertEqual(state.kids.last?.avatar, .bear) // default avatar
    }

    func testRemoveKid() {
        let state = makeAppState()
        state.removeKid(at: 1)
        XCTAssertEqual(state.kids.count, 1)
        XCTAssertEqual(state.kids[0].name, "Alice")
    }

    func testRemoveKidCannotRemoveLastKid() {
        let state = makeAppState()
        state.removeKid(at: 0)
        // Now only Bob remains
        XCTAssertEqual(state.kids.count, 1)
        state.removeKid(at: 0)
        // Should still have one kid
        XCTAssertEqual(state.kids.count, 1)
    }

    func testRemoveKidInvalidIndex() {
        let state = makeAppState()
        state.removeKid(at: 99)
        XCTAssertEqual(state.kids.count, 2)
    }

    func testRemoveKidAdjustsSelectedIndex() {
        let state = makeAppState()
        state.selectedKidIndex = 1
        state.removeKid(at: 1)
        XCTAssertEqual(state.selectedKidIndex, 0)
    }

    func testRemoveSelectedKidWhenFirst() {
        let state = makeAppState()
        state.addKid(name: "Charlie")
        state.selectedKidIndex = 2
        state.removeKid(at: 2)
        XCTAssertEqual(state.selectedKidIndex, 1)
    }

    // MARK: - Kid update methods

    func testUpdateKidName() {
        let state = makeAppState()
        state.updateKidName("Alice Updated", at: 0)
        XCTAssertEqual(state.kids[0].name, "Alice Updated")
    }

    func testUpdateKidNameTrimsWhitespace() {
        let state = makeAppState()
        state.updateKidName("  Trimmed  ", at: 0)
        XCTAssertEqual(state.kids[0].name, "Trimmed")
    }

    func testUpdateKidNameIgnoresEmpty() {
        let state = makeAppState()
        state.updateKidName("", at: 0)
        XCTAssertEqual(state.kids[0].name, "Alice")
    }

    func testUpdateKidNameIgnoresWhitespaceOnly() {
        let state = makeAppState()
        state.updateKidName("   ", at: 0)
        XCTAssertEqual(state.kids[0].name, "Alice")
    }

    func testUpdateKidNameInvalidIndex() {
        let state = makeAppState()
        state.updateKidName("Nope", at: 99)
        XCTAssertEqual(state.kids[0].name, "Alice")
    }

    func testUpdateKidWallpaper() {
        let state = makeAppState()
        state.updateKidWallpaper(.bluey, at: 0)
        XCTAssertEqual(state.kids[0].wallpaper, .bluey)
    }

    func testUpdateKidWallpaperInvalidIndex() {
        let state = makeAppState()
        state.updateKidWallpaper(.bluey, at: 99)
        // No crash, original unchanged
        XCTAssertNotEqual(state.kids[0].wallpaper, .bluey)
    }

    func testUpdateKidAvatar() {
        let state = makeAppState()
        state.updateKidAvatar(.unicorn, at: 0)
        XCTAssertEqual(state.kids[0].avatar, .unicorn)
    }

    // MARK: - Greeting

    func testGreetingNight() {
        let state = makeAppState()
        // Greeting is based on currentTime which is Date() — we test the logic pattern
        // by checking it returns a non-empty string
        XCTAssertFalse(state.greeting.isEmpty)
    }

    // MARK: - nextActivityIndex

    func testNextActivityIndexWhenNoActivities() {
        let state = makeAppState()
        state.replaceActivities([])
        XCTAssertNil(state.nextActivityIndex)
    }
}
