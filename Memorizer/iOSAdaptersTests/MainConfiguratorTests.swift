import XCTest
@testable import iOSAdapters

class MainConfiguratorTests: XCTestCase {
    
    private var sut: MemorizerConfigurator!
    private var configurable: Configurable!
    
    override func setUp() {
        super.setUp()
        configurable = Configurable()
        sut = MemorizerConfigurator()
    }
    
    override func tearDown() {
        configurable = nil
        sut = nil
        super.tearDown()
    }
    
    func x_test_configure_configurationDone() {
        sut.configure(configurable)
        XCTAssertEqual(configurable.configurationDoneWasInvoked, 1)
    }
    
    func x_test_configureSetsAppStarter() {
        sut.configure(configurable)
        XCTAssertNotNil(configurable.appStarter)
    }
}
extension MainConfiguratorTests {
    class Configurable: MainConfigurable {
        var appStarter: AppStarter!
        
        var configurationDoneWasInvoked = 0
        func configurationDone() {
            configurationDoneWasInvoked += 1
        }
    }
}
