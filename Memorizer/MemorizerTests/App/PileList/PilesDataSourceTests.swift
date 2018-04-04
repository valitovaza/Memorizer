import XCTest

class PilesDataSourceTests: XCTestCase {
    
    private var sut: PilesDataSource!
    private var delegate: PilesDataSourceDelegateSpy!
    private var tstCurrntDate: Date!
    private var tstNextMonth: Date!
    private var tstNextYear: Date!
    
    override func setUp() {
        super.setUp()
        tstCurrntDate = Date()
        tstNextMonth = Date().nextMonth()
        tstNextYear = Date().nextYear()
        sut = PilesDataSource()
        delegate = PilesDataSourceDelegateSpy()
        sut.delegate = delegate
    }
    
    override func tearDown() {
        tstCurrntDate = nil
        tstNextMonth = nil
        tstNextYear = nil
        delegate = nil
        sut = nil
        super.tearDown()
    }
    
    func test_initialState_itemsCounts_0() {
        assert_AllItemsCountsIs_0()
    }
    
    func test_0PilesFetched_itemsCounts_0() {
        sut.onPilesFetched([])
        assert_AllItemsCountsIs_0()
    }
    private func assert_AllItemsCountsIs_0() {
        XCTAssertEqual(sut.sectionsCount, 0)
        
        XCTAssertEqual(sut.rowsCount(for: 0), 0)
        XCTAssertEqual(sut.rowsCount(for: 1), 0)
        XCTAssertEqual(sut.rowsCount(for: 100), 0)
    }
    
    func test_rowCountForInvalidSection() {
        XCTAssertEqual(sut.rowsCount(for: -1), 0)
    }
    
    func test_1PileFetched_itemsCount_1() {
        sut.onPilesFetched([PileItem.testNewItem])
        XCTAssertEqual(sut.sectionsCount, 1)
        XCTAssertEqual(sut.rowsCount(for: 0), 1)
        XCTAssertEqual(sut.rowsCount(for: 10), 0)
    }
    
    func test_multiplePilesWithTheSameDate_1section_multipleRows() {
        let count2Array = [PileItem.testNewItem, PileItem.testNewItem]
        sut.onPilesFetched(count2Array)
        XCTAssertEqual(sut.sectionsCount, 1)
        XCTAssertEqual(sut.rowsCount(for: 0), count2Array.count)
        XCTAssertEqual(sut.rowsCount(for: 11), 0)
    }
    
    func test_revisableItems_on1section() {
        sut.onPilesFetched([PileItem.needToReviseTestItem(),
                            PileItem.needToReviseTestItem(1)])
        XCTAssertEqual(sut.sectionsCount, 1)
        XCTAssertEqual(sut.rowsCount(for: 0), 2)
    }
    
    func test_revisableItemAndNotRevisable_onDifferentSections() {
        sut.onPilesFetched([PileItem.testNewItem,
                            PileItem.needToReviseTestItem()])
        XCTAssertEqual(sut.sectionsCount, 2)
        XCTAssertEqual(sut.rowsCount(for: 0), 1)
        XCTAssertEqual(sut.rowsCount(for: 1), 1)
    }
    
    func test_onFetchReplaceItems_doesntAddButReplace() {
        sut.onPilesFetched([PileItem.testNewItem])
        XCTAssertEqual(sut.sectionsCount, 1)
        sut.onPilesFetched([])
        XCTAssertEqual(sut.sectionsCount, 0)
    }
    
