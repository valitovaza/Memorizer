import Foundation

extension Date {
    func isSameDMY(compared to: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        let toComponents = calendar.dateComponents([.day, .month, .year], from: to)
        return components.day == toComponents.day
            && components.month == toComponents.month
            && components.year == toComponents.year
    }
}
