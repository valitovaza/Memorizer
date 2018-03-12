public class PilesRepositoryListener {
    public init() {}
    public var countListeners: [PilesCountChangersListener] = []
    public var changeListeners: [PileItemChangeListener] = []
    public var delegates: [PileItemRepositoryDelegate] = []
}
extension PilesRepositoryListener: PileItemRepositoryDelegate {
    public func onPilesFetched(_ pileItems: [PileItem]) {
        countListeners.forEach({$0.onPilesFetched(pileItems)})
        delegates.forEach({$0.onPilesFetched(pileItems)})
    }
    
    public func onPileRemoved(at index: Int) {
        countListeners.forEach({$0.onPileRemoved(at: index)})
        delegates.forEach({$0.onPileRemoved(at: index)})
    }
    
    public func onPileAdded(pile: PileItem, at index: Int) {
        countListeners.forEach({$0.onPileAdded(pile: pile, at: index)})
        delegates.forEach({$0.onPileAdded(pile: pile, at: index)})
    }
    
    public func onPileChanged(pile: PileItem, at index: Int) {
        changeListeners.forEach({$0.onPileChanged(pile: pile, at: index)})
        delegates.forEach({$0.onPileChanged(pile: pile, at: index)})
    }
}
