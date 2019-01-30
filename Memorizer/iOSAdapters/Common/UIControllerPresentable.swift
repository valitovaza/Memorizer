import UIKit

protocol UIControllerPresentable {
    func didMove(toParent parent: UIViewController?)
}
extension UIViewController: UIControllerPresentable {}
