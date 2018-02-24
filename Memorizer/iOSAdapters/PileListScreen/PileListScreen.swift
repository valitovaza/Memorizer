import UIKit

class PileListScreen {
    private weak var controllerPresenter: UIViewController?
    private let viewControllerFactory: ViewControllerFactory
    init(_ controllerPresenter: UIViewController,
         _ viewControllerFactory: ViewControllerFactory) {
        self.controllerPresenter = controllerPresenter
        self.viewControllerFactory = viewControllerFactory
    }
}
extension PileListScreen: Presenter {
    func present() {
        let childViewController = viewControllerFactory.createViewController()
        controllerPresenter?.addChildViewController(childViewController)
        if let childView = childViewController.view,
            let parentView = controllerPresenter?.view {
            childView.translatesAutoresizingMaskIntoConstraints = false
            parentView.addSubview(childView)
            NSLayoutConstraint.activate([
                childView.leadingAnchor
                    .constraint(equalTo: parentView.leadingAnchor),
                childView.trailingAnchor
                    .constraint(equalTo: parentView.trailingAnchor),
                childView.topAnchor
                    .constraint(equalTo: parentView.topAnchor),
                childView.bottomAnchor
                    .constraint(equalTo: parentView.bottomAnchor)
            ])
        }
        childViewController.didMove(toParentViewController: controllerPresenter)
    }
}
