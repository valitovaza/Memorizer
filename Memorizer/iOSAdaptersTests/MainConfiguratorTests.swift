import XCTest
@testable import iOSAdapters

class MainConfiguratorTests: XCTestCase {
    
    private var sut: MemorizerConfigurator!
    private var configurable: Configurable!
    private var viewControllerFactory: ViewControllerFactorySpy!
    
    override func setUp() {
        super.setUp()
        configurable = Configurable()
        viewControllerFactory = ViewControllerFactorySpy()
        sut = MemorizerConfigurator(viewControllerFactory)
    }
    
    override func tearDown() {
        configurable = nil
        viewControllerFactory = nil
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
        XCTAssertEqual(configurable.controllerPresenterSpy.addChildViewControllerCallCount, 1)
    }
    
    func test_configure_usesFactoryFromInitializer() {
        sut.configure(configurable)
        configurable.appStarter.onStart()
        XCTAssertTrue(configurable.controllerPresenterSpy
            .savedChildController === viewControllerFactory.testCreateController)
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
        var controllerPresenter: UIViewController {
            return controllerPresenterSpy
        }
    
        var configurationDoneWasInvoked = 0
        var configurationDoneCallBack: (()->())?
        func configurationDone() {
            configurationDoneWasInvoked += 1
            configurationDoneCallBack?()
        }
    }
    class ControllerAndConfigurable: UIViewController, MainConfigurable {
        var appStarter: AppStarter!
        
        var controllerPresenter: UIViewController {
            return self
        }
        func configurationDone() {
        }
    }
}
