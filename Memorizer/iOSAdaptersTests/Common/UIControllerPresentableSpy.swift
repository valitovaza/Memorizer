import XCTest
@testable import iOSAdapters

class UIControllerPresentableSpy: UIViewController {
    var didMoveCallCount = 0
    var savedParent: UIViewController?
    override func didMove(toParentViewController parent: UIViewController?) {
        didMoveCallCount += 1
        savedParent = parent
    }
}
