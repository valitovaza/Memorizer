public protocol PileRepository: PilesCountHolder {
    func fetchPiles()
    func delete(at index: Int)
}
public protocol PilesCountHolder {
    var count: Int { get }
}
protocol PileRepositoryDelegate: class {
    func onPilesFetched(_ pileHolders: [CardList])
    func onPileRemoved(at index: Int)
    func onPileAdded(pile: CardList, at index: Int)
    func onPileChanged(pile: CardList, at index: Int)
}
