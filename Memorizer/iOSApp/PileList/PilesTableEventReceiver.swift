import iOSAdapters

class PilesTableEventReceiver {    
    var router: PileListRouter = RouterFactory.getPileListRouter()
    private var pileItemCleanerInTable: PileItemCleanerInTable
    private let pilesCombiner: PilesCombiner
    private let netUpdater: NetUpdater
    init(_ pileItemCleanerInTable: PileItemCleanerInTable,
         _ pilesCombiner: PilesCombiner,
         _ netUpdater: NetUpdater) {
        self.pileItemCleanerInTable = pileItemCleanerInTable
        self.pilesCombiner = pilesCombiner
        self.netUpdater = netUpdater
    }
}
extension PilesTableEventReceiver: PilesTableEventHandler {
    func handle(event: PilesTableViewController.Event) {
        switch event {
        case .onDelete(section: let section, row: let row):
            pileItemCleanerInTable.deleteIn(section: section, row: row)
        case .openDetails(section: let section, row: let row):
            router.openPileDetails(at: section, row: row)
        case .onCombine(section: let section, row: let row):
            pilesCombiner.setCombine(section: section, row: row)
        case .selectedCountChanged(let count):
            pilesCombiner.selectedCountChanged(count)
        case .onSelect(section: let section, row: let row):
            router.openPileToRevise(at: section, row: row)
        case .viewDidAppear(let animator, let dataSource):
            if dataSource.sectionsCount > 0 {
                PileListOnboarding(animator, dataSource).animateIfNeed()
            }else{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    PileListOnboarding(animator, dataSource).animateIfNeed()
                }
            }
            netUpdater.fetchAndSavePilesOptionally()
            netUpdater.sendLocalPilesOptionally()
        }
    }
}
