import XCTest
@testable import iOSApp

class PileListEmptyViewControllerTests: LocalizerTests {
    
    private var sut: PileListEmptyViewController!
    
    override func setUp() {
        super.setUp()
        sut = UIControllerFactory.instantiate(.PileList) as PileListEmptyViewController
        _=sut.view
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_outlets_initialized() {
        XCTAssertNotNil(sut.emptyLabel)
    }
    
    func test_onLoad_emptyLabelL10n_en() {
        L10n.localizeFunc = L10n.enTr
        sut.viewDidLoad()
        XCTAssertEqual(sut.emptyLabel.text, L10n.emptyPileList)
    }
    
    func test_onLoad_emptyLabelL10n_ru() {
        L10n.localizeFunc = L10n.ruTr
        sut.viewDidLoad()
        XCTAssertEqual(sut.emptyLabel.text, L10n.emptyPileList)
    }
}
class LocalizerTests: XCTestCase {
    
    private var oldLocalizeFunc: ((String, String, CVarArg...)->(String))!
    
    override func setUp() {
        super.setUp()
        oldLocalizeFunc = L10n.localizeFunc
    }
    
    override func tearDown() {
        L10n.localizeFunc = oldLocalizeFunc
        super.tearDown()
    }
}
