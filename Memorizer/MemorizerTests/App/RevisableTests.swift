import XCTest

class RevisableTests: XCTestCase {
    
    func test_reviseIfCreateDateIsEqualToCurrentTime() {
        XCTAssertTrue(revisable(withCreateDateAddition: 0).needToRevise)
    }
    
    func test_noReviseIfCreateDateIsGreaterThanCurrentTime() {
        XCTAssertFalse(revisable(withCreateDateAddition: 100).needToRevise)
    }
    
    func test_noReviseIfCreateDateIsNotLessEnoughForReviseThanCurrentTime() {
        XCTAssertFalse(revisable(withCreateDateAddition:
            -TestRevisable.intervals[0] + 10).needToRevise)
    }
    
    func test_reviseIfCreateDateIsLessOrEqualIntervalSecsThanCurrentTime() {
        XCTAssertTrue(revisable(withCreateDateAddition:
            -TestRevisable.intervals[0]).needToRevise)
        XCTAssertTrue(revisable(withCreateDateAddition:
            -TestRevisable.intervals[0] - 10).needToRevise)
    }
    
    func test_noReviseIfTimeIntervalSinceRevisedDateIsLessThanReviseInterval() {
        XCTAssertFalse(revisable(withCreateDateAddition: -TestRevisable.intervals[0],
                                 revisedDateAddition: 10).needToRevise)
    }
    
    func test_reviseIfTimeIntervalSinceReviseDateIsGreaterOrEqThanReviseInterval() {
        XCTAssertTrue(revisable(withCreateDateAddition: -TestRevisable.intervals[0],
                   revisedDateAddition: -TestRevisable.intervals[0]).needToRevise)
        XCTAssertTrue(revisable(withCreateDateAddition: -TestRevisable.intervals[0],
               revisedDateAddition: -TestRevisable.intervals[0] - 10).needToRevise)
    }
    
    func test_noReviseIfTimeIntervalSinceReviseDateIsNotEnoughLessReviseInterval() {
        XCTAssertFalse(revisable(withCreateDateAddition: -TestRevisable.intervals[0],
                revisedDateAddition: -TestRevisable.intervals[0] + 10).needToRevise)
    }
    
    func test_negativeRevisedCountActsLike_0_ReviseCount() {
        XCTAssertFalse(revisable(withCreateDateAddition: 10,
                                 revisedCount: -1).needToRevise)
    }
    
    func test_intervals() {
        let secInHour: TimeInterval = 60 * 60
        let secInDay = 24 * secInHour
        let secInMonth = 30 * secInDay
        XCTAssertEqual(TestRevisable.intervals[0], 0)
        XCTAssertEqual(TestRevisable.intervals[1], secInHour)
        XCTAssertEqual(TestRevisable.intervals[2], secInDay)
        XCTAssertEqual(TestRevisable.intervals[3], 2 * secInDay)
        XCTAssertEqual(TestRevisable.intervals[4], 3 * secInDay)
        XCTAssertEqual(TestRevisable.intervals[5], 4 * secInDay)
        XCTAssertEqual(TestRevisable.intervals[6], secInMonth)
        XCTAssertEqual(TestRevisable.intervals[7], 2 * secInMonth)
        XCTAssertEqual(TestRevisable.intervals[8], 4 * secInMonth)
    }
    
    func test_invalidBigRevisedCountActsLike_MaxInterval_ReviseCount() {
        XCTAssertFalse(revisable(withCreateDateAddition: 0,
                                 revisedCount: 1_000_000).needToRevise)
        XCTAssertFalse(revisable(withCreateDateAddition: -TestRevisable.intervals[0],
                                revisedCount: 1_000_000,
        revisedDateAddition: -TestRevisable.intervals[6]).needToRevise)
        XCTAssertTrue(revisable(withCreateDateAddition: -TestRevisable.intervals[0],
                                revisedCount: 1_000_000,
        revisedDateAddition: -TestRevisable.intervals.last!).needToRevise)
    }
    
    func test_intervalNumberNotEnoughForReviseIfReviseCountIsMoreThanThisNumber() {
        XCTAssertFalse(revisable(withCreateDateAddition:
            -TestRevisable.intervals[0], revisedCount:
            reviseCountForTest).needToRevise)
    }
    
    func test_timeIntervalSinceReviseDateIsEqualConsideringReviseCount() {
        XCTAssertTrue(revisable(withCreateDateAddition:
            -TestRevisable.intervals[0], revisedCount: reviseCountForTest, revisedDateAddition:
            -TestRevisable.intervals[reviseCountForTest]).needToRevise)
    }
    var reviseCountForTest: Int {
        return 1
    }
    func revisable(withCreateDateAddition cSec: TimeInterval, revisedCount: Int = 0, revisedDateAddition rSec: TimeInterval) -> Revisable {
        return createRevisableAndSetFakeCurrentDate(withCreateDateAddition: cSec, revisedCount: revisedCount, revisedDateAddition: rSec)
    }
    func revisable(withCreateDateAddition sec: TimeInterval, revisedCount: Int = 0) -> Revisable {
        return createRevisableAndSetFakeCurrentDate(withCreateDateAddition: sec,
                                                    revisedCount: revisedCount)
    }
    private func createRevisableAndSetFakeCurrentDate(withCreateDateAddition cSec: TimeInterval, revisedCount: Int, revisedDateAddition rSec: TimeInterval? = nil) -> Revisable {
        let currentDate = Date()
        FakeCurrentDateProvider.fakeCurrentDate = currentDate
        return constructRevisable(createdDate: currentDate.addingTimeInterval(cSec), revisedCount: revisedCount, revisedDate: rSec == nil ? nil : currentDate.addingTimeInterval(rSec!))
    }
    private func constructRevisable(createdDate: Date, revisedCount: Int,
                                    revisedDate: Date? = nil) -> Revisable {
        return TestRevisable(createdDate: createdDate,
                             revisedCount: revisedCount,
                             revisedDate: revisedDate)
    }
}
class RevisableTestsWithRevisedCount2: RevisableTests {
    override var reviseCountForTest: Int {
        return 2
    }
    override func revisable(withCreateDateAddition cSec: TimeInterval,
                            revisedCount: Int = 2,
                            revisedDateAddition rSec: TimeInterval) -> Revisable {
        return super.revisable(withCreateDateAddition: cSec,
                               revisedCount: revisedCount,
                               revisedDateAddition: rSec)
    }
    override func revisable(withCreateDateAddition sec: TimeInterval, revisedCount: Int = 2) -> Revisable {
        return super.revisable(withCreateDateAddition: sec,
                               revisedCount: revisedCount)
    }
}
private class FakeCurrentDateProvider: CurrentDateProvider {
    static var fakeCurrentDate = Date()
    static var currentDate: Date {
        return fakeCurrentDate
    }
}
private struct TestRevisable {
    let createdDate: Date
    let revisedCount: Int
    let revisedDate: Date?
}
extension TestRevisable: Revisable {
    var currentDateProvider: CurrentDateProvider.Type {
        return FakeCurrentDateProvider.self
    }
}
