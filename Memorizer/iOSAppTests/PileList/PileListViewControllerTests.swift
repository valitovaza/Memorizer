import XCTest
@testable import iOSApp

class PileListViewControllerTests: LocalizerTests {
    
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
    
    func test_outletsFromStoryboard() {
        loadViews()
        XCTAssertTrue(sut.emptyView.isHidden)
        XCTAssertTrue(sut.contentView.isHidden)
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
    
    func test_showEmptyView_stopsSpinnerAnimation() {
        startActivity()
        sut.showEmptyView()
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }
    
    func test_showEmptyView_unhideEmptyView() {
        hideEmptyView()
        sut.showEmptyView()
        XCTAssertFalse(sut.emptyView.isHidden)
        XCTAssertTrue(sut.contentView.isHidden)
    }
    private func hideEmptyView() {
        loadViews()
        sut.emptyView.isHidden = true
        sut.contentView.isHidden = false
    }
    
    func test_showContentView_stopsSpinnerAnimation() {
        startActivity()
        sut.showContentView()
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }
    
    func test_showContentView_unhideContentView() {
        hideContentView()
        sut.showContentView()
        XCTAssertTrue(sut.emptyView.isHidden)
        XCTAssertFalse(sut.contentView.isHidden)
    }
    private func hideContentView() {
        loadViews()
        sut.emptyView.isHidden = false
        sut.contentView.isHidden = true
    }
    private func startActivity() {
        loadViews()
        sut.activityIndicator.startAnimating()
    }
    private func loadViews() {
        _=sut.view
    }
    
    func test_onLoad_titleL10n_en() {
        L10n.localizeFunc = L10n.enTr
        sut.viewDidLoad()
        XCTAssertEqual(sut.navigationItem.title, L10n.memorizer)
    }
    
    func test_onLoad_titleL10n_ru() {
        L10n.localizeFunc = L10n.ruTr
        sut.viewDidLoad()
        XCTAssertEqual(sut.navigationItem.title, L10n.memorizer)
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
