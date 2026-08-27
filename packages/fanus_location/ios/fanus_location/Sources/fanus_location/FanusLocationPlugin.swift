import CoreLocation
import Flutter
import UIKit

/// Fanus'un iOS konum katmanı: CLCircularRegion tabanlı geofence izleme,
/// iki aşamalı yetkilendirme (when-in-use -> always) ve odak oturumu sırasında
/// pil dostu arka plan konum güncellemeleri.
///
/// Not: Bölge izleme (region monitoring) iOS tarafında sistem servisiyle çalışır;
/// uygulama kapalıyken bile giriş/çıkışta uygulama arka planda uyandırılır.
public class FanusLocationPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, CLLocationManagerDelegate {
  private let locationManager = CLLocationManager()
  private var eventSink: FlutterEventSink?
  private var permissionResult: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = FanusLocationPlugin()
    let methodChannel = FlutterMethodChannel(
      name: "com.samedaydin.fanus/location",
      binaryMessenger: registrar.messenger()
    )
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    let eventChannel = FlutterEventChannel(
      name: "com.samedaydin.fanus/location_events",
      binaryMessenger: registrar.messenger()
    )
    eventChannel.setStreamHandler(instance)
  }

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.pausesLocationUpdatesAutomatically = true
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "hasPermissions":
      result(locationManager.authorizationStatus == .authorizedAlways)
    case "requestPermissions":
      requestPermissions(result: result)
    case "registerAreas":
      registerAreas(call: call, result: result)
    case "clearAreas":
      locationManager.monitoredRegions.forEach { locationManager.stopMonitoring(for: $0) }
      result(nil)
    case "startTracking":
      locationManager.allowsBackgroundLocationUpdates = true
      locationManager.startUpdatingLocation()
      result(nil)
    case "stopTracking":
      locationManager.stopUpdatingLocation()
      locationManager.allowsBackgroundLocationUpdates = false
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func requestPermissions(result: @escaping FlutterResult) {
    switch locationManager.authorizationStatus {
    case .authorizedAlways:
      result(true)
    case .notDetermined:
      permissionResult = result
      locationManager.requestWhenInUseAuthorization()
    case .authorizedWhenInUse:
      permissionResult = result
      locationManager.requestAlwaysAuthorization()
    default:
      result(false)
    }
  }

  private func registerAreas(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let areas = args["areas"] as? [[String: Any]]
    else {
      result(FlutterError(code: "invalid_arguments", message: "areas listesi bekleniyor", details: nil))
      return
    }
    guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
      result(FlutterError(code: "unsupported", message: "Bu cihaz bölge izlemeyi desteklemiyor", details: nil))
      return
    }
    for area in areas {
      guard let id = area["id"] as? String,
            let latitude = area["latitude"] as? Double,
            let longitude = area["longitude"] as? Double,
            let radius = area["radiusMeters"] as? Double
      else { continue }
      let region = CLCircularRegion(
        center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
        radius: min(radius, locationManager.maximumRegionMonitoringDistance),
        identifier: id
      )
      region.notifyOnEntry = true
      region.notifyOnExit = true
      locationManager.startMonitoring(for: region)
    }
    result(nil)
  }

  private func emit(areaId: String, transition: String) {
    let event: [String: Any] = [
      "areaId": areaId,
      "transition": transition,
      "timestamp": Int(Date().timeIntervalSince1970 * 1000),
    ]
    DispatchQueue.main.async { [weak self] in
      self?.eventSink?(event)
    }
  }

  // MARK: - CLLocationManagerDelegate

  public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    emit(areaId: region.identifier, transition: "enter")
  }

  public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    emit(areaId: region.identifier, transition: "exit")
  }

  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    guard let result = permissionResult else { return }
    switch manager.authorizationStatus {
    case .authorizedWhenInUse:
      // "Her zaman" yetkisine yükselt; kullanıcı ikinci sistem diyaloğunu görür.
      manager.requestAlwaysAuthorization()
    case .authorizedAlways:
      permissionResult = nil
      result(true)
    case .denied, .restricted:
      permissionResult = nil
      result(false)
    default:
      break
    }
  }

  // MARK: - FlutterStreamHandler

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
