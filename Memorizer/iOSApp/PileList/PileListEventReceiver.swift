import iOSAdapters

class PileListEventReceiver {
    private let pilesLoader: PilesLoader
    private let createInteractor: CreatePileHandler
    init(_ pilesLoader: PilesLoader,
         _ createInteractor: CreatePileHandler) {
        self.pilesLoader = pilesLoader
        self.createInteractor = createInteractor
    }
}
extension PileListEventReceiver: PileListEventHandler {
    func handle(event: PileListViewController.Event) {
        switch event {
        case .onLoad:
            pilesLoader.onLoad()
        case .onCreate:
            createInteractor.onCreatePile()
        }
    }
}
