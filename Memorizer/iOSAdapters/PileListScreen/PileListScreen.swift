import UIKit

class PileListScreen {
    private weak var controllerPresenter: UIControllerPresenter?
    init(_ controllerPresenter: UIControllerPresenter) {
        self.controllerPresenter = controllerPresenter
    }
}
extension PileListScreen: Presenter {
    func present() {
        let vc = UIViewController()
        controllerPresenter?.present(vc, animated: true, completion: nil)
    }
}
