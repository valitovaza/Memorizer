import UIKit
import iOSAdapters

protocol PileListEventHandler {
    func handle(event: PileListViewController.Event)
}
protocol PilesDataSourceHolder {
    var dataSource: PileListDataSource! { get set }
}
typealias PileTableHolder = PilesDataSourceHolder & PilesDataSourceDelegate & TableReloader
class PileListViewController: UIViewController {
    enum Event {
        case onLoad
        case onPrepareSegue(PileTableHolder)
        case onCreate
    }
    
    var eventHandler: PileListEventHandler?

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func createPile(_ sender: Any) {
        eventHandler?.handle(event: .onCreate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        eventHandler?.handle(event: .onLoad)
    }
    private func localize() {
        navigationItem.title = L10n.memorizer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dsHolder = segue.destination as? PileTableHolder else { return }
        eventHandler?.handle(event: .onPrepareSegue(dsHolder))
    }
}
extension PileListViewController: ActivityIndicatorPresenter {
    func animateActivityIndicator() {
        activityIndicator.startAnimating()
    }
}
extension PileListViewController: ListEmptySwitcher {
    func presentPileList() {
        emptyView.isHidden = true
        contentView.isHidden = false
        activityIndicator.stopAnimating()
    }
    func presentEmpty() {
        contentView.isHidden = true
        emptyView.isHidden = false
        activityIndicator.stopAnimating()
    }
}
