import CloudKit

public protocol NetUpdater {
    func fetchAndSavePilesOptionally()
}
public protocol CoreDataSaver {
    func save(_ loadedPiles: [PileItemWithNetId], _ completion: @escaping (Bool)->())
}
public struct PileItemWithNetId {
    let netId: String
    let pileItem: PileItem
    init(_ netId: String, _ pileItem: PileItem) {
        self.netId = netId
        self.pileItem = pileItem
    }
}
public protocol PileUpdatesPresenter {
    func pilesLoaded()
}
public class CloudKitWorker {
    fileprivate let pileRecordType = "Pile"
    fileprivate let rTitle = "title"
    fileprivate let rCreatedDate = "createdDate"
    fileprivate let rRevisedCount = "revisedCount"
    fileprivate let rRevisedDate = "revisedDate"
    fileprivate let rFrontSides = "frontSides"
    fileprivate let rBackSides = "backSides"
    
    fileprivate let container: CKContainer
    fileprivate let privateDB: CKDatabase
    init() {
        container = CKContainer.default()
        privateDB = container.privateCloudDatabase
    }
}
public class CloudKitCache: CloudKitWorker {
    
    private let lastCloudFetchKey = "com.memorizer.lastCloudFetchKey"
    private let userDefaults = UserDefaults.standard
    private var isFetching = false
    
    private let saver: CoreDataSaver
    private let presenter: PileUpdatesPresenter
    public init(_ saver: CoreDataSaver, _ presenter: PileUpdatesPresenter) {
        self.saver = saver
        self.presenter = presenter
        super.init()
    }
}
extension CloudKitCache: NetUpdater {
    public func fetchAndSavePilesOptionally() {
        guard canFetch() else { return }
        
        let query = CKQuery(recordType: pileRecordType, predicate: NSPredicate(value: true))
        
        isFetching = true
        privateDB.perform(query, inZoneWith: nil) {[weak self] (results, error) in
            self?.isFetching = false
            
            if let error = error {
                print(error)
                return
            }
            
            self?.saveFetchDate()
            
            guard let records = results, records.count > 0 else { return }
            let pilesToSave = records.compactMap({self?.convert(record: $0)})
            guard pilesToSave.count > 0 else { return }
            DispatchQueue.main.async {
                self?.saver.save(pilesToSave, { hasChanges in
                    if hasChanges {
                        self?.presenter.pilesLoaded()
                    }
                })
            }
        }
    }
    private func canFetch() -> Bool {
        guard !isFetching else { return false }
        guard let lastFetchDate = userDefaults.value(forKey: lastCloudFetchKey) as? Date else { return true }
        return lastFetchDate.addingTimeInterval(8 * 60 * 60) < Date()
    }
    private func saveFetchDate() {
        userDefaults.set(Date(), forKey: lastCloudFetchKey)
    }
    private func convert(record: CKRecord) -> PileItemWithNetId? {
        guard let title = record.value(forKey: rTitle) as? String,
            let createdDate = record.value(forKey: rCreatedDate) as? Date,
            let revisedCount = record.value(forKey: rRevisedCount) as? Int,
            let frontSides = record.value(forKey: rFrontSides) as? [String],
            let backSides = record.value(forKey: rBackSides) as? [String] else { return nil }
        let revisedDate = record.value(forKey: rRevisedDate) as? Date
        let cards = zip(frontSides, backSides).map({Card($0, $1)})
        var pile = CardPile()
        cards.forEach({pile.add($0)})
        let pileItem = PileItem(title: title, pile: pile, createdDate: createdDate,
                                revisedCount: revisedCount, revisedDate: revisedDate)
        return PileItemWithNetId(record.recordID.recordName, pileItem)
    }
}
public class CloudKitSaver: CloudKitWorker {}
extension CloudKitSaver: NetSaver {
    public func savePile(_ pileItem: PileItem, completion: @escaping (String?) -> ()) {
        guard let cardPile = pileItem.pile as? CardPile else { return }
        let record = CKRecord(recordType: pileRecordType)
        fillRecordFields(record, pileItem, cardPile)
        saveRecord(record, completion: completion)
    }
    private func fillRecordFields(_ record: CKRecord, _ pileItem: PileItem, _ cardPile: CardPile) {
        record.setValue(pileItem.title, forKey: rTitle)
        record.setValue(pileItem.createdDate, forKey: rCreatedDate)
        record.setValue(pileItem.revisedCount, forKey: rRevisedCount)
        if let revisedDate = pileItem.revisedDate {
            record.setValue(revisedDate, forKey: rRevisedDate)
        }
        let frontSides = cardPile.cards.compactMap({$0.front as? String})
        let backSides = cardPile.cards.compactMap({$0.back as? String})
        if frontSides.count > 0 && backSides.count == frontSides.count {
            record.setValue(frontSides, forKey: rFrontSides)
            record.setValue(backSides, forKey: rBackSides)
        }
    }
    private func saveRecord(_ record: CKRecord, completion: ((String?) -> ())? = nil) {
        privateDB.save(record) { (result, error) in
            if let error = error {
                print(error)
                completion?(nil)
                return
            }
            if let result = result {
                completion?(result.recordID.recordName)
            }else{
                completion?(nil)
            }
        }
    }
    public func delete(id netId: String) {
        privateDB.delete(withRecordID: CKRecordID(recordName: netId)) { (result, error) in
            if let error = error {
                print(error)
                return
            }
        }
    }
    public func change(pileItem: PileItem, netId: String) {
        guard let cardPile = pileItem.pile as? CardPile else { return }
        privateDB.fetch(withRecordID: CKRecordID(recordName: netId)) { (record, error) in
            if let error = error {
                print(error)
                return
            }
            guard let record = record else { return }
            self.fillRecordFields(record, pileItem, cardPile)
            self.saveRecord(record)
        }
    }
}
