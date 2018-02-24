import XCTest
@testable import iOSApp

class PileListVCFactoryTests: XCTestCase {
    
    private var sut: PileListVCFactory!
    private var factoryFuncCallCount = 0
    
    override func setUp() {
        super.setUp()
        factoryFuncCallCount = 0
        sut = PileListVCFactory()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_create_invokesFactoryFunc() {
        changeFactoryFunc(sut)
        _=sut.create()
        XCTAssertEqual(factoryFuncCallCount, 1)
    }
    private func changeFactoryFunc(_ sut: PileListVCFactory) {
        sut.factoryFunc = {[weak self] storyboard, controller in
            self?.factoryFuncCallCount += 1
            XCTAssertEqual(storyboard.filename,
                           UIStoryboard.Storyboard.PileList.filename)
            return UINavigationController()
        }
    }
}
