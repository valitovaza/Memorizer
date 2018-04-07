class CreateCardEventReceiver {
    var router: CreateCardRouter = RouterFactory.getCreateCardRouter()
}
extension CreateCardEventReceiver: CreateCardEventHandler {
    func handle(event: CreateCardViewController.Event) {
        switch event {
        case .onCancel:
            router.closeCreateCard()
        case .onSave:
            router.closeCreateCard()
        case .onFirstTextChanged(_):
            break
        case .onSecondTextChanged(_):
            break
        }
    }
}
