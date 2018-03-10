import Foundation

func shuffleArray<T>(_ array: [T]) -> [T] {
    guard array.count > 1 else { return array }
    var mArray = array
    for (firstUnshuffled, unshuffledCount) in zip(mArray.indices, stride(from: mArray.count, to: 1, by: -1)) {
        mArray.swapAt(firstUnshuffled, mArray.index(firstUnshuffled,
        offsetBy: numericCast(arc4random_uniform(numericCast(unshuffledCount)))))
    }
    return mArray
}
