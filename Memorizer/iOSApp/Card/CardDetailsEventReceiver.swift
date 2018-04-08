import iOSAdapters

class CardDetailsEventReceiver<CHolder: CardHolder> {
    var router: CreateCardRouter = RouterFactory.getCreateCardRouter()
    var cardsTableDataChanger: CardsTableDataChanger?
    var dataSource: CardsDataSource?
    var cardHolder: CHolder!
}
extension CardDetailsEventReceiver: CardDetailsEventHandler {
    func handle(event: CardDetailsViewController.Event) {
        switch event {
        case .onLoad(let saveCardPresenter):
            createCardHolder(saveCardPresenter)
        case .onCancel:
            onCancel()
        case .onSave:
            onSave()
        case .onFirstTextChanged(let text):
            guard let frontSide = text as? CHolder.T else { return }
            cardHolder.frontChanged(frontSide)
        case .onSecondTextChanged(let text):
            guard let backSide = text as? CHolder.T else { return }
            cardHolder.backChanged(backSide)
        }
    }
    private func createCardHolder(_ saveCardPresenter: SaveCardPresenter) {
        cardHolder = StringCardHolder(SaveCardViewImpl(saveCardPresenter)) as! CHolder
    }
    private func onCancel() {
        if cardsCountInPile > 0 {
            router.closeCreateCard()
        }else{
            router.closeCreateCardAndCreatePile()
        }
    }
    private var cardsCountInPile: Int {
        return dataSource?.cardsCount ?? 0
    }
    private func onSave() {
        guard let card = cardHolder.card else { return }
        cardsTableDataChanger?.add(card: card)
        router.closeCreateCard()
    }
}
