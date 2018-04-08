import UIKit
import iOSAdapters

protocol CardsTableEventListener: class {
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.cardsCount ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CardTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let card = dataSource?.getCard(at: indexPath.row)
        configure(cell: cell, card: card)
        return cell
    }
    private func configure(cell: CardTableViewCell, card: Card?) {
        guard let card = card else { return }
        cell.frontTitle.text = card.front as? String
        cell.backTitle.text = card.back as? String
    }
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataCleaner?.removePile(at: indexPath.row)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableListener?.scrollOccur()
    }
}
extension CardsTableViewController: UITableReloader {
    func reloadTable() {
        tableView.reloadData()
    }
}
