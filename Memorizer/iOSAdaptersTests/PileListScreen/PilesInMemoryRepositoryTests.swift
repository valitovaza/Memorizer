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
    class DelegateSpy: PileRepositoryDelegate {
        var onPilesFetchedCallCount = 0
        func onPilesFetched(_ pileHolders: [CardList]) {
            onPilesFetchedCallCount += 1
        }
        func onPileRemoved(at index: Int) {
            
        }
        func onPileAdded(pile: CardList, at index: Int) {
            
        }
        func onPileChanged(pile: CardList, at index: Int) {
            
        }
    }
}
