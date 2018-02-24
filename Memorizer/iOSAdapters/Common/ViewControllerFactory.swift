import UIKit

public protocol ViewControllerFactory {
    func createViewController() -> UIViewController
}
