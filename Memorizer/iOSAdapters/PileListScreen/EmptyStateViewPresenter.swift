public protocol EmptyStateView: class {
    func showEmptyView()
    func showContentView()
}
public class EmptyStateViewPresenter {
    private weak var view: EmptyStateView?
    public init(_ view: EmptyStateView) {
        self.view = view
    }
}
extension EmptyStateViewPresenter: PilesListOrEmptyScreen {
    public func presentPileList() {
        view?.showContentView()
    }
    public func presentEmpty() {
        view?.showEmptyView()
    }
}
