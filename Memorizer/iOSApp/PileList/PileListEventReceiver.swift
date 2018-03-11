import iOSAdapters

class PileListEventReceiver {
    private let pilesLoader: PilesLoader
    var pilesEmptyToggle: PilesEmptyToggle?
    init(_ pilesLoader: PilesLoader) {
        self.pilesLoader = pilesLoader
    }
}
extension PileListEventReceiver: PileListEventHandler {
    func handle(event: PileListViewController.Event) {
        switch event {
        case .onLoad:
            pilesLoader.onLoad()
        case .onCreate:
            print("onCreate")
        }
    }
}
