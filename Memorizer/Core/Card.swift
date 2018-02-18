struct Card {
    let front: CardSide
    let back: CardSide
    init(_ front: CardSide, _ back: CardSide) {
        self.front = front
        self.back = back
    }
}
