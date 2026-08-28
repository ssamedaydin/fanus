import 'package:fanus_core/fanus_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReconnectBackoff', () {
    const backoff = ReconnectBackoff();

    test('denemeler üstel olarak artar', () {
      expect(backoff.delayFor(0), const Duration(seconds: 1));
      expect(backoff.delayFor(1), const Duration(seconds: 2));
      expect(backoff.delayFor(2), const Duration(seconds: 4));
      expect(backoff.delayFor(3), const Duration(seconds: 8));
    });

    test('gecikme üst sınırda sabitlenir', () {
      expect(backoff.delayFor(5), const Duration(seconds: 30));
      expect(backoff.delayFor(50), const Duration(seconds: 30));
    });
  });
}
