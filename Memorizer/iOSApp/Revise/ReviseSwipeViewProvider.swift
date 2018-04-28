import UIKit

class ReviseSwipeViewProvider {
    
    private var words: [(front: String, back: String)] = []
    private var isReverted = false
    private var isInitialFill: Bool {
        return setWordsCount <= 1
    }
    private var setWordsCount = 0
    
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
        cardView.firstBigTurnButton.isUserInteractionEnabled = true
        cardView.secondBigTurnButton.isUserInteractionEnabled = true
        return cardView
    }
    
    func reset() {
        setWordsCount = 0
    }
}
extension ReviseSwipeViewProvider: SwipeViewProvider {
    func nextSwipeView() -> UIView? {
        guard !words.isEmpty else { return nil }
        
        let word = (!isInitialFill && words.count > 1) ? words.remove(at: 1) : words.removeFirst()
        let swipeView = currentSwipeView
        configure(cardView: swipeView, word)
        currentSwipeView = nexSwipeView
        return swipeView
    }
    private func configure(cardView: CardView, _ word: (front: String, back: String)) {
        cardView.firstTextView.text = word.front
        cardView.secondTextView.text = word.back
        if isReverted {
            cardView.turnToSecondWithoutAnimation()
        }else{
            cardView.turnToFirstWithoutAnimation()
        }
    }
    private var nexSwipeView: CardView {
        return currentSwipeView == firstSwipeView ? secondSwipeView : firstSwipeView
    }
}
extension ReviseSwipeViewProvider: ReviseWordsHolder {
    func setRevise(wordsData: WordsData) {
        words = wordsData.words
        isReverted = wordsData.isReverted
        setWordsCount += 1
    }
}
