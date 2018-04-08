protocol RoutersProvider {
    var pileListRouter: PileListRouter { get }
    var pileDetailsRouter: PileDetailsRouter { get }
    var createCardRouter: CreateCardRouter { get }
}
class RouterFactory {
    private static var factory: RoutersProvider!
    
    static func set(factory: RoutersProvider) {
        self.factory = factory
    }
    
    static func getPileListRouter() -> PileListRouter {
        return factory.pileListRouter
    }
    static func getPileDetailsRouter() -> PileDetailsRouter {
        return factory.pileDetailsRouter
    }
    static func getCreateCardRouter() -> CreateCardRouter {
        return factory.createCardRouter
    }
}

protocol PileListRouter {
    func openCreatePile()
    func openPileDetails(at index: Int)
}
protocol PileDetailsRouter {
    func closePileDetails()
    func openCreateCard()
    func openCardDetails(at index: Int)
}
protocol CreateCardRouter {
    func closeCreateCard()
    func closeCreateCardAndCreatePile()
}

import UIKit

class AppRouter {
    private var startViewController: UIViewController
    private var modalStack: [UIViewController] = []
    init(_ startViewController: UIViewController) {
        self.startViewController = startViewController
    }
}
extension AppRouter: RoutersProvider {
    var pileListRouter: PileListRouter {
        return self
    }
    var pileDetailsRouter: PileDetailsRouter {
        return self
    }
    var createCardRouter: CreateCardRouter {
        return self
    }
}
extension AppRouter: PileListRouter {
    func openCreatePile() {
        guard let pileDetailsNav = makePilesDetailsNav() else { return }
        presentOverWithoutAnimation(pileDetailsNav) {
            self.modalStack.append(pileDetailsNav)
            guard let cardNav = self.makeCreateCardNav() else { return }
            pileDetailsNav.present(cardNav, animated: true, completion: {
                self.modalStack.append(cardNav)
                pileDetailsNav.view.alpha = 1.0
            })
        }
    }
    private func makePilesDetailsNav() -> UINavigationController? {
        let nav = UIControllerFactory.instantiateNavigation(.PileDetails,
                                                            with: PileDetailsViewController.self)
        guard let details = nav.viewControllers.first as? PileDetailsViewController else { return nil }
        details.eventHandler = DependencyResolver.getPileDetailsEventHandler()
        return nav
    }
    private func makeCreateCardNav() -> UINavigationController? {
        let nav = UIControllerFactory.instantiateNavigation(.Card, with: CardDetailsViewController.self)
        guard let card = nav.viewControllers.first as? CardDetailsViewController else { return nil }
        card.eventHandler = DependencyResolver.getCardDetailsEventHandler()
        return nav
    }
    private func presentOverWithoutAnimation(_ viewController: UIViewController,
                                             _ completion: @escaping ()->()) {
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.view.alpha = 0.0
        startViewController.present(viewController, animated: false) {
            completion()
        }
    }
    func openPileDetails(at index: Int) {
    }
}
extension AppRouter: PileDetailsRouter {
    func closePileDetails() {
        closeModal()
    }
    private func closeModal() {
        modalStack.last?.view.endEditing(true)
        modalStack.last?.dismiss(animated: true, completion: nil)
        modalStack.removeLast()
    }
    func openCreateCard() {
        guard let cardNav = self.makeCreateCardNav() else { return }
        let parent = modalStack.last ?? startViewController
        parent.present(cardNav, animated: true, completion: nil)
        modalStack.append(cardNav)
    }
    func openCardDetails(at index: Int) {
    }
}
extension AppRouter: CreateCardRouter {
    func closeCreateCard() {
        closeModal()
    }
    func closeCreateCardAndCreatePile() {
        if modalStack.count > 1 {
            closeLastTwoModals()
        }else{
            closeModal()
        }
    }
    private func closeLastTwoModals() {
        let createCard = modalStack.last!
        modalStack.removeLast()
        let createPile = modalStack.last!
        modalStack.removeLast()
        createCard.view.endEditing(true)
        createPile.view.alpha = 0.0
        createCard.dismiss(animated: true) {
            createPile.dismiss(animated: false, completion: nil)
        }
    }
}
