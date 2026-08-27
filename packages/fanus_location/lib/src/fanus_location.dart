import 'package:flutter/services.dart';

import 'models.dart';

/// Native konum katmanının Flutter arayüzü.
///
/// Android tarafında GeofencingClient + foreground service, iOS tarafında
/// CLLocationManager bölge izleme kullanılır; olaylar [transitions]
/// akışından gelir.
class FanusLocation {
  static const MethodChannel _methods =
      MethodChannel('com.samedaydin.fanus/location');
  static const EventChannel _events =
      EventChannel('com.samedaydin.fanus/location_events');

  static Stream<GeofenceTransitionEvent>? _transitions;

  /// Gerekli tüm izinler (arka plan konumu dahil) verilmiş mi?
  Future<bool> hasPermissions() async =>
      await _methods.invokeMethod<bool>('hasPermissions') ?? false;

  /// İzin akışını başlatır; arka plan konumu dahil verildiyse true döner.
  Future<bool> requestPermissions() async =>
      await _methods.invokeMethod<bool>('requestPermissions') ?? false;

  /// Çalışma alanlarını native geofence katmanına kaydeder.
  /// Mevcut kayıtların üzerine yazar (aynı id'ler güncellenir).
  Future<void> registerAreas(List<GeofenceArea> areas) => _methods.invokeMethod(
        'registerAreas',
        {'areas': areas.map((area) => area.toMap()).toList()},
      );

  /// Tüm geofence kayıtlarını kaldırır.
  Future<void> clearAreas() => _methods.invokeMethod('clearAreas');

  /// Odak oturumu takibini başlatır (Android: foreground service,
  /// iOS: arka plan konum güncellemeleri).
  Future<void> startTracking() => _methods.invokeMethod('startTracking');

  /// Odak oturumu takibini durdurur.
  Future<void> stopTracking() => _methods.invokeMethod('stopTracking');

  /// Geofence giriş/çıkış olayları.
  Stream<GeofenceTransitionEvent> get transitions =>
      _transitions ??= _events.receiveBroadcastStream().map(
            (event) =>
                GeofenceTransitionEvent.fromMap(event as Map<Object?, Object?>),
          );
}
