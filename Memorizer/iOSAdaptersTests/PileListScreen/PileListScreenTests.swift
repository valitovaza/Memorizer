import XCTest
@testable import iOSAdapters

class PileListScreenTests: XCTestCase {
    
    private var sut: PileListScreen!
    private var controllerPresenter: ControllerPresenterSpy!
    private var viewControllerCreator: ViewControllerCreatorSpy!
    
    override func setUp() {
        super.setUp()
        controllerPresenter = ControllerPresenterSpy()
        viewControllerCreator = ViewControllerCreatorSpy()
        sut = PileListScreen(controllerPresenter, viewControllerCreator)
    }
    
    override func tearDown() {
        controllerPresenter = nil
        viewControllerCreator = nil
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
            .savedChildController === viewControllerCreator.testCreateController)
    }
    
    func test_present_didMove() {
        sut.present()
        XCTAssertEqual(viewControllerCreator
            .testCreateController.didMoveCallCount, 1)
    }
}
