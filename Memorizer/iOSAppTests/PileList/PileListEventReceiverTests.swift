import XCTest
@testable import iOSApp
@testable import iOSAdapters

class PileListEventReceiverTests: XCTestCase {
    
    private var sut: PileListEventReceiver!
    private var pilesLoader: PilesLoaderSpy!
    private var createInteractor: CreatePileInteractorSpy!
    
    override func setUp() {
        super.setUp()
        pilesLoader = PilesLoaderSpy()
        createInteractor = CreatePileInteractorSpy()
        sut = PileListEventReceiver(pilesLoader, createInteractor)
    }
    
    override func tearDown() {
        pilesLoader = nil
        createInteractor = nil
        sut = nil
        super.tearDown()
    }
    
    func test_handleOnLoadEvent_pilesLoadersLoad() {
        sut.handle(event: .onLoad)
        XCTAssertEqual(createInteractor.onCreatePileCallCount, 0)
        XCTAssertEqual(pilesLoader.onLoadCallCount, 1)
    }
    
    func test_handleOnCreateEvent_onCreatePile() {
        sut.handle(event: .onCreate)
        XCTAssertEqual(pilesLoader.onLoadCallCount, 0)
        XCTAssertEqual(createInteractor.onCreatePileCallCount, 1)
    }
}
extension PileListEventReceiverTests {
    class PilesLoaderSpy: PilesLoader {
        var onLoadCallCount = 0
        func onLoad() {
            onLoadCallCount += 1
        }
    }
    class CreatePileInteractorSpy: CreatePileHandler {
        var onCreatePileCallCount = 0
        func onCreatePile() {
            onCreatePileCallCount += 1
        }
    }
}
