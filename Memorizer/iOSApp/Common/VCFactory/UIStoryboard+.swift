import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        case Main
        case PileList
        case PileDetails
        case Card
        var filename: String {
            return rawValue
        }
    }
    convenience init(storyboard: Storyboard) {
        self.init(name: storyboard.filename, bundle: nil)
    }
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        return viewController
    }
    func instantiateViewController<T: UIViewController>(_ storyboardIdentifier: String) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(storyboardIdentifier) ")
        }
        return viewController
    }
}
