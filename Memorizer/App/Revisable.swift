import Foundation

protocol Revisable: CurrentDateConsumer {
    var createdData: Date { get }
    var revisedCount: Int { get }
    var revisedDate: Date? { get }
}

extension Revisable {
    static var intervals: [TimeInterval] {
        return [3_600,
                86_400,
                172_800,
                259_200,
                345_600,
                2_592_000,
                5_184_000,
                10_368_000]
    }
    var needToRevise: Bool {
        let index = min(max(revisedCount, 0), Self.intervals.count - 1)
        return currentDateProvider.currentDate
            .timeIntervalSince(revisedDate ?? createdData) >= Self.intervals[index]
    }
}

extension PileItem: Revisable {}
