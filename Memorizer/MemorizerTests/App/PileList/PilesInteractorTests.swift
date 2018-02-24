import XCTest

class PilesInteractorTests: XCTestCase {
    
    private var sut: PilesInteractor!
    private var router: RouterSpy!
    private var repository: RepositorySpy!
    
    override func setUp() {
        super.setUp()
        router = RouterSpy()
        repository = RepositorySpy()
        sut = PilesInteractor(router, repository)
    }
    
    override func tearDown() {
        repository = nil
        router = nil
        sut = nil
        super.tearDown()
    }
    
    func test_onEditAtIndex_openEditScreen() {
        let testIndex = 34
        sut.onEdit(at: testIndex)
        XCTAssertEqual(router.openEditPileAtIndexWasInvoked, 1)
        XCTAssertEqual(router.editIndex, testIndex)
    }
    
    func test_onRepeatAtIndex_openRepeatScreen() {
        let testIndex = 21
        sut.onRepeat(at: testIndex)
        XCTAssertEqual(router.openRepeatAtIndexWasInvoked, 1)
        XCTAssertEqual(router.repeatIndex, testIndex)
    }
    
    func test_onDeleteAtIndex_deleteOnRepository() {
        let testIndex = 98
        sut.onDelete(at: testIndex)
        XCTAssertEqual(repository.deleteAtIndexWasInvoked, 1)
        XCTAssertEqual(repository.deleteIndex, testIndex)
    }
}
extension PilesInteractorTests {
    class RouterSpy: RileListRouter {
        var openEditPileAtIndexWasInvoked = 0
        var editIndex: Int?
        func openEditPile(at index: Int) {
            openEditPileAtIndexWasInvoked += 1
            editIndex = index
        }
        
        var openRepeatAtIndexWasInvoked = 0
        var repeatIndex: Int?
        func openRepeat(at index: Int) {
            openRepeatAtIndexWasInvoked += 1
            repeatIndex = index
        }
    }
}
