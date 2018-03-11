struct PileStub: Pile {
    var isExamined: Bool { return false }
    mutating func add(_ card: Card) {}
    mutating func remove(at index: Int) {}
    mutating func shuffle() {}
    mutating func markTopCardRemembered() {}
    mutating func markTopCardForgotten() {}
    mutating func prepareForExam() {}
}
