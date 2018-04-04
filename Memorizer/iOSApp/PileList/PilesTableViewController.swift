import UIKit
import iOSAdapters

class PilesTableViewController: UITableViewController, PilesDataSourceHolder {
    
    var dataSource: PileListDataSource!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.sectionsCount
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.rowsCount(for: section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PileCell", for: indexPath)
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch dataSource.sectionInfo(at: section) {
        case .forRevise:
            return "forRevise"
        case .date(let date):
            return date.description
        }
    }
}
extension PilesTableViewController: PilesDataSourceDelegate {
    func insertRows(at: [ItemPosition]) {
        tableView.insertRows(at: at.map({IndexPath(row: $0.row, section: $0.section)}), with: .automatic)
    }
    func deleteRows(at: [ItemPosition]) {
        tableView.deleteRows(at: at.map({IndexPath(row: $0.row, section: $0.section)}), with: .automatic)
    }
    func updateRows(at: [ItemPosition]) {
        tableView.reloadRows(at: at.map({IndexPath(row: $0.row, section: $0.section)}), with: .automatic)
    }
    func moveRow(from: ItemPosition, to: ItemPosition) {
        tableView.moveRow(at: IndexPath(row: from.row, section: from.section),
                          to: IndexPath(row: to.row, section: to.section))
    }
    func insertSection(at index: Int) {
        tableView.insertSections(IndexSet(integer: index), with: .automatic)
    }
    func deleteSection(at index: Int) {
        tableView.deleteSections(IndexSet(integer: index), with: .automatic)
    }
}
