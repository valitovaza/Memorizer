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
                        createdDate: Date(),
                        revisedCount: 1,
                        revisedDate: nil)
    }
    static func pileItem(title: String,
                         createdDate: Date,
                         revisedCount: Int) -> PileItem {
        return PileItem(title: title,
                        pile: PileStub(),
                        createdDate: createdDate,
                        revisedCount: revisedCount,
                        revisedDate: nil)
    }
}
extension PileItem {
    static func pileItem(createdDate: Date, title: String = "test") -> PileItem {
        return PileItem(title: title,
                        pile: PileStub(),
                        createdDate: createdDate,
                        revisedCount: 1,
                        revisedDate: nil)
    }
    static func needToReviseTestItem(_ revisedCount: Int = 0,
                                     title: String = "test") -> PileItem {
        return PileItem(title: title,
                        pile: PileStub(),
                        createdDate: date(for: revisedCount),
                        revisedCount: revisedCount,
                        revisedDate: nil)
    }
    static func revisedNeedToReviseTestItem(_ revisedCount: Int = 0,
                                            title: String = "test",
                                            createdData: Date) -> PileItem {
        return PileItem(title: title,
                        pile: PileStub(),
                        createdDate: createdData,
                        revisedCount: revisedCount,
                        revisedDate: date(for: revisedCount))
    }
    static func nonReviseTestItem(createdDate: Date) -> PileItem {
        let rDate = Date().addingTimeInterval(PileItem.intervals[1])
        return PileItem(title: "test",
                        pile: PileStub(),
                        createdDate: createdDate,
                        revisedCount: 1,
                        revisedDate: rDate)
    }
    static func reviseTestItem(createdDate: Date) -> PileItem {
        let rDate = Date().addingTimeInterval(-PileItem.intervals[0])
        return PileItem(title: "test",
                        pile: PileStub(),
                        createdDate: createdDate,
                        revisedCount: 0,
                        revisedDate: rDate)
    }
    private static func date(for revisedCount: Int) -> Date {
        let additionalTime: TimeInterval = 100
        return Date().addingTimeInterval(-PileItem.intervals[revisedCount])
            .addingTimeInterval(-additionalTime)
    }
}
