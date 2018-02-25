public protocol PilesLoaderScreen {
    func presentLoading()
}
protocol PilesScreen {
    func present(piles: [CardList])
    func presentEmpty()
    func presentNew(pile: CardList, at index: Int)
    func onPileRemoved(at index: Int)
    func presentChange(of pile: CardList, at index: Int)
}
protocol CardList {
    var cards: [Card] { get }
}
extension CardPile: CardList {}
protocol RileListRouter {
    func openEditPile(at index: Int)
    func openRepeat(at index: Int)
}
