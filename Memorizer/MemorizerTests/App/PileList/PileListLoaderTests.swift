import XCTest

class PileListLoaderTests: XCTestCase {

    private var sut: PileListLoader!
    private var repository: RepositorySpy!
    private var screen: ScreenSpy!
    
    override func setUp() {
        super.setUp()
        screen = ScreenSpy()
        repository = RepositorySpy()
        sut = PileListLoader(screen, repository)
    }
    
    override func tearDown() {
        screen = nil
        repository = nil
        sut = nil
        super.tearDown()
    }
    
    func test_onLoad_presentLoadingState() {
        sut.onLoad()
        XCTAssertEqual(screen.presentStateWasInvoked, 1)
        XCTAssertEqual(screen.savedState, .loading)
    }
    
    func test_onLoad_fetchPiles() {
        sut.onLoad()
        XCTAssertEqual(repository.fetchPilesWasInvoked, 1)
    }
    
    func test_onLoad_loadingState_BeforeFetchPiles() {
        repository.onFetchPileBlock = {[unowned self] in
            XCTAssertEqual(self.screen.presentStateWasInvoked, 1)
        }
        sut.onLoad()
    }
}
extension PileListLoaderTests {
    class ScreenSpy: PilesLoaderScreen {
        var presentStateWasInvoked = 0
        var savedState: PileListScreenState?
        func present(state: PileListScreenState) {
            presentStateWasInvoked += 1
            savedState = state
        }
    }
}