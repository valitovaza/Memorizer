import UIKit

protocol CardViewDelegate: class {
    func firstTextChanged(_ text: String)
    func secondTextChanged(_ text: String)
    func returnAction()
}
class CardView: UIView {
    
    @IBOutlet weak var firstBigTurnButton: UIButton!
    @IBOutlet weak var secondBigTurnButton: UIButton!
    @IBOutlet weak var firstSide: UIView!
    @IBOutlet weak var secondSide: UIView!
    @IBOutlet weak var firstTextHeight: NSLayoutConstraint!
    @IBOutlet weak var firstTextView: CardTextView!
    @IBOutlet weak var secondTextView: CardTextView!
    @IBOutlet weak var secondTextHeight: NSLayoutConstraint!
    
    weak var delegate: CardViewDelegate?
    private let cRadius: CGFloat = 10.0
    private let turnDuration: TimeInterval = 0.3
    
    static func loadFromXib() -> CardView {
        return Bundle.main.loadNibNamed(String(describing: CardView.self), owner: self,
                                        options: nil)!.first as! CardView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        onAwakeFromNib()
        firstTextView.preferredLanguage = CardViewKeyboardSuggestions.firstPreferredLanguage
        secondTextView.preferredLanguage = CardViewKeyboardSuggestions.secondPreferredLanguage
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
    func turn() {
        let needOpenKeyboardAfterAnimation = currentTextView.isFirstResponder
        closeKeyboardIfNeed(needOpenKeyboardAfterAnimation)
        turnAnimation(currentSide, flippedSide) {
            self.openKeyboardIfNeed(needOpenKeyboardAfterAnimation)
        }
    }
    func turnToFirstWithoutAnimation() {
        firstSide.isHidden = false
        secondSide.isHidden = true
    }
    func turnToSecondWithoutAnimation() {
        firstSide.isHidden = true
        secondSide.isHidden = false
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
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
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
    func configureFirstTextViewHeight() {
        configureHeight(of: firstTextView, constraint: firstTextHeight)
    }
    private func configureHeight(of tv: UITextView, constraint: NSLayoutConstraint) {
        constraint.constant = tv.contentSize.height + tv.textContainerInset.top + tv.textContainerInset.bottom
    }
    func configureSecondTextViewHeight() {
        configureHeight(of: secondTextView, constraint: secondTextHeight)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.returnAction()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let primaryLanguage = textView.notOverriddenInputMode?.primaryLanguage else { return }
        guard let cardTextView = textView as? CardTextView else { return }
        cardTextView.preferredLanguage = primaryLanguage
        if cardTextView == firstTextView {
            CardViewKeyboardSuggestions.setFirstPreferredLanguage(primaryLanguage)
        }else{
            CardViewKeyboardSuggestions.setSecondPreferredLanguage(primaryLanguage)
        }
    }
}
struct CardViewKeyboardSuggestions {
    private static let firstKeyboardPrimaryLanguageKey = "com.memorizer.firstKeyboardPrimaryLanguageKey"
    private static let secondKeyboardPrimaryLanguageKey = "com.memorizer.secondKeyboardPrimaryLanguageKey"
    private static let userDefaults = UserDefaults.standard
    static func setFirstPreferredLanguage(_ lang: String) {
        userDefaults.set(lang, forKey: firstKeyboardPrimaryLanguageKey)
    }
    static var firstPreferredLanguage: String? {
        return userDefaults.object(forKey: firstKeyboardPrimaryLanguageKey) as? String
    }
    static func setSecondPreferredLanguage(_ lang: String) {
        userDefaults.set(lang, forKey: secondKeyboardPrimaryLanguageKey)
    }
    static var secondPreferredLanguage: String? {
        return userDefaults.object(forKey: secondKeyboardPrimaryLanguageKey) as? String
    }
}
