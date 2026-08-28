import 'package:fanus_screen_time/fanus_screen_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppUsageStat native map\'ten doğru parse edilir', () {
    final stat = AppUsageStat.fromMap(const {
      'packageName': 'com.example.social',
      'label': 'Social',
      'foregroundMs': 5400000,
    });

    expect(stat.packageName, 'com.example.social');
    expect(stat.label, 'Social');
    expect(stat.foreground, const Duration(hours: 1, minutes: 30));
  });

  test('InstalledApp native map\'ten doğru parse edilir', () {
    final app = InstalledApp.fromMap(const {
      'packageName': 'com.example.mail',
      'label': 'Mail',
    });

    expect(app.packageName, 'com.example.mail');
    expect(app.label, 'Mail');
  });
}
