public protocol CardPileTitleChanger {
    func change(title: String)
}
public protocol CardsTableDataChanger {
    func add(card: Card)
    func change(card: Card, at index: Int)
}
public protocol CardsTableDataCleaner {
    func removePile(at index: Int)
}
public protocol CardsDataSource {
    var cardsCount: Int { get }
    func getCard(at index: Int) -> Card
}
public protocol SavePileView {
    func updateTitle(_ title: String)
    func enableSaveButton()
    func disableSaveButton()
}
public protocol CardsTableReloader {
    func reloadTable()
}
public class PileDataHolder {
    private var title = ""
    private var cards: [Card] = []
    
    private let view: SavePileView
    private let reloader: CardsTableReloader
    public init(_ view: SavePileView, _ reloader: CardsTableReloader) {
        self.view = view
        self.reloader = reloader
    }
}
extension PileDataHolder: CardsTableDataChanger {
    public func add(card: Card) {
        cards.insert(card, at: 0)
        reloadTableAndCheckSaveButton()
        updateTitleIfNeed()
    }
    private func reloadTableAndCheckSaveButton() {
        reloader.reloadTable()
        checkSaveButton()
    }
    private func checkSaveButton() {
        if cards.isEmpty {
            view.disableSaveButton()
        }else{
            view.enableSaveButton()
        }
    }
    private func updateTitleIfNeed() {
        guard title.isEmpty, let firstCard = cards.first,
            let frontString = firstCard.front as? String else { return }
        title = "[\(frontString)]..."
        view.updateTitle(title)
    }
    public func change(card: Card, at index: Int) {
        cards[index] = card
        reloadTableAndCheckSaveButton()
    }
}
extension PileDataHolder: CardsTableDataCleaner {
    public func removePile(at index: Int) {
        cards.remove(at: index)
        reloadTableAndCheckSaveButton()
        cleanTitleIfNeed()
    }
    private func cleanTitleIfNeed() {
        if cards.isEmpty {
            title = ""
            view.updateTitle(title)
        }
    }
}
extension PileDataHolder: CardPileTitleChanger {
    public func change(title: String) {
        self.title = title
    }
}
extension PileDataHolder: CardsDataSource {
    public var cardsCount: Int {
        return cards.count
    }
    public func getCard(at index: Int) -> Card {
        return cards[index]
    }
}
