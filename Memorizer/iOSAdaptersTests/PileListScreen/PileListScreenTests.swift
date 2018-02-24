import XCTest
@testable import iOSAdapters

class PileListScreenTests: XCTestCase {
    
    private var sut: PileListScreen!
    private var controllerPresenter: ControllerPresenterSpy!
    private var viewControllerFactory: ViewControllerFactorySpy!
    
    override func setUp() {
        super.setUp()
        controllerPresenter = ControllerPresenterSpy()
        viewControllerFactory = ViewControllerFactorySpy()
        sut = PileListScreen(controllerPresenter, viewControllerFactory)
    }
    
    override func tearDown() {
        controllerPresenter = nil
        viewControllerFactory = nil
        sut = nil
        super.tearDown()
    }
    
    func test_present_presentViewController() {
        sut.present()
        XCTAssertEqual(controllerPresenter.addChildViewControllerCallCount, 1)
        XCTAssertEqual(controllerPresenter.presentCallCount, 0)
    }
    
    func test_present_usesViewControllerFromfactory() {
        sut.present()
        XCTAssertTrue(controllerPresenter
            .savedChildController === viewControllerFactory.testCreateController)
    }
    
    func test_present_didMove() {
        sut.present()
        XCTAssertEqual(viewControllerFactory
            .testCreateController.didMoveCallCount, 1)
    }
}
