import 'package:fanus_screen_time/fanus_screen_time.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Native ekran süresi katmanı.
final fanusScreenTimeProvider =
    Provider<FanusScreenTime>((ref) => FanusScreenTime());

// --- Android izin durumları ---

final usageAccessProvider = FutureProvider<bool>(
  (ref) => ref.watch(fanusScreenTimeProvider).hasUsageAccess(),
);

final accessibilityEnabledProvider = FutureProvider<bool>(
  (ref) => ref.watch(fanusScreenTimeProvider).isAccessibilityEnabled(),
);

final deviceAdminProvider = FutureProvider<bool>(
  (ref) => ref.watch(fanusScreenTimeProvider).isDeviceAdminActive(),
);

// --- iOS FamilyControls yetkisi ---

final screenTimeAuthorizedProvider = FutureProvider<bool>(
  (ref) => ref.watch(fanusScreenTimeProvider).isScreenTimeAuthorized(),
);

// --- Kullanım ve kısıtlama verileri ---

final todayUsageProvider = FutureProvider<List<AppUsageStat>>((ref) async {
  final screenTime = ref.watch(fanusScreenTimeProvider);
  if (!await screenTime.hasUsageAccess()) return const [];
  return screenTime.getTodayUsage();
});

final launchableAppsProvider = FutureProvider<List<InstalledApp>>(
  (ref) => ref.watch(fanusScreenTimeProvider).getLaunchableApps(),
);

/// Odak sırasında engellenecek paketler; her değişiklik native katmana yazılır.
class RestrictedAppsNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async =>
      (await ref.watch(fanusScreenTimeProvider).getRestrictedApps()).toSet();

  Future<void> toggle(String packageName) async {
    final current = {...state.value ?? const <String>{}};
    if (!current.remove(packageName)) {
      current.add(packageName);
    }
    state = AsyncData(current);
    await ref.read(fanusScreenTimeProvider).setRestrictedApps(current.toList());
  }
}

final restrictedAppsProvider =
    AsyncNotifierProvider<RestrictedAppsNotifier, Set<String>>(
  RestrictedAppsNotifier.new,
);
