class PileListOrEmptyResolver {
    private let countHolder: PilesCountHolder
    private let screen: PilesListOrEmptyScreen
    init(_ countHolder: PilesCountHolder,
         _ screen: PilesListOrEmptyScreen) {
        self.countHolder = countHolder
        self.screen = screen
    }
}
extension PileListOrEmptyResolver: PileRepositoryDelegate {
    func onPilesFetched(_ pileHolders: [CardList]) {
        checkCount()
    }
    func onPileRemoved(at index: Int) {
        checkCount()
    }
    private func checkCount() {
        if countHolder.count > 0 {
            screen.presentPileList()
        }else{
            screen.presentEmpty()
        }
    }
    func onPileAdded(pile: CardList, at index: Int) {
        screen.presentPileList()
    }
    func onPileChanged(pile: CardList, at index: Int) {
    }
}
