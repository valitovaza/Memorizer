import UIKit
import iOSAdapters

protocol DoneButtonView: class {
    func showDoneButton()
    func enableDoneButton()
    func disableDoneButton()
    func hideDoneButton()
}
enum PilesTableState {
    case combine(selected: IndexPath)
    case normal
}
protocol PilesTableView: class {
    func setState(_ state: PilesTableState)
    func getSelectedIndexes() -> [IndexPath]
}
protocol PilesCombiner {
    func setCombine(section: Int, row: Int)
    func selectedCountChanged(_ count: Int)
    func combine()
    func cancel()
}
class CombineWorker {
    private weak var doneButtonView: DoneButtonView?
    private weak var pilesTableView: PilesTableView?
    private let pileItemCombiner: PileItemCombiner
    init(_ doneButtonView: DoneButtonView,
         _ pilesTableView: PilesTableView,
         _ pileItemCombiner: PileItemCombiner) {
        self.doneButtonView = doneButtonView
        self.pilesTableView = pilesTableView
        self.pileItemCombiner = pileItemCombiner
    }
}
extension CombineWorker: PilesCombiner {
    func setCombine(section: Int, row: Int) {
        pilesTableView?.setState(.combine(selected: IndexPath(row: row, section: section)))
        doneButtonView?.showDoneButton()
        doneButtonView?.disableDoneButton()
    }
    func selectedCountChanged(_ count: Int) {
        if count > 1 {
            doneButtonView?.enableDoneButton()
        }else{
            doneButtonView?.disableDoneButton()
        }
    }
    func combine() {
        let selectedIndexes = pilesTableView?.getSelectedIndexes() ?? []
        pileItemCombiner.combine(at: selectedIndexes.map({ItemPosition($0.section, $0.row)}))
        closeSlectMode()
    }
    private func closeSlectMode() {
        pilesTableView?.setState(.normal)
        doneButtonView?.hideDoneButton()
    }
    func cancel() {
        closeSlectMode()
    }
}
