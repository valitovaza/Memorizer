import Cadmium
import CoreData

public final class CoreDataService: NSObject, ApplicationService {
    
    private let bundleID = "Memorizer.iOSAdapters"
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        do {
            try Cd.initWithSQLStore(momdInbundleID: bundleID,
                                    momdName: "Memorizer.momd",
                                    sqliteFilename: "Memorizer.sqlite",
                                    options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                              NSInferMappingModelAutomaticallyOption: true])
        } catch let error {
            print("\(error)")
        }
        return true
    }
}
