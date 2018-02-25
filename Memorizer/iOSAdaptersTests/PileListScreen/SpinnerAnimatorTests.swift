import XCTest
@testable import iOSAdapters

class SpinnerAnimatorTests: XCTestCase {
    
    private var sut: SpinnerAnimator!
    private var presenter: ActivityIndicatorSpy!
    
    override func setUp() {
        super.setUp()
        presenter = ActivityIndicatorSpy()
        sut = SpinnerAnimator(presenter)
    }
    
    override func tearDown() {
        presenter = nil
        sut = nil
        super.tearDown()
    }
    
    func test_presentLoading_animatesActivityIndicator() {
        sut.presentLoading()
        XCTAssertEqual(presenter.animateActivityIndicatorCallCount, 1)
    }
}
extension SpinnerAnimatorTests {
    class ActivityIndicatorSpy: ActivityIndicatorPresenter {
        var animateActivityIndicatorCallCount = 0
        func animateActivityIndicator() {
            animateActivityIndicatorCallCount += 1
        }
    }
}
