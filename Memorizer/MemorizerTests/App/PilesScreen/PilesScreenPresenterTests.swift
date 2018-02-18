import XCTest

class PilesScreenPresenterTests: XCTestCase {
    
    private var sut: PilesScreenPresenter!
    private var topBarPresenter: PresenterSpy!
    private var pileListPresenter: PresenterSpy!
    
    override func setUp() {
        super.setUp()
        topBarPresenter = PresenterSpy()
        pileListPresenter = PresenterSpy()
        sut = PilesScreenPresenter(topBarPresenter, pileListPresenter)
    }
    
    override func tearDown() {
        topBarPresenter = nil
        pileListPresenter = nil
        sut = nil
        super.tearDown()
    }
    
    func testPresent_presentsTopBar() {
        sut.present()
        XCTAssertEqual(topBarPresenter.presentWasInvoked, 1)
    }
    
    func testPresent_presentsPileList() {
        sut.present()
        XCTAssertEqual(pileListPresenter.presentWasInvoked, 1)
    }
}
