import iOSAdapters

typealias PileItemContainer = PileItemCleanerInTable & PileItemCombiner
class PileListEventReceiver {
    private let pilesLoader: PilesLoader
    private var pilesDataSource: PileListDataSource
    private var pileItemContainer: PileItemContainer
    private var combineWorker: CombineWorker?
    var router: PileListRouter = RouterFactory.getPileListRouter()
    var pilesRepositoryListener: PilesRepositoryListener?
    init(_ pilesLoader: PilesLoader,
         _ pilesDataSource: PileListDataSource,
         _ pileItemContainer: PileItemContainer) {
        self.pilesLoader = pilesLoader
        self.pilesDataSource = pilesDataSource
        self.pileItemContainer = pileItemContainer
    }
}
extension PileListEventReceiver: PileListEventHandler {
    func handle(event: PileListViewController.Event) {
        switch event {
        case .onLoad:
            pilesLoader.onLoad()
        case .onPrepareSegue(var dataSourceHolder, let doneView):
            dataSourceHolder.dataSource = pilesDataSource
            let combineWorker = CombineWorker(doneView, dataSourceHolder, pileItemContainer)
            dataSourceHolder.eventHandler = PilesTableEventReceiver(pileItemContainer, combineWorker)
            pilesDataSource.delegate = dataSourceHolder
            pilesRepositoryListener?.fetchedListeners = [TableReloaderAtFetch(dataSourceHolder)]
            self.combineWorker = combineWorker
        case .onCreate:
            router.openCreatePile()
        case .doneTableSelection:
            combineWorker?.combine()
        case .cancelTableSelection:
            combineWorker?.cancel()
        }
    }
}
