import XCTest

class PileListInteractorTests: XCTestCase {

    private var sut: PileListInteractor!
    private var repository: RepositorySpy!
    private var screen: ScreenSpy!
    
    override func setUp() {
        super.setUp()
        screen = ScreenSpy()
        repository = RepositorySpy()
        sut = PileListInteractor(screen, repository)
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
    
    func test_onPilesFetched_presentFetchedPiles() {
        let testPileHolders = generatedTestPileHolders
        sut.onPilesFetched(testPileHolders)
        XCTAssertEqual(screen.presentStateWasInvoked, 1)
        XCTAssertEqual(screen.savedState, .piles(testPileHolders))
    }
    
    func test_onEmptyProfilesFetched_presentEmptyScreen() {
        sut.onPilesFetched([])
        XCTAssertEqual(screen.savedState, .empty)
    }
    
    func test_onEditAtIndex_openEditScreen() {
        let testIndex = 34
        sut.onEdit(at: testIndex)
        XCTAssertEqual(screen.openEditPileAtIndexWasInvoked, 1)
        XCTAssertEqual(screen.editIndex, testIndex)
    }
    
    func test_onRepeatAtIndex_openRepeatScreen() {
        let testIndex = 21
        sut.onRepeat(at: testIndex)
        XCTAssertEqual(screen.openRepeatAtIndexWasInvoked, 1)
        XCTAssertEqual(screen.repeatIndex, testIndex)
    }
    
    func test_onDeleteAtIndex_deleteOnRepository() {
        let testIndex = 98
        sut.onDelete(at: testIndex)
        XCTAssertEqual(repository.deleteAtIndexWasInvoked, 1)
        XCTAssertEqual(repository.deleteIndex, testIndex)
    }
    
    func test_onPileRemoved_presentRemoved() {
        let testIndex = 987
        sut.onPileRemoved(at: testIndex)
        XCTAssertEqual(screen.onPileRemovedWasInvoked, 1)
        XCTAssertEqual(screen.removeIndex, testIndex)
    }
    
    func test_onPileAdded_presentNewPile() {
        let testPile = generatedTestPileHolder
        let testIndex = 34
        sut.onPileAdded(pile: testPile, at: testIndex)
        XCTAssertEqual(screen.presentNewPileWasInvoked, 1)
        XCTAssertEqual(screen.newPileIndex, testIndex)
        assertEqual(lCardList: screen.newPile, rCardList: testPile)
    }
    
    func test_onPileChanged_presentChange() {
        let testPile = generatedTestPileHolder
        let testIndex = 34
        sut.onPileChanged(pile: testPile, at: testIndex)
        XCTAssertEqual(screen.presentChangeWasInvoked, 1)
        XCTAssertEqual(screen.changeIndex, testIndex)
        assertEqual(lCardList: screen.changedPile, rCardList: testPile)
    }
    
    private func assertEqual(lCardList: CardList?, rCardList: CardList) {
        if let lCardList = lCardList {
            XCTAssertTrue(`is`(lCardList, equalTo: rCardList))
        }else{
            XCTFail("No saved card list on stub")
        }
    }
}
