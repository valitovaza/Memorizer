import UIKit

public protocol Presenter {
    func present()
}
public protocol PresenterCreator {
    func create(on parent: UIViewController) -> Presenter
}
public class PileListScreen {
    private weak var controllerPresenter: UIViewController?
    private let viewControllerCreator: ViewControllerCreator
    public init(_ controllerPresenter: UIViewController,
                _ viewControllerCreator: ViewControllerCreator) {
        self.controllerPresenter = controllerPresenter
        self.viewControllerCreator = viewControllerCreator
    }
}
extension PileListScreen: Presenter {
    public func present() {
        let childViewController = viewControllerCreator.create()
        controllerPresenter?.addChildViewController(childViewController)
        addViewAndLayout(childViewController, controllerPresenter)
        childViewController.didMove(toParentViewController: controllerPresenter)
    }
    private func addViewAndLayout(_ childViewController: UIViewController,
                                  _ parentViewController: UIViewController?) {
        if let childView = childViewController.view,
            let parentView = parentViewController?.view {
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
    }
}
