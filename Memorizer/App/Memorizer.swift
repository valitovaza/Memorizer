class Memorizer {
    private let presenter: Presenter
    init(_ presenter: Presenter) {
        self.presenter = presenter
    }
    func onStart() {
        presenter.present()
    }
}
