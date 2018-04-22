protocol PilesCacheWorker {
    func fetchPiles(_ completion: @escaping ([IdentifyablePileItem])->())
    func addPileItem(_ pileItem: PileItem, _ completion: @escaping (Int64)->())
    func deletePileItem(_ id: Int64)
    func changePileItem(_ pileItem: PileItem, id: Int64)
}

import Cadmium

class CoreDataPileWorker: PilesCacheWorker {
    func fetchPiles(_ completion: @escaping ([IdentifyablePileItem])->()) {
        Cd.transact {
            var fetchedItems: [IdentifyablePileItem] = []
            defer {
                DispatchQueue.main.async {
                    completion(fetchedItems)
                }
            }
            do {
                let cdPiles = try self.getAllCDPiles()
                fetchedItems = cdPiles.map({IdentifyablePileItem($0.id, self.convert($0))})
            } catch let error {
                print("\(error)")
            }
        }
    }
    private func getAllCDPiles() throws -> [CDPile] {
        return try Cd.objects(CDPile.self).fetch().sorted(by: {$0.id < $1.id})
    }
    private func convert(_ cdPile: CDPile) -> PileItem {
        var cardPile = CardPile()
        let cards = cdPile.cards?.allObjects.compactMap({$0 as? CDCard}).sorted(by: {$0.id < $1.id})
            .map({Card($0.frontSide!, $0.backSide!)}) ?? []
        cards.forEach({cardPile.add($0)})
        return PileItem(title: cdPile.title!,
                        pile: cardPile,
                        createdDate: cdPile.createdDate! as Date,
                        revisedCount: Int(cdPile.revisedCount),
                        revisedDate: cdPile.revisedDate as Date?)
    }
    func addPileItem(_ pileItem: PileItem, _ completion: @escaping (Int64)->()) {
        Cd.transact {
            var addedId: Int64 = 0
            defer {
                DispatchQueue.main.async {
                    completion(addedId)
                }
            }
            do {
                let cdPile = try Cd.create(CDPile.self)
                addedId = try self.getNextIdForCDPile()
                cdPile.id = addedId
                try self.fillInfo(cdPile, pileItem)
                try Cd.commit()
            } catch let error {
                print("\(error)")
            }
        }
    }
    private func fillInfo(_ cdPile: CDPile, _ pileItem: PileItem) throws {
        cdPile.title = pileItem.title
        cdPile.createdDate = pileItem.createdDate as NSDate
        cdPile.revisedCount = Int16(pileItem.revisedCount)
        cdPile.revisedDate = pileItem.revisedDate as NSDate?
        
        let existCards = cdPile.cards?.allObjects.compactMap({$0 as? CDCard}) ?? []
        for cdCard in existCards {
            cdPile.removeFromCards(cdCard)
        }
        
        guard let cardPile = pileItem.pile as? CardPile else { return }
        for (index, card) in cardPile.cards.enumerated() {
            let cdCard = try Cd.create(CDCard.self)
            cdCard.id = Int64(index)
            cdCard.frontSide = card.front as? String
            cdCard.backSide = card.back as? String
            cdPile.addToCards(cdCard)
        }
    }
    private func getNextIdForCDPile() throws -> Int64 {
        guard let lastId = try getAllCDPiles().last?.id else { return 0 }
        return lastId + 1
    }
    func deletePileItem(_ id: Int64) {
        Cd.transact {
            do {
                let pilesForDelete = try Cd.objects(CDPile.self)
                    .filter(NSPredicate(format: "id == %lld", id)).fetch()
                for pile in pilesForDelete {
                    Cd.delete(pile)
                }
                try Cd.commit()
            } catch let error {
                print("\(error)")
            }
        }
    }
    func changePileItem(_ pileItem: PileItem, id: Int64) {
        Cd.transact {
            do {
                guard let pileToEdit = try Cd.objects(CDPile.self)
                    .filter(NSPredicate(format: "id == %lld", id)).fetchOne() else { return }
                try self.fillInfo(pileToEdit, pileItem)
                try Cd.commit()
            } catch let error {
                print("\(error)")
            }
        }
    }
}
