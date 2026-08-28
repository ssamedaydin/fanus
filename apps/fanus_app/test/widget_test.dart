import 'package:fanus_app/app/app.dart';
import 'package:fanus_app/features/areas/areas_providers.dart';
import 'package:fanus_app/features/focus/focus_providers.dart';
import 'package:fanus_app/i18n/translations.g.dart';
import 'package:fanus_location/fanus_location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Testte native kanala bağlanmayan sahte konum katmanı.
class _FakeFanusLocation extends FanusLocation {
  @override
  Stream<GeofenceTransitionEvent> get transitions => const Stream.empty();
}

void main() {
  testWidgets('uygulama açılır ve oturum durumu görünür', (tester) async {
    LocaleSettings.setLocaleSync(AppLocale.tr);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            fanusLocationProvider.overrideWithValue(_FakeFanusLocation()),
          ],
          child: const FanusApp(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Fanus'), findsOneWidget);
    expect(find.text('Aktif odak oturumu yok'), findsOneWidget);
    expect(find.text('Çalışma alanları'), findsOneWidget);
    expect(find.text('Odak odaları'), findsOneWidget);
  });
}
