import XCTest
@testable import iOSApp
@testable import iOSAdapters

class MainViewControllerTests: XCTestCase {
    
    private var sut: MainViewController!
    private var creator: PresenterCreatorSpy!
    
    override func setUp() {
        super.setUp()
        creator = PresenterCreatorSpy()
        sut = MainViewController()
        sut.presenterCreator = creator
    }
    
    override func tearDown() {
        creator = nil
        sut = nil
        super.tearDown()
    }
    
    func test_onViewDidLoad_createPresenter() {
        sut.viewDidLoad()
        XCTAssertEqual(creator.createCallCount, 1)
        XCTAssertTrue(creator.savedParent === sut)
    }
    
    func test_onViewDidLoad_presentInvokes() {
        sut.viewDidLoad()
        XCTAssertEqual(creator.savedPresenter?.presentCallCount, 1)
    }
}
extension MainViewControllerTests {
    class PresenterCreatorSpy: PresenterCreator {
        var createCallCount = 0
        var savedParent: UIViewController?
        var savedPresenter: PresenterSpy?
        func create(on parent: UIViewController) -> Presenter {
            createCallCount += 1
            savedParent = parent
            savedPresenter = PresenterSpy()
            return savedPresenter!
        }
    }
    class PresenterSpy: Presenter {
        var presentCallCount = 0
        func present() {
            presentCallCount += 1
        }
    }
}
