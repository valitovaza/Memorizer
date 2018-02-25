import XCTest

class CreatePileLogicTests: XCTestCase {

    private var sut: CreatePileLogic!
    private var screen: ScreenSpy!
    
    override func setUp() {
        super.setUp()
        screen = ScreenSpy()
        sut = CreatePileLogic(screen)
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
extension CreatePileLogicTests {
    class ScreenSpy: CreatePileScreen {
        var openCreatePileScreenWasInvoked = 0
        func openCreatePileScreen() {
            openCreatePileScreenWasInvoked += 1
        }
    }
}
