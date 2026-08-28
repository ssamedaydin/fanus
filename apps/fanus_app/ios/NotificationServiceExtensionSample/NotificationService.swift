import OneSignalExtension
import UserNotifications

/// Xcode'da Runner projesine "Notification Service Extension" hedefi olarak
/// eklenecek örnek (hedef adı önerisi: OneSignalNotificationServiceExtension).
/// Zengin içerikli (görselli/butonlu) OneSignal bildirimlerini teslimden önce
/// işler. Hedefin Podfile'ına `OneSignalXCFramework` eklenmelidir; ayrıntı
/// için OneSignal iOS SDK kurulum dokümanına bakın.
class NotificationService: UNNotificationServiceExtension {
  var contentHandler: ((UNNotificationContent) -> Void)?
  var receivedRequest: UNNotificationRequest?
  var bestAttemptContent: UNMutableNotificationContent?

  override func didReceive(
    _ request: UNNotificationRequest,
    withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
  ) {
    self.receivedRequest = request
    self.contentHandler = contentHandler
    self.bestAttemptContent =
      (request.content.mutableCopy() as? UNMutableNotificationContent)
    if let receivedRequest = receivedRequest,
       let bestAttemptContent = bestAttemptContent {
      OneSignalExtension.didReceiveNotificationExtensionRequest(
        receivedRequest,
        with: bestAttemptContent,
        withContentHandler: contentHandler
      )
    }
  }

  override func serviceExtensionTimeWillExpire() {
    if let receivedRequest = receivedRequest,
       let contentHandler = contentHandler,
       let bestAttemptContent = bestAttemptContent {
      OneSignalExtension.serviceExtensionTimeWillExpireRequest(
        receivedRequest,
        with: bestAttemptContent
      )
      contentHandler(bestAttemptContent)
    }
  }
}
