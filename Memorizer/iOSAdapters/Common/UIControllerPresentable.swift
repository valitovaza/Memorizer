import UIKit

protocol UIControllerPresentable {
    func didMove(toParentViewController parent: UIViewController?)
}
extension UIViewController: UIControllerPresentable {}
