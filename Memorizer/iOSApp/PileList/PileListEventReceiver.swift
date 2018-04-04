import iOSAdapters

protocol PilesDataSourceHolder {
    var dataSource: PileListDataSource! { get set }
}
class PileListEventReceiver {
    private let pilesLoader: PilesLoader
    private var pilesDataSource: PileListDataSource
    init(_ pilesLoader: PilesLoader, _ pilesDataSource: PileListDataSource) {
        self.pilesLoader = pilesLoader
        self.pilesDataSource = pilesDataSource
    }
}
extension PileListEventReceiver: PileListEventHandler {
    func handle(event: PileListViewController.Event) {
        switch event {
        case .onLoad:
            pilesLoader.onLoad()
        case .onPrepareSegue(var dataSourceHolder):
            dataSourceHolder.dataSource = pilesDataSource
            pilesDataSource.delegate = dataSourceHolder
        case .onCreate:
            print("onCreate")
        }
    }
}
