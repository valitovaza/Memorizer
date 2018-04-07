import UIKit
import iOSAdapters

class MainViewController: UIViewController {
    var dependencyProvider: DependencyProvider = AppDependencyProvider()
    var presenterCreator: PresenterCreator = PileListScreenCreator()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApp()
        presenterCreator.create(on: self).present()
    }
    private func configureApp() {
        DependencyResolver.set(dependencyProvider: dependencyProvider)
        RouterFactory.set(factory: AppRouter(self))
    }
}
class PileListScreenCreator: PresenterCreator {
    func create(on parent: UIViewController) -> Presenter {
        return PileListScreen(parent, PileListVCCreator())
    }
}
