import 'package:fanus_app/app/app.dart';
import 'package:fanus_app/features/focus/focus_providers.dart';
import 'package:fanus_location/fanus_location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Testte native kanala bağlanmayan sahte konum katmanı.
class _FakeFanusLocation extends FanusLocation {
  @override
  Stream<GeofenceTransitionEvent> get transitions => const Stream.empty();
}

void main() {
  testWidgets('uygulama açılır ve oturum durumu görünür', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fanusLocationProvider.overrideWithValue(_FakeFanusLocation()),
        ],
        child: const FanusApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Fanus'), findsOneWidget);
    expect(find.text('Aktif odak oturumu yok'), findsOneWidget);
  });
}
