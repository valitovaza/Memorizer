import UIKit
import iOSAdapters

class MainViewController: UIViewController, MainConfigurable {
    var configurator: MainConfigurator = MemorizerConfigurator()
    
    var appStarter: AppStarter!
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
