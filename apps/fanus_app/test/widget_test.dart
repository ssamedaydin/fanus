import 'package:fanus_app/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('uygulama açılır ve marka görünür', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FanusApp()));
    expect(find.text('Fanus'), findsOneWidget);
  });
}
