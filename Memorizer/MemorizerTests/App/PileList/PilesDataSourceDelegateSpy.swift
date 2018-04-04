class PilesDataSourceDelegateSpy: PilesDataSourceDelegate {
    var insertCallCount = 0
    var insertedPositions: [ItemPosition] = []
    var insertBlock: (()->())?
    func insertRows(at: [ItemPosition]) {
        insertCallCount += 1
        insertedPositions = at
        insertBlock?()
    }
    
    var deleteCallCount = 0
    var deletedPositions: [ItemPosition] = []
    var deleteBlock: (()->())?
    func deleteRows(at: [ItemPosition]) {
        deleteCallCount += 1
        deletedPositions = at
        deleteBlock?()
    }
    
    var updateCallCount = 0
    var updatedPositions: [ItemPosition] = []
    var updateBlock: (()->())?
    func updateRows(at: [ItemPosition]) {
        updateCallCount += 1
        updatedPositions = at
        updateBlock?()
    }
    
    var moveCallCount = 0
    var moveFrom: ItemPosition?
    var moveTo: ItemPosition?
    var moveBlock: (()->())?
    func moveRow(from: ItemPosition, to: ItemPosition) {
        moveCallCount += 1
        moveFrom = from
        moveTo = to
        moveBlock?()
    }
    
    var insertSectionCallCount = 0
    var insertedSectionIndex: Int?
    var insertSectionBlock: (()->())?
    func insertSection(at index: Int) {
        insertSectionCallCount += 1
        insertedSectionIndex = index
        insertSectionBlock?()
    }
    
    var deleteSectionCallCount = 0
    var deletedSectionIndex: Int?
    var deleteSectionBlock: (()->())?
    func deleteSection(at index: Int) {
        deleteSectionCallCount += 1
        deletedSectionIndex = index
        deleteSectionBlock?()
    }
}
