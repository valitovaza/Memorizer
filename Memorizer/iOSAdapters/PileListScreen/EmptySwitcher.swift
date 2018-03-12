public protocol ListEmptySwitcher: class, PilesOrEmptyScreen {}
public class EmptySwitcher {
    private weak var presenter: ListEmptySwitcher?
    public init(_ presenter: ListEmptySwitcher) {
        self.presenter = presenter
    }
}
extension EmptySwitcher: PilesOrEmptyScreen {
    public func presentPileList() {
        presenter?.presentPileList()
    }
    public func presentEmpty() {
        presenter?.presentEmpty()
    }
}
