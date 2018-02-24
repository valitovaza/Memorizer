protocol PilesLoader {
    func onLoad()
}
class PileListLoader {
    private let repository: PileRepository
    private let screen: PilesLoaderScreen
    init(_ screen: PilesLoaderScreen,
         _ repository: PileRepository) {
        self.screen = screen
        self.repository = repository
    }
}
extension PileListLoader: PilesLoader {
    func onLoad() {
        screen.present(state: .loading)
        repository.fetchPiles()
    }
}
