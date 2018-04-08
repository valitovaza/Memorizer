public protocol CardHolder {
    associatedtype T: CardSide
    func frontChanged(_ cardSide: T)
    func backChanged(_ cardSide: T)
    var card: Card? { get }
}
public protocol SaveCardView {
    func enableSaveButton()
    func disableSaveButton()
}
public class StringCardHolder {
    private var front = ""
    private var back = ""
    private let view: SaveCardView
    public init(_ view: SaveCardView) {
        self.view = view
    }
    public init(_ view: SaveCardView, front: String, back: String) {
        self.view = view
        self.front = front
        self.back = back
    }
}
extension StringCardHolder: CardHolder {
    public func frontChanged(_ cardSide: String) {
        front = cardSide.trim()
        checkSaveButton()
    }
    private func checkSaveButton() {
        if isSavingEnabled {
            view.enableSaveButton()
        }else{
            view.disableSaveButton()
        }
    }
    private var isSavingEnabled: Bool {
        return !front.isEmpty && !back.isEmpty
    }
    public func backChanged(_ cardSide: String) {
        back = cardSide.trim()
        checkSaveButton()
    }
    public var card: Card? {
        guard isSavingEnabled else { return nil }
        return Card(front, back)
    }
}
