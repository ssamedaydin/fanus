import DeviceActivity
import FamilyControls
import Flutter
import ManagedSettings
import SwiftUI
import UIKit

/// Fanus'un iOS ekran süresi katmanı: FamilyControls `.individual`
/// yetkilendirmesi (Opal modeli), FamilyActivityPicker ile uygulama seçimi,
/// ManagedSettings kalkanı ve DeviceActivity izleme.
///
/// Gerçek cihazda Family Controls entitlement'ı gerekir; development
/// entitlement demo için yeterlidir (bkz. paket README'si).
public class FanusScreenTimePlugin: NSObject, FlutterPlugin {
  private let store = ManagedSettingsStore()
  private let activityCenter = DeviceActivityCenter()
  private let activityName = DeviceActivityName("fanus.focus")
  private let selectionDefaultsKey = "fanus_family_activity_selection"

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.samedaydin.fanus/screen_time",
      binaryMessenger: registrar.messenger()
    )
    let instance = FanusScreenTimePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isAuthorized":
      result(AuthorizationCenter.shared.authorizationStatus == .approved)
    case "requestAuthorization":
      Task { @MainActor in
        do {
          try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
          result(true)
        } catch {
          result(false)
        }
      }
    case "showAppPicker":
      presentPicker(result: result)
    case "setShieldEnabled":
      let enabled = (call.arguments as? [String: Any])?["enabled"] as? Bool ?? false
      setShield(enabled: enabled)
      result(nil)
    case "isShieldEnabled":
      result(store.shield.applications != nil || store.shield.applicationCategories != nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - Seçim kalıcılığı

  private func loadSelection() -> FamilyActivitySelection {
    guard let data = UserDefaults.standard.data(forKey: selectionDefaultsKey),
          let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
    else { return FamilyActivitySelection() }
    return selection
  }

  private func saveSelection(_ selection: FamilyActivitySelection) {
    if let data = try? JSONEncoder().encode(selection) {
      UserDefaults.standard.set(data, forKey: selectionDefaultsKey)
    }
  }

  // MARK: - FamilyActivityPicker

  private func presentPicker(result: @escaping FlutterResult) {
    guard let root = Self.rootViewController() else {
      result(FlutterError(code: "no_view_controller", message: "Görünür pencere yok", details: nil))
      return
    }
    var host: UIHostingController<ActivityPickerScreen>?
    let screen = ActivityPickerScreen(
      selection: loadSelection(),
      onDone: { [weak self] selection in
        self?.saveSelection(selection)
        host?.dismiss(animated: true)
        result(true)
      },
      onCancel: {
        host?.dismiss(animated: true)
        result(false)
      }
    )
    let controller = UIHostingController(rootView: screen)
    host = controller
    root.present(controller, animated: true)
  }

  // MARK: - Kalkan

  private func setShield(enabled: Bool) {
    if enabled {
      let selection = loadSelection()
      store.shield.applications =
        selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
      store.shield.applicationCategories = selection.categoryTokens.isEmpty
        ? nil
        : ShieldSettings.ActivityCategoryPolicy.specific(selection.categoryTokens)
      let schedule = DeviceActivitySchedule(
        intervalStart: DateComponents(hour: 0, minute: 0),
        intervalEnd: DateComponents(hour: 23, minute: 59),
        repeats: true
      )
      try? activityCenter.startMonitoring(activityName, during: schedule)
    } else {
      store.shield.applications = nil
      store.shield.applicationCategories = nil
      activityCenter.stopMonitoring([activityName])
    }
  }

  private static func rootViewController() -> UIViewController? {
    UIApplication.shared.connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.keyWindow }
      .first?.rootViewController
  }
}

/// FamilyActivityPicker'ı saran seçim ekranı.
private struct ActivityPickerScreen: View {
  @State var selection: FamilyActivitySelection
  let onDone: (FamilyActivitySelection) -> Void
  let onCancel: () -> Void

  var body: some View {
    NavigationView {
      FamilyActivityPicker(selection: $selection)
        .navigationTitle("Kısıtlanacak uygulamalar")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Vazgeç", action: onCancel)
          }
          ToolbarItem(placement: .confirmationAction) {
            Button("Bitti") { onDone(selection) }
          }
        }
    }
  }
}
