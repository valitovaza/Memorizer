import UIKit
import iOSAdapters

class PluggableAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var services: [ApplicationService] { return [] }
    
    private lazy var __services: [ApplicationService] = {
        return services
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()
        var result = false
        for service in __services {
            if service.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? false {
                result = true
            }
        }
        return result
    }
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        var result = false
        for service in __services {
            if service.application?(application, open: url, options: options) ?? false {
                result = true
            }
        }
        return result
    }
    
    func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        for service in __services {
            service.application?(application,
                                 didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
        for service in __services {
            service.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        for service in __services {
            service.applicationDidBecomeActive?(application)
        }
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        for service in __services {
            service.applicationWillEnterForeground?(application)
        }
    }
}
