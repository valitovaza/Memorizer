import XCTest
@testable import iOSAdapters

class ControllerPresenterSpy: UIControllerPresenter {
    var presentCallCount = 0
    func present(_ viewControllerToPresent: UIViewController,
                 animated flag: Bool, completion: (() -> Swift.Void)?) {
        presentCallCount += 1
    }
}
