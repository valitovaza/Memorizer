import UIKit
import iOSAdapters

class MainViewController: UIViewController, MainConfigurable {
    var configurator: MainConfigurator = MemorizerConfigurator(PileListViewControllerFactory())
    
    var appStarter: AppStarter!
    var controllerPresenter: UIViewController {
        return self
    }
    func configurationDone() {
        appStarter.onStart()
    }
}
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(self)
    }
}
