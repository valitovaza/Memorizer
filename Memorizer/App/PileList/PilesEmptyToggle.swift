public class PilesEmptyToggle {
    private let countHolder: PileItemsCountHolder
    private let screen: PilesOrEmptyScreen
    public init(_ countHolder: PileItemsCountHolder,
                _ screen: PilesOrEmptyScreen) {
        self.countHolder = countHolder
        self.screen = screen
    }
}
extension PilesEmptyToggle: PilesCountChangersListener {
    public func onPilesFetched(_ pileItems: [PileItem]) {
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
    public func onPileAdded(pile: PileItem, at index: Int) {
        screen.presentPileList()
    }
}
