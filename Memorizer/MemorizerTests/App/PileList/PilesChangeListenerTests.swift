import XCTest

class PilesChangeListenerTests: XCTestCase {
    
    private var sut: PilesChangeListener!
    private var screen: ScreenSpy!
    
    override func setUp() {
        super.setUp()
        screen = ScreenSpy()
        sut = PilesChangeListener(screen)
    }
    
    override func tearDown() {
        screen = nil
        sut = nil
        super.tearDown()
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
extension PilesChangeListenerTests {
    class ScreenSpy: PilesChangesListenerScreen {
        var presentStateWasInvoked = 0
        var savedState: PileListScreenState?
        func present(state: PileListScreenState) {
            presentStateWasInvoked += 1
            savedState = state
        }
        
        var presentNewPileWasInvoked = 0
        var newPileIndex: Int?
        var newPile: CardList?
        func presentNew(pile: CardList, at index: Int) {
            presentNewPileWasInvoked += 1
            newPileIndex = index
            newPile = pile
        }
        
        var onPileRemovedWasInvoked = 0
        var removeIndex: Int?
        func onPileRemoved(at index: Int) {
            onPileRemovedWasInvoked += 1
            removeIndex = index
        }
        
        var presentChangeWasInvoked = 0
        var changeIndex: Int?
        var changedPile: CardList?
        func presentChange(of pile: CardList, at index: Int) {
            presentChangeWasInvoked += 1
            changeIndex = index
            changedPile = pile
        }
    }
}
