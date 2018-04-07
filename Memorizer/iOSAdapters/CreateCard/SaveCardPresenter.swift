public protocol SaveCardPresenter: class {
    func enableSaveButton()
    func disableSaveButton()
}
public class SaveCardViewImpl {
    private weak var presenter: SaveCardPresenter?
    public init(_ presenter: SaveCardPresenter) {
        self.presenter = presenter
    }
}
extension SaveCardViewImpl: SaveCardView {
    public func enableSaveButton() {
        presenter?.enableSaveButton()
    }
    public func disableSaveButton() {
        presenter?.disableSaveButton()
    }
}
