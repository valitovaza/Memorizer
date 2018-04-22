import XCTest
@testable import iOSAdapters

class PilesRepositoryTests: XCTestCase {
    
    private var sut: PilesRepository!
    private var delegate: DelegateSpy!
    private var fetcher: PileFetcherSpy!
    
    override func setUp() {
        super.setUp()
        delegate = DelegateSpy()
        sut = PilesRepository()
        fetcher = PileFetcherSpy()
        sut.cache = fetcher
        sut.delegate = delegate
    }
    
    override func tearDown() {
        delegate = nil
        fetcher = nil
        sut = nil
        super.tearDown()
    }
    
    func test_fetchPiles_fetchsWithFetcher() {
        sut.fetchPiles()
        XCTAssertEqual(fetcher.fetchPilesCallCount, 1)
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
    class PileFetcherSpy: PilesCacheWorker {
    
        var fetchPilesCallCount = 0
        func fetchPiles(_ completion: @escaping ([IdentifyablePileItem])->()) {
            fetchPilesCallCount += 1
        }
        
        func addPileItem(_ pileItem: PileItem, _ completion: @escaping (Int64) -> ()) {
            
        }
        func deletePileItem(_ id: Int64) {
            
        }
        func changePileItem(_ pileItem: PileItem, id: Int64) {
            
        }
    }
}
