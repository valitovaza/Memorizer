protocol Shuffler {
    func shuffle<T>(_ array: [T]) -> [T]
}
class ArrayShuffler: Shuffler {
    func shuffle<T>(_ array: [T]) -> [T] {
        return shuffleArray(array)
    }
}
