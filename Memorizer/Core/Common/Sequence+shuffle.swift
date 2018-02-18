import Foundation

extension MutableCollection {
    mutating func shuffle() {
        guard count > 1 else { return }
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: count, to: 1, by: -1)) {
            swapAt(firstUnshuffled, index(firstUnshuffled, offsetBy: numericCast(arc4random_uniform(numericCast(unshuffledCount)))))
        }
    }
}
extension Sequence {
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
