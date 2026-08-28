import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Fanus demo sunucusu: oda listesi (REST) ve gerçek zamanlı üye durumu (WS).
///
/// Çalıştırma: `dart run fanus_server` (varsayılan port 8787, PORT ile değişir).
Future<void> main(List<String> args) async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8787;
  final hub = RoomHub({
    'derin-odak': 'Derin Odak',
    'kutuphane': 'Kütüphane',
    'sabah-rutini': 'Sabah Rutini',
  });

  final router = Router()
    ..get('/rooms', hub.listRooms)
    ..get('/ws', hub.handleWebSocket);

  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(router.call);
  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
  // ignore: avoid_print
  print('Fanus server dinliyor: http://${server.address.host}:${server.port}');
}

/// Odaları ve üyelerini bellekte tutan merkez.
class RoomHub {
  RoomHub(Map<String, String> roomNames) {
    for (final entry in roomNames.entries) {
      _rooms[entry.key] = _Room(entry.key, entry.value);
    }
  }

  final _rooms = <String, _Room>{};

  Response listRooms(Request request) => Response.ok(
        jsonEncode([
          for (final room in _rooms.values)
            {
              'id': room.id,
              'name': room.name,
              'memberCount': room.members.length,
            },
        ]),
        headers: {'content-type': 'application/json'},
      );

  FutureOr<Response> handleWebSocket(Request request) {
    final roomId = request.url.queryParameters['room'];
    final userName = request.url.queryParameters['user'] ?? 'misafir';
    final room = _rooms[roomId];
    if (room == null) {
      return Response.notFound('Oda bulunamadı: $roomId');
    }

    return webSocketHandler((WebSocketChannel channel, String? protocol) {
      final member = _Member(userName, channel);
      room.join(member);
      channel.stream.listen(
        (dynamic message) {
          try {
            final decoded =
                jsonDecode(message as String) as Map<String, dynamic>;
            if (decoded['type'] == 'status') {
              member.focusing = decoded['focusing'] == true;
              room.broadcastState();
            }
          } catch (_) {
            // Bozuk mesajlar bağlantıyı düşürmesin.
          }
        },
        onDone: () => room.leave(member),
        onError: (Object _) => room.leave(member),
      );
    })(request);
  }
}

class _Room {
  _Room(this.id, this.name);

  final String id;
  final String name;
  final members = <_Member>[];

  void join(_Member member) {
    members.add(member);
    broadcastState();
  }

  void leave(_Member member) {
    members.remove(member);
    broadcastState();
  }

  void broadcastState() {
    final payload = jsonEncode({
      'type': 'room_state',
      'roomId': id,
      'members': [
        for (final member in members)
          {'name': member.name, 'focusing': member.focusing},
      ],
    });
    for (final member in members) {
      member.channel.sink.add(payload);
    }
  }
}

class _Member {
  _Member(this.name, this.channel);

  final String name;
  final WebSocketChannel channel;
  bool focusing = false;
}
