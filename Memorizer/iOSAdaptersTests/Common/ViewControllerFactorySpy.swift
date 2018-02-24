import XCTest
@testable import iOSAdapters

class ViewControllerFactorySpy: ViewControllerFactory {
    var testCreateController = UIControllerPresentableSpy()
    func createViewController() -> UIViewController {
        return testCreateController
    }
}
