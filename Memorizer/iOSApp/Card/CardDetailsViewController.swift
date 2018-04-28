import UIKit
import iOSAdapters

protocol CardDetailsEventHandler {
    func handle(event: CardDetailsViewController.Event)
}
protocol CardDetailsConfigurable {
    func configureCreateView()
    func configureEditView(_ frontText: String, _ backText: String)
}

typealias CardDetailsVC = CardDetailsConfigurable & SaveCardPresenter

class CardDetailsViewController: UIViewController {
    enum Event {
        case onLoad(CardDetailsVC)
        case onCancel
        case onSave
        case onFirstTextChanged(String)
        case onSecondTextChanged(String)
    }
    
    var eventHandler: CardDetailsEventHandler?
    private var cardView: CardView!
    private var topCardViewConstraint: NSLayoutConstraint?
    
    @IBAction func cancelAction(_ sender: Any) {
        eventHandler?.handle(event: .onCancel)
    }
    @IBAction func saveAction(_ sender: Any) {
        eventHandler?.handle(event: .onSave)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onDidLoad()
        eventHandler?.handle(event: .onLoad(self))
    }
    private func onDidLoad() {
        addCardView()
        cardView.openKeyboard()
    }
    private func addCardView() {
        cardView = CardView.loadFromXib()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)
        let margin: CGFloat = 20.0
        let topConstraint = cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topCardMargin())
        let width = isLandscapeOrientation ? view.bounds.size.height : view.bounds.size.width
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                              constant: margin),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: cardView.trailingAnchor,
                                                               constant: margin),
            topConstraint,
            cardView.heightAnchor.constraint(equalToConstant: width * 0.5)])
        cardView.delegate = self
        topCardViewConstraint = topConstraint
    }
    private func topCardMargin() -> CGFloat {
        let size = view.bounds.size
        if isLandscapeOrientation {
            return -size.height * 0.1
        }else{
            return size.height * 0.07
        }
    }
    private var isLandscapeOrientation: Bool {
        return view.bounds.size.width > view.bounds.size.height
    }
    override func viewDidLayoutSubviews() {
        topCardViewConstraint?.constant = topCardMargin()
    }
}
extension CardDetailsViewController: CardViewDelegate {
    func firstTextChanged(_ text: String) {
        eventHandler?.handle(event: .onFirstTextChanged(text))
    }
    func secondTextChanged(_ text: String) {
        eventHandler?.handle(event: .onSecondTextChanged(text))
    }
    func returnAction() {
        if canSave() {
            eventHandler?.handle(event: .onSave)
        }else{
            cardView.turn()
        }
    }
    private func canSave() -> Bool {
        return navigationItem.rightBarButtonItem?.isEnabled ?? false
    }
}
extension CardDetailsViewController: SaveCardPresenter {
    func enableSaveButton() {
        change(returnKey: .done, of: cardView.firstTextView)
        change(returnKey: .done, of: cardView.secondTextView)
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    private func change(returnKey: UIReturnKeyType, of textView: UITextView) {
        textView.returnKeyType = returnKey
        textView.reloadInputViews()
    }
    func disableSaveButton() {
        change(returnKey: .next, of: cardView.firstTextView)
        change(returnKey: .next, of: cardView.secondTextView)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}
extension CardDetailsViewController: CardDetailsConfigurable {
    func configureCreateView() {
        navigationItem.title = L10n.createСard
        disableSaveButton()
    }
    func configureEditView(_ frontText: String, _ backText: String) {
        navigationItem.title = L10n.editСard
        cardView.firstTextView.text = frontText
        cardView.secondTextView.text = backText
    }
}
