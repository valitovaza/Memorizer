protocol PileRepository {
    func fetchPiles()
    func delete(at index: Int)
}
protocol PileRepositoryDelegate {
    func onPilesFetched(_ pileHolders: [CardList])
    func onPileRemoved(at index: Int)
    func onPileAdded(pile: CardList, at index: Int)
    func onPileChanged(pile: CardList, at index: Int)
}
