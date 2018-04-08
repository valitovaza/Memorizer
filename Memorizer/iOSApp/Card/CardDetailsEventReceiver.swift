import iOSAdapters

enum CardDetailsType {
    case create
    case edit(Int)
}
class CardDetailsEventReceiver<CHolder: CardHolder> {
    var router: CreateCardRouter = RouterFactory.getCreateCardRouter()
    var type: CardDetailsType = .create
    var cardsTableDataChanger: CardsTableDataChanger?
    var dataSource: CardsDataSource?
    var cardHolder: CHolder!
}
extension CardDetailsEventReceiver: CardDetailsEventHandler {
    func handle(event: CardDetailsViewController.Event) {
        switch event {
        case .onLoad(let saveCardPresenter):
            createCardHolder(saveCardPresenter)
            configureView(saveCardPresenter)
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
        switch type {
        case .create:
            cardHolder = StringCardHolder(SaveCardViewImpl(saveCardPresenter)) as! CHolder
        case .edit(let index):
            guard let frontText = getFrontText(index) else { return }
            guard let backText = getBackText(index) else { return }
            let saveCardView = SaveCardViewImpl(saveCardPresenter)
            cardHolder = StringCardHolder(saveCardView, front: frontText, back: backText) as! CHolder
        }
    }
    private func getFrontText(_ index: Int) -> String? {
        guard let card = dataSource?.getCard(at: index) else { return nil }
        return card.front as? String
    }
    private func getBackText(_ index: Int) -> String? {
        guard let card = dataSource?.getCard(at: index) else { return nil }
        return card.back as? String
    }
    private func configureView(_ view: CardDetailsConfigurable) {
        switch type {
        case .create:
            view.configureCreateView()
        case .edit(let index):
            guard let frontText = getFrontText(index) else { return }
            guard let backText = getBackText(index) else { return }
            view.configureEditView(frontText, backText)
        }
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
        switch type {
        case .create:
            cardsTableDataChanger?.add(card: card)
        case .edit(let index):
            cardsTableDataChanger?.change(card: card, at: index)
        }
        router.closeCreateCard()
    }
}
