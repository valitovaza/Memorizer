import iOSAdapters

class PileListEventReceiver {
    private let pilesLoader: PilesLoader
    private var pilesDataSource: PileListDataSource
    var pilesRepositoryListener: PilesRepositoryListener?
    var router: PileListRouter = RouterFactory.getPileListRouter()
    init(_ pilesLoader: PilesLoader, _ pilesDataSource: PileListDataSource) {
        self.pilesLoader = pilesLoader
        self.pilesDataSource = pilesDataSource
    }
}
extension PileListEventReceiver: PileListEventHandler {
    func handle(event: PileListViewController.Event) {
        switch event {
        case .onLoad:
            pilesLoader.onLoad()
        case .onPrepareSegue(var dataSourceHolder):
            dataSourceHolder.dataSource = pilesDataSource
            pilesDataSource.delegate = dataSourceHolder
            pilesRepositoryListener?.fetchedListeners = [TableReloaderAtFetch(dataSourceHolder)]
        case .onCreate:
            router.openCreatePile()
        }
    }
}
