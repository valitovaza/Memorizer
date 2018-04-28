import UIKit

protocol PileCellDelegate: class {
    func onDelete(cell: PileCell)
    func onEdit(cell: PileCell)
    func onCombine(cell: PileCell)
    func swipeInProgress(cell: PileCell)
}
class PileCell: UITableViewCell {
    
    static let openedConstraint: CGFloat = 66.0
    static let closedConstraint: CGFloat = 16.0
    
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var beginXPosition: CGFloat = 0.0
    private var isSwiping = false
    
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
        configureUI()
    }
    private func localize() {
        deleteButton.setTitle(L10n.delete, for: .normal)
        editButton.setTitle(L10n.edit, for: .normal)
        combineButton.setTitle(L10n.combine, for: .normal)
    }
    private func configureUI() {
        addPangesture()
        hideButtons()
    }
    private func hideButtons() {
        deleteButton.isHidden = true
        editButton.isHidden = true
        combineButton.isHidden = true
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
            beginXPosition = contentLeading.constant
            showButtons()
        case .changed:
            guard isSwiping else { return }
            let translation = gestureRecognizer.translation(in: self)
            contentLeading.constant = min(0.0, translation.x + beginXPosition)
            delegate?.swipeInProgress(cell: self)
        case .ended:
            guard isSwiping else { return }
            if gestureRecognizer.velocity(in: self).x < 0
                && abs(gestureRecognizer.translation(in: self).x) > 20.0 {
                openButtonsAnimated()
            }else{
                closeButtonsAnimated()
            }
            isSwiping = false
        default:
            guard isSwiping else { return }
            closeButtonsAnimated()
            isSwiping = false
        }
    }
    private func canStartToSwipe(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return abs(gestureRecognizer.translation(in: self).y) < abs(gestureRecognizer.translation(in: self).x)
    }
    private func showButtons() {
        deleteButton.isHidden = false
        editButton.isHidden = false
        combineButton.isHidden = false
    }
    func cancelGesture() {
        panGestureRecognizer?.isEnabled = false
        panGestureRecognizer?.isEnabled = true
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
    func preparePileCell() {
        layer.removeAllAnimations()
        contentLeading.constant = 0.0
        hideButtons()
        isSwiping = false
    }
    func enablePan() {
        panGestureRecognizer?.isEnabled = true
    }
    func disablePan() {
        panGestureRecognizer?.isEnabled = false
    }
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !isSwiping
    }
}
