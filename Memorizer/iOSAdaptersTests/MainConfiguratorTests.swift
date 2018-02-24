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
    
    func test_configure_configurationDone() {
        sut.configure(configurable)
        XCTAssertEqual(configurable.configurationDoneWasInvoked, 1)
    }
    
    func test_configureSetsAppStarter() {
        sut.configure(configurable)
        XCTAssertNotNil(configurable.appStarter)
    }
    
    func test_configurationDoneInvokesAfterAppStarterInitialization() {
        configurable.configurationDoneCallBack = {[weak self] in
            XCTAssertNotNil(self?.configurable.appStarter)
        }
        sut.configure(configurable)
    }
    
    func test_configure_usesViewControllerPresenterFromConfigurable() {
        sut.configure(configurable)
        configurable.appStarter.onStart()
        XCTAssertEqual(configurable.controllerPresenterSpy.presentCallCount, 1)
    }
    
    func test_retainCycle() {
        var configurable: ControllerAndConfigurable? = ControllerAndConfigurable()
        weak var weakConfigurable = configurable
        sut.configure(configurable!)
        configurable = nil
        sut = nil
        XCTAssertNil(weakConfigurable)
    }
}
extension MainConfiguratorTests {
    class Configurable: MainConfigurable {
        var appStarter: AppStarter!
        
        var controllerPresenterSpy = ControllerPresenterSpy()
        var controllerPresenter: UIControllerPresenter {
            return controllerPresenterSpy
        }
    
        var configurationDoneWasInvoked = 0
        var configurationDoneCallBack: (()->())?
        func configurationDone() {
            configurationDoneWasInvoked += 1
            configurationDoneCallBack?()
        }
    }
    class ControllerAndConfigurable: Configurable, UIControllerPresenter {
        override var controllerPresenter: UIControllerPresenter {
            return self
        }
        func present(_ viewControllerToPresent: UIViewController,
                     animated flag: Bool, completion: (() -> Swift.Void)?) {
        }
    }
}
