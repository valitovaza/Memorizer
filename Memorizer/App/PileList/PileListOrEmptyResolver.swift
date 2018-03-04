public class PileListOrEmptyResolver {
    private let countHolder: PilesCountHolder
    private let screen: PilesListOrEmptyScreen
    public init(_ countHolder: PilesCountHolder,
                _ screen: PilesListOrEmptyScreen) {
        self.countHolder = countHolder
        self.screen = screen
    }
}
extension PileListOrEmptyResolver: PileRepositoryDelegate {
    public func onPilesFetched(_ pileHolders: [CardList]) {
        checkCount()
    }
    public func onPileRemoved(at index: Int) {
        checkCount()
    }
    private func checkCount() {
        if countHolder.count > 0 {
            screen.presentPileList()
        }else{
            screen.presentEmpty()
        }
    }
    public func onPileAdded(pile: CardList, at index: Int) {
        screen.presentPileList()
    }
    public func onPileChanged(pile: CardList, at index: Int) {
    }
}
