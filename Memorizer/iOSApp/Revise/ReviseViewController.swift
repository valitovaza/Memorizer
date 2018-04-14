import UIKit

protocol ReviseEventHandler {
    func handle(event: ReviseViewController.Event)
}
protocol ReviseWordsHolder {
    func addRevise(words: [(front: String, back: String)])
}
class ReviseViewController: UIViewController {
    enum Event {
        case onLoad(ReviseWordsHolder)
        case swipeRight
        case swipeLeft
    }
    
    var eventHandler: ReviseEventHandler?
    
    private let viewProvider = ReviseSwipeViewProvider()
    
    @IBOutlet weak var swipeView: SwipeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    private func onLoad() {
        localize()
        eventHandler?.handle(event: .onLoad(viewProvider))
        configureSwipeView()
    }
    private func localize() {
        navigationItem.title = L10n.revisePile
    }
    private func configureSwipeView() {
        swipeView.delegate = self
        swipeView.swipeViewProvider = viewProvider
        swipeView.reload()
    }
}
extension ReviseViewController: SwipeViewDelegate {
    func swiped(to: SwipeDirection) {
        switch to {
        case .left:
            eventHandler?.handle(event: .swipeLeft)
        case .right:
            eventHandler?.handle(event: .swipeRight)
        }
    }
}
