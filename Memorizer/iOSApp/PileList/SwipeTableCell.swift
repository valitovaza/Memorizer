import UIKit

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
