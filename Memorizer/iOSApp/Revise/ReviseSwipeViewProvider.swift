import UIKit

class ReviseSwipeViewProvider {
    
    private var words: [(front: String, back: String)] = []
    
    private let firstSwipeView: CardView
    private let secondSwipeView: CardView
    private var currentSwipeView: CardView
    init() {
        firstSwipeView = ReviseSwipeViewProvider.createSwipeView()
        secondSwipeView = ReviseSwipeViewProvider.createSwipeView()
        currentSwipeView = firstSwipeView
    }
    private static func createSwipeView() -> CardView {
        let cardView = CardView.loadFromXib()
        cardView.firstTextView.isUserInteractionEnabled = false
        cardView.secondTextView.isUserInteractionEnabled = false
        return cardView
    }
}
extension ReviseSwipeViewProvider: SwipeViewProvider {
    func nextSwipeView() -> UIView? {
        guard !words.isEmpty else { return nil }
        
        let word = words.removeLast()
        let swipeView = currentSwipeView
        configure(cardView: swipeView, word)
        currentSwipeView = nexSwipeView
        return swipeView
    }
    private func configure(cardView: CardView, _ word: (front: String, back: String)) {
        cardView.firstTextView.text = word.front
        cardView.secondTextView.text = word.back
    }
    private var nexSwipeView: CardView {
        return currentSwipeView == firstSwipeView ? secondSwipeView : firstSwipeView
    }
}
extension ReviseSwipeViewProvider: ReviseWordsHolder {
    func addRevise(words: [(front: String, back: String)]) {
        self.words = words
    }
}
