import XCTest

class PilesRepositoryListenerTests: XCTestCase {
    
    private var sut: PilesRepositoryListener!
    private var countListener0: CountChangeListener!
    private var countListener1: CountChangeListener!
    private var changeListener0: ChangeListener!
    private var changeListener1: ChangeListener!
    private var delegateSpy0: DelegateSpy!
    private var delegateSpy1: DelegateSpy!
    
    override func setUp() {
        super.setUp()
        sut = PilesRepositoryListener()
        createCountChangeListeners()
        createChangeListeners()
        createDelegates()
    }
    private func createCountChangeListeners() {
        countListener0 = CountChangeListener()
        countListener1 = CountChangeListener()
        sut.countListeners = [countListener0, countListener1]
    }
    private func createChangeListeners() {
        changeListener0 = ChangeListener()
        changeListener1 = ChangeListener()
        sut.changeListeners = [changeListener0, changeListener1]
    }
    private func createDelegates() {
        delegateSpy0 = DelegateSpy()
        delegateSpy1 = DelegateSpy()
        sut.delegates = [delegateSpy0, delegateSpy1]
    }
    
    override func tearDown() {
        clearVars()
        super.tearDown()
    }
    private func clearVars() {
        countListener0 = nil
        countListener1 = nil
        
        changeListener0 = nil
        changeListener1 = nil
        
        delegateSpy0 = nil
        delegateSpy1 = nil
        sut = nil
    }
    
    func test_onPilesFetched_invokesSameOnListeners() {
        let piles = [PileItem.testNewItem, PileItem.testNewItem]
        sut.onPilesFetched(piles)
        
        XCTAssertEqual(countListener0.onPilesFetchedCallCount, 1)
        XCTAssertEqual(countListener1.onPilesFetchedCallCount, 1)
        XCTAssertEqual(countListener0.fetchedCount, piles.count)
        XCTAssertEqual(countListener1.fetchedCount, piles.count)
        
        XCTAssertEqual(changeListener0.onPileChangedCallCount, 0)
        XCTAssertEqual(changeListener1.onPileChangedCallCount, 0)
        
        XCTAssertEqual(delegateSpy0.onPilesFetchedCallCount, 1)
        XCTAssertEqual(delegateSpy1.onPilesFetchedCallCount, 1)
        XCTAssertEqual(delegateSpy0.fetchedCount, piles.count)
        XCTAssertEqual(delegateSpy1.fetchedCount, piles.count)
    }
    
    func test_onPileRemoved_invokesSameOnListeners() {
        sut.onPileRemoved(at: 5)
        
        XCTAssertEqual(countListener0.onPileRemovedCallCount, 1)
        XCTAssertEqual(countListener1.onPileRemovedCallCount, 1)
        XCTAssertEqual(countListener0.removeIndex, 5)
        XCTAssertEqual(countListener1.removeIndex, 5)
        
        XCTAssertEqual(changeListener0.onPileChangedCallCount, 0)
        XCTAssertEqual(changeListener1.onPileChangedCallCount, 0)
        
        XCTAssertEqual(delegateSpy0.onPileRemovedCallCount, 1)
        XCTAssertEqual(delegateSpy1.onPileRemovedCallCount, 1)
        XCTAssertEqual(delegateSpy0.removeIndex, 5)
        XCTAssertEqual(delegateSpy1.removeIndex, 5)
    }
    
    func test_onPileAdded_invokesSameOnListeners() {
        sut.onPileAdded(pile: PileItem.testNewItem, at: 45)
        
        XCTAssertEqual(countListener0.onPileAddedCallCount, 1)
        XCTAssertEqual(countListener1.onPileAddedCallCount, 1)
        XCTAssertEqual(countListener0.addIndex, 45)
        XCTAssertEqual(countListener1.addIndex, 45)
        
        XCTAssertEqual(changeListener0.onPileChangedCallCount, 0)
        XCTAssertEqual(changeListener1.onPileChangedCallCount, 0)
        
        XCTAssertEqual(delegateSpy0.onPileAddedCallCount, 1)
        XCTAssertEqual(delegateSpy1.onPileAddedCallCount, 1)
        XCTAssertEqual(delegateSpy0.addIndex, 45)
        XCTAssertEqual(delegateSpy1.addIndex, 45)
    }
    
    func test_onPileChanged_invokesSameOnChangeListeners() {
        sut.onPileChanged(pile: PileItem.testNewItem, at: 23)
        
        XCTAssertEqual(changeListener0.onPileChangedCallCount, 1)
        XCTAssertEqual(changeListener1.onPileChangedCallCount, 1)
        XCTAssertEqual(changeListener0.changeIndex, 23)
        XCTAssertEqual(changeListener1.changeIndex, 23)
        
        XCTAssertEqual(countListener0.onPilesFetchedCallCount, 0)
        XCTAssertEqual(countListener1.onPilesFetchedCallCount, 0)
        
        XCTAssertEqual(delegateSpy0.onPileChangedCallCount, 1)
        XCTAssertEqual(delegateSpy1.onPileChangedCallCount, 1)
        XCTAssertEqual(delegateSpy0.changeIndex, 23)
        XCTAssertEqual(delegateSpy1.changeIndex, 23)
    }
}
extension PilesRepositoryListenerTests {
    class CountChangeListener: PilesCountChangersListener {
        var onPilesFetchedCallCount = 0
        var fetchedCount: Int?
        func onPilesFetched(_ pileItems: [PileItem]) {
            onPilesFetchedCallCount += 1
            fetchedCount = pileItems.count
        }
        
        var onPileRemovedCallCount = 0
        var removeIndex: Int?
        func onPileRemoved(at index: Int) {
            onPileRemovedCallCount += 1
            removeIndex = index
        }
        
        var onPileAddedCallCount = 0
        var addIndex: Int?
        func onPileAdded(pile: PileItem, at index: Int) {
            onPileAddedCallCount += 1
            addIndex = index
        }
    }
    class ChangeListener: PileItemChangeListener {
        var onPileChangedCallCount = 0
        var changeIndex: Int?
        func onPileChanged(pile: PileItem, at index: Int) {
            onPileChangedCallCount += 1
            changeIndex = index
        }
    }
    class DelegateSpy: PileItemRepositoryDelegate {
        var onPilesFetchedCallCount = 0
        var fetchedCount: Int?
        func onPilesFetched(_ pileItems: [PileItem]) {
            onPilesFetchedCallCount += 1
            fetchedCount = pileItems.count
        }
        
        var onPileRemovedCallCount = 0
        var removeIndex: Int?
        func onPileRemoved(at index: Int) {
            onPileRemovedCallCount += 1
            removeIndex = index
        }
        
        var onPileAddedCallCount = 0
        var addIndex: Int?
        func onPileAdded(pile: PileItem, at index: Int) {
            onPileAddedCallCount += 1
            addIndex = index
        }
        
        var onPileChangedCallCount = 0
        var changeIndex: Int?
        func onPileChanged(pile: PileItem, at index: Int) {
            onPileChangedCallCount += 1
            changeIndex = index
        }
    }
}
