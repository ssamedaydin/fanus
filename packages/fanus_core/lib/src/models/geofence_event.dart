import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence_event.freezed.dart';
part 'geofence_event.g.dart';

/// Bir çalışma alanının sınırından geçiş yönü.
enum GeofenceTransition { enter, exit }

/// Native geofence katmanından gelen giriş/çıkış olayı.
@freezed
abstract class GeofenceEvent with _$GeofenceEvent {
  const factory GeofenceEvent({
    required String areaId,
    required GeofenceTransition transition,
    required DateTime timestamp,
  }) = _GeofenceEvent;

  factory GeofenceEvent.fromJson(Map<String, dynamic> json) =>
      _$GeofenceEventFromJson(json);
}
