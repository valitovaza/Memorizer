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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func createPile(_ sender: Any) {
        eventHandler?.handle(event: .onCreate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler?.handle(event: .onLoad)
    }
}
extension PileListViewController: ActivityIndicatorPresenter {
    func animateActivityIndicator() {
        activityIndicator.startAnimating()
    }
}
