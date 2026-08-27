import 'package:fanus_location/fanus_location.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GeofenceArea kanal sözleşmesine uygun map üretir', () {
    const area = GeofenceArea(
      id: 'office',
      latitude: 40.99,
      longitude: 29.23,
      radiusMeters: 150,
    );

    expect(area.toMap(), {
      'id': 'office',
      'latitude': 40.99,
      'longitude': 29.23,
      'radiusMeters': 150.0,
    });
  });

  test('GeofenceTransitionEvent native map\'ten doğru parse edilir', () {
    final event = GeofenceTransitionEvent.fromMap(const {
      'areaId': 'office',
      'transition': 'exit',
      'timestamp': 1756368000000,
    });

    expect(event.areaId, 'office');
    expect(event.transition, GeofenceAreaTransition.exit);
    expect(
      event.timestamp,
      DateTime.fromMillisecondsSinceEpoch(1756368000000),
    );
  });
}
