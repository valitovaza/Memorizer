public protocol MainConfigurator {
    func configure(_ main: MainConfigurable)
}
public protocol MainConfigurable: class {
    var appStarter: AppStarter! { get set }
    var controllerPresenter: UIControllerPresenter { get }
    func configurationDone()
}
public class MemorizerConfigurator {
    public init() {}
}
extension MemorizerConfigurator: MainConfigurator {
    public func configure(_ main: MainConfigurable) {
        main.appStarter = Memorizer(PileListScreen(main.controllerPresenter))
        main.configurationDone()
    }
}
