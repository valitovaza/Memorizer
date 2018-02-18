class PresenterSpy: Presenter {
    var presentWasInvoked = 0
    func present() {
        presentWasInvoked += 1
    }
}
