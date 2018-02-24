import XCTest
@testable import iOSApp

class UIStoryboard_Tests: XCTestCase {
    func test_instantiateMainViewController() {
        XCTAssertNotNil(UIStoryboard(storyboard: .Main)
            .instantiateViewController() as MainViewController)
    }
    func test_instantiatePileListViewController() {
        XCTAssertNotNil(UIStoryboard(storyboard: .PileList)
            .instantiateViewController() as PileListViewController)
    }
}
