import iOSAdapters

enum PileDetailsType {
    case create
    case edit(Int)
}
class PileDetailsEventReceiver {
    var router: PileDetailsRouter = RouterFactory.getPileDetailsRouter()
    var type: PileDetailsType = .create
    var repository: PilesRepositoryChanger!
    var pileFinderByIndex: PileItemByIndexProvider!
    private var tableReloader: UITableReloader!
    private var cardsDataSourceHolder: CardsDataSourceHolder!
    private var cardPileHolder: PileDataHolder!
}
protocol CardsDataSourceHolder {
    var dataSource: CardsDataSource? { get set }
    var dataCleaner: CardsTableDataCleaner? { get set }
}
extension PileDetailsEventReceiver: PileDetailsEventHandler {
    func handle(event: PileDetailsViewController.Event) {
        switch event {
        case .onPrepareSegue(let reloader, let dsHolder):
            tableReloader = reloader
            cardsDataSourceHolder = dsHolder
        case .onLoad(let pileDetailsVC):
            createCardPileHolder(pileDetailsVC)
            configureView(pileDetailsVC)
        case .onTitleChanged(let text):
            cardPileHolder.change(title: text)
        case .onAddCard:
            router.openCreateCard()
        case .onCellSecelted(let index):
            router.openCardDetails(at: index)
        case .onCancel:
            router.closePileDetails()
        case .onSave:
            onSave()
        }
    }
    private func createCardPileHolder(_ presenter: PileDetailsPresenter) {
        switch type {
        case .create:
            cardPileHolder = DependencyResolver.makePileDataHolder(SavePileViewImpl(presenter),
                                                                   CardsTableReloaderImpl(tableReloader))
        case .edit(let index):
            let pileItem = pileFinderByIndex.getPileItem(for: index)
            cardPileHolder = DependencyResolver.makePileDataHolder(SavePileViewImpl(presenter),
                                                                   CardsTableReloaderImpl(tableReloader),
                                                                   pileItem)
        }
        cardsDataSourceHolder.dataSource = cardPileHolder
        cardsDataSourceHolder.dataCleaner = cardPileHolder
    }
    private func configureView(_ view: PileDetailsConfigurable) {
        switch type {
        case .create:
            view.configureCreateView()
        case .edit(let index):
            let pileItem = pileFinderByIndex.getPileItem(for: index)
            view.configureEditView(pileTitle: pileItem.title)
        }
    }
    private func onSave() {
        switch type {
        case .create:
            repository.add(pileItem: cardPileHolder.pileItem)
        case .edit(let index):
            repository.change(pileItem: cardPileHolder.pileItem, at: index)
        }
        router.closePileDetails()
    }
}
