import XCTest
@testable import iOSApp

class PileListViewControllerTests: XCTestCase {
    
    private var sut: PileListViewController!
    private var navigationController: UINavigationController!
    private var eventHandler: EventHandlerSpy!
    
    override func setUp() {
        super.setUp()
        createSut()
        eventHandler = EventHandlerSpy()
        sut.eventHandler = eventHandler
    }
    private func createSut() {
        navigationController = UIControllerFactory
            .instantiateNavigation(.PileList, with: PileListViewController.self)
        sut = navigationController.viewControllers.first as! PileListViewController
    }
    override func tearDown() {
        cleanVars()
        super.tearDown()
    }
    private func cleanVars() {
        eventHandler = nil
        sut = nil
        navigationController = nil
    }
    
    func test_activityIsStopped() {
        loadViews()
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }
    
    func test_createPile_sendEvent() {
        sut.createPile(UIButton())
        XCTAssertEqual(eventHandler.handleEventCallCount, 1)
        XCTAssertEqual(eventHandler.savedEvent, .onCreate)
    }
    
    func test_onLoad_sendEvent() {
        loadViews()
        XCTAssertEqual(eventHandler.handleEventCallCount, 1)
        XCTAssertEqual(eventHandler.savedEvent, .onLoad)
    }
    
    func test_animateActivityIndicator_animatesIt() {
        loadViews()
        sut.animateActivityIndicator()
        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }
    private func loadViews() {
        _=sut.view
    }
}
extension PileListViewControllerTests {
    class EventHandlerSpy: PileListEventHandler {
        var handleEventCallCount = 0
        var savedEvent: PileListViewController.Event?
        func handle(event: PileListViewController.Event) {
            handleEventCallCount += 1
            savedEvent = event
        }
    }
}