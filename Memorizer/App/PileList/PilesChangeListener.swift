protocol PilesChangesListenerScreen: PileListScreen, PilesLoaderScreen {}
class PilesChangeListener {
    private let screen: PilesChangesListenerScreen
    init(_ screen: PilesChangesListenerScreen) {
        self.screen = screen
    }
}
extension PilesChangeListener: PileRepositoryDelegate {
    func onPilesFetched(_ pileHolders: [CardList]) {
        if pileHolders.count > 0 {
            screen.present(state: .piles(pileHolders))
        }else{
            screen.present(state: .empty)
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
