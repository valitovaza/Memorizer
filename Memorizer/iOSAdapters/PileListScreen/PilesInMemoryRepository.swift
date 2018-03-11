public class PilesInMemoryRepository {
    public var delegate: PileItemRepositoryDelegate?
    public init() {}
}
extension PilesInMemoryRepository: PileItemRepository {
    public var count: Int {
        return 0
    }
    public func fetchPiles() {
        delegate?.onPilesFetched([])
    }
    public func delete(at index: Int) {
        
    }
}
