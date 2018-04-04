import Foundation

extension Date {
    func nextHour() -> Date {
        return Calendar.current.date(byAdding: .hour, value: 1, to: self)!
    }
    func nextDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    func nextMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }
    func nextYear() -> Date {
        return Calendar.current.date(byAdding: .year, value: 1, to: self)!
    }
}
