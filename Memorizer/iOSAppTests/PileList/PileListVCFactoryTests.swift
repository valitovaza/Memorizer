import XCTest
@testable import iOSApp

class PileListVCFactoryTests: XCTestCase {
    
    private var sut: PileListVCFactory!
    private var factoryFuncCallCount = 0
    private var testNavViewController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        factoryFuncCallCount = 0
        testNavViewController = TestNavigationController()
        sut = PileListVCFactory()
    }
    
    override func tearDown() {
        testNavViewController = nil
        sut = nil
        super.tearDown()
    }
    
    func test_create_invokesFactoryFunc() {
        changeFactoryFunc(sut)
        let nav = sut.create()
        XCTAssertEqual(factoryFuncCallCount, 1)
        XCTAssertTrue(nav === testNavViewController)
    }
    private func changeFactoryFunc(_ sut: PileListVCFactory) {
        sut.factoryFunc = {[unowned self] storyboard, controller in
            self.factoryFuncCallCount += 1
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
        XCTAssertNil(weakVc)
    }
    private func createPileList() -> PileListViewController? {
        changeFactoryFunc(sut)
        return (sut.create() as? UINavigationController)?
            .visibleViewController as? PileListViewController
    }
}
extension PileListVCFactoryTests {
    class TestNavigationController: UINavigationController {
        var pileListVc = PileListViewController()
        override var visibleViewController: UIViewController? {
            return pileListVc
        }
    }
}
