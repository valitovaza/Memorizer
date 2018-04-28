import Foundation

protocol Revisable: CurrentDateConsumer {
    var createdDate: Date { get }
    var revisedCount: Int { get }
    var revisedDate: Date? { get }
}

extension Revisable {
    static var intervals: [TimeInterval] {
        return [0,
                3_600,
                28_800,
                86_400,
                86_400,
                86_400,
                604_800,
                1_209_600,
                2_419_200,
                5_184_000,
                10_368_000,
                20_736_000]
    }
    var needToRevise: Bool {
        guard revisedCount < Self.intervals.count - 1 else { return false }
        let index = min(max(revisedCount, 0), Self.intervals.count - 1)
        return currentDateProvider.currentDate
            .timeIntervalSince(revisedDate ?? createdDate) >= Self.intervals[index]
    }
}

extension PileItem: Revisable {}
