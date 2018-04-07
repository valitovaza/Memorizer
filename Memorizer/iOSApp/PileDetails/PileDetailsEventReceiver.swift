class PileDetailsEventReceiver {
    var router: PileDetailsRouter = RouterFactory.getPileDetailsRouter()
}
extension PileDetailsEventReceiver: PileDetailsEventHandler {
    func handle(event: PileDetailsViewController.Event) {
        switch event {
        case .onCancel:
            router.closePileDetails()
        case .onSave:
            break
        }
    }
}
