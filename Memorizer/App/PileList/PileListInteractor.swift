protocol PileListEventHandler {
    func onLoad()
    func onEdit(at index: Int)
    func onRepeat(at index: Int)
    func onDelete(at index: Int)
}
class PileListInteractor {
    private let repository: PileRepository
    private let screen: PileListScreen
    init(_ screen: PileListScreen,
         _ repository: PileRepository) {
        self.screen = screen
        self.repository = repository
    }
}
extension PileListInteractor: PileListEventHandler {
    func onLoad() {
        screen.present(state: .loading)
        repository.fetchPiles()
    }
    func onEdit(at index: Int) {
        screen.openEditPile(at: index)
    }
    func onRepeat(at index: Int) {
        screen.openRepeat(at: index)
    }
    func onDelete(at index: Int) {
        repository.delete(at: index)
    }
}
extension PileListInteractor: PileRepositoryDelegate {
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
