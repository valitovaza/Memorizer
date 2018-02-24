import UIKit
import iOSAdapters

class PileListVCFactory: ViewControllerFactory {
    var factoryFunc: ((_ storyboard: UIStoryboard.Storyboard, _ controller: UIViewController.Type) -> UINavigationController) = UIControllerFactory.instantiateNavigation
    func create() -> UIViewController {
        return factoryFunc(.PileList, PileListViewController.self)
    }
}
