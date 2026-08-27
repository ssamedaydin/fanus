import 'package:fake_async/fake_async.dart';
import 'package:fanus_core/fanus_core.dart';
import 'package:flutter_test/flutter_test.dart';

GeofenceEvent _enter(String areaId, DateTime at) => GeofenceEvent(
      areaId: areaId,
      transition: GeofenceTransition.enter,
      timestamp: at,
    );

GeofenceEvent _exit(String areaId, DateTime at) => GeofenceEvent(
      areaId: areaId,
      transition: GeofenceTransition.exit,
      timestamp: at,
    );

void main() {
  final t0 = DateTime(2026, 8, 28, 9);
  var idCounter = 0;

  SessionEngine buildEngine({DateTime Function()? now}) => SessionEngine(
        exitGrace: const Duration(minutes: 2),
        now: now ?? () => t0,
        newId: () => 'session-${idCounter++}',
      );

  group('SessionEngine', () {
    test('alana girince oturum başlar', () {
      final engine = buildEngine();
      engine.handle(_enter('office', t0));

      expect(engine.active, isNotNull);
      expect(engine.active!.areaId, 'office');
      expect(engine.active!.isActive, isTrue);
      engine.dispose();
    });

    test('çıkışta oturum hemen değil, grace süresi sonunda biter', () {
      fakeAsync((async) {
        final endsAt = t0.add(const Duration(minutes: 10));
        final engine = buildEngine(now: () => endsAt);
        final updates = <FocusSession>[];
        engine.updates.listen(updates.add);

        engine.handle(_enter('office', t0));
        engine.handle(_exit('office', t0.add(const Duration(minutes: 8))));

        async.elapse(const Duration(minutes: 1));
        expect(engine.active, isNotNull,
            reason: 'grace dolmadan oturum kapanmamalı');

        async.elapse(const Duration(minutes: 1, seconds: 1));
        expect(engine.active, isNull);
        expect(updates.last.endedAt, endsAt);
        engine.dispose();
      });
    });

    test('grace içinde geri dönülürse oturum kesintisiz devam eder', () {
      fakeAsync((async) {
        final engine = buildEngine();
        engine.handle(_enter('office', t0));
        engine.handle(_exit('office', t0.add(const Duration(minutes: 5))));

        async.elapse(const Duration(minutes: 1));
        engine.handle(_enter('office', t0.add(const Duration(minutes: 6))));

        async.elapse(const Duration(minutes: 30));
        expect(engine.active, isNotNull);
        expect(engine.active!.areaId, 'office');
        engine.dispose();
      });
    });

    test('başka alana girilince mevcut oturum kapanır, yenisi başlar', () {
      final updates = <FocusSession>[];
      final engine = buildEngine();
      engine.updates.listen(updates.add);

      engine.handle(_enter('office', t0));
      final switchAt = t0.add(const Duration(hours: 1));
      engine.handle(_enter('library', switchAt));

      expect(engine.active!.areaId, 'library');
      expect(updates.map((s) => s.areaId).toList(),
          ['office', 'office', 'library']);
      expect(updates[1].isActive, isFalse);
      expect(updates[1].endedAt, switchAt);
      engine.dispose();
    });

    test('aktif olmayan alandan gelen çıkış yok sayılır', () {
      fakeAsync((async) {
        final engine = buildEngine();
        engine.handle(_enter('office', t0));
        engine.handle(_exit('library', t0.add(const Duration(minutes: 1))));

        async.elapse(const Duration(minutes: 10));
        expect(engine.active, isNotNull);
        engine.dispose();
      });
    });
  });
}
