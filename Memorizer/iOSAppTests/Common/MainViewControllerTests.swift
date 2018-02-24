import XCTest
@testable import iOSApp
@testable import iOSAdapters

class MainViewControllerTests: XCTestCase {
    
    private var sut: MainViewController!
    private var configurator: Configurator!
    private var appStarter: AppStarterSpy!
    
    override func setUp() {
        super.setUp()
        sut = MainViewController()
        setConfigurator()
        setAppStarter()
    }
    private func setConfigurator() {
        configurator = Configurator()
        sut.configurator = configurator
    }
    private func setAppStarter() {
        appStarter = AppStarterSpy()
        sut.appStarter = appStarter
    }
    
    override func tearDown() {
        clearTestsVars()
        super.tearDown()
    }
    private func clearTestsVars() {
        configurator = nil
        appStarter = nil
        sut = nil
    }
    
    func test_viewDidLoad_configure() {
        sut.viewDidLoad()
        XCTAssertEqual(configurator.configureWasInvoked, 1)
        XCTAssertTrue(configurator.savedMain === sut)
    }
    
    func test_configurationDone_onStart() {
        sut.configurationDone()
        XCTAssertEqual(appStarter.onStartWasInvoked, 1)
    }
}
extension MainViewControllerTests {
    class Configurator: MainConfigurator {
        var configureWasInvoked = 0
        var savedMain: MainConfigurable?
        func configure(_ main: MainConfigurable) {
            configureWasInvoked += 1
            savedMain = main
        }
    }
    class AppStarterSpy: AppStarter {
        var onStartWasInvoked = 0
        func onStart() {
            onStartWasInvoked += 1
        }
    }
}
