public protocol Pile {
    var isExamined: Bool { get }
    mutating func add(_ card: Card)
    mutating func remove(at index: Int)
    mutating func shuffle()
    mutating func markTopCardRemembered()
    mutating func markTopCardForgotten()
    mutating func prepareForExam()
}

typealias CardInfo = (card: Card, isExamined: Bool)

public struct CardPile {
    
    var shuffler: Shuffler = ArrayShuffler()
    
    public var cards: [Card] {
        return cardInfos.map({$0.0})
    }
    
    private var cardInfos: [CardInfo] = []
    private let forgottenIndex = 3
}
extension CardPile: Pile {
    public var isExamined: Bool {
        return cardInfos.filter({!$0.isExamined}).isEmpty
    }
    public mutating func add(_ card: Card) {
        cardInfos.insert((card, false), at: 0)
    }
    public mutating func remove(at index: Int) {
        guard isCardsValidIndex(index) else { return }
        cardInfos.remove(at: index)
    }
    public mutating func shuffle() {
        cardInfos = shuffler.shuffle(cardInfos)
    }
    public mutating func markTopCardRemembered() {
        guard cardInfos.count > 0 else { return }
        setTopExamined(true)
        cardInfos.append(cardInfos.remove(at: 0))
    }
    public mutating func markTopCardForgotten() {
        guard cardInfos.count > 0 else { return }
        setTopExamined(false)
        insertForgotten(cardInfos.removeFirst())
    }
    public mutating func prepareForExam() {
        guard cardInfos.count > 0 else { return }
        for index in 0..<cardInfos.count {
            cardInfos[index] = (cardInfos[index].card, false)
        }
    }
    
    private mutating func setTopExamined(_ isExamined: Bool) {
        cardInfos[0] = (cardInfos[0].card, isExamined)
    }
    private mutating func insertForgotten(_ cardInfo: CardInfo) {
        if cardInfos.count >= forgottenIndex {
            cardInfos.insert(cardInfo, at: forgottenIndex)
        }else{
            cardInfos.append(cardInfo)
        }
    }
    private func isCardsValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < cards.count
    }
}
