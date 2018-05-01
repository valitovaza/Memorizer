import UIKit
import iOSAdapters

protocol PilesTableEventHandler {
    func handle(event: PilesTableViewController.Event)
}
class PilesTableViewController: UITableViewController, PilesDataSourceHolder {
    
    enum Event {
        case onDelete(section: Int, row: Int)
        case openDetails(section: Int, row: Int)
        case onCombine(section: Int, row: Int)
        case selectedCountChanged(Int)
        case onSelect(section: Int, row: Int)
    }
    
    var dataSource: PileListDataSource!
    var eventHandler: PilesTableEventHandler?
    private var state: PilesTableState = .normal
    private var selectedIndexes: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 69
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeAllOpenedCells()
    }
    private func closeAllOpenedCells() {
        for tableCell in tableView.visibleCells {
            guard let pileCell = tableCell as? PileCell else { continue }
            pileCell.closeButtonsAnimated()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.sectionsCount
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectIndexPathIfNeed(indexPath)
        handleSelectEventIfNormalState(indexPath)
    }
    private func selectIndexPathIfNeed(_ indexPath: IndexPath) {
        guard case .combine = state else { return }
        if let index = selectedIndexes.index(of: indexPath) {
            selectedIndexes.remove(at: index)
        }else{
            selectedIndexes.append(indexPath)
        }
        eventHandler?.handle(event: .selectedCountChanged(selectedIndexes.count))
        reloadWithAnimation()
    }
    private func reloadWithAnimation() {
        tableView.reloadRows(at: tableView.indexPathsForVisibleRows ?? [], with: .automatic)
    }
    private func handleSelectEventIfNormalState(_ indexPath: IndexPath) {
        guard case .normal = state else { return }
        eventHandler?.handle(event: .onSelect(section: indexPath.section, row: indexPath.row))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.rowsCount(for: section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PileCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        configure(cell: cell, at: indexPath)
        return cell
    }
    private func configure(cell: PileCell, at indexPath: IndexPath) {
        let item = dataSource.itemIn(section: indexPath.section, row: indexPath.row)
        cell.titleLabel.text = item.title
        cell.subtitleLabel.text = formatedTitle(item.createdDate)
        cell.cardCountLabel.text = "\(L10n.count): \(item.cardCount)"
        configureState(of: cell, at: indexPath)
        cell.delegate = self
        cell.preparePileCell()
    }
    private func configureState(of cell: PileCell, at indexPath: IndexPath) {
        switch state {
        case .normal:
            cell.selectImage.isHidden = true
            cell.leadingConstraint.constant = PileCell.closedConstraint
        case .combine:
            cell.selectImage.isHidden = false
            configure(selectedImage: cell.selectImage, at: indexPath)
            cell.leadingConstraint.constant = PileCell.openedConstraint
        }
    }
    private func configure(selectedImage: UIImageView, at indexPath: IndexPath) {
        if selectedIndexes.contains(indexPath) {
            selectedImage.image = UIImage(named: "selectedCircle")
        }else{
            selectedImage.image = UIImage(named: "unselectedCircle")
        }
    }
    private func formatedTitle(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch dataSource.sectionInfo(at: section) {
        case .forRevise:
            return L10n.pilesToRepeat
        case .date(let date):
            return formatedSectionTitle(date)
        }
    }
    private func formatedSectionTitle(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
extension PilesTableViewController: PilesDataSourceDelegate {
    func insertRows(at: [ItemPosition]) {
        tableView.insertRows(at: convert(at), with: .automatic)
    }
    private func convert(_ positions: [ItemPosition]) -> [IndexPath] {
        return positions.map({IndexPath(row: $0.row, section: $0.section)})
    }
    func deleteRows(at: [ItemPosition]) {
        tableView.deleteRows(at: convert(at), with: .automatic)
    }
    func updateRows(at: [ItemPosition]) {
        tableView.reloadRows(at: convert(at), with: .automatic)
    }
    func moveRow(from: ItemPosition, to: ItemPosition) {
        tableView.moveRow(at: IndexPath(row: from.row, section: from.section),
                          to: IndexPath(row: to.row, section: to.section))
        tableView.reloadRows(at: [IndexPath(row: from.row, section: from.section), IndexPath(row: to.row, section: to.section)], with: .automatic)
    }
    func insertSection(at index: Int) {
        tableView.insertSections(IndexSet(integer: index), with: .automatic)
    }
    func deleteSection(at index: Int) {
        tableView.deleteSections(IndexSet(integer: index), with: .automatic)
    }
}
extension PilesTableViewController: TableReloader {
    func reloadTable() {
        tableView.reloadData()
    }
}
extension PilesTableViewController: PilesTableView {
    func setState(_ state: PilesTableState) {
        self.state = state
        changeTableState()
    }
    private func changeTableState() {
        switch state {
        case .combine(let selectedIndex):
            selectedIndexes = [selectedIndex]
        case .normal:
            selectedIndexes = []
        }
        reloadWithAnimation()
    }
    func getSelectedIndexes() -> [IndexPath] {
        return selectedIndexes
    }
}
extension PilesTableViewController: PileCellDelegate {
    func onDelete(cell: PileCell) {
        guard let indexPath = getIndexPath(for: cell) else { return }
        openDeleteAlert(at: indexPath)
    }
    private func openDeleteAlert(at index: IndexPath) {
        let alert = UIAlertController(title: L10n.deleteAlert,
                                      message: nil,
                                      preferredStyle: UIAlertControllerStyle.alert)
        let deleteAction = UIAlertAction(title: L10n.delete, style: UIAlertActionStyle.destructive)
        { action -> Void in
            self.eventHandler?.handle(event: .onDelete(section: index.section, row: index.row))
        }
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    private func getIndexPath(for cell: PileCell) -> IndexPath? {
        return tableView.indexPath(for: cell)
    }
    func onEdit(cell: PileCell) {
        guard let indexPath = getIndexPath(for: cell) else { return }
        eventHandler?.handle(event: .openDetails(section: indexPath.section, row: indexPath.row))
    }
    func onCombine(cell: PileCell) {
        guard let indexPath = getIndexPath(for: cell) else { return }
        self.eventHandler?.handle(event: .onCombine(section: indexPath.section, row: indexPath.row))
    }
    func swipeInProgress(cell: PileCell) {
        closeAllOpenedCells(except: cell)
        tableView.isScrollEnabled = false
        tableView.isScrollEnabled = true
    }
    private func closeAllOpenedCells(except cell: PileCell) {
        for tableCell in tableView.visibleCells {
            guard tableCell != cell else { continue }
            guard let pileCell = tableCell as? PileCell else { continue }
            pileCell.closeButtonsAnimated()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        closeAllOpenedCells()
    }
}
extension PileItem {
    var cardCount: Int {
        guard let cardPile = pile as? CardPile else { return 0 }
        return cardPile.cards.count
    }
}
