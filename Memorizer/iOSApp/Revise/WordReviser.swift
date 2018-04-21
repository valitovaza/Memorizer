import iOSAdapters

protocol WordReviser {
    func swipeLeft()
    func swipeRight()
    var wordsData: WordsData { get }
    var view: WordReviserView? { get set }
}
protocol WordReviserView: class {
    func pileRevised()
    func turnPile(_ wordsData: WordsData)
}
class WordReviserImpl {
    private var isReverted = false
    private var pile: CardPile
    
    weak var view: WordReviserView?
    
    init(_ pile: CardPile) {
        self.pile = pile
        shuffleAndPrepareForExam()
    }
    private func shuffleAndPrepareForExam() {
        pile.shuffle()
        pile.prepareForExam()
    }
}
extension WordReviserImpl: WordReviser {
    func swipeLeft() {
        pile.markTopCardForgotten()
    }
    func swipeRight() {
        pile.markTopCardRemembered()
        checkIsPileRevised()
    }
    private func checkIsPileRevised() {
        guard pile.isExamined else { return }
        isReverted = !isReverted
        shuffleAndPrepareForExam()
        view?.turnPile(wordsData)
    }
    var wordsData: WordsData {
        let words = pile.cards.compactMap({(front: $0.front, back: $0.back) as? (front: String, back: String)})
        return WordsData(words: words, isReverted: isReverted)
    }
}
