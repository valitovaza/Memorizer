import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}
extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
extension UIViewController: StoryboardIdentifiable { }
struct UIControllerFactory {
    static func instantiate<T: UIViewController>(_ storyboard: UIStoryboard.Storyboard) -> T {
        return UIStoryboard(storyboard: storyboard).instantiateViewController()
    }
}
extension UIControllerFactory {
    private static let navigationIdentifierSuffix = "Nav"
    static func instantiateNavigation<T: UIViewController>(_ storyboard: UIStoryboard.Storyboard,
                                     with controller: T.Type) -> UINavigationController {
        let identifier = controller.storyboardIdentifier + navigationIdentifierSuffix
        return UIStoryboard(storyboard: storyboard).instantiateViewController(identifier)
    }
}
