import iOSAdapters

protocol DependencyProvider {
    var pilesRepository: PileItemRepository { get }
    var pileListDataSource: PileListDataSource { get }
    var pilesRepositoryListener: PilesRepositoryListener { get }
    
    var pileDetailsEventHandler: PileDetailsEventHandler { get }
    
    var cardDetailsEventHandler: CardDetailsEventHandler { get }
    func makePileDataHolder(_ view: SavePileView, _ reloader: CardsTableReloader) -> PileDataHolder
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
    static func getPilesRepositoryListener() -> PilesRepositoryListener {
        return dependencyProvider.pilesRepositoryListener
    }
    
    static func getPileDetailsEventHandler() -> PileDetailsEventHandler {
        return dependencyProvider.pileDetailsEventHandler
    }
    
    static func getCardDetailsEventHandler() -> CardDetailsEventHandler {
        return dependencyProvider.cardDetailsEventHandler
    }
    static func makePileDataHolder(_ view: SavePileView, _ reloader: CardsTableReloader) -> PileDataHolder {
        return dependencyProvider.makePileDataHolder(view, reloader)
    }
}
class AppDependencyProvider {
    private let pilesDataSource = PilesDataSource()
    private let pRepository = PilesRepository()
    private let pRepositoryListener = PilesRepositoryListener()
    private weak var lastPileDataHolder: PileDataHolder?
    init() {
        pRepository.delegate = pRepositoryListener
        pRepositoryListener.delegates = [pilesDataSource]
    }
}
extension AppDependencyProvider: DependencyProvider {
    var pilesRepository: PileItemRepository {
        return pRepository
    }
    var pileListDataSource: PileListDataSource {
        return pilesDataSource
    }
    var pilesRepositoryListener: PilesRepositoryListener {
        return pRepositoryListener
    }
    
    var pileDetailsEventHandler: PileDetailsEventHandler {
        return PileDetailsEventReceiver()
    }
    
    var cardDetailsEventHandler: CardDetailsEventHandler {
        let eventReceiver = CardDetailsEventReceiver<StringCardHolder>()
        eventReceiver.cardsTableDataChanger = lastPileDataHolder
        eventReceiver.dataSource = lastPileDataHolder
        return eventReceiver
    }
    func makePileDataHolder(_ view: SavePileView, _ reloader: CardsTableReloader) -> PileDataHolder {
        let lastPileDataHolder = PileDataHolder(view, reloader)
        self.lastPileDataHolder = lastPileDataHolder
        return lastPileDataHolder
    }
}
