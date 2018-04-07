import UIKit

protocol PileDetailsEventHandler {
    func handle(event: PileDetailsViewController.Event)
}
class PileDetailsViewController: UIViewController {
    enum Event {
        case onCancel
        case onSave
    }
    
    var eventHandler: PileDetailsEventHandler?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addCardBottom: NSLayoutConstraint!
    
    @IBAction func cancelAction(_ sender: Any) {
        eventHandler?.handle(event: .onCancel)
    }
    @IBAction func saveAction(_ sender: Any) {
        eventHandler?.handle(event: .onSave)
    }
    @IBAction func addCardAction(_ sender: Any) {
        
    }
    @IBAction func textChangedAction(_ sender: Any) {
        checkSaveButton()
    }
    private func checkSaveButton() {
        navigationItem.rightBarButtonItem?.isEnabled = isSaveEnabled
    }
    private var isSaveEnabled: Bool {
        return !(nameField.text?.isEmpty ?? true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    private func onLoad() {
        checkSaveButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setObserver()
    }
    private func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        addCardBottom.constant = keyboardSize.height - view.safeAreaInsets.bottom
        animateLayout()
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        addCardBottom.constant = 0.0
        animateLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let lHolder = segue.destination as? CardsTableListenerHolder else { return }
        lHolder.tableListener = self
    }
}
extension PileDetailsViewController: CardsTableEventListener {
    func scrollOccur() {
        closeKeyboard()
    }
    private func closeKeyboard() {
        nameField.resignFirstResponder()
    }
}
extension PileDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        closeKeyboard()
        return false
    }
}
