import iOSAdapters
import UIKit
import UserNotifications

final class LocalNotificationService: NSObject, ApplicationService {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted { print("Something went wrong")}
        }
        return true
    }
}
