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
        XCTAssertEqual(screen.openCreateProfileScreenWasInvoked, 1)
    }
}
extension CreateBarInteractorTests {
    class ScreenSpy: CreateBarScreen {
        var openCreateProfileScreenWasInvoked = 0
        func openCreateProfileScreen() {
            openCreateProfileScreenWasInvoked += 1
        }
    }
}
