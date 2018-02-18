protocol CardSide {
    var cardText: String { get }
}
extension CardSide where Self: CustomStringConvertible  {
    var cardText: String {
        return description
    }
}
extension Int: CardSide {}
extension String: CardSide {}
extension Double: CardSide {}
