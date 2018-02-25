public protocol CreatePileHandler {
    func onCreatePile()
}
class CreatePileLogic {
    private let screen: CreatePileScreen
    init(_ screen: CreatePileScreen) {
        self.screen = screen
    }
}
extension CreatePileLogic: CreatePileHandler {
    func onCreatePile() {
        screen.openCreatePileScreen()
    }
}
