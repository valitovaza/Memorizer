import UIKit
import iOSAdapters

class PileListViewControllerFactory: ViewControllerFactory {
    func createViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blue
        return vc
    }
}
