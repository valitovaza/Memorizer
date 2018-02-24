import UIKit

public protocol UIControllerPresenter: class {
    func present(_ viewControllerToPresent: UIViewController,
                 animated flag: Bool, completion: (() -> Swift.Void)?)
}
extension UIViewController: UIControllerPresenter {}
