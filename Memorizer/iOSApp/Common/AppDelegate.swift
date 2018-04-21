import UIKit
import iOSAdapters

@UIApplicationMain
class AppDelegate: PluggableAppDelegate {
    override var services: [ApplicationService] {
        return [CoreDataService()]
    }
}
