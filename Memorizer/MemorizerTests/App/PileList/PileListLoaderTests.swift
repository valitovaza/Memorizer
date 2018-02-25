import XCTest

class PileListLoaderTests: XCTestCase {

    private var sut: PileListLoader!
    private var repository: PileRepositorySpy!
    private var screen: ScreenSpy!
    
    override func setUp() {
        super.setUp()
        screen = ScreenSpy()
        repository = PileRepositorySpy()
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
        XCTAssertEqual(screen.presentLoadingWasInvoked, 1)
    }
    
    func test_onLoad_fetchPiles() {
        sut.onLoad()
        XCTAssertEqual(repository.fetchPilesWasInvoked, 1)
    }
    
    func test_onLoad_loadingState_BeforeFetchPiles() {
        repository.onFetchPileBlock = {[unowned self] in
            XCTAssertEqual(self.screen.presentLoadingWasInvoked, 1)
        }
        sut.onLoad()
    }
}
extension PileListLoaderTests {
    class ScreenSpy: PilesLoaderScreen {
        var presentLoadingWasInvoked = 0
        func presentLoading() {
            presentLoadingWasInvoked += 1
        }
    }
}
