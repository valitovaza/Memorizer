public protocol PilesLoaderScreen {
    func presentLoading()
}
public protocol PilesOrEmptyScreen {
    func presentPileList()
    func presentEmpty()
}
