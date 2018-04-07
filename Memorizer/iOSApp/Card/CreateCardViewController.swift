import UIKit

protocol CreateCardEventHandler {
    func handle(event: CreateCardViewController.Event)
}
class CreateCardViewController: UIViewController {
    enum Event {
        case onCancel
        case onSave
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
        onDidLoad()
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
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                              constant: margin),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: cardView.trailingAnchor,
                                                               constant: margin),
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            cardView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)])
    }
}
