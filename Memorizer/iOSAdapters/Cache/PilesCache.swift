protocol CacheIdResolver {
    func save(netId: String, for coreDataId: Int64)
    func getNetId(for coreDataId: Int64, _ completion: @escaping (String?)->())
}
public protocol NetSaver {
    func savePile(_ pileItem: PileItem, completion: @escaping (String?) -> ())
    func delete(id netId: String)
    func change(pileItem: PileItem, netId: String)
}
class PilesCache: PilesCacheWorker {
    
    lazy var netSaver: NetSaver = CloudKitSaver()
    var cache: PilesCacheWorker = CoreDataPileWorker()
    var netIdSaver: CacheIdResolver = CoreDataPileWorker()
    
    func fetchPiles(_ completion: @escaping ([IdentifyablePileItem])->()) {
        cache.fetchPiles(completion)
    }
    func addPileItem(_ pileItem: PileItem, _ completion: @escaping (Int64)->()) {
        cache.addPileItem(pileItem) { (cachePileId) in
            completion(cachePileId)
            self.netSaver.savePile(pileItem, completion: { (recordId) in
                guard let recordId = recordId else { return }
                self.netIdSaver.save(netId: recordId, for: cachePileId)
            })
        }
    }
    func deletePileItem(_ id: Int64) {
        cache.deletePileItem(id)
        netIdSaver.getNetId(for: id) { (netId) in
            guard let netId = netId else { return }
            self.netSaver.delete(id: netId)
        }
    }
    func changePileItem(_ pileItem: PileItem, id: Int64) {
        cache.changePileItem(pileItem, id: id)
        netIdSaver.getNetId(for: id) { (netId) in
            guard let netId = netId else { return }
            self.netSaver.change(pileItem: pileItem, netId: netId)
        }
    }
}
