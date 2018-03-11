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
        let repository = PilesInMemoryRepository()
        let pileListLoader = PileListLoader(spinnerAnimator, repository)
        let eventReceiver = PileListEventReceiver(pileListLoader)
        return eventReceiver
    }
}
