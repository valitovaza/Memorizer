public protocol TableReloader {
    func reloadTable()
}
public class TableReloaderAtFetch {
    private let reloader: TableReloader
    public init(_ reloader: TableReloader) {
        self.reloader = reloader
    }
}
extension TableReloaderAtFetch: PilesFetchedListener {
    public func onPilesFetched(_ pileItems: [PileItem]) {
        reloader.reloadTable()
    }
}
