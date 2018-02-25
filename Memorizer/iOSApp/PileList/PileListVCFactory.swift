import UIKit
import iOSAdapters

class PileListVCFactory: ViewControllerFactory {
    var factoryFunc: ((_ storyboard: UIStoryboard.Storyboard, _ controller: UIViewController.Type) -> UINavigationController) = UIControllerFactory.instantiateNavigation
    func create() -> UIViewController {
        let nav = factoryFunc(.PileList, PileListViewController.self)
        setEventHandler(nav)
        return nav
    }
    private func setEventHandler(_ nav: UINavigationController) {
        guard let pileListVc = nav
            .visibleViewController as? PileListViewController else { return }
        pileListVc.eventHandler = createEventHandler(pileListVc)
    }
    private func createEventHandler(_ activityIndicatorPresenter: ActivityIndicatorPresenter) -> PileListEventReceiver {
        let spinnerAnimator = SpinnerAnimator(activityIndicatorPresenter)
        let pileListLoader = PileListLoader(spinnerAnimator,
                                            PilesInMemoryRepository())
        return PileListEventReceiver(pileListLoader, StubCreatePileHandler())
    }
}
class StubCreatePileHandler: CreatePileHandler {
    func onCreatePile() {
        
    }
}
