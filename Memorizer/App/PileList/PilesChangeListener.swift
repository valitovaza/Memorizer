class PilesChangeListener {
    private let screen: PilesScreen
    init(_ screen: PilesScreen) {
        self.screen = screen
    }
}
extension PilesChangeListener: PileRepositoryDelegate {
    func onPilesFetched(_ pileHolders: [CardList]) {
        if pileHolders.count > 0 {
            screen.present(piles: pileHolders)
        }else{
            screen.presentEmpty()
        }
    }
    func onPileRemoved(at index: Int) {
        screen.onPileRemoved(at: index)
    }
    func onPileAdded(pile: CardList, at index: Int) {
        screen.presentNew(pile: pile, at: index)
    }
    func onPileChanged(pile: CardList, at index: Int) {
        screen.presentChange(of: pile, at: index)
    }
}
