import XCTest
@testable import iOSApp

class PileListVCCreatorTests: XCTestCase {
    
    private var sut: PileListVCCreator!
    private var createFuncCallCount = 0
    private var testNavViewController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        createFuncCallCount = 0
        testNavViewController = TestNavigationController()
        sut = PileListVCCreator()
    }
    
    override func tearDown() {
        testNavViewController = nil
        sut = nil
        super.tearDown()
    }
    
    func test_create_invokesFactoryFunc() {
        changeFactoryFunc(sut)
        let nav = sut.create()
        XCTAssertEqual(createFuncCallCount, 1)
        XCTAssertTrue(nav === testNavViewController)
    }
    private func changeFactoryFunc(_ sut: PileListVCCreator) {
        sut.createFunc = {[unowned self] storyboard, controller in
            self.createFuncCallCount += 1
            XCTAssertEqual(storyboard.filename,
                           UIStoryboard.Storyboard.PileList.filename)
            return self.testNavViewController
        }
    }
    
    func test_create_initializeEventHandler() {
        XCTAssertNotNil(createPileListVcFromStoryboard()?.eventHandler)
    }
    
    private func createPileListVcFromStoryboard() -> PileListViewController? {
        let nav = sut.create() as? UINavigationController
        return nav?.viewControllers.first as? PileListViewController
    }
    
    func test_retainCycle() {
        var vc: PileListViewController? = createPileList()
        weak var weakVc = vc
        XCTAssertNotNil(weakVc)
        vc = nil
        testNavViewController = nil
        sut = nil
        XCTAssertNil(weakVc)
    }
    private func createPileList() -> PileListViewController? {
        changeFactoryFunc(sut)
        return (sut.create() as? UINavigationController)?
            .visibleViewController as? PileListViewController
    }
}
extension PileListVCCreatorTests {
    class TestNavigationController: UINavigationController {
        var pileListVc = PileListViewController()
        override var visibleViewController: UIViewController? {
            return pileListVc
        }
    }
}
