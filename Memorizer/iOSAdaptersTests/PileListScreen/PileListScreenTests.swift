import XCTest
@testable import iOSAdapters

class PileListScreenTests: XCTestCase {
    
    private var sut: PileListScreen!
    private var controllerPresenter: ControllerPresenterSpy!
    
    override func setUp() {
        super.setUp()
        controllerPresenter = ControllerPresenterSpy()
        sut = PileListScreen(controllerPresenter)
    }
    
    override func tearDown() {
        controllerPresenter = nil
        sut = nil
        super.tearDown()
    }
    
    func test_present_presentViewController() {
        sut.present()
        XCTAssertEqual(controllerPresenter.presentCallCount, 1)
    }
}
