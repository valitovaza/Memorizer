import XCTest

class shuffleTests: XCTestCase {
    
    private let shuffleCount = 100
    
    func test_shuffle_emptyArray() {
        let emptyArray: [Int] = []
        XCTAssertEqual(emptyArray.shuffled(), emptyArray)
    }
    
    func test_shuffle_oneSizedArray() {
        XCTAssertEqual([1].shuffled(), [1])
        XCTAssertEqual([6].shuffled(), [6])
    }
    
    func test_shuffle_smallArray() {
        let equalCount = equalCountAfterShuffle([1, 2])
        XCTAssertNotEqual(equalCount, 0)
        XCTAssertNotEqual(equalCount, shuffleCount)
    }
    
    func test_shuffle_bigArray() {
        let maxValue = 100
        let equalCountForBigArray = equalCountAfterShuffle((1...shuffleCount).map{_ in numericCast(arc4random_uniform(numericCast(maxValue)))})
        XCTAssertNotEqual(equalCountForBigArray, shuffleCount)
    }
    
    // MARK: Helpers
    
    private func equalCountAfterShuffle(_ initialArray: [Int]) -> Int {
        var equalCount = 0
        for _ in 0..<shuffleCount {
            if initialArray.shuffled() == initialArray {
                equalCount += 1
            }
        }
        return equalCount
    }
}
