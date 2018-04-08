public protocol PileDetailsPresenter: class {
    func updateTitle(_ title: String)
    func enableSaveButton()
    func disableSaveButton()
}
public class SavePileViewImpl {
    private weak var presenter: PileDetailsPresenter?
    public init(_ presenter: PileDetailsPresenter) {
        self.presenter = presenter
    }
}
extension SavePileViewImpl: SavePileView {
    public func updateTitle(_ title: String) {
        presenter?.updateTitle(title)
    }
    public func enableSaveButton() {
        presenter?.enableSaveButton()
    }
    public func disableSaveButton() {
        presenter?.disableSaveButton()
    }
}
