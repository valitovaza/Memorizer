import XCTest

class CardSideTests: XCTestCase {
    func testCardTextDefault_equal_description() {
        XCTAssertEqual(3.cardText, 3.description)
        XCTAssertEqual("test".cardText, "test".description)
    }
}
