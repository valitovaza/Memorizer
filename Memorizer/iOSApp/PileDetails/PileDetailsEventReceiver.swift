import iOSAdapters

class PileDetailsEventReceiver {
    var router: PileDetailsRouter = RouterFactory.getPileDetailsRouter()
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
        case .onLoad(let presenter):
            cardPileHolder = DependencyResolver.makePileDataHolder(SavePileViewImpl(presenter),
                                                                   CardsTableReloaderImpl(tableReloader))
            cardsDataSourceHolder.dataSource = cardPileHolder
            cardsDataSourceHolder.dataCleaner = cardPileHolder
        case .onTitleChanged(let text):
            cardPileHolder.change(title: text)
        case .onAddCard:
            router.openCreateCard()
        case .onCancel:
            router.closePileDetails()
        case .onSave:
            break
        }
    }
}
