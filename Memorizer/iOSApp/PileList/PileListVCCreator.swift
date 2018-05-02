import UIKit
import iOSAdapters

class PileListVCCreator: ViewControllerCreator {
    var createFunc: ((_ storyboard: UIStoryboard.Storyboard, _ controller: UIViewController.Type) -> UINavigationController) = UIControllerFactory.instantiateNavigation
    func create() -> UIViewController {
        let nav = createFunc(.PileList, PileListViewController.self)
        setEventHandler(nav)
        return nav
    }
    private func setEventHandler(_ nav: UINavigationController) {
        guard let pileListVc = nav.visibleViewController as? PileListViewController else { return }
        pileListVc.eventHandler = createEventHandler(pileListVc, pileListVc)
    }
    private func createEventHandler(_ activityIndicatorPresenter: ActivityIndicatorPresenter,
                                    _ listEmptySwitcher: ListEmptySwitcher) -> PileListEventReceiver {
        let spinnerAnimator = SpinnerAnimator(activityIndicatorPresenter)
        let emptySwitcher = EmptySwitcher(listEmptySwitcher)
        let repository = DependencyResolver.getPileItemRepository()
        let toggler = PilesEmptyToggle(repository, emptySwitcher)
        let listener = DependencyResolver.getPilesRepositoryListener()
        listener.countListeners = [toggler]
        let pileListLoader = PileListLoader(spinnerAnimator, repository)
        let eventReceiver = PileListEventReceiver(pileListLoader,
                                                  DependencyResolver.getPileListDataSource(),
                                                  DependencyResolver.getPileItemContainer())
        eventReceiver.pilesRepositoryListener = listener
        eventReceiver.pilesFetcher = repository
        return eventReceiver
    }
}
