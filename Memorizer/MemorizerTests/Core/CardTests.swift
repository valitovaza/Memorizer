import XCTest

class CardTests: XCTestCase {
    func testCardInitialization() {
        XCTAssertEqual(createSut("test", 0).front as? String, "test")
        XCTAssertEqual(createSut(0, 8.7).back as? Double, 8.7)
    }
    
    // MARK: Helpers
    
    private func createSut(_ front: CardSide, _ back: CardSide) -> Card {
        return Card(front, back)
    }
}
