protocol PilesLoaderScreen {
    func present(state: PileListScreenState)
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
protocol PileListScreen {
    func presentNew(pile: CardList, at index: Int)
    func onPileRemoved(at index: Int)
    func presentChange(of pile: CardList, at index: Int)
}
protocol RileListRouter {
    func openEditPile(at index: Int)
    func openRepeat(at index: Int)
}
