import UIKit
import iOSAdapters

class MainViewController: UIViewController, MainConfigurable {
    var configurator: MainConfigurator = MemorizerConfigurator()
    
    var appStarter: AppStarter!
    var controllerPresenter: UIControllerPresenter {
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
