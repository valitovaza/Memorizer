public protocol MainConfigurator {
    func configure(_ main: MainConfigurable)
}
public protocol MainConfigurable: class {
    var appStarter: AppStarter! { get set }
    func configurationDone()
}
public class MemorizerConfigurator {
    public init() {}
}
extension MemorizerConfigurator: MainConfigurator {
    public func configure(_ main: MainConfigurable) {
        //main.configurationDone()
        //main.appStarter = Memorizer(<#T##presenter: Presenter##Presenter#>)
    }
}
