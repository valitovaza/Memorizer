import iOSAdapters

class ReviseEventReceiver {
    var pileReviser: PileReviser?
    var wordReviser: WordReviser!
    
    private var wordsHolder: ReviseWordsHolder?
    
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
        case .onLoad(let wordsHolder, let reviserView):
            wordReviser.view = reviserView
            self.wordsHolder = wordsHolder
            wordsHolder.setRevise(wordsData: wordReviser.wordsData)
        case .swipeRight(let reloader):
            wordReviser.swipeRight()
            updateCards(reloader)
        case .swipeLeft(let reloader):
            wordReviser.swipeLeft()
            updateCards(reloader)
        case .onPileRevised:
            pileReviser?.revise(at: section, row: row)
        }
    }
    private func updateCards(_ reloader: CardViewReloader) {
        wordsHolder?.setRevise(wordsData: wordReviser.wordsData)
        if wordReviser.wordsData.words.count == 1 {
            reloader.reload()
        }
    }
}
