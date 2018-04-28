import UIKit

class CardTextView: UITextView {
    var preferredLanguage: String?
    override var textInputMode: UITextInputMode? {
        guard let preferredLanguage = preferredLanguage else {
            return super.textInputMode
        }
        for tim in UITextInputMode.activeInputModes {
            if tim.primaryLanguage!.contains(preferredLanguage) {
                return tim
            }
        }
        return super.textInputMode
    }
}
