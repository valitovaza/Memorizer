import Foundation

extension UInt32: CardSide {}
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
func generateCards() -> [Card] {
    var cards: [Card] = []
    let maxCardsCount: UInt32 = 20
    let maxCardSideValue: UInt32 = 100
    for _ in 0..<positiveRand(maxCardsCount) {
        cards.append(Card(arc4random_uniform(maxCardSideValue),
                          arc4random_uniform(maxCardSideValue)))
    }
    return cards
}
func positiveRand(_ max: UInt32) -> UInt32 {
    return arc4random_uniform(max) + 1
}
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
extension Card: Equatable {}
public func ==(lhs: Card, rhs: Card) -> Bool {
    guard let lhsInfo = lhs.back as? CustomStringConvertible,
        let rhsInfo = rhs.back as? CustomStringConvertible else { return false }
    return lhsInfo.description == rhsInfo.description
}
