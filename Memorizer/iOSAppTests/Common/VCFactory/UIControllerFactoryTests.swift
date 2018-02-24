import XCTest
@testable import iOSApp

class UIControllerFactoryTests: XCTestCase {
    func test_instantiateMainViewController() {
        XCTAssertNotNil(UIControllerFactory.instantiate(.Main) as MainViewController)
    }
    func test_instantiateNavigation_PileListViewController() {
        XCTAssertNotNil(UIControllerFactory.instantiateNavigation(.PileList,
                        with: PileListViewController.self)
                        .viewControllers.first as? PileListViewController)
    }
}
