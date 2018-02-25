public protocol ActivityIndicatorPresenter: class {
    func animateActivityIndicator()
}
public class SpinnerAnimator {
    private weak var presenter: ActivityIndicatorPresenter?
    public init(_ presenter: ActivityIndicatorPresenter) {
        self.presenter = presenter
    }
}
extension SpinnerAnimator: PilesLoaderScreen {
    public func presentLoading() {
        presenter?.animateActivityIndicator()
    }
}
