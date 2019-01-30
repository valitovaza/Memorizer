import UIKit

public protocol UIControllerPresenter: class {
    func present(_ viewControllerToPresent: UIViewController,
                 animated flag: Bool, completion: (() -> Swift.Void)?)
    func addChild(_ childController: UIViewController)
}
extension UIViewController: UIControllerPresenter {}
