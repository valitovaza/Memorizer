import XCTest

class CreateBarInteractorTests: XCTestCase {

    private var sut: CreateBarInteractor!
    private var screen: ScreenSpy!
    
    override func setUp() {
        super.setUp()
        screen = ScreenSpy()
        sut = CreateBarInteractor(screen)
    }
    
    override func tearDown() {
        screen = nil
        sut = nil
        super.tearDown()
    }
    
    func testOnCreate_presentCreateProfileScreen() {
        sut.onCreatePile()
        XCTAssertEqual(screen.openCreatePileScreenWasInvoked, 1)
    }
}
extension CreateBarInteractorTests {
    class ScreenSpy: CreateBarScreen {
        var openCreatePileScreenWasInvoked = 0
        func openCreatePileScreen() {
            openCreatePileScreenWasInvoked += 1
        }
    }
}
