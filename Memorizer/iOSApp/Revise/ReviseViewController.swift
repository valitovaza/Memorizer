import UIKit

protocol ReviseEventHandler {
    func handle(event: ReviseViewController.Event)
}
struct WordsData {
    let words: [(front: String, back: String)]
    let isReverted: Bool
}
protocol ReviseWordsHolder {
    func setRevise(wordsData: WordsData)
}
protocol CardViewReloader {
    func reload()
}
extension SwipeView: CardViewReloader {}
class ReviseViewController: UIViewController {
    enum Event {
        case onLoad(ReviseWordsHolder, WordReviserView)
        case swipeRight(CardViewReloader)
        case swipeLeft(CardViewReloader)
        case onPileRevised
    }
    
    var eventHandler: ReviseEventHandler?
    
    private let viewProvider = ReviseSwipeViewProvider()
    
    @IBOutlet weak var thumbsUp: UIImageView!
    @IBOutlet weak var thumbsDown: UIImageView!
    @IBOutlet weak var swipeView: SwipeView!
    
    @IBAction func infoAction(_ sender: Any) {
        presentAlert(L10n.info, L10n.swipeInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    private func onLoad() {
        localize()
        eventHandler?.handle(event: .onLoad(viewProvider, self))
        configureSwipeView()
        thumbsUp.alpha = 0.0
        thumbsDown.alpha = 0.0
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
            eventHandler?.handle(event: .swipeLeft(swipeView))
        case .right:
            eventHandler?.handle(event: .swipeRight(swipeView))
        }
        hideThumbs()
    }
    private func hideThumbs() {
        UIView.animate(withDuration: 0.2) {
            self.thumbsUp.alpha = 0.0
            self.thumbsDown.alpha = 0.0
        }
    }
    func dragged(_ dragDistance: CGPoint) {
        let visiblePercent = min(1.0, abs(0.8 * dragDistance.x)/(view.bounds.size.width * 0.3))
        if dragDistance.x > 0 {
            thumbsDown.alpha = 0.0
            thumbsUp.alpha = visiblePercent
        }else{
            thumbsUp.alpha = 0.0
            thumbsDown.alpha = visiblePercent
        }
    }
    func swipeCancelled() {
        hideThumbs()
    }
}
extension ReviseViewController: WordReviserView {
    func pileRevised() {
        eventHandler?.handle(event: .onPileRevised)
        presentRevisedAlert()
    }
    private func presentRevisedAlert() {
        presentAlert(L10n.pileRevised, nil) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    private func presentAlert(_ title: String, _ message: String?, _ completion: (()->())? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        { action -> Void in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func turnPile(_ wordsData: WordsData) {
        if wordsData.words.count == 1 {
            turnWithoutAnimation(wordsData)
        }else{
            turnWithAnimation(wordsData)
        }
    }
    private func turnWithoutAnimation(_ wordsData: WordsData) {
        self.viewProvider.reset()
        self.viewProvider.setRevise(wordsData: wordsData)
        self.swipeView.reload()
    }
    private func turnWithAnimation(_ wordsData: WordsData) {
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.swipeView.alpha = 0.0
        }) { (_) in
            self.viewProvider.reset()
            self.viewProvider.setRevise(wordsData: wordsData)
            self.swipeView.reload()
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.swipeView.alpha = 1.0
                self.view.isUserInteractionEnabled = true
            })
        }
    }
}
