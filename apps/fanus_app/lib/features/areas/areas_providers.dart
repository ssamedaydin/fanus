import 'package:fanus_core/fanus_core.dart';
import 'package:fanus_location/fanus_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../focus/focus_providers.dart';
import 'areas_repository.dart';

/// main() içinde gerçek instance ile override edilir.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('main() içinde override edilmeli'),
);

final areasRepositoryProvider = Provider<AreasRepository>(
  (ref) => AreasRepository(ref.watch(sharedPreferencesProvider)),
);

/// Gerekli konum izinleri (arka plan dahil) verilmiş mi?
final locationPermissionProvider = FutureProvider<bool>(
  (ref) => ref.watch(fanusLocationProvider).hasPermissions(),
);

/// Çalışma alanları; her değişiklikte kalıcılaştırılır ve native geofence
/// kayıtları tazelenir.
class AreasNotifier extends Notifier<List<FocusArea>> {
  @override
  List<FocusArea> build() => ref.watch(areasRepositoryProvider).load();

  Future<void> add(FocusArea area) => _update([...state, area]);

  Future<void> remove(String id) =>
      _update(state.where((area) => area.id != id).toList());

  Future<void> _update(List<FocusArea> areas) async {
    state = areas;
    await ref.read(areasRepositoryProvider).save(areas);
    await _syncGeofences(areas);
  }

  Future<void> _syncGeofences(List<FocusArea> areas) async {
    final location = ref.read(fanusLocationProvider);
    try {
      await location.clearAreas();
      if (areas.isNotEmpty) {
        await location.registerAreas([
          for (final area in areas)
            GeofenceArea(
              id: area.id,
              latitude: area.latitude,
              longitude: area.longitude,
              radiusMeters: area.radiusMeters,
            ),
        ]);
      }
    } on PlatformException catch (e) {
      // İzin yokken alan tanımlamak mümkün; geofence kaydı izin gelince
      // bir sonraki senkronda yapılır.
      debugPrint('Geofence senkronu ertelendi: ${e.code}');
    }
  }

  /// İzin sonradan verildiğinde mevcut alanları yeniden kaydettirmek için.
  Future<void> resyncGeofences() => _syncGeofences(state);
}

final areasProvider =
    NotifierProvider<AreasNotifier, List<FocusArea>>(AreasNotifier.new);
