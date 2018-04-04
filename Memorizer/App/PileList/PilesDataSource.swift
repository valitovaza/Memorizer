public protocol PileListDataSource {
    var delegate: PilesDataSourceDelegate? { get  set }
    var sectionsCount: Int { get }
    func rowsCount(for section: Int) -> Int
    func sectionInfo(at section: Int) -> PileSectionInfo
    func itemIn(section: Int, row: Int) -> PileItem
}
public struct ItemPosition {
    public let section: Int
    public let row: Int
    init(_ section: Int, _ row: Int) {
        self.section = section
        self.row = row
    }
}
public protocol PilesDataSourceDelegate: class {
    func insertRows(at: [ItemPosition])
    func deleteRows(at: [ItemPosition])
    func updateRows(at: [ItemPosition])
    func moveRow(from: ItemPosition, to: ItemPosition)
    func insertSection(at index: Int)
    func deleteSection(at index: Int)
}
public enum PileSectionInfo {
    case forRevise
    case date(Date)
}
public class PilesDataSource {
    public weak var delegate: PilesDataSourceDelegate?
    private var data: [PileData] = []
    
    public init() {}
    
    private struct PileData {
        var sectionInfo: PileSectionInfo
        var piles: [IndexedPileItem]
    }
    private struct IndexedPileItem {
        var index: Int
        let pileItem: PileItem
    }
}
extension PilesDataSource: PileListDataSource {
    public var sectionsCount: Int {
        return data.count
    }
    public func rowsCount(for section: Int) -> Int {
        guard section >= 0 && data.count > section else { return 0 }
        return data[section].piles.count
    }
    public func sectionInfo(at section: Int) -> PileSectionInfo {
        return data[section].sectionInfo
    }
    public func itemIn(section: Int, row: Int) -> PileItem {
        return data[section].piles[row].pileItem
    }
}

import Foundation

extension PilesDataSource: PileItemRepositoryDelegate {
    public func onPilesFetched(_ pileItems: [PileItem]) {
        data.removeAll()
        fetch(pileItems)
    }
    private func fetch(_ pileItems: [PileItem]) {
        let indexedItems = itemsWithIndexes(pileItems)
        addRevisableItems(indexedItems)
        addNotRevisableItems(indexedItems)
    }
    private func itemsWithIndexes(_ pileItems: [PileItem]) -> [IndexedPileItem] {
        return pileItems.enumerated().map { (offset, item) -> IndexedPileItem in
            return IndexedPileItem(index: offset, pileItem: item)
        }
    }
    private func addRevisableItems(_ pileItems: [IndexedPileItem]) {
        let revisableItems = sortedRevisableItems(pileItems)
        if revisableItems.count > 0 {
            data.append(PileData(sectionInfo: .forRevise, piles: revisableItems))
        }
    }
    private func sortedRevisableItems(_ pileItems: [IndexedPileItem]) -> [IndexedPileItem] {
        return pileItems.filter({$0.pileItem.needToRevise})
            .sorted(by: {$0.pileItem.lessDateThan(compare: $1.pileItem)})
    }
    private func addNotRevisableItems(_ pileItems: [IndexedPileItem]) {
        let notRevisableItems = sortedNotRevisableItems(pileItems)
        for date in differentDates(notRevisableItems) {
            let itemsForDate = filter(pileItems: notRevisableItems, by: date)
            if itemsForDate.count > 0 {
                data.append(PileData(sectionInfo: .date(date), piles: itemsForDate))
            }
        }
    }
    private func sortedNotRevisableItems(_ pileItems: [IndexedPileItem]) -> [IndexedPileItem] {
        return pileItems.filter({!$0.pileItem.needToRevise}).sorted(by: {$1.pileItem.lessDateThan(compare: $0.pileItem)})
    }
    private func differentDates(_ notRevisableItems: [IndexedPileItem]) -> [Date] {
        var dates: [Date] = []
        for item in notRevisableItems {
            if shouldAppend(date: item.pileItem.createdDate, into: dates) {
                dates.append(item.pileItem.createdDate)
            }
        }
        return dates.sorted(by: {$0 > $1})
    }
    private func filter(pileItems: [IndexedPileItem], by date: Date) -> [IndexedPileItem] {
        return pileItems.filter({$0.pileItem.createdDate.isSameDMY(compared: date)})
    }
    private func shouldAppend(date: Date, into dates: [Date]) -> Bool {
        return dates.filter({$0.isSameDMY(compared: date)}).isEmpty
    }
    
