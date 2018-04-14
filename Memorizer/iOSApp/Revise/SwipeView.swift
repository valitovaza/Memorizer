import UIKit

protocol SwipeViewDelegate: class {
    func swiped(to: SwipeDirection)
}
protocol SwipeViewProvider: class {
    func nextSwipeView() -> UIView?
}
enum SwipeDirection {
    case right
    case left
}
class SwipeView: UIView, UIGestureRecognizerDelegate {
    
    weak var delegate: SwipeViewDelegate?
    weak var swipeViewProvider: SwipeViewProvider?
    
    private var firstSwipeContainer: UIView!
    private var secondSwipeContainer: UIView!
    private var currentSwipeContainer: UIView!
    
    private let maxAngle = CGFloat(Double.pi) / 16.0
    private let scaleMin: CGFloat = 0.9
    private let canBeSwipedCoeff: CGFloat = 0.3
    private let fastAnimationVelocity: CGFloat = 1400.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureSwipeView()
    }
    private func configureSwipeView() {
        addSwipeContainers()
        addPangesture()
    }
    private func addSwipeContainers() {
        addSecondSwipeContainer()
        addFirstSwipeContainer()
        currentSwipeContainer = firstSwipeContainer
    }
    private func addSecondSwipeContainer() {
        secondSwipeContainer = createSwipeContainer()
        add(childView: secondSwipeContainer, into: self)
        enableAntialiasing(on: secondSwipeContainer)
    }
    private func enableAntialiasing(on content: UIView) {
        content.layer.shouldRasterize = true
        content.layer.rasterizationScale = UIScreen.main.scale
        content.layer.allowsEdgeAntialiasing = true
    }
    private func createSwipeContainer() -> UIView {
        let view = UIView()
        view.isHidden = true
        return view
    }
    private func addFirstSwipeContainer() {
        firstSwipeContainer = createSwipeContainer()
        add(childView: firstSwipeContainer, into: self)
        enableAntialiasing(on: firstSwipeContainer)
    }
    private func add(childView: UIView, into parent: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(childView)
        NSLayoutConstraint.activate([
            childView.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            childView.topAnchor.constraint(equalTo: parent.topAnchor),
            childView.bottomAnchor.constraint(equalTo: parent.bottomAnchor)])
    }
    private func addPangesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        pan.delegate = self
        pan.maximumNumberOfTouches = 1
        addGestureRecognizer(pan)
    }
    @objc func panGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        if currentSwipeContainer.isHidden { return }
        switch gestureRecognizer.state {
        case .began:
            prepareSwipe(for: currentSwipeContainer, with: gestureRecognizer.location(in: self))
        case .changed:
            applyTransformations(of: currentSwipeContainer,
                                 relatedTo: gestureRecognizer.translation(in: self))
        case .ended:
            endSwipe(for: currentSwipeContainer,
                     with: gestureRecognizer.velocity(in: currentSwipeContainer))
        default:
            resetWithAnimationPosition(of: currentSwipeContainer)
        }
    }
    private func prepareSwipe(for content: UIView, with firstTouchPoint: CGPoint) {
        setAnchorPoint(CGPoint(x: firstTouchPoint.x / content.bounds.width,
                               y: firstTouchPoint.y / content.bounds.height), for: content)
    }
    private func setAnchorPoint(_ newAnchorPoint: CGPoint, for content: UIView) {
        let oldPosition = CGPoint(x: content.bounds.size.width * content.layer.anchorPoint.x,
                                  y: content.bounds.size.height * content.layer.anchorPoint.y)
        let newPosition = CGPoint(x: content.bounds.size.width * newAnchorPoint.x,
                                  y: content.bounds.size.height * newAnchorPoint.y)
        content.layer.position = CGPoint(x: content.layer.position.x - oldPosition.x + newPosition.x,
                                         y: content.layer.position.y - oldPosition.y + newPosition.y)
        content.layer.anchorPoint = newAnchorPoint
    }
    private func applyTransformations(of content: UIView, relatedTo dragDistance: CGPoint) {
        let rotationStrength = min(dragDistance.x / content.frame.width, 1.0)
        let rotationAngle = maxAngle * rotationStrength
        let scaleStrength = 1 - ((1 - scaleMin) * abs(rotationStrength))
        let scale = max(scaleStrength, scaleMin)
        
        var transform = CATransform3DIdentity
        transform = CATransform3DScale(transform, scale, scale, 1)
        transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
        transform = CATransform3DTranslate(transform, dragDistance.x, dragDistance.y, 0)
        content.layer.transform = transform
    }
    private func endSwipe(for content: UIView, with velocity: CGPoint) {
        if canBeSwiped(content, velocity: velocity) {
            animateTillRemove(content, with: velocity)
        }else{
            resetWithAnimationPosition(of: content)
        }
    }
    private func canBeSwiped(_ content: UIView, velocity: CGPoint) -> Bool {
        if isVelocity(velocity, oppositeTo: content.frame.origin) {
            return false
        }else if isSwipedEnoughToCorner(content) {
            return true
        }
        return false
    }
    private func isVelocity(_ velocity: CGPoint, oppositeTo direction: CGPoint) -> Bool {
        return (direction.x > 0 && velocity.x < 0) || (direction.x < 0 && velocity.x > 0)
    }
    private func isSwipedEnoughToCorner(_ content: UIView) -> Bool {
        return abs(content.frame.origin.x) > content.frame.width * canBeSwipedCoeff
    }
    private func animateTillRemove(_ content: UIView, with velocity: CGPoint) {
        isUserInteractionEnabled = false
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.onAnimateTillRemoveEnd(content)
        })
        content.layer.add(basicAnimationForRemove(content, with: velocity), forKey: "transform")
        CATransaction.commit()
    }
    private func onAnimateTillRemoveEnd(_ content: UIView) {
        let swipedDirection = getDirection(for: content)
        changeCurrentView()
        delegate?.swiped(to: swipedDirection)
        isUserInteractionEnabled = true
    }
    private func getDirection(for content: UIView) -> SwipeDirection {
        return content.frame.origin.x > 0 ? .right : .left
    }
    private func changeCurrentView() {
        revertCurrentAndBottomContainers()
        resetAfterSwipePosition(of: bottomSwipeContainer)
    }
    private func revertCurrentAndBottomContainers() {
        bringSubview(toFront: bottomSwipeContainer)
        currentSwipeContainer = bottomSwipeContainer
    }
    private func resetAfterSwipePosition(of content: UIView) {
        content.isHidden = true
        UIView.animate(withDuration: 0.0, animations: {
            content.layer.transform = CATransform3DIdentity
        }) { (_) in
            self.resetAnchorPoint(for: content)
            self.fetchContentForBottomContainer()
        }
    }
    private func resetAnchorPoint(for content: UIView) {
        content.layer.position = CGPoint(x: content.frame.size.width/2.0, y: content.frame.size.height/2.0)
        content.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    private func fetchContentForBottomContainer() {
        removeChilds(of: bottomSwipeContainer)
        addContent(into: bottomSwipeContainer)
    }
    private func basicAnimationForRemove(_ content: UIView, with velocity: CGPoint) -> CABasicAnimation {
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.toValue = NSValue(caTransform3D: transformationForRemove(of: content))
        transformAnimation.duration = duration(for: velocity)
        transformAnimation.fillMode = kCAFillModeForwards
        transformAnimation.isRemovedOnCompletion = false
        return transformAnimation
    }
    private func transformationForRemove(of content: UIView) -> CATransform3D {
        let xDiff = content.frame.origin.x
        let yDiff = content.frame.origin.y
        let yMultiplier = xDiff == 0 ? 1.0 : yDiff / xDiff
        let xTranslation = isRightMove(content) ? content.bounds.size.width : -content.bounds.size.width
        let yTranslation = xTranslation * yMultiplier
        var transform = content.layer.transform
        transform = CATransform3DTranslate(transform,
                                           xTranslation,
                                           yTranslation, 0)
        return transform
    }
    private func isRightMove(_ content: UIView) -> Bool {
        return content.frame.origin.x > 0
    }
    private func duration(for velocity: CGPoint) -> TimeInterval {
        return velocity.distance > fastAnimationVelocity ? 0.1 : 0.3
    }
    private func resetWithAnimationPosition(of content: UIView) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            content.layer.transform = CATransform3DIdentity
        }) { (_) in
            self.isUserInteractionEnabled = true
            self.resetAnchorPoint(for: content)
        }
    }
    
    func reload() {
        removeChildsOfSwipeContainers()
        addContentFromProvider()
    }
    private func removeChildsOfSwipeContainers() {
        removeChilds(of: firstSwipeContainer)
        removeChilds(of: secondSwipeContainer)
    }
    private func removeChilds(of view: UIView) {
        view.subviews.forEach { (child) in
            child.removeFromSuperview()
        }
    }
    private func addContentFromProvider() {
        addContent(into: currentSwipeContainer)
        addContent(into: bottomSwipeContainer)
    }
    private func addContent(into container: UIView) {
        if let swipeView = swipeViewProvider?.nextSwipeView() {
            add(childView: swipeView, into: container)
            container.isHidden = false
        }
    }
    private var bottomSwipeContainer: UIView {
        return currentSwipeContainer == firstSwipeContainer ? secondSwipeContainer : firstSwipeContainer
    }
}
extension CGPoint {
    var distance: CGFloat {
        return sqrt(x * x + y * y)
    }
}
