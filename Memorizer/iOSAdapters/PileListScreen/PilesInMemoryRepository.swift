public class PilesInMemoryRepository {
    public weak var delegate: PileRepositoryDelegate?
    public init() {}
}
extension PilesInMemoryRepository: PileRepository {
    public var count: Int {
        return 0
    }
    public func fetchPiles() {
        delegate?.onPilesFetched([])
    }
    public func delete(at index: Int) {
        
    }
}
