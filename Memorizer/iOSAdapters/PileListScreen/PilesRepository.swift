public class PilesRepository {
    public var delegate: PileItemRepositoryDelegate?
    private var piles: [PileItem] = []
    public init() {}
}
extension PilesRepository: PileItemRepository {
    public var count: Int {
        return piles.count
    }
    public func fetchPiles() {
        delegate?.onPilesFetched([])
    }
    public func delete(at index: Int) {
        
    }
}
