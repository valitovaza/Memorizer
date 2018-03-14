import UIKit

class PileListEmptyViewController: UIViewController {
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyLabel.text = L10n.emptyPileList
    }
}
