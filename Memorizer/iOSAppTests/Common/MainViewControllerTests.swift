import XCTest
@testable import iOSApp
@testable import iOSAdapters

class MainViewControllerTests: XCTestCase {
    
    private var sut: MainViewController!
    
    override func setUp() {
        super.setUp()
        sut = MainViewController()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
