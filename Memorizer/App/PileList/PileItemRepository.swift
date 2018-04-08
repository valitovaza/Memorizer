public protocol PileItemRepository: PileItemsCountHolder {
    func fetchPiles()
}
public protocol PileItemsCountHolder {
    var count: Int { get }
}
public protocol PilesRepositoryChanger {
    func add(pileItem: PileItem)
    func change(pileItem: PileItem, at index: Int)
}
public protocol PileItemRepositoryDelegate: PilesCountChangersListener, PileItemChangeListener {}
public protocol PilesCountChangersListener: PilesFetchedListener {
    func onPileRemoved(at index: Int)
    func onPileAdded(pile: PileItem, at index: Int)
}
public protocol PilesFetchedListener {
    func onPilesFetched(_ pileItems: [PileItem])
}
public protocol PileItemChangeListener {
    func onPileChanged(pile: PileItem, at index: Int)
}
public protocol RepositoryIndexFinder {
    func repositoryIndexFor(section: Int, row: Int) -> Int?
}
