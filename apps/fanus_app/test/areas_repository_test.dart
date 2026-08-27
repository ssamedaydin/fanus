import 'package:fanus_app/features/areas/areas_repository.dart';
import 'package:fanus_core/fanus_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('alanlar kaydedilip geri yüklenir', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repository = AreasRepository(prefs);

    expect(repository.load(), isEmpty);

    const area = FocusArea(
      id: 'a1',
      name: 'Ofis',
      latitude: 41.0,
      longitude: 29.0,
      radiusMeters: 150,
    );
    await repository.save([area]);

    expect(AreasRepository(prefs).load(), [area]);
  });
}
