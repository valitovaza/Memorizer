import XCTest

class PileListOrEmptyResolverTests: XCTestCase {
    
    private var sut: PileListOrEmptyResolver!
    private var repository: PileRepositorySpy!
    private var screen: ScreenSpy!
    
    override func setUp() {
        super.setUp()
        repository = PileRepositorySpy()
        screen = ScreenSpy()
        sut = PileListOrEmptyResolver(repository, screen)
    }
    
    override func tearDown() {
        repository = nil
        screen = nil
        sut = nil
        super.tearDown()
    }
    
    func test_onPilesFetchedAndCountIs0_presentEmpty() {
        repository.testCount = 0
        sut.onPilesFetched([])
        checkEmptyPresented()
    }
    
    func test_onPilesFetchedAndCountIsGreaterThan0_presentList() {
        repository.testCount = 1
        sut.onPilesFetched([])
        checkPileListPresented()
    }
    
    func test_onPileRemovedAndCountIs0_presentEmpty() {
        repository.testCount = 0
        sut.onPileRemoved(at: 0)
        checkEmptyPresented()
    }
    
    func test_onPileRemovedAndCountIsGreaterThan0_presentList() {
        repository.testCount = 34
        sut.onPileRemoved(at: 0)
        checkPileListPresented()
    }
    
    func test_onPileAdded_presentList() {
        sut.onPileAdded(pile: generatedTestPileHolder, at: 0)
        checkPileListPresented()
    }
    
    private func checkEmptyPresented() {
        XCTAssertEqual(screen.presentPileListCallCount, 0)
        XCTAssertEqual(screen.presentEmptyCallCount, 1)
    }
    private func checkPileListPresented() {
        XCTAssertEqual(screen.presentEmptyCallCount, 0)
        XCTAssertEqual(screen.presentPileListCallCount, 1)
    }
}
extension PileListOrEmptyResolverTests {
    class ScreenSpy: PilesListOrEmptyScreen {
        var presentPileListCallCount = 0
        func presentPileList() {
            presentPileListCallCount += 1
        }
        
        var presentEmptyCallCount = 0
        func presentEmpty() {
            presentEmptyCallCount += 1
        }
    }
}
