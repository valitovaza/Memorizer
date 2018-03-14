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
        let repository = PilesRepository()
        let emptySwitcher = EmptySwitcher(listEmptySwitcher)
        let repositoryListener = PilesRepositoryListener()
        repositoryListener.countListeners = [PilesEmptyToggle(repository, emptySwitcher)]
        repository.delegate = repositoryListener
        let pileListLoader = PileListLoader(spinnerAnimator, repository)
        let eventReceiver = PileListEventReceiver(pileListLoader)
        return eventReceiver
    }
}
