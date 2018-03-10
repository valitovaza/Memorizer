protocol CardSidePresenter {
    func present<T: CardSide>(cardSide: T)
}


struct TestPresenter: CardSidePresenter {
    func present<String>(cardSide: String) {
        
    }
}

struct PresenterHolder {
    var presenter: CardSidePresenter!
}
