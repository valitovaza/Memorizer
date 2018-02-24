import XCTest

class CreatePileInteractorTests: XCTestCase {

    private var sut: CreatePileInteractor!
    private var screen: ScreenSpy!
    
    override func setUp() {
        super.setUp()
        screen = ScreenSpy()
        sut = CreatePileInteractor(screen)
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
extension CreatePileInteractorTests {
    class ScreenSpy: CreatePileScreen {
        var openCreatePileScreenWasInvoked = 0
        func openCreatePileScreen() {
            openCreatePileScreenWasInvoked += 1
        }
    }
}
