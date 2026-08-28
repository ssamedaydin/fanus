import 'dart:async';

import 'package:fanus_app/features/focus/focus_providers.dart';
import 'package:fanus_app/features/screen_time/screen_time_providers.dart';
import 'package:fanus_location/fanus_location.dart';
import 'package:fanus_screen_time/fanus_screen_time.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _RecordingLocation extends FanusLocation {
  final calls = <String>[];
  final _controller = StreamController<GeofenceTransitionEvent>.broadcast();

  @override
  Stream<GeofenceTransitionEvent> get transitions => _controller.stream;

  @override
  Future<void> startTracking() async => calls.add('start');

  @override
  Future<void> stopTracking() async => calls.add('stop');

  void emitEnter(String areaId) => _controller.add(
        GeofenceTransitionEvent(
          areaId: areaId,
          transition: GeofenceAreaTransition.enter,
          timestamp: DateTime.now(),
        ),
      );
}

class _RecordingScreenTime extends FanusScreenTime {
  final shieldCalls = <bool>[];

  @override
  Future<void> setShieldEnabled(bool enabled) async =>
      shieldCalls.add(enabled);
}

void main() {
  test('alan değişiminde takip servisi durdurulup yeniden başlatılmaz', () async {
    final location = _RecordingLocation();
    final screenTime = _RecordingScreenTime();
    final container = ProviderContainer(
      overrides: [
        fanusLocationProvider.overrideWithValue(location),
        fanusScreenTimeProvider.overrideWithValue(screenTime),
      ],
    );
    addTearDown(container.dispose);

    container.read(sessionEngineProvider);

    // Alan A'ya giriş: takip bir kez başlar.
    location.emitEnter('area-a');
    await Future<void>.delayed(Duration.zero);
    expect(location.calls, ['start']);
    expect(screenTime.shieldCalls, [true]);

    // Alan B'ye geçiş: oturum art arda biter ve başlar; servis bu
    // patlamada durdurulup yeniden başlatılmamalı (crash senaryosu).
    location.emitEnter('area-b');
    await Future<void>.delayed(Duration.zero);
    expect(location.calls, ['start']);
    expect(screenTime.shieldCalls, [true]);
  });
}
