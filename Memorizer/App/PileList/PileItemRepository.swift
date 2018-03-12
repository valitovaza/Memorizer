public protocol PileItemRepository: PileItemsCountHolder {
    func fetchPiles()
    func delete(at index: Int)
}
public protocol PileItemsCountHolder {
    var count: Int { get }
}
public protocol PileItemRepositoryDelegate: PilesCountChangersListener, PileItemChangeListener {}
public protocol PilesCountChangersListener {
    func onPilesFetched(_ pileItems: [PileItem])
    func onPileRemoved(at index: Int)
    func onPileAdded(pile: PileItem, at index: Int)
}
public protocol PileItemChangeListener {
    func onPileChanged(pile: PileItem, at index: Int)
}