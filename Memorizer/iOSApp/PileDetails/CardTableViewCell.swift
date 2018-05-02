import UIKit

protocol CardTableViewCellDelegate: class {
    func onDelete(cell: CardTableViewCell)
    func swipeInProgress(cell: CardTableViewCell)
}
class CardTableViewCell: SwipeTableCell {

    weak var delegate: CardTableViewCellDelegate?
    
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var cardContentLeading: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var frontTitle: UILabel!
    @IBOutlet weak var backTitle: UILabel!

    @IBAction func deleteAction(_ sender: Any) {
        delegate?.onDelete(cell: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        localize()
        hideButton()
    }
    private func localize() {
        deleteButton.setTitle(L10n.delete, for: .normal)
    }
    private func hideButton() {
        deleteButton.isHidden = true
    }
    
    override var contentConstraint: NSLayoutConstraint? {
        return cardContentLeading
    }
    
    override func onSwipeBegan() {
        showButtons()
    }
    private func showButtons() {
        deleteButton.isHidden = false
    }
    
    override func onSwipeProgress() {
        delegate?.swipeInProgress(cell: self)
    }
    override func onOpenActions() {
        openButtonsAnimated()
    }
    override func onCloseActions() {
        closeButtonsAnimated()
    }
    func closeButtonsAnimated() {
        cancelGesture()
        guard cardContentLeading.constant != 0.0 else { return }
        cardContentLeading.constant = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            self.hideButton()
        }
    }
    private func openButtonsAnimated() {
        showButtons()
        cardContentLeading.constant = -buttonWidth.constant
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    override func preparePileCell() {
        super.preparePileCell()
        hideButton()
    }
}
