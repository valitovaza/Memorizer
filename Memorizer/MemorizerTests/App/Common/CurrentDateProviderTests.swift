import XCTest

class CurrentDateProviderTests: XCTestCase {
    func test_DatesCurrentDate() {
        XCTAssertEqual(Date.currentDate.timeIntervalSinceNow,
                       Date().timeIntervalSinceNow, accuracy: 0.001)
    }
}
