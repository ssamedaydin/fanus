import 'dart:math';

import 'package:fanus_core/fanus_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../focus/focus_providers.dart';

/// Sunucu adresi; Android emülatöründe host makineye 10.0.2.2 ile erişilir.
/// Gerçek cihazda `--dart-define=FANUS_SERVER=http://<makine-ip>:8787` verin.
const serverBaseUrl = String.fromEnvironment(
  'FANUS_SERVER',
  defaultValue: 'http://10.0.2.2:8787',
);

final roomsApiProvider =
    Provider<RoomsApi>((ref) => RoomsApi(baseUrl: serverBaseUrl));

/// Oda listesi; ekrana her girişte yeniden çekilsin diye autoDispose.
final roomsProvider = FutureProvider.autoDispose<List<FocusRoom>>(
  (ref) => ref.watch(roomsApiProvider).fetchRooms(),
);

/// Odalarda görünen takma ad; oturum boyunca sabit kalır.
final guestNameProvider =
    Provider<String>((ref) => 'Misafir-${Random().nextInt(9000) + 1000}');

/// Oda başına canlı WebSocket bağlantısı; ekran kapanınca kendini kapatır.
final roomConnectionProvider =
    Provider.autoDispose.family<RoomConnection, String>((ref, roomId) {
  final wsBase = serverBaseUrl.replaceFirst('http', 'ws');
  final userName = ref.watch(guestNameProvider);
  final connection = RoomConnection(
    uri: Uri.parse('$wsBase/ws?room=$roomId&user=$userName'),
  )..connect();

  // Kendi odak durumunu odaya bildir: odaya girerken mevcut durum
  // (fireImmediately) ve sonrasındaki her değişim.
  ref.listen(
    activeSessionProvider,
    (previous, next) => connection.sendStatus(next.value != null),
    fireImmediately: true,
  );
  ref.onDispose(connection.dispose);
  return connection;
});

final roomMembersProvider = StreamProvider.autoDispose
    .family<List<RoomMember>, String>(
  (ref, roomId) => ref.watch(roomConnectionProvider(roomId)).members,
);

final roomStatusProvider = StreamProvider.autoDispose
    .family<RoomConnectionStatus, String>(
  (ref, roomId) => ref.watch(roomConnectionProvider(roomId)).status,
);
