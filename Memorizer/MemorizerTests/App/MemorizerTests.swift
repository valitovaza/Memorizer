import XCTest

class MemorizerTests: XCTestCase {
    
    private var sut: Memorizer!
    private var presenter: PresenterSpy!
    
    override func setUp() {
        super.setUp()
        presenter = PresenterSpy()
        sut = Memorizer(presenter)
    }
    
    override func tearDown() {
        sut = nil
        presenter = nil
        super.tearDown()
    }
    
    func test_onStart_presentUI() {
        sut.onStart()
        XCTAssertEqual(presenter.presentWasInvoked, 1)
    }
}
