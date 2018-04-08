import UIKit
import iOSAdapters

class PilesTableViewController: UITableViewController, PilesDataSourceHolder {
    
    var dataSource: PileListDataSource!
    var cleanerInTable: PileItemCleanerInTable!
    var router: PileListRouter!
    
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
            self.router.openPileDetails(at: index.section, row: index.row)
        }
        editAction.backgroundColor = UIColor.blue
        let combineAction = UITableViewRowAction(style: .normal, title: L10n.combine) { action, index in
            
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
            self.cleanerInTable.deleteIn(section: index.section, row: index.row)
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
