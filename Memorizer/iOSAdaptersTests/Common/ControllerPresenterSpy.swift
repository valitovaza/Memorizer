import XCTest
@testable import iOSAdapters

class ControllerPresenterSpy: UIViewController {
    var presentCallCount = 0
    
    var savedViewControllerToPresent: UIViewController?
    var savedFlag: Bool?
    var savedCompletion: (() -> Swift.Void)?
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Swift.Void)?) {
        savedViewControllerToPresent = viewControllerToPresent
        savedFlag = flag
        savedCompletion = completion
        presentCallCount += 1
    }
    
    var addChildViewControllerCallCount = 0
    var savedChildController: UIViewController?
    override func addChildViewController(_ childController: UIViewController) {
        addChildViewControllerCallCount += 1
        savedChildController = childController
    }
}
