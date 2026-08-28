import 'package:flutter/services.dart';

import 'models.dart';

/// Native ekran süresi katmanının Flutter arayüzü.
///
/// Android: UsageStatsManager (kullanım), AccessibilityService (kalkan),
/// DevicePolicyManager (yönetici/force-lock).
/// iOS: FamilyControls + ManagedSettings + DeviceActivity; uygulama seçimi
/// sistemin FamilyActivityPicker'ı ile yapılır.
class FanusScreenTime {
  static const MethodChannel _channel =
      MethodChannel('com.samedaydin.fanus/screen_time');

  // --- Kullanım istatistikleri (Android) ---

  Future<bool> hasUsageAccess() async =>
      await _channel.invokeMethod<bool>('hasUsageAccess') ?? false;

  Future<void> openUsageAccessSettings() =>
      _channel.invokeMethod('openUsageAccessSettings');

  Future<List<AppUsageStat>> getTodayUsage() async {
    final raw =
        await _channel.invokeListMethod<Map<Object?, Object?>>('getTodayUsage');
    return raw?.map(AppUsageStat.fromMap).toList() ?? const [];
  }

  Future<List<InstalledApp>> getLaunchableApps() async {
    final raw = await _channel
        .invokeListMethod<Map<Object?, Object?>>('getLaunchableApps');
    return raw?.map(InstalledApp.fromMap).toList() ?? const [];
  }

  // --- Kalkan (Android: AccessibilityService) ---

  Future<bool> isAccessibilityEnabled() async =>
      await _channel.invokeMethod<bool>('isAccessibilityEnabled') ?? false;

  Future<void> openAccessibilitySettings() =>
      _channel.invokeMethod('openAccessibilitySettings');

  Future<List<String>> getRestrictedApps() async =>
      await _channel.invokeListMethod<String>('getRestrictedApps') ?? const [];

  Future<void> setRestrictedApps(List<String> packages) =>
      _channel.invokeMethod('setRestrictedApps', {'packages': packages});

  /// Odak oturumu başında true, sonunda false çağrılır; iki platformda da
  /// kısıtlamayı bu anahtar açar/kapatır.
  Future<void> setShieldEnabled(bool enabled) =>
      _channel.invokeMethod('setShieldEnabled', {'enabled': enabled});

  // --- Cihaz yöneticisi (Android) ---

  Future<bool> isDeviceAdminActive() async =>
      await _channel.invokeMethod<bool>('isDeviceAdminActive') ?? false;

  Future<void> requestDeviceAdmin() =>
      _channel.invokeMethod('requestDeviceAdmin');

  Future<void> lockNow() => _channel.invokeMethod('lockNow');

  // --- Ekran süresi yetkisi (iOS: FamilyControls) ---

  Future<bool> isScreenTimeAuthorized() async =>
      await _channel.invokeMethod<bool>('isAuthorized') ?? false;

  Future<bool> requestScreenTimeAuthorization() async =>
      await _channel.invokeMethod<bool>('requestAuthorization') ?? false;

  /// iOS'ta FamilyActivityPicker'ı açar; seçim native tarafta saklanır.
  Future<bool> showAppPicker() async =>
      await _channel.invokeMethod<bool>('showAppPicker') ?? false;
}
