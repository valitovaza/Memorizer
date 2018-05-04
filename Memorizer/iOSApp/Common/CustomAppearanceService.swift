import UIKit
import iOSAdapters

final class CustomAppearanceService: NSObject, ApplicationService {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        configureAppearance()
        return true
    }
    private func configureAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor(red:1.00, green:0.58, blue:0.15, alpha:1.00)
    }
}
