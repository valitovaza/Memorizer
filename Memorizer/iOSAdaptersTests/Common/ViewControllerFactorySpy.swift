import XCTest
@testable import iOSAdapters

class ViewControllerFactorySpy: ViewControllerFactory {
    var testCreateController = UIControllerPresentableSpy()
    func create() -> UIViewController {
        return testCreateController
    }
}
