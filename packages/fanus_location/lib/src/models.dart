/// Native geofence katmanına kaydedilecek dairesel alan.
class GeofenceArea {
  const GeofenceArea({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
  });

  final String id;
  final double latitude;
  final double longitude;
  final double radiusMeters;

  Map<String, Object> toMap() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'radiusMeters': radiusMeters,
      };
}

/// Alan sınırından geçiş yönü.
enum GeofenceAreaTransition { enter, exit }

/// Native katmandan gelen geofence geçiş olayı.
class GeofenceTransitionEvent {
  const GeofenceTransitionEvent({
    required this.areaId,
    required this.transition,
    required this.timestamp,
  });

  factory GeofenceTransitionEvent.fromMap(Map<Object?, Object?> map) {
    return GeofenceTransitionEvent(
      areaId: map['areaId']! as String,
      transition: map['transition'] == 'enter'
          ? GeofenceAreaTransition.enter
          : GeofenceAreaTransition.exit,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']! as int),
    );
  }

  final String areaId;
  final GeofenceAreaTransition transition;
  final DateTime timestamp;
}
