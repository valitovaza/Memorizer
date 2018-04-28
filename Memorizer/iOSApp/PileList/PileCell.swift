import UIKit

protocol PileCellDelegate: class {
    func onDelete(cell: PileCell)
    func onEdit(cell: PileCell)
    func onCombine(cell: PileCell)
    func swipeInProgress(cell: PileCell)
}
class SwipeTableCell: UITableViewCell {
    
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer?
    fileprivate var beginXPosition: CGFloat = 0.0
    fileprivate var isSwiping = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addPangesture()
    }
    var contentConstraint: NSLayoutConstraint? {
        return nil
    }
    private func addPangesture() {
        guard panGestureRecognizer == nil else { return }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        pan.delegate = self
        pan.maximumNumberOfTouches = 1
        addGestureRecognizer(pan)
        panGestureRecognizer = pan
    }
    @objc func panGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            guard canStartToSwipe(gestureRecognizer) else { return }
            isSwiping = true
            beginXPosition = contentConstraint?.constant ?? 0.0
            onSwipeBegan()
        case .changed:
            guard isSwiping else { return }
            let translation = gestureRecognizer.translation(in: self)
            contentConstraint?.constant = min(0.0, translation.x + beginXPosition)
            onSwipeProgress()
        case .ended:
            guard isSwiping else { return }
            if gestureRecognizer.velocity(in: self).x < 0
                && abs(gestureRecognizer.translation(in: self).x) > 20.0 {
                onOpenActions()
            }else{
                onCloseActions()
            }
            isSwiping = false
        default:
            guard isSwiping else { return }
            onCloseActions()
            isSwiping = false
        }
    }
    func onSwipeBegan() {
    }
    func onSwipeProgress() {
    }
    func onOpenActions() {
    }
    func onCloseActions() {
    }
    private func canStartToSwipe(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return abs(gestureRecognizer.translation(in: self).y) < abs(gestureRecognizer.translation(in: self).x)
    }
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !isSwiping
    }
    func preparePileCell() {
        layer.removeAllAnimations()
        contentConstraint?.constant = 0.0
        isSwiping = false
    }
    func cancelGesture() {
        panGestureRecognizer?.isEnabled = false
        panGestureRecognizer?.isEnabled = true
    }
}
class PileCell: SwipeTableCell {
    
    static let openedConstraint: CGFloat = 66.0
    static let closedConstraint: CGFloat = 16.0
    
    weak var delegate: PileCellDelegate?
    
    @IBOutlet weak var contentLeading: NSLayoutConstraint!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var combineButton: UIButton!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    
    @IBAction func deleteAction(_ sender: Any) {
        closeButtonsAnimated()
        delegate?.onDelete(cell: self)
    }
    @IBAction func editAction(_ sender: Any) {
        closeButtonsAnimated()
        delegate?.onEdit(cell: self)
    }
    @IBAction func combineAction(_ sender: Any) {
        closeButtonsAnimated()
        delegate?.onCombine(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        localize()
        hideButtons()
    }
    private func localize() {
        deleteButton.setTitle(L10n.delete, for: .normal)
        editButton.setTitle(L10n.edit, for: .normal)
        combineButton.setTitle(L10n.combine, for: .normal)
    }
    private func hideButtons() {
        deleteButton.isHidden = true
        editButton.isHidden = true
        combineButton.isHidden = true
    }
    override var contentConstraint: NSLayoutConstraint? {
        return contentLeading
    }
    
    override func onSwipeBegan() {
        showButtons()
    }
    private func showButtons() {
        deleteButton.isHidden = false
        editButton.isHidden = false
        combineButton.isHidden = false
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
        guard contentLeading.constant != 0.0 else { return }
        contentLeading.constant = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            self.hideButtons()
        }
    }
    private func openButtonsAnimated() {
        showButtons()
        contentLeading.constant = -3.0 * buttonWidth.constant
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    override func preparePileCell() {
        super.preparePileCell()
        hideButtons()
    }
}
