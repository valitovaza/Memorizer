public class PilesInMemoryRepository {
    weak var delegate: PileRepositoryDelegate?
    public init(){}
}
extension PilesInMemoryRepository: PileRepository {
    public func fetchPiles() {
        delegate?.onPilesFetched([])
    }
    public func delete(at index: Int) {
        
    }
}
