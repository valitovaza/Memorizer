import iOSAdapters

typealias PileItemContainer = PileItemCleanerInTable & PileItemCombiner & PilesReviseStateUpdater
class PileListEventReceiver {
    private let pilesLoader: PilesLoader
    private var pilesDataSource: PileListDataSource
    private var pileItemContainer: PileItemContainer
    private var combineWorker: CombineWorker?
    private let pilesReviseUpdater: PilesReviseUpdater
    var router: PileListRouter = RouterFactory.getPileListRouter()
    var pilesRepositoryListener: PilesRepositoryListener?
    var pilesFetcher: PileItemRepository?
    init(_ pilesLoader: PilesLoader,
         _ pilesDataSource: PileListDataSource,
         _ pileItemContainer: PileItemContainer) {
        self.pilesLoader = pilesLoader
        self.pilesDataSource = pilesDataSource
        self.pileItemContainer = pileItemContainer
        pilesReviseUpdater = PilesReviseUpdater(pileItemContainer)
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
            let netWorker = CloudKitCache(CoreDataPileWorker(), PileUpdater(self))
            dataSourceHolder.eventHandler = PilesTableEventReceiver(pileItemContainer,
                                                                    combineWorker, netWorker)
            pilesDataSource.delegate = dataSourceHolder
            pilesRepositoryListener?.fetchedListeners = [TableReloaderAtFetch(dataSourceHolder)]
            self.combineWorker = combineWorker
        case .onCreate:
            router.openCreatePile()
        case .doneTableSelection:
            combineWorker?.combine()
        case .cancelTableSelection:
            combineWorker?.cancel()
        case .didAppear:
            pilesReviseUpdater.unblockTimer()
        case .didDisappear:
            pilesReviseUpdater.blockTimer()
        }
    }
}
struct PileUpdater: PileUpdatesPresenter {
    private weak var er: PileListEventReceiver?
    init(_ er: PileListEventReceiver) {
        self.er = er
    }
    func pilesLoaded() {
        er?.pilesFetcher?.fetchPiles()
    }
}
