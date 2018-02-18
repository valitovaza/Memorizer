class PilesScreenPresenter {
    private let createBar: Presenter
    private let pileList: Presenter
    init(_ createBar: Presenter,
         _ pileList: Presenter) {
        self.createBar = createBar
        self.pileList = pileList
    }
}
extension PilesScreenPresenter: Presenter {
    func present() {
        createBar.present()
        pileList.present()
    }
}
