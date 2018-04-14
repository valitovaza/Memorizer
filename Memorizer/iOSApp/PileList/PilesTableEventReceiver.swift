import iOSAdapters

class PilesTableEventReceiver {
    var router: PileListRouter = RouterFactory.getPileListRouter()
    private var pileItemCleanerInTable: PileItemCleanerInTable
    private let pilesCombiner: PilesCombiner
    init(_ pileItemCleanerInTable: PileItemCleanerInTable, _ pilesCombiner: PilesCombiner) {
        self.pileItemCleanerInTable = pileItemCleanerInTable
        self.pilesCombiner = pilesCombiner
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
        }
    }
}
