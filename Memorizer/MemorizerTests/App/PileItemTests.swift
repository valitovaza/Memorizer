import XCTest

class PileItemTests: XCTestCase {
    func test_currentDateProvider_is_Date() {
        XCTAssertTrue(PileItem.testNewItem.currentDateProvider == Date.self)
    }
}
extension PileItem {
    static var testNewItem: PileItem {
        return PileItem(title: "test",
                        pile: PileStub(),
                        createdData: Date(),
                        revisedCount: 0,
                        revisedDate: nil)
    }
}