    public func onPileRemoved(at index: Int) {
        guard let pos = position(for: index) else { return }
        removeItem(with: index, at: pos)
        removeSectionIfNeedAndInformDelegate(at: pos)
    }
    private func position(for index: Int) -> (section: Int, row: Int)? {
        for section in 0..<data.count {
            for row in 0..<data[section].piles.count {
                if data[section].piles[row].index == index {
                    return (section: section, row: row)
                }
            }
        }
        return nil
    }
    private func removeItem(with index: Int, at position: (section: Int, row: Int)) {
        data[position.section].piles.remove(at: position.row)
        fixIndexesForRemove(at: index)
    }
    private func fixIndexesForRemove(at index: Int) {
        for section in 0..<data.count {
            for row in 0..<data[section].piles.count {
                if data[section].piles[row].index > index {
                    data[section].piles[row].index -= 1
                }
            }
        }
    }
    private func removeSectionIfNeedAndInformDelegate(at pos: (section: Int, row: Int)) {
        if data[pos.section].piles.isEmpty {
            deleteSection(at: pos)
        }else{
            onlyRowDeleted(at: pos)
        }
    }
    private func deleteSection(at pos: (section: Int, row: Int)) {
        delegate?.deleteRows(at: [ItemPosition(pos.section, pos.row)])
        data.remove(at: pos.section)
        delegate?.deleteSection(at: pos.section)
    }
    private func onlyRowDeleted(at pos: (section: Int, row: Int)) {
        delegate?.deleteRows(at: [ItemPosition(pos.section, pos.row)])
    }
    
    public func onPileAdded(pile: PileItem, at index: Int) {
        fixIndexesForAdd(at: index)
        insert(IndexedPileItem(index: index, pileItem: pile))
    }
    private func fixIndexesForAdd(at index: Int) {
        for section in 0..<data.count {
            for row in 0..<data[section].piles.count {
                if data[section].piles[row].index >= index {
                    data[section].piles[row].index += 1
                }
            }
        }
    }
    private func insert(_ iPile: IndexedPileItem) {
        if iPile.pileItem.needToRevise {
            insertRevisable(iPile)
        }else{
            insertIntoDateSection(iPile)
        }
    }
    private func insertRevisable(_ iPile: IndexedPileItem) {
        if let firstRevisableSection = data.first,
            case .forRevise = firstRevisableSection.sectionInfo {
            let row = rowIndexForAddingRevisable(iPile, into: data[0].piles)
            insertRevisableItemAndInformDelegate(iPile, at: row)
        }else{
            let pd = PileData(sectionInfo: .forRevise, piles: [iPile])
            insertIntoNewSectionAndInformDelegate(pd, section: 0)
        }
    }
    private func rowIndexForAddingRevisable(_ iPile: IndexedPileItem, into: [IndexedPileItem]) -> Int {
        for row in 0..<into.count {
            guard !into[row].pileItem.lessDateThan(compare: iPile.pileItem) else { continue }
            return row
        }
        return into.count
    }
    private func insertRevisableItemAndInformDelegate(_ iPile: IndexedPileItem,
                                                      at row: Int) {
        data[0].piles.insert(iPile, at: row)
        delegate?.insertRows(at: [ItemPosition(0, row)])
    }
    private func insertIntoNewSectionAndInformDelegate(_ pd: PileData,
                                                       section: Int) {
        insertEmptySection(pd, at: section)
        data[section].piles = pd.piles
        delegate?.insertRows(at: [ItemPosition(section, 0)])
    }
    private func insertEmptySection(_ pd: PileData, at section: Int) {
        var emptySection = pd
        emptySection.piles = []
        data.insert(emptySection, at: section)
        delegate?.insertSection(at: section)
    }
    private func insertIntoDateSection(_ iPile: IndexedPileItem) {
        if let section = section(for: iPile.pileItem.createdDate) {
            let row = rowIndexForAddingNotRevisable(iPile, into: data[section].piles)
            insertDateItemAndInformDelegate(iPile, at: row, section: section)
        }else{
            let createdDate = iPile.pileItem.createdDate
            let section = insertSectionPosition(for: createdDate)
            let pd = PileData(sectionInfo: .date(createdDate), piles: [iPile])
            insertIntoNewSectionAndInformDelegate(pd, section: section)
        }
    }
    private func insertDateItemAndInformDelegate(_ iPile: IndexedPileItem,
                                                 at row: Int, section: Int) {
        data[section].piles.insert(iPile, at: row)
        delegate?.insertRows(at: [ItemPosition(section, row)])
    }
    private func insertSectionPosition(for date: Date) -> Int {
        var insertSection = 0
        for section in 0..<data.count {
            if case .date(let sectionDate) = sectionInfo(at: section),
                sectionDate.timeIntervalSince(date) <= 0 {
                continue
            }
            insertSection += 1
        }
        return insertSection
    }
    private func rowIndexForAddingNotRevisable(_ iPile: IndexedPileItem,
                                   into: [IndexedPileItem]) -> Int {
        for row in 0..<into.count {
            guard into[row].pileItem.lessDateThan(compare: iPile.pileItem) else { continue }
            return row
        }
        return into.count
    }
    private func section(for date: Date) -> Int? {
        for section in 0..<data.count {
            if case .date(let sectionDate) = sectionInfo(at: section),
                date.isSameDMY(compared: sectionDate) {
                return section
            }
        }
        return nil
    }
    
