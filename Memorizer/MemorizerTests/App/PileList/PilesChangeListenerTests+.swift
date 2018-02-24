import Foundation

extension UInt32: CardSide {}
extension PilesChangeListenerTests {
    struct CardHolderStub: CardList {
        var cards: [Card]
    }
    var generatedTestPileHolder: CardList {
        return CardHolderStub(cards: generateCards())
    }
    var generatedTestPileHolders: [CardList] {
        var cardHolders: [CardList] = []
        let maxPilesCount: UInt32 = 20
        for _ in 0..<positiveRand(maxPilesCount) {
            cardHolders.append(generatedTestPileHolder)
        }
        return cardHolders
    }
    private func generateCards() -> [Card] {
        var cards: [Card] = []
        let maxCardsCount: UInt32 = 20
        let maxCardSideValue: UInt32 = 100
        for _ in 0..<positiveRand(maxCardsCount) {
            cards.append(Card(arc4random_uniform(maxCardSideValue),
                              arc4random_uniform(maxCardSideValue)))
        }
        return cards
    }
    private func positiveRand(_ max: UInt32) -> UInt32 {
        return arc4random_uniform(max) + 1
    }
}
extension PileListScreenState: Equatable {}
func compare(_ lholders: [CardList], _ rholders: [CardList]) -> Bool {
    guard lholders.count == rholders.count else { return false }
    for (index, element) in lholders.enumerated() {
        guard `is`(rholders[index], equalTo: element) else { return false }
    }
    return true
}
func `is`(_ lholder: CardList, equalTo rholder: CardList) -> Bool {
    guard lholder.cards.count == rholder.cards.count else { return false }
    for (index, element) in lholder.cards.enumerated() {
        guard rholder.cards[index] == element else { return false }
    }
    return true
}
func ==(lhs: PileListScreenState, rhs: PileListScreenState) -> Bool {
    if case .loading = lhs, case .loading = rhs {
        return true
    }
    if case .empty = lhs, case .empty = rhs {
        return true
    }
    if case .piles(let lholders) = lhs,
        case .piles(let rholders) = rhs {
        return compare(lholders, rholders)
    }
    return false
}
extension Card: Equatable {}
func ==(lhs: Card, rhs: Card) -> Bool {
    return lhs.back.cardText == rhs.back.cardText
}
