import iOSAdapters

class CreateCardEventReceiver<CHolder: CardHolder> {
    var router: CreateCardRouter = RouterFactory.getCreateCardRouter()
    var cardHolder: CHolder!
}
extension CreateCardEventReceiver: CreateCardEventHandler {
    func handle(event: CreateCardViewController.Event) {
        switch event {
        case .onLoad(let saveCardPresenter):
            cardHolder = StringCardHolder(SaveCardViewImpl(saveCardPresenter)) as! CHolder
        case .onCancel:
            router.closeCreateCard()
        case .onSave:
            router.closeCreateCard()
        case .onFirstTextChanged(let text):
            guard let frontSide = text as? CHolder.T else { return }
            cardHolder.frontChanged(frontSide)
        case .onSecondTextChanged(let text):
            guard let backSide = text as? CHolder.T else { return }
            cardHolder.backChanged(backSide)
        }
    }
}
