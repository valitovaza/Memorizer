import XCTest
@testable import iOSApp
@testable import iOSAdapters

class PileListEventReceiverTests: XCTestCase {
    
    private var sut: PileListEventReceiver!
    private var pilesLoader: PilesLoaderSpy!
    private var dataSource: DataSourceSpy!
    
    override func setUp() {
        super.setUp()
        pilesLoader = PilesLoaderSpy()
        dataSource = DataSourceSpy()
        sut = PileListEventReceiver(pilesLoader, dataSource)
    }
    
    override func tearDown() {
        pilesLoader = nil
        dataSource = nil
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
    class DataSourceSpy: PileListDataSource {
        var delegate: PilesDataSourceDelegate?
        var sectionsCount: Int {
            return 0
        }
        func rowsCount(for section: Int) -> Int {
            return 0
        }
        func sectionInfo(at section: Int) -> PileSectionInfo {
            return .forRevise
        }
        func itemIn(section: Int, row: Int) -> PileItem {
            return PileItem(title: "", pile: CardPile(), createdDate: Date(), revisedCount: 0, revisedDate: nil)
        }
    }
}
