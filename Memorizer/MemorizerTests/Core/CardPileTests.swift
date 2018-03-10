import XCTest

class CardPileTests: XCTestCase {
    
    private var sut: CardPile!
    private var shuffler: ShufflerSpy!
    
    private let testInt = 7
    private let testString = "test"
    private let testDoudle: Double = 6.7
    
    override func setUp() {
        super.setUp()
        shuffler = ShufflerSpy()
        sut = CardPile()
        sut.shuffler = shuffler
    }
    
    override func tearDown() {
        sut = nil
        shuffler = nil
        super.tearDown()
    }
    
    func test_addCard_incrementsCardCount() {
        sut.add(Card(0, 0))
        XCTAssertEqual(sut.cards.count, 1)
        sut.add(Card("", ""))
        XCTAssertEqual(sut.cards.count, 2)
    }
    
    func test_addCard_saveCards() {
        sut.add(testFirstCard)
        checkThatCardIsFirst(sut.cards.first)
        
        sut.add(testSecondCard)
        checkThatCardIsSecond(sut.cards.first)
    }
    
    func test_removeAtInvalidIndexShouldBeIgnored() {
        sut.remove(at: 0)
        sut.add(testFirstCard)
        sut.remove(at: 100)
        sut.remove(at: -100)
        XCTAssertEqual(sut.cards.count, 1)
    }
    
    func test_removeAtValidIndex_removeCardAtIndex() {
        sut.add(testFirstCard)
        sut.remove(at: 0)
        XCTAssertEqual(sut.cards.count, 0)
    }
    
    func test_shuffle_changeCardArray() {
        shuffler.testArray = [(testSecondCard, false)]
        sut.shuffle()
        
        XCTAssertEqual(shuffler.shuffleWasInvoked, 1)
        XCTAssertEqual(sut.cards.count, 1)
        checkThatCardIsSecond(sut.cards.first)
    }
    
    func test_shuffle_passCardsArray() {
        sut.add(testFirstCard)
        sut.shuffle()
        
        XCTAssertEqual(shuffler.savedArray.count, 1)
        checkThatCardIsFirst(shuffler.savedArray.first?.card)
    }
    
    func test_markTopCardRemembered_withEmptyCardsShouldBeIgnored() {
        sut.markTopCardRemembered()
        XCTAssertEqual(sut.cards.count, 0)
    }
    
    func test_markTopCardRemembered_moveFirstCardToTheLastPosition() {
        sut.add(testThirdCard)
        sut.add(testSecondCard)
        sut.add(testFirstCard)
        
        sut.markTopCardRemembered()
        checkThatCardIsSecond(sut.cards.first)
        
        sut.markTopCardRemembered()
        checkThatCardIsThird(sut.cards.first)
        
        sut.markTopCardRemembered()
        checkThatCardIsFirst(sut.cards.first)
    }
    
    func test_markAllCardsAsRemembered_setIsExaminedTrue() {
        sut.add(testFirstCard)
        sut.add(testSecondCard)
        
        sut.markTopCardRemembered()
        XCTAssertFalse(sut.isExamined)
        
        sut.markTopCardRemembered()
        XCTAssertTrue(sut.isExamined)
    }
    
    func test_markTopCardForgotten_placeItTo3positionsBelow() {
        add5FirstTestCards()
        sut.add(testSecondCard)
        sut.markTopCardForgotten()
        
        checkThatCardIsSecond(sut.cards[3])
        checkThatCardIsFirst(sut.cards.first)
        XCTAssertEqual(sut.cards.count, 6)
    }
    
    func test_markTopCardForgotten_with_0_1Cards_ignored() {
        sut.markTopCardForgotten()
        sut.add(testFirstCard)
        sut.markTopCardForgotten()
        
        checkThatCardIsFirst(sut.cards.last)
        XCTAssertEqual(sut.cards.count, 1)
    }
    
