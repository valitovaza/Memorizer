public protocol MainConfigurator {
    func configure(_ main: MainConfigurable)
}
public protocol MainConfigurable: class {
    var appStarter: AppStarter! { get set }
    var controllerPresenter: UIViewController { get }
    func configurationDone()
}
public class MemorizerConfigurator {
    private let viewControllerFactory: ViewControllerFactory
    public init(_ viewControllerFactory: ViewControllerFactory) {
        self.viewControllerFactory = viewControllerFactory
    }
}
import UIKit

extension MemorizerConfigurator: MainConfigurator {
    public func configure(_ main: MainConfigurable) {
        let pileListScreen = PileListScreen(main.controllerPresenter,
                                            viewControllerFactory)
        main.appStarter = Memorizer(pileListScreen)
        main.configurationDone()
    }
}
