public class PilesRepository {
    public var delegate: PileItemRepositoryDelegate?
    public init() {}
}
extension PilesRepository: PileItemRepository {
    public var count: Int {
        return 0
    }
    public func fetchPiles() {
        delegate?.onPilesFetched([])
    }
    public func delete(at index: Int) {
        
    }
}
