import XCTest
@testable import iOSAdapters

class PilesInMemoryRepositoryTests: XCTestCase {
    
    private var sut: PilesInMemoryRepository!
    private var delegate: DelegateSpy!
    
    override func setUp() {
        super.setUp()
        delegate = DelegateSpy()
        sut = PilesInMemoryRepository()
        sut.delegate = delegate
    }
    
    override func tearDown() {
        delegate = nil
        sut = nil
        super.tearDown()
    }
    
    func test_fetchPiles_onProfilefetched() {
        sut.fetchPiles()
        XCTAssertEqual(delegate.onPilesFetchedCallCount, 1)
    }
}
extension PilesInMemoryRepositoryTests {
    class DelegateSpy: PileItemRepositoryDelegate {
        var onPilesFetchedCallCount = 0
        func onPilesFetched(_ pileHolders: [PileItem]) {
            onPilesFetchedCallCount += 1
        }
        func onPileRemoved(at index: Int) {
            
        }
        func onPileAdded(pile: PileItem, at index: Int) {
            
        }
        func onPileChanged(pile: PileItem, at index: Int) {
            
        }
    }
}
