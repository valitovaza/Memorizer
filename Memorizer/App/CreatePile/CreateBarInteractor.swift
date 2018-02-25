public protocol CreatePileHandler {
    func onCreatePile()
}
class CreatePileInteractor {
    private let screen: CreatePileScreen
    init(_ screen: CreatePileScreen) {
        self.screen = screen
    }
}
extension CreatePileInteractor: CreatePileHandler {
    func onCreatePile() {
        screen.openCreatePileScreen()
    }
}
