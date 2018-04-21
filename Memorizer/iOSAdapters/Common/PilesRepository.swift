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
public protocol PileItemCombiner {
    func combine(at positions: [ItemPosition])
}
extension PilesRepository: PileItemCombiner {
    public func combine(at positions: [ItemPosition]) {
        guard positions.count > 1 else { return }
        
        let combineCards = retrieveAllCombineCards(at: positions)
        let title = newTitleForCombinedPileItem(positions)
        delete(at: positions)
        
        addNewPileItem(title, combineCards)
    }
    private func retrieveAllCombineCards(at positions: [ItemPosition]) -> [Card] {
        var combineCards: [Card] = []
        for position in positions {
            guard let cardPileItem = getPileCard(at: position) else { continue }
            combineCards.append(contentsOf: cardPileItem.cards)
        }
        return combineCards
    }
    public func getPileCard(at position: ItemPosition) -> CardPile? {
        guard let pileItem = getPileItem(at: position) else { return nil }
        return pileItem.pile as? CardPile
    }
    private func getPileItem(at position: ItemPosition) -> PileItem? {
        guard let index = indexResolver?.repositoryIndexFor(section: position.section,
                                                            row: position.row) else { return nil }
        return getPileItem(for: index)
    }
    private func newTitleForCombinedPileItem(_ positions: [ItemPosition]) -> String {
        for position in positions {
            guard let pileItem = getPileItem(at: position) else { continue }
            return pileItem.title
        }
        return ""
    }
    private func delete(at positions: [ItemPosition]) {
        var indexesForDelete: [Int] = []
        for position in positions {
            guard let index = indexResolver?.repositoryIndexFor(section: position.section,
                                                                row: position.row) else { continue }
            indexesForDelete.append(index)
        }
        for index in indexesForDelete.sorted(by: {$0 > $1}) {
            piles.remove(at: index)
            delegate?.onPileRemoved(at: index)
        }
    }
    private func addNewPileItem(_ title: String, _ cards: [Card]) {
        var pile = CardPile()
        cards.forEach({pile.add($0)})
        let combinedPileItem = PileItem(title: title,
                                        pile: pile,
                                        createdDate: Date(),
                                        revisedCount: 0,
                                        revisedDate: nil)
        add(pileItem: combinedPileItem)
    }
}
public protocol PileReviser {
    func revise(at section: Int, row: Int)
}
extension PilesRepository: PileReviser {
    public func revise(at section: Int, row: Int) {
        guard let index = indexResolver?.repositoryIndexFor(section: section, row: row) else { return }
        let pileItem = getPileItem(for: index)
        piles.remove(at: index)
        delegate?.onPileRemoved(at: index)
        
        let newItem = PileItem(title: pileItem.title,
                               pile: pileItem.pile,
                               createdDate: pileItem.createdDate,
                               revisedCount: pileItem.revisedCount + 1,
                               revisedDate: Date())
        piles.insert(newItem, at: index)
        delegate?.onPileAdded(pile: newItem, at: index)
    }
}
