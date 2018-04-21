import iOSAdapters

struct LocalAlertTextProvider: NotificationTextProvider {
    var notificationTitle: String {
        return L10n.localNotificationTitle
    }
}
