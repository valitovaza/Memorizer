import UIKit

class ReviseViewController: UIViewController {
    
    @IBOutlet weak var swipeView: SwipeView!
    
    private var swipeViews: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    private func onLoad() {
        localize()
        configureSwipeView()
    }
    private func localize() {
        navigationItem.title = L10n.revisePile
    }
    private func configureSwipeView() {
        swipeView.delegate = self
        swipeView.swipeViewProvider = self
        
        let view = UIView()
        view.backgroundColor = .green
        swipeViews.append(view)
        
        let view2 = UIView()
        view2.backgroundColor = .red
        swipeViews.append(view2)
        
        let view3 = UIView()
        view3.backgroundColor = .black
        swipeViews.append(view3)
        
        swipeView.reload()
    }
}
extension ReviseViewController: SwipeViewDelegate {
    func swiped(to: SwipeDirection) {
        
    }
}
extension ReviseViewController: SwipeViewProvider {
    func nextSwipeView() -> UIView? {
        guard !swipeViews.isEmpty else { return nil }
        return swipeViews.removeLast()
    }
}
