import XCTest
@testable import iOSAdapters

class ViewControllerCreatorSpy: ViewControllerCreator {
    var testCreateController = UIControllerPresentableSpy()
    func create() -> UIViewController {
        return testCreateController
    }
}
