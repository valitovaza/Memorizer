import UserNotifications

public protocol LocalNotificationScheduler {
    func schedule(at date: Date)
    func cancelNotification()
}
public protocol NotificationTextProvider {
    var notificationTitle: String { get }
}
public class ReviseAlertScheduler: LocalNotificationScheduler {
    
    private let center = UNUserNotificationCenter.current()
    
    private let textProvider: NotificationTextProvider
    public init(_ textProvider: NotificationTextProvider) {
        self.textProvider = textProvider
    }
    
    public func schedule(at date: Date) {
        center.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            self.removeAllPreviousNotifications()
            self.addLocalNotification(at: date)
        }
    }
    private func addLocalNotification(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = textProvider.notificationTitle
        content.sound = UNNotificationSound.default()

        let trDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: trDate, repeats: false)
        
        let identifier = "MemorizerLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    private func removeAllPreviousNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    public func cancelNotification() {
        removeAllPreviousNotifications()
    }
}
