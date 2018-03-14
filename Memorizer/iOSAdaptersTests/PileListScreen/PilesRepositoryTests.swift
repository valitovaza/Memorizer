import XCTest
@testable import iOSAdapters

class PilesRepositoryTests: XCTestCase {
    
    private var sut: PilesRepository!
    private var delegate: DelegateSpy!
    
    override func setUp() {
        super.setUp()
        delegate = DelegateSpy()
        sut = PilesRepository()
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
extension PilesRepositoryTests {
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
