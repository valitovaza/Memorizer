public struct Card {
    public let front: CardSide
    public let back: CardSide
    init(_ front: CardSide, _ back: CardSide) {
        self.front = front
        self.back = back
    }
}
