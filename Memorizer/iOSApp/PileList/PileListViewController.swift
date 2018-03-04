import UIKit
import iOSAdapters

protocol PileListEventHandler {
    func handle(event: PileListViewController.Event)
}
class PileListViewController: UIViewController {
    enum Event {
        case onLoad
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
}
extension PileListViewController: ActivityIndicatorPresenter {
    func animateActivityIndicator() {
        activityIndicator.startAnimating()
    }
}
extension PileListViewController: EmptyStateView {
    func showEmptyView() {
        activityIndicator.stopAnimating()
        emptyView.isHidden = false
        contentView.isHidden = true
    }
    func showContentView() {
        activityIndicator.stopAnimating()
        emptyView.isHidden = true
        contentView.isHidden = false
    }
}
