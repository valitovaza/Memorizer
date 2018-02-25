protocol PileList {
    func onEdit(at index: Int)
    func onRepeat(at index: Int)
    func onDelete(at index: Int)
}
class PileActionsWorker {
    private let router: RileListRouter
    private let repository: PileRepository
    init(_ router: RileListRouter,
         _ repository: PileRepository) {
        self.router = router
        self.repository = repository
    }
}
extension PileActionsWorker: PileList {
    func onEdit(at index: Int) {
        router.openEditPile(at: index)
    }
    func onRepeat(at index: Int) {
        router.openRepeat(at: index)
    }
    func onDelete(at index: Int) {
        repository.delete(at: index)
    }
}
