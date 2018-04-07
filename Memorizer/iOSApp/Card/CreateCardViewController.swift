import UIKit
import iOSAdapters

protocol CreateCardEventHandler {
    func handle(event: CreateCardViewController.Event)
}
class CreateCardViewController: UIViewController {
    enum Event {
        case onLoad(SaveCardPresenter)
        case onCancel
        case onSave
        case onFirstTextChanged(String)
        case onSecondTextChanged(String)
    }
    
    var eventHandler: CreateCardEventHandler?
    private var cardView: CardView!
    
    @IBAction func cancelAction(_ sender: Any) {
        eventHandler?.handle(event: .onCancel)
    }
    @IBAction func saveAction(_ sender: Any) {
        eventHandler?.handle(event: .onSave)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler?.handle(event: .onLoad(self))
        localize()
        onDidLoad()
    }
    private func localize() {
        navigationItem.title = L10n.createСard
    }
    private func onDidLoad() {
        disableSaveButton()
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
extension CreateCardViewController: CardViewDelegate {
    func firstTextChanged(_ text: String) {
        eventHandler?.handle(event: .onFirstTextChanged(text))
    }
    func secondTextChanged(_ text: String) {
        eventHandler?.handle(event: .onSecondTextChanged(text))
    }
}
extension CreateCardViewController: SaveCardPresenter {
    func enableSaveButton() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    func disableSaveButton() {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}
