import iOSAdapters

class ReviseEventReceiver {
    var wordsProvider: WordsProvider?
    private let section: Int
    private let row: Int
    init(_ section: Int, _ row: Int) {
        self.section = section
        self.row = row
    }
}
extension ReviseEventReceiver: ReviseEventHandler {
    func handle(event: ReviseViewController.Event) {
        switch event {
        case .onLoad(let wordsHolder):
            let words = wordsProvider?.wordsFor(section: section, row: row) ?? []
            wordsHolder.addRevise(words: words)
        case .swipeRight:
            break
        case .swipeLeft:
            break
        }
    }
}
