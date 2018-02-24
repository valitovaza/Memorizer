public protocol AppStarter {
    func onStart()
}
class Memorizer {
    private let presenter: Presenter
    init(_ presenter: Presenter) {
        self.presenter = presenter
    }
}
extension Memorizer: AppStarter {
    func onStart() {
        presenter.present()
    }
}
