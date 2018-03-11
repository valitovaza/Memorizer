public protocol PilesLoader {
    func onLoad()
}
public class PileListLoader {
    private let repository: PileItemRepository
    private let screen: PilesLoaderScreen
    public init(_ screen: PilesLoaderScreen,
                _ repository: PileItemRepository) {
        self.screen = screen
        self.repository = repository
    }
}
extension PileListLoader: PilesLoader {
    public func onLoad() {
        screen.presentLoading()
        repository.fetchPiles()
    }
}
