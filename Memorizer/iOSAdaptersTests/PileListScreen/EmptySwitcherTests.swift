import XCTest
@testable import iOSAdapters

class EmptySwitcherTests: XCTestCase {
    
    private var sut: EmptySwitcher!
    private var presenter: PresenterSpy!
    
    override func setUp() {
        super.setUp()
        presenter = PresenterSpy()
        sut = EmptySwitcher(presenter)
    }
    
    override func tearDown() {
        presenter = nil
        sut = nil
        super.tearDown()
    }
    
    func test_presentPileList_invokesPresenters() {
        sut.presentPileList()
        XCTAssertEqual(presenter.presentEmptyCallCount, 0)
        XCTAssertEqual(presenter.presentPileListCallCount, 1)
    }
    
    func test_presentEmpty_invokesPresenters() {
        sut.presentEmpty()
        XCTAssertEqual(presenter.presentPileListCallCount, 0)
        XCTAssertEqual(presenter.presentEmptyCallCount, 1)
    }
}
extension EmptySwitcherTests {
    class PresenterSpy: ListEmptySwitcher {
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
