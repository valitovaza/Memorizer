import XCTest
@testable import iOSAdapters

class EmptyStateViewPresenterTests: XCTestCase {
    
    private var sut: EmptyStateViewPresenter!
    private var view: EmptyStateViewSpy!
    
    override func setUp() {
        super.setUp()
        view = EmptyStateViewSpy()
        sut = EmptyStateViewPresenter(view)
    }
    
    override func tearDown() {
        view = nil
        sut = nil
        super.tearDown()
    }
    
    func test_presentPileList_showsContentView() {
        sut.presentPileList()
        XCTAssertEqual(view.showContentViewCallCount, 1)
        XCTAssertEqual(view.showEmptyViewCallCount, 0)
    }
    
    func test_presentEmpty_showsEmptyView() {
        sut.presentEmpty()
        XCTAssertEqual(view.showContentViewCallCount, 0)
        XCTAssertEqual(view.showEmptyViewCallCount, 1)
    }
}
extension EmptyStateViewPresenterTests {
    class EmptyStateViewSpy: EmptyStateView {
        var showEmptyViewCallCount = 0
        func showEmptyView() {
            showEmptyViewCallCount += 1
        }
        
        var showContentViewCallCount = 0
        func showContentView() {
            showContentViewCallCount += 1
        }
    }
}
