import 'package:fanus_core/fanus_core.dart';
import 'package:fanus_location/fanus_location.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Native konum katmanı.
final fanusLocationProvider = Provider<FanusLocation>((ref) => FanusLocation());

/// Geofence olaylarını odak oturumlarına çeviren motor; native akışa bağlıdır.
final sessionEngineProvider = Provider<SessionEngine>((ref) {
  final location = ref.watch(fanusLocationProvider);
  final engine = SessionEngine();
  // Oturum başlarken pil dostu takip (foreground service) başlar, biterken durur.
  final trackingSubscription = engine.updates.listen((session) {
    if (session.isActive) {
      location.startTracking();
    } else {
      location.stopTracking();
    }
  });
  final subscription = location.transitions.listen(
    (event) {
      engine.handle(
        GeofenceEvent(
          areaId: event.areaId,
          transition: switch (event.transition) {
            GeofenceAreaTransition.enter => GeofenceTransition.enter,
            GeofenceAreaTransition.exit => GeofenceTransition.exit,
          },
          timestamp: event.timestamp,
        ),
      );
    },
    // Kanal hatası (ör. platform desteği yoksa) oturum akışını düşürmesin.
    onError: (Object error, StackTrace stackTrace) {
      debugPrint('fanus_location olay akışı hatası: $error');
    },
  );
  ref.onDispose(() {
    trackingSubscription.cancel();
    subscription.cancel();
    engine.dispose();
  });
  return engine;
});

/// Devam eden odak oturumu; yoksa null.
final activeSessionProvider = StreamProvider<FocusSession?>((ref) async* {
  final engine = ref.watch(sessionEngineProvider);
  yield engine.active;
  await for (final _ in engine.updates) {
    yield engine.active;
  }
});
