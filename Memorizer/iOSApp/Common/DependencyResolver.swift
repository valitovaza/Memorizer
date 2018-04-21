import iOSAdapters

protocol DependencyProvider {
    var pilesRepository: PileItemRepository { get }
    var pileListDataSource: PileListDataSource { get }
    var pileItemContainer: PileItemContainer { get }
    var pilesRepositoryListener: PilesRepositoryListener { get }
    
    var pileDetailsEventHandler: PileDetailsEventHandler { get }
    func getEditPileDetailsEventHandler(section: Int, row: Int) -> PileDetailsEventHandler
    
    var cardDetailsEventHandler: CardDetailsEventHandler { get }
    func getEditCardDetailsEventHandler(_ index: Int) -> CardDetailsEventHandler
    func makePileDataHolder(_ view: SavePileView, _ reloader: CardsTableReloader) -> PileDataHolder
    func makePileDataHolder(_ view: SavePileView, _ reloader: CardsTableReloader,
                            _ pileItem: PileItem) -> PileDataHolder
    
    func makeReviseEventHandler(_ section: Int, _ row: Int) -> ReviseEventHandler
}
class DependencyResolver {
    private static var dependencyProvider: DependencyProvider!
    
    static func set(dependencyProvider: DependencyProvider) {
        self.dependencyProvider = dependencyProvider
    }
    
    static func getPileItemRepository() -> PileItemRepository {
        return dependencyProvider.pilesRepository
    }
    static func getPileListDataSource() -> PileListDataSource {
        return dependencyProvider.pileListDataSource
    }
    static func getPileItemContainer() -> PileItemContainer {
        return dependencyProvider.pileItemContainer
    }
    static func getPilesRepositoryListener() -> PilesRepositoryListener {
        return dependencyProvider.pilesRepositoryListener
    }
    
    static func getPileDetailsEventHandler() -> PileDetailsEventHandler {
        return dependencyProvider.pileDetailsEventHandler
    }
    static func getEditPileDetailsEventHandler(section: Int, row: Int) -> PileDetailsEventHandler {
        return dependencyProvider.getEditPileDetailsEventHandler(section: section, row: row)
    }
    
    static func getCardDetailsEventHandler() -> CardDetailsEventHandler {
        return dependencyProvider.cardDetailsEventHandler
    }
    static func getEditCardDetailsEventHandler(_ index: Int) -> CardDetailsEventHandler {
        return dependencyProvider.getEditCardDetailsEventHandler(index)
    }
    static func makePileDataHolder(_ view: SavePileView, _ reloader: CardsTableReloader) -> PileDataHolder {
        return dependencyProvider.makePileDataHolder(view, reloader)
    }
    static func makePileDataHolder(_ view: SavePileView, _ reloader: CardsTableReloader,
                                   _ pileItem: PileItem) -> PileDataHolder {
        return dependencyProvider.makePileDataHolder(view, reloader, pileItem)
    }
    
    static func makeReviseEventHandler(_ section: Int, _ row: Int) -> ReviseEventHandler {
        return dependencyProvider.makeReviseEventHandler(section, row)
    }
}
class AppDependencyProvider {
    private let pilesDataSource = PilesDataSource()
    private let pRepository = PilesRepository()
    private let pRepositoryListener = PilesRepositoryListener()
    private weak var lastPileDataHolder: PileDataHolder?
    init() {
        pRepository.delegate = pRepositoryListener
        pRepository.indexResolver = pilesDataSource
        
        let notificationScheduler = ReviseAlertScheduler(LocalAlertTextProvider())
        let notificationPlanner = ReviseAlertPlanner(notificationScheduler, pRepository)
        pRepositoryListener.delegates = [pilesDataSource, notificationPlanner]
    }
}
extension AppDependencyProvider: DependencyProvider {
    var pilesRepository: PileItemRepository {
        return pRepository
    }
    var pileListDataSource: PileListDataSource {
        return pilesDataSource
    }
    var pileItemContainer: PileItemContainer {
        return pRepository
    }
    var pilesRepositoryListener: PilesRepositoryListener {
        return pRepositoryListener
    }
    
    var pileDetailsEventHandler: PileDetailsEventHandler {
        let eventReceiver = PileDetailsEventReceiver()
        eventReceiver.repository = pRepository
        return eventReceiver
    }
    func getEditPileDetailsEventHandler(section: Int, row: Int) -> PileDetailsEventHandler {
        let eventReceiver = PileDetailsEventReceiver()
        eventReceiver.repository = pRepository
        eventReceiver.type = .edit(pilesDataSource.repositoryIndexFor(section: section, row: row)!)
        eventReceiver.pileFinderByIndex = pRepository
        return eventReceiver
    }
    
    var cardDetailsEventHandler: CardDetailsEventHandler {
        return cardDetailsEventReceiver
    }
    private var cardDetailsEventReceiver: CardDetailsEventReceiver<StringCardHolder> {
        let eventReceiver = CardDetailsEventReceiver<StringCardHolder>()
        eventReceiver.cardsTableDataChanger = lastPileDataHolder
        eventReceiver.dataSource = lastPileDataHolder
        return eventReceiver
    }
    func getEditCardDetailsEventHandler(_ index: Int) -> CardDetailsEventHandler {
        let eventReceiver = cardDetailsEventReceiver
        eventReceiver.type = .edit(index)
        return eventReceiver
    }
    func makePileDataHolder(_ view: SavePileView, _ reloader: CardsTableReloader) -> PileDataHolder {
        let lastPileDataHolder = PileDataHolder(view, reloader)
        self.lastPileDataHolder = lastPileDataHolder
        return lastPileDataHolder
    }
    func makePileDataHolder(_ view: SavePileView, _ reloader: CardsTableReloader,
                            _ pileItem: PileItem) -> PileDataHolder {
        let lastPileDataHolder = PileDataHolder(view, reloader, pileItem)
        self.lastPileDataHolder = lastPileDataHolder
        return lastPileDataHolder
    }
    
    func makeReviseEventHandler(_ section: Int, _ row: Int) -> ReviseEventHandler {
        let eventHandler = ReviseEventReceiver(section, row)
        eventHandler.wordReviser = WordReviserImpl(pRepository.getPileCard(at: ItemPosition(section, row))!)
        eventHandler.pileReviser = pRepository
        return eventHandler
    }
}