    public func onPileChanged(pile: PileItem, at index: Int) {
        guard let pos = position(for: index) else { return }
        let changedItem = IndexedPileItem(index: index, pileItem: pile)
        let oldSectionInfo = data[pos.section].sectionInfo
        if isSectionChangedFor(pile, oldSectionInfo) {
            changePileAndItsSection(changedItem, oldPos: pos)
        }else{
            changePileAndOptionallyPosition(changedItem, oldPos: pos)
        }
    }
    private func isSectionChangedFor(_ changedPile: PileItem,
                                     _ oldSectionInfo: PileSectionInfo) -> Bool {
        switch oldSectionInfo {
        case .date(let oldDate):
            return isDifferentSection(changedPile, oldDate)
        case .forRevise:
            return !changedPile.needToRevise
        }
    }
    private func isDifferentSection(_ changedPile: PileItem,
                                    _ oldSectionDate: Date) -> Bool {
        return !oldSectionDate.isSameDMY(compared: changedPile.createdDate) ||
            changedPile.needToRevise
    }
    private func changePileAndItsSection(_ changedItem: IndexedPileItem,
                                          oldPos pos: (section: Int, row: Int)) {
        let oldSectionInfo = data[pos.section].sectionInfo
        insertAndMoveOnDelegate(changedItem, oldPos: pos)
        removeOldSectionIfEmpty(oldSectionInfo)
    }
    private func insertAndMoveOnDelegate(_ changedItem: IndexedPileItem,
                                         oldPos pos: (section: Int, row: Int)) {
        if changedItem.pileItem.needToRevise {
            insertRevisableAndMoveOnDelegate(changedItem, oldPos: pos)
        }else{
            insertNonRevisableAndMoveOnDelegate(changedItem, oldPos: pos)
        }
    }
    private func insertRevisableAndMoveOnDelegate(_ changedItem: IndexedPileItem,
                                          oldPos pos: (section: Int, row: Int)) {
        if let firstSectionInfo = data.first,
            case .forRevise = firstSectionInfo.sectionInfo {
            data[pos.section].piles.remove(at: pos.row)
            insertRevisableAndMoveOnDelegate(changedItem, into: 0, pos)
        }else{
            let pd = PileData(sectionInfo: .forRevise, piles: [changedItem])
            insertIntoNewSectionAndMoveOnDelegate(section: 0, pd, pos)
        }
    }
    private func insertNonRevisableAndMoveOnDelegate(_ changedItem: IndexedPileItem,
                                            oldPos pos: (section: Int, row: Int)) {
        if let section = section(for: changedItem.pileItem.createdDate) {
            data[pos.section].piles.remove(at: pos.row)
            insertNonRevisableAndMoveOnDelegate(changedItem, into: section, pos)
        }else{
            let createdDate = changedItem.pileItem.createdDate
            let section = insertSectionPosition(for: createdDate)
            let pd = PileData(sectionInfo: .date(createdDate), piles: [changedItem])
            insertIntoNewSectionAndMoveOnDelegate(section: section, pd, pos)
        }
    }
    private func insertRevisableAndMoveOnDelegate(_ changedItem: IndexedPileItem,
                                                  into section: Int,
                                                  _ pos: (section: Int, row: Int)) {
        let row = rowIndexForAddingRevisable(changedItem, into: data[section].piles)
        insertItemAndMoveOnDelegate(changedItem, (section, row), pos)
    }
    private func insertItemAndMoveOnDelegate(_ changedItem: IndexedPileItem,
                                             _ newPos: (section: Int, row: Int),
                                             _ pos: (section: Int, row: Int)) {
        data[newPos.section].piles.insert(changedItem, at: newPos.row)
        delegate?.moveRow(from: ItemPosition(pos.section, pos.row),
                          to: ItemPosition(newPos.section, newPos.row))
    }
    private func insertNonRevisableAndMoveOnDelegate(_ changedItem: IndexedPileItem,
                                                     into section: Int,
                                                _ pos: (section: Int, row: Int)) {
        let row = rowIndexForAddingNotRevisable(changedItem,
                                                into: data[section].piles)
        insertItemAndMoveOnDelegate(changedItem, (section, row), pos)
    }
    private func insertIntoNewSectionAndMoveOnDelegate(section: Int,
                                                       _ pd: PileData,
                                      _ pos: (section: Int, row: Int)) {
        let oldSectionInfo = data[pos.section].sectionInfo
        insertEmptySection(pd, at: section)
        
        let oldSection = findIndexOfSection(for: oldSectionInfo)!
        data[oldSection].piles.remove(at: pos.row)
        data[section].piles = pd.piles
        delegate?.moveRow(from: ItemPosition(oldSection, pos.row),
                          to: ItemPosition(section, 0))
    }
    private func removeOldSectionIfEmpty(_ oldSectionInfo: PileSectionInfo) {
        guard let section = findIndexOfSection(for: oldSectionInfo) else { return }
        if data[section].piles.isEmpty {
            data.remove(at: section)
            delegate?.deleteSection(at: section)
        }
    }
    private func changePileAndOptionallyPosition(_ changedItem: IndexedPileItem,
                            oldPos pos: (section: Int, row: Int)) {
        if isDateChanged(changedItem, pos) {
            data[pos.section].piles.remove(at: pos.row)
            insertNonRevisableAndMoveOnDelegate(changedItem, into: pos.section, pos)
        }else{
            data[pos.section].piles[pos.row] = changedItem
            delegate?.updateRows(at: [ItemPosition(pos.section, pos.row)])
        }
    }
    private func isDateChanged(_ changedItem: IndexedPileItem,
                               _ pos: (section: Int, row: Int)) -> Bool {
        return data[pos.section].piles[pos.row].pileItem.createdDate != changedItem.pileItem.createdDate
    }
    private func findIndexOfSection(for oldSectionInfo: PileSectionInfo) -> Int? {
        switch oldSectionInfo {
        case .date(let oldSectionDate):
            return section(for: oldSectionDate)
        case .forRevise:
            return 0
        }
    }
}
extension PileItem {
    func lessDateThan(compare to: PileItem) -> Bool {
        let date = revisedDate ?? createdDate
        let toDate = to.revisedDate ?? to.createdDate
        return date.timeIntervalSince(toDate) < 0
    }
}
