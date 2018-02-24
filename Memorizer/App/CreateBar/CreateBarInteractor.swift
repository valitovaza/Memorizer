protocol CreateBarEventHandler {
    func onCreatePile()
}
class CreateBarInteractor {
    private let screen: CreateBarScreen
    init(_ screen: CreateBarScreen) {
        self.screen = screen
    }
}
extension CreateBarInteractor: CreateBarEventHandler {
    func onCreatePile() {
        screen.openCreatePileScreen()
    }
}
