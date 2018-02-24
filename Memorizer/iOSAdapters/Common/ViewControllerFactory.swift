import UIKit

public protocol ViewControllerFactory {
    func create() -> UIViewController
}
