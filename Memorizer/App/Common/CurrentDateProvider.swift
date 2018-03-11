import Foundation

protocol CurrentDateProvider {
    static var currentDate: Date { get }
}
extension Date: CurrentDateProvider {
    static var currentDate: Date {
        return Date()
    }
}

protocol CurrentDateConsumer {
    var currentDateProvider: CurrentDateProvider.Type { get }
}
extension CurrentDateConsumer {
    var currentDateProvider: CurrentDateProvider.Type {
        return Date.self
    }
}
