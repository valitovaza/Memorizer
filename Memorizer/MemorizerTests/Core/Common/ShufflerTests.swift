import XCTest

class ShufflerTests: XCTestCase {
    
    private var sut: ArrayShuffler!
    private let shuffleCount = 100
    
    override func setUp() {
        super.setUp()
        sut = ArrayShuffler()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_shuffle_emptyArray() {
        let emptyArray: [Int] = []
        XCTAssertEqual(sut.shuffle(emptyArray), emptyArray)
    }
    
    func test_shuffle_oneSizedArray() {
        XCTAssertEqual(sut.shuffle([1]), [1])
        XCTAssertEqual(sut.shuffle([6]), [6])
    }
    
    func test_shuffle_smallArray() {
        let equalCount = equalCountAfterShuffle([1, 2])
        XCTAssertNotEqual(equalCount, 0)
        XCTAssertNotEqual(equalCount, shuffleCount)
    }
    
    func test_shuffle_bigArray() {
        let maxValue = 100
        let arrayLength = 100
        let equalCount = equalCountAfterShuffle((0...arrayLength).map{_ in numericCast(arc4random_uniform(numericCast(maxValue)))})
        XCTAssertNotEqual(equalCount, shuffleCount)
    }
    
    // MARK: Helpers
    
    private func equalCountAfterShuffle(_ initialArray: [Int]) -> Int {
        var equalCount = 0
        for _ in 0..<shuffleCount {
            if sut.shuffle(initialArray) == initialArray {
                equalCount += 1
            }
        }
        return equalCount
    }
}
