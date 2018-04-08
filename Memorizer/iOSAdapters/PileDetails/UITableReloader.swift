public protocol UITableReloader: class {
    func reloadTable()
}
public class CardsTableReloaderImpl {
    private weak var uiReloader: UITableReloader?
    public init(_ uiReloader: UITableReloader) {
        self.uiReloader = uiReloader
    }
}
extension CardsTableReloaderImpl: CardsTableReloader {
    public func reloadTable() {
        uiReloader?.reloadTable()
    }
}
