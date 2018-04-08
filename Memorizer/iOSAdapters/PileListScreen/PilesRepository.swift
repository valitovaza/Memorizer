public class PilesRepository {
    public var delegate: PileItemRepositoryDelegate?
    public var indexResolver: RepositoryIndexFinder?
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
}
extension PilesRepository: PilesRepositoryChanger {
    public func add(pileItem: PileItem) {
        let addIndex = piles.count
        piles.append(pileItem)
        delegate?.onPileAdded(pile: pileItem, at: addIndex)
    }
    public func change(pileItem: PileItem, at index: Int) {
        piles[index] = pileItem
        delegate?.onPileChanged(pile: pileItem, at: index)
    }
}
public protocol PileItemCleanerInTable {
    func deleteIn(section: Int, row: Int)
}
extension PilesRepository: PileItemCleanerInTable {
    public func deleteIn(section: Int, row: Int) {
        guard let index = indexResolver?.repositoryIndexFor(section: section, row: row) else { return }
        piles.remove(at: index)
        delegate?.onPileRemoved(at: index)
    }
}
public protocol PileItemByIndexProvider {
    func getPileItem(for index: Int) -> PileItem
}
extension PilesRepository: PileItemByIndexProvider {
    public func getPileItem(for index: Int) -> PileItem {
        return piles[index]
    }
}
