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
        let topMargin = view.bounds.height * 0.07
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                              constant: margin),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: cardView.trailingAnchor,
                                                               constant: margin),
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topMargin),
            cardView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)])
        cardView.delegate = self
    }
}
extension CardDetailsViewController: CardViewDelegate {
    func firstTextChanged(_ text: String) {
        eventHandler?.handle(event: .onFirstTextChanged(text))
    }
    func secondTextChanged(_ text: String) {
        eventHandler?.handle(event: .onSecondTextChanged(text))
    }
}
extension CardDetailsViewController: SaveCardPresenter {
    func enableSaveButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    func disableSaveButton() {
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
