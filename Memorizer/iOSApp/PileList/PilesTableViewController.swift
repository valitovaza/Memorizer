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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.sectionsCount
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectIndexPathIfNeed(indexPath)
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
        configureState(of: cell, at: indexPath)
    }
    private func configureState(of cell: PileCell, at indexPath: IndexPath) {
        switch state {
        case .normal:
            cell.selectImage.isHidden = true
            cell.leadingConstraint.constant = 0
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
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: L10n.delete) { action, index in
            self.openDeleteAlert(at: index)
        }
        let editAction = UITableViewRowAction(style: .normal, title: L10n.edit) { action, index in
            self.eventHandler?.handle(event: .openDetails(section: index.section, row: index.row))
        }
        editAction.backgroundColor = UIColor.blue
        let combineAction = UITableViewRowAction(style: .normal, title: L10n.combine) { action, index in
            self.eventHandler?.handle(event: .onCombine(section: index.section, row: index.row))
        }
        combineAction.backgroundColor = UIColor.brown
        return [combineAction, editAction, deleteAction]
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
