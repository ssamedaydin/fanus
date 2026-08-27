import 'dart:async';

import '../models/focus_session.dart';
import '../models/geofence_event.dart';

/// Geofence olaylarını odak oturumlarına çeviren durum makinesi.
///
/// Kurallar:
///  * Aktif oturum yokken `enter` yeni oturum başlatır.
///  * Aktif alandan `exit` gelince oturum hemen değil, [exitGrace] sonunda
///    kapanır; süre dolmadan aynı alana dönülürse oturum kesintisiz sürer.
///    (GPS sıçramaları ve kısa çıkışlar oturumu bölmesin diye.)
///  * Aktif oturum varken başka bir alana `enter` gelirse mevcut oturum o
///    anda kapatılır ve yeni alan için oturum başlatılır.
class SessionEngine {
  SessionEngine({
    this.exitGrace = const Duration(minutes: 2),
    DateTime Function()? now,
    String Function()? newId,
  })  : _now = now ?? DateTime.now,
        _newId = newId ?? _timestampId;

  /// Alandan çıkış ile oturumun kapanması arasındaki tolerans süresi.
  final Duration exitGrace;

  final DateTime Function() _now;
  final String Function() _newId;

  final _updates = StreamController<FocusSession>.broadcast(sync: true);
  FocusSession? _active;
  Timer? _exitTimer;

  /// Başlayan ve biten oturum güncellemeleri.
  Stream<FocusSession> get updates => _updates.stream;

  /// Devam eden oturum; yoksa null.
  FocusSession? get active => _active;

  void handle(GeofenceEvent event) {
    switch (event.transition) {
      case GeofenceTransition.enter:
        _onEnter(event);
      case GeofenceTransition.exit:
        _onExit(event);
    }
  }

  void _onEnter(GeofenceEvent event) {
    final current = _active;
    if (current != null) {
      if (current.areaId == event.areaId) {
        _cancelExit();
        return;
      }
      _endActive(at: event.timestamp);
    }
    final session = FocusSession(
      id: _newId(),
      areaId: event.areaId,
      startedAt: event.timestamp,
    );
    _active = session;
    _updates.add(session);
  }

  void _onExit(GeofenceEvent event) {
    final current = _active;
    if (current == null || current.areaId != event.areaId) return;
    _exitTimer ??= Timer(exitGrace, () {
      _exitTimer = null;
      _endActive(at: _now());
    });
  }

  void _endActive({required DateTime at}) {
    _cancelExit();
    final current = _active;
    if (current == null) return;
    final ended = current.copyWith(endedAt: at);
    _active = null;
    _updates.add(ended);
  }

  void _cancelExit() {
    _exitTimer?.cancel();
    _exitTimer = null;
  }

  void dispose() {
    _cancelExit();
    _updates.close();
  }

  static String _timestampId() =>
      'session-${DateTime.now().microsecondsSinceEpoch}';
}
