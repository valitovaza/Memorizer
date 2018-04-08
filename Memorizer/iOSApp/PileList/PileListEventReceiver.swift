import iOSAdapters

class PileListEventReceiver {
    private let pilesLoader: PilesLoader
    private var pilesDataSource: PileListDataSource
    private var pileItemCleanerInTable: PileItemCleanerInTable
    var pilesRepositoryListener: PilesRepositoryListener?
    var router: PileListRouter = RouterFactory.getPileListRouter()
    init(_ pilesLoader: PilesLoader,
         _ pilesDataSource: PileListDataSource,
         _ pileItemCleanerInTable: PileItemCleanerInTable) {
        self.pilesLoader = pilesLoader
        self.pilesDataSource = pilesDataSource
        self.pileItemCleanerInTable = pileItemCleanerInTable
    }
}
extension PileListEventReceiver: PileListEventHandler {
    func handle(event: PileListViewController.Event) {
        switch event {
        case .onLoad:
            pilesLoader.onLoad()
        case .onPrepareSegue(var dataSourceHolder):
            dataSourceHolder.dataSource = pilesDataSource
            dataSourceHolder.cleanerInTable = pileItemCleanerInTable
            dataSourceHolder.router = router
            pilesDataSource.delegate = dataSourceHolder
            pilesRepositoryListener?.fetchedListeners = [TableReloaderAtFetch(dataSourceHolder)]
        case .onCreate:
            router.openCreatePile()
        }
    }
}
