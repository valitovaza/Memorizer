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
    
    @IBOutlet weak var swipeView: SwipeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    private func onLoad() {
        localize()
        eventHandler?.handle(event: .onLoad(viewProvider, self))
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
            eventHandler?.handle(event: .swipeLeft(swipeView))
        case .right:
            eventHandler?.handle(event: .swipeRight(swipeView))
        }
    }
}
extension ReviseViewController: WordReviserView {
    func pileRevised() {
        eventHandler?.handle(event: .onPileRevised)
        presentRevisedAlert()
    }
    private func presentRevisedAlert() {
        let alert = UIAlertController(title: L10n.pileRevised,
                                      message: nil,
                                      preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { action -> Void in
            self.navigationController?.popViewController(animated: true)
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