    func test_onFetched_revisableItemsFirst() {
        sut.onPilesFetched([PileItem.testNewItem,
                            PileItem.needToReviseTestItem(title: "revisable")])
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).title, "revisable")
    }
    
    func test_revisableSortedRelatedToCreatedDate() {
        sut.onPilesFetched([PileItem.needToReviseTestItem(title: "1"),
                            PileItem.needToReviseTestItem(1, title: "0")])
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).title, "0")
        XCTAssertEqual(sut.itemIn(section: 0, row: 1).title, "1")
    }
    
    func test_revisableSortedRelatedToLastRevisedDate() {
        sut.onPilesFetched([PileItem.revisedNeedToReviseTestItem(title: "1",
                            createdData: Date()),
                            PileItem.revisedNeedToReviseTestItem(1, title: "0",
                            createdData: Date().addingTimeInterval(100))])
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).title, "0")
        XCTAssertEqual(sut.itemIn(section: 0, row: 1).title, "1")
    }
    
    func test_onlyDay_Month_Year_affectToSectionCount() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: Date()),
                            PileItem.pileItem(createdDate: Date().nextHour()),
                            PileItem.pileItem(createdDate: Date().nextDay()),
                            PileItem.pileItem(createdDate: Date().nextDay()),
                            PileItem.pileItem(createdDate: Date().nextMonth()),
                            PileItem.pileItem(createdDate: Date().nextYear())])
        XCTAssertEqual(sut.sectionsCount, 4)
    }
    
    func test_mixedItemsRevisableAndNot() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: Date()),
                            PileItem.pileItem(createdDate: Date().nextHour()),
                            PileItem.pileItem(createdDate: Date().nextDay()),
                            PileItem.pileItem(createdDate: Date().nextMonth()),
                            PileItem.needToReviseTestItem(),
                            PileItem.needToReviseTestItem(1)])
        XCTAssertEqual(sut.sectionsCount, 4)
    }
    
    func test_dateSorting() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: Date()),
                            PileItem.pileItem(createdDate: Date().nextDay()),
                            PileItem.pileItem(createdDate: Date().nextMonth())])
        let section0Item = sut.itemIn(section: 0, row: 0)
        XCTAssertEqual(section0Item.createdDate.timeIntervalSinceNow,
                       Date().nextMonth().timeIntervalSinceNow, accuracy: 0.1)
        let section1Item = sut.itemIn(section: 1, row: 0)
        XCTAssertEqual(section1Item.createdDate.timeIntervalSinceNow,
                       Date().nextDay().timeIntervalSinceNow, accuracy: 0.1)
        let section2Item = sut.itemIn(section: 2, row: 0)
        XCTAssertEqual(section2Item.createdDate.timeIntervalSinceNow,
                       Date().timeIntervalSinceNow, accuracy: 0.1)
    }
    
    func test_sectionInfoForMixedFetchedItems() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstCurrntDate),
                            PileItem.pileItem(createdDate: tstNextYear),
                            PileItem.needToReviseTestItem()])
        XCTAssertEqual(sut.sectionInfo(at: 0), .forRevise)
        XCTAssertEqual(sut.sectionInfo(at: 1), .date(tstNextYear))
        XCTAssertEqual(sut.sectionInfo(at: 2), .date(tstCurrntDate))
    }
    
    func test_sectionInfoOnlyForNotRevisableItems() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstCurrntDate),
                            PileItem.pileItem(createdDate: tstNextMonth)])
        XCTAssertEqual(sut.sectionInfo(at: 0), .date(tstNextMonth))
        XCTAssertEqual(sut.sectionInfo(at: 1), .date(tstCurrntDate))
    }
    
    func test_onPileRemoved_changesPileData() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: Date().nextMonth()),
                            PileItem.pileItem(createdDate: Date().nextMonth()),
                            PileItem.pileItem(createdDate: Date()),
                            PileItem.pileItem(createdDate: Date())])
        sut.onPileRemoved(at: 2)
        XCTAssertEqual(sut.rowsCount(for: 0), 2)
        XCTAssertEqual(sut.rowsCount(for: 1), 1)
        
        sut.onPileRemoved(at: 2)
        XCTAssertEqual(sut.rowsCount(for: 0), 2)
        XCTAssertEqual(sut.sectionsCount, 1)
    }
    
    func test_onPileRemoved_atTheBeginning_andAtTheEnd() {
        fetch2Sections0123()
        sut.onPileRemoved(at: 0)
        XCTAssertEqual(sut.sectionsCount, 2)
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).title, "1")
        
        sut.onPileRemoved(at: 2)
        XCTAssertEqual(sut.itemIn(section: 1, row: 0).title, "2")
    }
    
    private func fetch2Sections0123() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: Date().nextMonth()
            .addingTimeInterval(10), title: "0"),
                            PileItem.pileItem(createdDate: Date()
                                .nextMonth(), title: "1"),
                            PileItem.pileItem(createdDate: Date()
                                .addingTimeInterval(10), title: "2"),
                            PileItem.pileItem(createdDate: Date(), title: "3")])
    }
    
    func test_onPileAdded_changesPileData() {
        let date = Date().nextYear().nextMonth()
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: date), at: 0)
        XCTAssertEqual(sut.sectionsCount, 1)
        XCTAssertEqual(sut.rowsCount(for: 0), 1)
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).createdDate, date)
        XCTAssertEqual(sut.sectionInfo(at: 0), .date(date))
    }
    
    func test_multipleAdditionWithSameDates() {
        sut.onPileAdded(pile: PileItem.testNewItem, at: 0)
        sut.onPileAdded(pile: PileItem.testNewItem, at: 0)
        XCTAssertEqual(sut.sectionsCount, 1)
    }
    
    func test_multipleAdditionWithDifferentDates_checkSectionsCount() {
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 0)
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstNextMonth), at: 0)
        XCTAssertEqual(sut.sectionsCount, 2)
    }
    
    func test_add_c1Nm2Ny3_checkSorting() {
        addC1()
        addNm2()
        addNy3()
        checkNy3Nm2c1()
    }
    
    func test_add_c1Ny3Nm2_checkSorting() {
        addC1()
        addNy3()
        addNm2()
        checkNy3Nm2c1()
    }
    
    func test_add_Nm2c1Ny3_checkSorting() {
        addNm2()
        addC1()
        addNy3()
        checkNy3Nm2c1()
    }
    
    func test_add_Nm2Ny3c1_checkSorting() {
        addNm2()
        addNy3()
        addC1()
        checkNy3Nm2c1()
    }
    
    func test_add_Ny3Nm2c1_checkSorting() {
        addNy3()
        addNm2()
        addC1()
        checkNy3Nm2c1()
    }
    
    func test_add_Ny3c1Nm2_checkSorting() {
        addNy3()
        addC1()
        addNm2()
        checkNy3Nm2c1()
    }
    
    private func addC1() {
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 0)
    }
    private func addNm2() {
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstNextMonth), at: 0)
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstNextMonth), at: 0)
    }
    private func addNy3() {
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstNextYear), at: 0)
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstNextYear), at: 0)
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstNextYear), at: 0)
    }
    private func checkNy3Nm2c1() {
        XCTAssertEqual(sut.rowsCount(for: 0), 3)
        XCTAssertEqual(sut.rowsCount(for: 1), 2)
        XCTAssertEqual(sut.rowsCount(for: 2), 1)
    }
    
    func test_addRevisableItem_createsRevisableSection() {
        sut.onPileAdded(pile: PileItem.needToReviseTestItem(), at: 0)
        sut.onPileAdded(pile: PileItem.needToReviseTestItem(), at: 0)
        XCTAssertEqual(sut.sectionsCount, 1)
        XCTAssertEqual(sut.sectionInfo(at: 0), .forRevise)
    }
    
    func test_addRevisableItemAfterNotRevisableWithSameCreationDate() {
        let rDate = Date()
        sut.onPileAdded(pile: PileItem.nonReviseTestItem(createdDate: rDate), at: 0)
        sut.onPileAdded(pile: PileItem.reviseTestItem(createdDate: rDate) , at: 0)
        XCTAssertEqual(sut.sectionInfo(at: 0), .forRevise)
        XCTAssertEqual(sut.sectionInfo(at: 1), .date(rDate))
    }
    
    func test_checkIndexChangesAfterOnPileAddedByCallingOnRemove() {
        addPile(date: tstNextYear, title: "2", at: 0)
        addPile(date: tstNextMonth, title: "1", at: 0)
        addPile(date: tstNextMonth, title: "0", at: 0)
        sut.onPileRemoved(at: 0)
        XCTAssertEqual(sut.sectionsCount, 2)
        XCTAssertEqual(sut.itemIn(section: 1, row: 0).title, "1")
    }
    
    func test_checkIndexChanges_addToTheEnd() {
        addPile(date: tstNextMonth, title: "2", at: 0)
        addPile(date: tstNextMonth, title: "0", at: 0)
        addPile(date: tstNextMonth, title: "1", at: 1) //end of 0[1]1
        sut.onPileRemoved(at: 1)
        XCTAssertEqual(sut.rowsCount(for: 0), 2)
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).title, "2")
        XCTAssertEqual(sut.itemIn(section: 0, row: 1).title, "0")
    }
    
    func test_checkIndexChanges_addIntoMiddle() {
        addPile(date: tstNextMonth, title: "0", at: 0)
        addPile(date: tstNextMonth, title: "2", at: 1)
        addPile(date: tstNextMonth, title: "3", at: 2)
        addPile(date: tstNextMonth, title: "1", at: 1) //middle of 1[1]23
        sut.onPileRemoved(at: 1)
        XCTAssertEqual(sut.rowsCount(for: 0), 3)
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).title, "0")
        XCTAssertEqual(sut.itemIn(section: 0, row: 1).title, "2")
        XCTAssertEqual(sut.itemIn(section: 0, row: 2).title, "3")
    }
    
    private func addPile(date: Date, title: String, at index: Int) {
        let pile = PileItem.pileItem(createdDate: date,title: title)
        sut.onPileAdded(pile: pile, at: index)
    }
    
    func test_sortingByCreationDateOnNotRevisableSection() {
        sut.onPilesFetched(testItemsForSorting)
        check0123Sorting()
    }
    
    func test_sortingOnAddingToDateSection() {
        sut.onPileAdded(pile: testItemsForSorting[0], at: 0)
        sut.onPileAdded(pile: testItemsForSorting[1], at: 0)
        sut.onPileAdded(pile: testItemsForSorting[2], at: 0)
        sut.onPileAdded(pile: testItemsForSorting[3], at: 0)
        check0123Sorting()
    }
    
    private var testItemsForSorting: [PileItem] {
        return [PileItem.pileItem(createdDate: tstCurrntDate, title: "3"),
                PileItem.pileItem(createdDate: tstCurrntDate.addingTimeInterval(100), title: "0"),
                PileItem.pileItem(createdDate: tstCurrntDate.addingTimeInterval(10), title: "2"),
                PileItem.pileItem(createdDate: tstCurrntDate.addingTimeInterval(40), title: "1")]
    }
    private func check0123Sorting() {
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).title, "0")
        XCTAssertEqual(sut.itemIn(section: 0, row: 1).title, "1")
        XCTAssertEqual(sut.itemIn(section: 0, row: 2).title, "2")
        XCTAssertEqual(sut.itemIn(section: 0, row: 3).title, "3")
    }
    
    func test_sortingOnAddingToRevisableSection() {
        sut.onPileAdded(pile: PileItem.revisedNeedToReviseTestItem(title: "1",
                              createdData: Date()), at: 0)
        sut.onPileAdded(pile: PileItem.revisedNeedToReviseTestItem(1, title: "0",
                              createdData: Date().addingTimeInterval(100)), at: 0)
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).title, "0")
        XCTAssertEqual(sut.itemIn(section: 0, row: 1).title, "1")
    }
    
    func test_onPileAdded_delegateEventsAndChangesOrder() {
        delegate.insertSectionBlock = {[unowned self] in
            XCTAssertEqual(self.sut.rowsCount(for: 0), 0)
        }
        delegate.insertBlock = {[unowned self] in
            XCTAssertEqual(self.sut.rowsCount(for: 0), 1)
        }
        sut.onPileAdded(pile: PileItem.testNewItem, at: 0)
    }
    
    func test_onRevisablePileAdded_delegateEventsAndChangesOrder() {
        delegate.insertSectionBlock = {[unowned self] in
            XCTAssertEqual(self.sut.rowsCount(for: 0), 0)
        }
        delegate.insertBlock = {[unowned self] in
            XCTAssertEqual(self.sut.rowsCount(for: 0), 1)
        }
        sut.onPileAdded(pile: PileItem.needToReviseTestItem(), at: 0)
    }
    
    func test_onPileRemovedWhenEmptyOrWithInvalidIndex_doesntCallDelete() {
        sut.onPileRemoved(at: 0)
        sut.onPileRemoved(at: -1)
        XCTAssertEqual(delegate.deleteCallCount, 0)
    }
    
    func test_onPileRemoved_delete() {
        fetch2Sections0123()
        sut.onPileRemoved(at: 0)
        XCTAssertEqual(delegate.deleteCallCount, 1)
        XCTAssertEqual(delegate.deletedPositions, [ItemPosition(0, 0)])
        
        sut.onPileRemoved(at: 2)
        XCTAssertEqual(delegate.deleteCallCount, 2)
        XCTAssertEqual(delegate.deletedPositions, [ItemPosition(1, 1)])
    }
    
    func test_onPileRemovedRemoveDataFirstThen_delete() {
        fetch2Sections0123()
        delegate.deleteBlock = {[unowned self] in
            XCTAssertEqual(self.sut.rowsCount(for: 1), 1)
        }
        sut.onPileRemoved(at: 2)
        
        delegate.deleteBlock = {[unowned self] in
            XCTAssertEqual(self.sut.rowsCount(for: 1), 0)
        }
        sut.onPileRemoved(at: 2)
    }
    
    func test_onPileRemovedDeleteSection() {
        fetch2Sections0123()
        sut.onPileRemoved(at: 2)
        XCTAssertEqual(delegate.deleteSectionCallCount, 0)
        delegate.deleteSectionBlock = {[unowned self] in
            XCTAssertEqual(self.sut.sectionsCount, 1)
            XCTAssertEqual(self.delegate.deleteCallCount, 2)
        }
        sut.onPileRemoved(at: 2)
        XCTAssertEqual(delegate.deleteSectionCallCount, 1)
        XCTAssertEqual(delegate.deletedSectionIndex, 1)
    }
    
    func test_onRemoveSection_delegateEventsOrder() {
        sut.onPilesFetched([PileItem.testNewItem])
        delegate.deleteBlock = {[unowned self] in
            XCTAssertEqual(self.sut.sectionsCount, 1)
        }
        delegate.deleteSectionBlock = {[unowned self] in
            XCTAssertEqual(self.sut.sectionsCount, 0)
        }
        sut.onPileRemoved(at: 0)
    }
    
    func test_onNotRevisablePileAdded_insertSection() {
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstNextYear), at: 0)
        XCTAssertEqual(delegate.insertSectionCallCount, 1)
        XCTAssertEqual(delegate.insertedSectionIndex, 0)
        
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstNextYear), at: 0)
        XCTAssertEqual(delegate.insertSectionCallCount, 1)
        
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 0)
        XCTAssertEqual(delegate.insertSectionCallCount, 2)
        XCTAssertEqual(delegate.insertedSectionIndex, 1)
    }
    
    func test_onNotRevisablePileAdded_dataChangesBeforeDelegateEvents() {
        delegate.insertSectionBlock = {[unowned self] in
            XCTAssertEqual(self.sut.sectionsCount, 1)
        }
        sut.onPileAdded(pile: PileItem.testNewItem, at: 0)
    }
    
    func test_onRevisablePileAdded_insertSection() {
        sut.onPileAdded(pile: PileItem.needToReviseTestItem(0), at: 0)
        XCTAssertEqual(delegate.insertSectionCallCount, 1)
        XCTAssertEqual(delegate.insertedSectionIndex, 0)
        
        sut.onPileAdded(pile: PileItem.needToReviseTestItem(1), at: 0)
        XCTAssertEqual(delegate.insertSectionCallCount, 1)
        
        sut.onPileAdded(pile: PileItem.needToReviseTestItem(2), at: 0)
        XCTAssertEqual(delegate.insertSectionCallCount, 1)
    }
    
    func test_onRevisablePileAdded_dataChangesBeforeDelegateEvents() {
        delegate.insertSectionBlock = {[unowned self] in
            XCTAssertEqual(self.sut.sectionsCount, 1)
        }
        sut.onPileAdded(pile: PileItem.needToReviseTestItem(), at: 0)
    }
    
    func test_onNonRevisableAdded_insertRows() {
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstNextYear.addingTimeInterval(10)), at: 0)
        XCTAssertEqual(delegate.insertCallCount, 1)
        XCTAssertEqual(delegate.insertedPositions, [ItemPosition(0, 0)])
        
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstNextYear), at: 0)
        XCTAssertEqual(delegate.insertCallCount, 2)
        XCTAssertEqual(delegate.insertedPositions, [ItemPosition(0, 1)])
        
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstNextYear.addingTimeInterval(5)), at: 0)
        XCTAssertEqual(delegate.insertCallCount, 3)
        XCTAssertEqual(delegate.insertedPositions, [ItemPosition(0, 1)])
        
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 2)
        XCTAssertEqual(delegate.insertCallCount, 4)
        XCTAssertEqual(delegate.insertedPositions, [ItemPosition(1, 0)])
        
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstCurrntDate.addingTimeInterval(10)), at: 2)
        XCTAssertEqual(delegate.insertCallCount, 5)
        XCTAssertEqual(delegate.insertedPositions, [ItemPosition(1, 0)])
    }
    
    func test_onRevisableAdded_insertRows() {
        delegate.insertBlock = {[unowned self] in
            XCTAssertEqual(self.delegate.insertSectionCallCount, 1)
        }
        sut.onPileAdded(pile: PileItem.needToReviseTestItem(1), at: 0)
        XCTAssertEqual(delegate.insertCallCount, 1)
        XCTAssertEqual(delegate.insertedPositions, [ItemPosition(0, 0)])
        
        sut.onPileAdded(pile: PileItem.needToReviseTestItem(), at: 0)
        XCTAssertEqual(delegate.insertCallCount, 2)
        XCTAssertEqual(delegate.insertedPositions, [ItemPosition(0, 1)])
        
        delegate.insertBlock = {[unowned self] in
            XCTAssertEqual(self.sut.rowsCount(for: 0), 3)
        }
        sut.onPileAdded(pile: PileItem.needToReviseTestItem(2), at: 0)
        XCTAssertEqual(delegate.insertCallCount, 3)
        XCTAssertEqual(delegate.insertedPositions, [ItemPosition(0, 0)])
    }
    
    func test_onNonRevisableAdded_insertRowsAfterSectionAndData() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstCurrntDate)])
        delegate.insertBlock = {[unowned self] in
            XCTAssertEqual(self.sut.rowsCount(for: 0), 2)
        }
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 0)
        
        delegate.insertBlock = {[unowned self] in
            XCTAssertEqual(self.delegate.insertSectionCallCount, 1)
        }
        sut.onPileAdded(pile: PileItem.pileItem(createdDate: tstNextYear), at: 0)
    }
    
    func test_onPileChanged_changesPileAtGivenIndex_withoutDateChanges() {
        sut.onPilesFetched([PileItem.pileItem(title: "tst0",
                                              createdDate: tstCurrntDate,
                                              revisedCount: 1),
                            PileItem.pileItem(title: "tst1",
                                              createdDate: tstNextMonth,
                                              revisedCount: 0)])
        sut.onPileChanged(pile: PileItem.pileItem(title: "test0",
                                                  createdDate: tstCurrntDate, revisedCount: 10), at: 0)
        XCTAssertEqual(sut.itemIn(section: 1, row: 0).title, "test0")
        XCTAssertEqual(sut.itemIn(section: 1, row: 0).revisedCount, 10)
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).title, "tst1")
        
        sut.onPileChanged(pile: PileItem.pileItem(title: "test1",
                                                  createdDate: tstNextMonth, revisedCount: 11), at: 1)
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).title, "test1")
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).revisedCount, 11)
    }
    
    func test_onPileChanged_updateInvokes() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear),
                            PileItem.pileItem(createdDate: tstNextMonth.addingTimeInterval(10)),
                            PileItem.pileItem(createdDate: tstNextMonth)])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextMonth.addingTimeInterval(10)), at: 1)
        XCTAssertEqual(delegate.updateCallCount, 1)
        XCTAssertEqual(delegate.updatedPositions, [ItemPosition(1, 0)])
        
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextMonth), at: 2)
        XCTAssertEqual(delegate.updateCallCount, 2)
        XCTAssertEqual(delegate.updatedPositions, [ItemPosition(1, 1)])
    }
    
    func test_onPileChangedAtInvalidIndex_dontInvokeUpdate() {
        sut.onPileChanged(pile: PileItem.testNewItem, at: -1)
        sut.onPileChanged(pile: PileItem.testNewItem, at: 0)
        sut.onPileChanged(pile: PileItem.testNewItem, at: 10)
        XCTAssertEqual(delegate.updateCallCount, 0)
    }
    
    func test_updateInvokesAfterDataChanges() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear,
                                              title: "original")])
        delegate.updateBlock = {[unowned self] in
            XCTAssertEqual(self.sut.itemIn(section: 0, row: 0).title, "changed")
        }
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextYear,
                                                  title: "changed"), at: 0)
    }
    
    func test_changeRevisableToNonRevisableWithExistedCreationDateSection() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear),
                            PileItem.pileItem(createdDate: tstNextMonth),
                            PileItem.needToReviseTestItem()])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextMonth), at: 2)
        XCTAssertEqual(sut.sectionsCount, 2)
        XCTAssertEqual(sut.sectionInfo(at: 1), .date(tstNextMonth))
        XCTAssertEqual(sut.rowsCount(for: 1), 2)
    }
    
    func test_changeRevisableToNonRevisable() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear),
                            PileItem.needToReviseTestItem()])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextMonth), at: 1)
        XCTAssertEqual(sut.sectionsCount, 2)
        XCTAssertEqual(sut.sectionInfo(at: 1), .date(tstNextMonth))
        XCTAssertEqual(sut.rowsCount(for: 1), 1)
    }
    
    func test_changeRevisableDate_sortingItemsOnExistedSection() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear),
            PileItem.pileItem(createdDate: tstNextYear.addingTimeInterval(10)),
                            PileItem.needToReviseTestItem()])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextYear.addingTimeInterval(5)), at: 2)
        XCTAssertEqual(sut.itemIn(section: 0, row: 1).createdDate,
                       tstNextYear.addingTimeInterval(5))
    }
    
    func test_changeRevisableDate_sortingSections() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear),
                            PileItem.pileItem(createdDate: tstCurrntDate),
                            PileItem.needToReviseTestItem()])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextMonth), at: 2)
        XCTAssertEqual(sut.sectionInfo(at: 1), .date(tstNextMonth))
    }
    
    func test_changeRevisableSectionWithMultipleItems() {
        sut.onPilesFetched([PileItem.needToReviseTestItem(),
                            PileItem.needToReviseTestItem(),
                            PileItem.pileItem(createdDate: tstNextYear)])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextYear), at: 1)
        XCTAssertEqual(sut.sectionsCount, 2)
        XCTAssertEqual(sut.rowsCount(for: 0), 1)
        
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextYear), at: 0)
        XCTAssertEqual(sut.sectionsCount, 1)
        XCTAssertEqual(sut.rowsCount(for: 0), 3)
    }
    
    func test_changeDate_changesSections() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextMonth)])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextYear), at: 0)
        XCTAssertEqual(sut.sectionsCount, 1)
        XCTAssertEqual(sut.sectionInfo(at: 0), .date(tstNextYear))
    }
    
    func test_changeDateNotEnoughForSectionName_notChangeSection() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextMonth)])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextMonth.addingTimeInterval(10)), at: 0)
        XCTAssertEqual(sut.sectionsCount, 1)
        XCTAssertEqual(sut.sectionInfo(at: 0), .date(tstNextMonth))
    }
    
    func test_changeDateOnSectionWithMultipleItems() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear),
                            PileItem.pileItem(createdDate: tstNextMonth),
                            PileItem.pileItem(createdDate: tstNextMonth),
                            PileItem.pileItem(createdDate: tstNextMonth)])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 1)
        XCTAssertEqual(sut.sectionsCount, 3)
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextYear), at: 2)
        XCTAssertEqual(sut.sectionsCount, 3)
        XCTAssertEqual(sut.rowsCount(for: 0), 2)
        
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextYear), at: 3)
        XCTAssertEqual(sut.sectionsCount, 2)
        XCTAssertEqual(sut.rowsCount(for: 0), 3)
    }
    
    func test_sortingOnChangeDate() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear),
            PileItem.pileItem(createdDate: tstNextMonth.addingTimeInterval(10)),
                            PileItem.pileItem(createdDate: tstNextMonth)])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextMonth.addingTimeInterval(5)), at: 0)
        XCTAssertEqual(sut.itemIn(section: 0, row: 1).createdDate,
                       tstNextMonth.addingTimeInterval(5))
    }
    
    func test_onPileChangedInvokesDelegatesUpdateOnlyIfNoDateChanges() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextMonth),
                            PileItem.pileItem(createdDate: tstNextMonth)])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextYear), at: 0)
        XCTAssertEqual(delegate.updateCallCount, 0)
        
        sut.onPilesFetched([PileItem.needToReviseTestItem(),
                            PileItem.needToReviseTestItem()])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextYear), at: 0)
        XCTAssertEqual(delegate.updateCallCount, 0)
    }
    
    func test_onPileChangedInvokesMoveRowToNewSection() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear),
                            PileItem.pileItem(createdDate: tstNextMonth.addingTimeInterval(10)),
                            PileItem.pileItem(createdDate: tstNextMonth)])
        delegate.moveBlock = {[unowned self] in
            XCTAssertEqual(self.delegate.insertSectionCallCount, 1)
            XCTAssertEqual(self.delegate.insertedSectionIndex, 2)
        }
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 2)
        XCTAssertEqual(delegate.insertCallCount, 0)
        XCTAssertEqual(delegate.moveCallCount, 1)
        XCTAssertEqual(delegate.moveFrom, ItemPosition(1, 1))
        XCTAssertEqual(delegate.moveTo, ItemPosition(2, 0))
    }
    
    func test_onPileChangedMoveSectionWhenItemMoveToUpperSection() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear),
                            PileItem.pileItem(createdDate: tstNextYear),
                            PileItem.pileItem(createdDate: tstCurrntDate),
                            PileItem.pileItem(createdDate: tstCurrntDate)])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextMonth), at: 3)
        XCTAssertEqual(delegate.moveFrom, ItemPosition(2, 1))
        XCTAssertEqual(delegate.moveTo, ItemPosition(1, 0))
    }
    
    func test_onPileChangedInvokesMoveRowToExistedSection() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear),
                            PileItem.pileItem(createdDate: tstNextMonth.addingTimeInterval(10)),
                            PileItem.pileItem(createdDate: tstNextMonth),
                            PileItem.pileItem(createdDate: tstCurrntDate.addingTimeInterval(10))])
        delegate.moveBlock = {[unowned self] in
            XCTAssertEqual(self.delegate.insertSectionCallCount, 0)
            XCTAssertEqual(self.sut.rowsCount(for: 2), 2)
        }
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 2)
        XCTAssertEqual(delegate.insertCallCount, 0)
        XCTAssertEqual(delegate.moveCallCount, 1)
        XCTAssertEqual(delegate.moveFrom, ItemPosition(1, 1))
        XCTAssertEqual(delegate.moveTo, ItemPosition(2, 1))
    }
    
    func test_onPileChangedInvokesDeleteSection() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear),
                            PileItem.pileItem(createdDate: tstNextMonth),
                            PileItem.pileItem(createdDate: tstCurrntDate)])
        delegate.moveBlock = {[unowned self] in
            XCTAssertEqual(self.sut.sectionsCount, 3)
        }
        delegate.deleteSectionBlock = {[unowned self] in
            XCTAssertEqual(self.delegate.moveCallCount, 1)
            XCTAssertEqual(self.sut.sectionsCount, 2)
        }
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 1)
        XCTAssertEqual(delegate.deleteSectionCallCount, 1)
        XCTAssertEqual(delegate.deletedSectionIndex, 1)
    }
    
    func test_onRevisablePileChangedInvokesMoveRowToNewSection() {
        sut.onPilesFetched([PileItem.needToReviseTestItem(1),
                            PileItem.needToReviseTestItem(),
                            PileItem.pileItem(createdDate: tstNextMonth)])
        delegate.moveBlock = {[unowned self] in
            XCTAssertEqual(self.delegate.insertSectionCallCount, 1)
            XCTAssertEqual(self.delegate.insertedSectionIndex, 2)
        }
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 1)
        XCTAssertEqual(delegate.insertCallCount, 0)
        XCTAssertEqual(delegate.moveCallCount, 1)
        XCTAssertEqual(delegate.moveFrom, ItemPosition(0, 1))
        XCTAssertEqual(delegate.moveTo, ItemPosition(2, 0))
    }
    
    func test_onRevisablePileChanged_delegateInserSectionBeforeRemoveItems() {
        sut.onPilesFetched([PileItem.needToReviseTestItem(),
                            PileItem.needToReviseTestItem()])
        delegate.insertSectionBlock = {[unowned self] in
            XCTAssertEqual(self.sut.rowsCount(for: 0), 2)
            XCTAssertEqual(self.sut.rowsCount(for: 1), 0)
        }
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 0)
    }
    
    func test_onNonRevisablePileChanged_delegateInserSectionBeforeRemoveItems() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextYear),
                            PileItem.pileItem(createdDate: tstNextYear)])
        delegate.insertSectionBlock = {[unowned self] in
            XCTAssertEqual(self.sut.rowsCount(for: 0), 2)
            XCTAssertEqual(self.sut.rowsCount(for: 1), 0)
        }
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 0)
    }
    
    func test_onRevisablePileChangedInvokesMoveRowToExistedSection() {
        sut.onPilesFetched([PileItem.needToReviseTestItem(1),
                            PileItem.needToReviseTestItem(),
                            PileItem.pileItem(createdDate: tstNextMonth),
                            PileItem.pileItem(createdDate: tstCurrntDate.addingTimeInterval(10))])
        delegate.moveBlock = {[unowned self] in
            XCTAssertEqual(self.delegate.insertSectionCallCount, 0)
            XCTAssertEqual(self.sut.rowsCount(for: 0), 1)
            XCTAssertEqual(self.sut.rowsCount(for: 2), 2)
        }
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 1)
        XCTAssertEqual(delegate.insertCallCount, 0)
        XCTAssertEqual(delegate.moveCallCount, 1)
        XCTAssertEqual(delegate.moveFrom, ItemPosition(0, 1))
        XCTAssertEqual(delegate.moveTo, ItemPosition(2, 1))
    }
    
    func test_onRevisablePileChangedInvokesDeleteSection() {
        sut.onPilesFetched([PileItem.needToReviseTestItem(),
                            PileItem.pileItem(createdDate: tstNextMonth),
                            PileItem.pileItem(createdDate: tstCurrntDate)])
        delegate.moveBlock = {[unowned self] in
            XCTAssertEqual(self.sut.sectionsCount, 3)
        }
        delegate.deleteSectionBlock = {[unowned self] in
            XCTAssertEqual(self.delegate.moveCallCount, 1)
            XCTAssertEqual(self.sut.sectionsCount, 2)
        }
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstCurrntDate), at: 0)
        XCTAssertEqual(delegate.deleteSectionCallCount, 1)
        XCTAssertEqual(delegate.deletedSectionIndex, 0)
    }
    
    func test_sortingOfRevisablesWhenOnChangeOccur() {
        sut.onPilesFetched([PileItem.testNewItem,
                            PileItem.testNewItem])
        sut.onPileChanged(pile: PileItem.revisedNeedToReviseTestItem(title: "1",
                                createdData: Date()), at: 0)
        XCTAssertEqual(sut.sectionsCount, 2)
        XCTAssertEqual(sut.sectionInfo(at: 0), .forRevise)
        sut.onPileChanged(pile: PileItem.revisedNeedToReviseTestItem(1, title: "0",
                                createdData: Date().addingTimeInterval(100)), at: 1)
        XCTAssertEqual(delegate.moveCallCount, 2)
        XCTAssertEqual(sut.itemIn(section: 0, row: 0).title, "0")
        XCTAssertEqual(sut.itemIn(section: 0, row: 1).title, "1")
        XCTAssertEqual(sut.sectionsCount, 1)
    }
    
    func test_changePilesOrderIfDateChangedButNotEnoughForSectionChange() {
        sut.onPilesFetched([PileItem.pileItem(createdDate: tstNextMonth.addingTimeInterval(5)),
                            PileItem.pileItem(createdDate: tstNextMonth)])
        sut.onPileChanged(pile: PileItem.pileItem(createdDate: tstNextMonth.addingTimeInterval(10)), at: 1)
        XCTAssertEqual(delegate.updateCallCount, 0)
        XCTAssertEqual(delegate.moveCallCount, 1)
        XCTAssertEqual(delegate.moveFrom, ItemPosition(0, 1))
        XCTAssertEqual(delegate.moveTo, ItemPosition(0, 0))
    }
}
extension PileSectionInfo: Equatable {
    public static func ==(lhs: PileSectionInfo, rhs: PileSectionInfo) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}
extension ItemPosition: Equatable {
    public static func ==(lhs: ItemPosition, rhs: ItemPosition) -> Bool {
        return lhs.section == rhs.section && lhs.row == rhs.row
    }
}