    func test_markTopCardForgotten_with_2_3Cards_placeItToTheLastPosition() {
        sut.add(testSecondCard)
        sut.add(testFirstCard)
        sut.markTopCardForgotten()
        
        checkThatCardIsFirst(sut.cards.last)
        
        sut.add(testThirdCard)
        sut.markTopCardForgotten()
        
        checkThatCardIsThird(sut.cards.last)
    }
    
    func test_ifSomeCardIsForgotten_pileIsNotExamined() {
        sut.add(testFirstCard)
        sut.add(testFirstCard)
        sut.markTopCardRemembered()
        sut.markTopCardForgotten()
        sut.markTopCardRemembered()
        XCTAssertFalse(sut.isExamined)
    }
    
    func test_ifMarkForgotten_isNotExamined() {
        sut.add(testFirstCard)
        sut.markTopCardRemembered()
        sut.markTopCardRemembered()
        sut.markTopCardForgotten()
        XCTAssertFalse(sut.isExamined)
    }
    
    func test_5cards_4remembered_1forgotten_2remember_isNotExamined() {
        add5FirstTestCards()
        rememberCard(count: 4)
        sut.markTopCardForgotten()
        rememberCard(count: 2)
        XCTAssertFalse(sut.isExamined)
    }
    
    func test_5cards_4remembered_1forgotten_4remember_isExamined() {
        add5FirstTestCards()
        rememberCard(count: 4)
        sut.markTopCardForgotten()
        rememberCard(count: 4)
        XCTAssertTrue(sut.isExamined)
    }
    
    func test_prepareForExam_ifPileIsEmpty_ignored() {
        let oldExaminedValue = sut.isExamined
        sut.prepareForExam()
        XCTAssertEqual(sut.isExamined, oldExaminedValue)
    }
    
    func test_prepareForExam_setIsExaminedFalse() {
        sut.add(testFirstCard)
        sut.markTopCardRemembered()
        sut.prepareForExam()
        XCTAssertFalse(sut.isExamined)
    }
    
    func test_prepareForExam_setAllCardsAsNotExamined() {
        add5FirstTestCards()
        rememberCard(count: 5)
        sut.prepareForExam()
        sut.markTopCardRemembered()
        XCTAssertFalse(sut.isExamined)
    }
    
    // MARK: Helpers
    
    private var testFirstCard: Card {
        return Card(testInt, testString)
    }
    private var testSecondCard: Card {
        return Card(testDoudle, testInt)
    }
    private var testThirdCard: Card {
        return Card(testDoudle, testString)
    }
    
    private func checkThatCardIsFirst(_ card: Card?) {
        XCTAssertEqual(card?.front as? Int, testInt)
        XCTAssertEqual(card?.back as? String, testString)
    }
    private func checkThatCardIsSecond(_ card: Card?) {
        XCTAssertEqual(card?.front as? Double, testDoudle)
        XCTAssertEqual(card?.back as? Int, testInt)
    }
    private func checkThatCardIsThird(_ card: Card?) {
        XCTAssertEqual(card?.front as? Double, testDoudle)
        XCTAssertEqual(card?.back as? String, testString)
    }
    
    private func rememberCard(count: Int) {
        for _ in 0..<count {
            sut.markTopCardRemembered()
        }
    }
    private func add5FirstTestCards() {
        sut.add(testFirstCard)
        sut.add(testFirstCard)
        sut.add(testFirstCard)
        sut.add(testFirstCard)
        sut.add(testFirstCard)
    }
}
private class ShufflerSpy: Shuffler {
    var testArray: [CardInfo] = []
    var savedArray: [CardInfo] = []
    var shuffleWasInvoked = 0
    func shuffle<T>(_ array: [T]) -> [T] {
        shuffleWasInvoked += 1
        savedArray = (array as? [CardInfo]) ?? []
        return (testArray as? [T]) ?? []
    }
}
