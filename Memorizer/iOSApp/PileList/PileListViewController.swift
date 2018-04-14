import UIKit
import iOSAdapters

protocol PileListEventHandler {
    func handle(event: PileListViewController.Event)
}
protocol PilesDataSourceHolder {
    var dataSource: PileListDataSource! { get set }
    var eventHandler: PilesTableEventHandler? { get set }
}
typealias PileTableHolder = PilesDataSourceHolder & PilesDataSourceDelegate & TableReloader & PilesTableView
class PileListViewController: UIViewController {
    enum Event {
        case onLoad
        case onPrepareSegue(PileTableHolder, DoneButtonView)
        case onCreate
        case cancelTableSelection
        case doneTableSelection
    }
    
    var eventHandler: PileListEventHandler?

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func createPile(_ sender: Any) {
        eventHandler?.handle(event: .onCreate)
    }
    
    @objc func doneAction() {
        eventHandler?.handle(event: .doneTableSelection)
    }
    @objc func cancelAction() {
        eventHandler?.handle(event: .cancelTableSelection)
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
        eventHandler?.handle(event: .onPrepareSegue(dsHolder, self))
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
extension PileListViewController: DoneButtonView {
    func showDoneButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self, action: #selector(doneAction))
    }
    func enableDoneButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    func disableDoneButton() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    func hideDoneButton() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self, action: #selector(createPile(_:)))
    }
}
