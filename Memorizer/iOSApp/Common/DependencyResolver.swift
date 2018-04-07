import iOSAdapters

protocol DependencyProvider {
    var pilesRepository: PileItemRepository { get }
    var pileListDataSource: PileListDataSource { get }
    var pilesRepositoryListener: PilesRepositoryListener { get }
    
    var pileDetailsEventHandler: PileDetailsEventHandler { get }
    var createCardEventHandler: CreateCardEventHandler { get }
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
    
    static func getCreateCardEventHandler() -> CreateCardEventHandler {
        return dependencyProvider.createCardEventHandler
    }
}
class AppDependencyProvider {
    private let pilesDataSource = PilesDataSource()
    private let pRepository = PilesRepository()
    private let pRepositoryListener = PilesRepositoryListener()
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
    
    var createCardEventHandler: CreateCardEventHandler {
        return CreateCardEventReceiver<StringCardHolder>()
    }
}
