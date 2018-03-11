import XCTest
@testable import iOSApp
@testable import iOSAdapters

class PileListEventReceiverTests: XCTestCase {
    
    private var sut: PileListEventReceiver!
    private var pilesLoader: PilesLoaderSpy!
    
    override func setUp() {
        super.setUp()
        pilesLoader = PilesLoaderSpy()
        sut = PileListEventReceiver(pilesLoader)
    }
    
    override func tearDown() {
        pilesLoader = nil
        sut = nil
        super.tearDown()
    }
    
    func test_handleOnLoadEvent_pilesLoadersLoad() {
        sut.handle(event: .onLoad)
        XCTAssertEqual(pilesLoader.onLoadCallCount, 1)
    }
}
extension PileListEventReceiverTests {
    class PilesLoaderSpy: PilesLoader {
        var onLoadCallCount = 0
        func onLoad() {
            onLoadCallCount += 1
        }
    }
}
