class RepositorySpy: PileRepository {
    var fetchPilesWasInvoked = 0
    var onFetchPileBlock: (()->())?
    func fetchPiles() {
        fetchPilesWasInvoked += 1
        onFetchPileBlock?()
    }
    
    var deleteAtIndexWasInvoked = 0
    var deleteIndex: Int?
    func delete(at index: Int) {
        deleteAtIndexWasInvoked += 1
        deleteIndex = index
    }
}
