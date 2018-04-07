import UIKit

protocol CardViewDelegate: class {
    func firstTextChanged(_ text: String)
    func secondTextChanged(_ text: String)
}
class CardView: UIView {
    
    @IBOutlet weak var firstSide: UIView!
    @IBOutlet weak var secondSide: UIView!
    @IBOutlet weak var firstTextHeight: NSLayoutConstraint!
    @IBOutlet weak var firstTextView: UITextView!
    @IBOutlet weak var secondTextView: UITextView!
    @IBOutlet weak var secondTextHeight: NSLayoutConstraint!
    
    weak var delegate: CardViewDelegate?
    private let cRadius: CGFloat = 10.0
    private let turnDuration: TimeInterval = 0.5
    
    static func loadFromXib() -> CardView {
        return Bundle.main.loadNibNamed(String(describing: CardView.self), owner: self,
                                        options: nil)!.first as! CardView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        onAwakeFromNib()
    }
    private func onAwakeFromNib() {
        secondSide.isHidden = true
        addShadow()
        configureRadiuses()
        configureTextHeights()
    }
    private func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 1
    }
    private func configureRadiuses() {
        firstSide.layer.cornerRadius = cRadius
        secondSide.layer.cornerRadius = cRadius
    }
    private func configureTextHeights() {
        configureFirstTextViewHeight()
        configureSecondTextViewHeight()
    }
    
    @IBAction func turnAction(_ sender: Any) {
        turn()
    }
    private func turn() {
        let needOpenKeyboardAfterAnimation = currentTextView.isFirstResponder
        closeKeyboardIfNeed(needOpenKeyboardAfterAnimation)
        turnAnimation(currentSide, flippedSide) {
            self.openKeyboardIfNeed(needOpenKeyboardAfterAnimation)
        }
    }
    private func closeKeyboardIfNeed(_ needOpenKeyboardAfterAnimation: Bool) {
        if needOpenKeyboardAfterAnimation {
            UIView.performWithoutAnimation {
                currentTextView.resignFirstResponder()
            }
        }
    }
    private var currentTextView: UITextView {
        return secondSide.isHidden ? firstTextView : secondTextView
    }
    private var currentSide: UIView {
        return secondSide.isHidden ? firstSide : secondSide
    }
    private var flippedSide: UIView {
        return secondSide.isHidden ? secondSide : firstSide
    }
    private func turnAnimation(_ firstView: UIView, _ secondView: UIView, _ completion: @escaping ()->()) {
        isUserInteractionEnabled = false
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        UIView.transition(with: firstView, duration: turnDuration, options: transitionOptions, animations: {
            firstView.isHidden = true
        })
        UIView.transition(with: secondView, duration: turnDuration, options: transitionOptions, animations: {
            secondView.isHidden = false
            self.isUserInteractionEnabled = true
            completion()
        })
    }
    private func openKeyboardIfNeed(_ needOpenKeyboardAfterAnimation: Bool) {
        if needOpenKeyboardAfterAnimation {
            UIView.performWithoutAnimation {
                currentTextView.becomeFirstResponder()
            }
        }
    }
    
    func openKeyboard() {
        currentTextView.becomeFirstResponder()
    }
}
extension CardView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == firstTextView {
            delegate?.firstTextChanged(textView.text)
            configureFirstTextViewHeight()
        }else{
            delegate?.secondTextChanged(textView.text)
            configureSecondTextViewHeight()
        }
    }
    private func configureFirstTextViewHeight() {
        configureHeight(of: firstTextView, constraint: firstTextHeight)
    }
    private func configureHeight(of tv: UITextView, constraint: NSLayoutConstraint) {
        constraint.constant = tv.contentSize.height + tv.textContainerInset.top + tv.textContainerInset.bottom
    }
    private func configureSecondTextViewHeight() {
        configureHeight(of: secondTextView, constraint: secondTextHeight)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            turn()
            return false
        }
        return true
    }
}
