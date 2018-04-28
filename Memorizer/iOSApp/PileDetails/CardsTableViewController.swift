import UIKit
import iOSAdapters

protocol CardsTableEventListener: class {
    func cellSelected(at index: Int)
    func scrollOccur()
}
protocol CardsTableListenerHolder: class {
    var tableListener: CardsTableEventListener? { get set }
}
class CardsTableViewController: UITableViewController, CardsTableListenerHolder, CardsDataSourceHolder {
    
    var dataSource: CardsDataSource?
    var dataCleaner: CardsTableDataCleaner?
    weak var tableListener: CardsTableEventListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 78
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeAllOpenedCells()
    }
    private func closeAllOpenedCells() {
        for tableCell in tableView.visibleCells {
            guard let pileCell = tableCell as? CardTableViewCell else { continue }
            pileCell.closeButtonsAnimated()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableListener?.cellSelected(at: indexPath.row)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.cardsCount ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CardTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let card = dataSource?.getCard(at: indexPath.row)
        configure(cell: cell, card: card)
        cell.delegate = self
        cell.preparePileCell()
        return cell
    }
    private func configure(cell: CardTableViewCell, card: Card?) {
        guard let card = card else { return }
        cell.frontTitle.text = card.front as? String
        cell.backTitle.text = card.back as? String
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableListener?.scrollOccur()
        closeAllOpenedCells()
    }
}
extension CardsTableViewController: UITableReloader {
    func reloadTable() {
        tableView.reloadData()
    }
}
extension CardsTableViewController: CardTableViewCellDelegate {
    func onDelete(cell: CardTableViewCell) {
        guard let indexPath = getIndexPath(for: cell) else { return }
        openDeleteAlert(at: indexPath)
    }
    private func openDeleteAlert(at index: IndexPath) {
        let alert = UIAlertController(title: L10n.deleteCardAlert,
                                      message: nil,
                                      preferredStyle: UIAlertControllerStyle.alert)
        let deleteAction = UIAlertAction(title: L10n.delete, style: UIAlertActionStyle.destructive)
        { action -> Void in
            self.dataCleaner?.removePile(at: index.row)
        }
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    private func getIndexPath(for cell: CardTableViewCell) -> IndexPath? {
        return tableView.indexPath(for: cell)
    }
    func swipeInProgress(cell: CardTableViewCell) {
        closeAllOpenedCells(except: cell)
        tableView.isScrollEnabled = false
        tableView.isScrollEnabled = true
    }
    private func closeAllOpenedCells(except cell: CardTableViewCell) {
        for tableCell in tableView.visibleCells {
            guard tableCell != cell else { continue }
            guard let pileCell = tableCell as? CardTableViewCell else { continue }
            pileCell.closeButtonsAnimated()
        }
    }
}
