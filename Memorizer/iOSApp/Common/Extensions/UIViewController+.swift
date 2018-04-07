import UIKit

extension UIViewController {
    func animateLayout(_ duration: TimeInterval = 0.4) {
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}
