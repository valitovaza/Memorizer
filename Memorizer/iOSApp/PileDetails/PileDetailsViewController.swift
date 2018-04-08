import UIKit
import iOSAdapters

protocol PileDetailsEventHandler {
    func handle(event: PileDetailsViewController.Event)
}
protocol PileDetailsConfigurable {
    func configureCreateView()
    func configureEditView()
}

typealias PileDetailsVC = PileDetailsPresenter & PileDetailsConfigurable

class PileDetailsViewController: UIViewController {
    enum Event {
        case onPrepareSegue(UITableReloader, CardsDataSourceHolder)
        case onLoad(PileDetailsVC)
        case onTitleChanged(String)
        case onAddCard
        case onCellSecelted(Int)
        case onCancel
        case onSave
    }
    
    var eventHandler: PileDetailsEventHandler?
    
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addCardBottom: NSLayoutConstraint!
    
    @IBAction func cancelAction(_ sender: Any) {
        eventHandler?.handle(event: .onCancel)
    }
    @IBAction func saveAction(_ sender: Any) {
        eventHandler?.handle(event: .onSave)
    }
    @IBAction func addCardAction(_ sender: Any) {
        eventHandler?.handle(event: .onAddCard)
    }
    @IBAction func textChangedAction(_ sender: Any) {
        guard let text = nameField.text else { return }
        eventHandler?.handle(event: .onTitleChanged(text))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler?.handle(event: .onLoad(self))
        localize()
        onLoad()
    }
    private func localize() {
        addCardButton.setTitle(L10n.addCard, for: .normal)
        nameField.placeholder = L10n.pileName
    }
    private func onLoad() {
        disableSaveButton()
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
        guard let reloader = segue.destination as? UITableReloader,
            let dsHolder = segue.destination as? CardsDataSourceHolder else { return }
        eventHandler?.handle(event: .onPrepareSegue(reloader, dsHolder))
    }
}
extension PileDetailsViewController: CardsTableEventListener {
    func cellSelected(at index: Int) {
        eventHandler?.handle(event: .onCellSecelted(index))
    }
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
extension PileDetailsViewController: PileDetailsPresenter {
    func updateTitle(_ title: String) {
        nameField.text = title
    }
    func enableSaveButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    func disableSaveButton() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}
extension PileDetailsViewController: PileDetailsConfigurable {
    func configureCreateView() {
        navigationItem.title = L10n.createPile
    }
    func configureEditView() {
        navigationItem.title = L10n.editPile
    }
}
