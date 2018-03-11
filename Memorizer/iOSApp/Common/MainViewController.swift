import UIKit
import iOSAdapters

class MainViewController: UIViewController {
    var presenterCreator: PresenterCreator = PileListScreenCreator()
    override func viewDidLoad() {
        super.viewDidLoad()
        presenterCreator.create(on: self).present()
    }
}
class PileListScreenCreator: PresenterCreator {
    func create(on parent: UIViewController) -> Presenter {
        return PileListScreen(parent, PileListVCCreator())
    }
}
