protocol PileListScreen {
    func present(state: PileListScreenState)
    func presentNew(pile: CardList, at index: Int)
    func onPileRemoved(at index: Int)
    func presentChange(of pile: CardList, at index: Int)
    func openEditPile(at index: Int)
    func openRepeat(at index: Int)
}
enum PileListScreenState {
    case loading
    case empty
    case piles([CardList])
}
protocol CardList {
    var cards: [Card] { get }
}
extension CardPile: CardList {}

