import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/room_member.dart';

enum RoomConnectionStatus { connecting, connected, reconnecting, disconnected }

/// Üstel geri çekilme hesabı (saf, test edilebilir).
class ReconnectBackoff {
  const ReconnectBackoff({
    this.initial = const Duration(seconds: 1),
    this.max = const Duration(seconds: 30),
  });

  final Duration initial;
  final Duration max;

  Duration delayFor(int attempt) {
    final exponent = min(attempt, 16);
    final millis = initial.inMilliseconds * (1 << exponent);
    return Duration(milliseconds: min(millis, max.inMilliseconds));
  }
}

/// Bir odak odasına WebSocket bağlantısı.
///
/// Bağlantı koptuğunda üstel geri çekilmeyle kendini toparlar; yeniden
/// bağlanınca son bilinen odak durumunu odaya tekrar bildirir. Oda durumu
/// [members] akışından gelir.
class RoomConnection {
  RoomConnection({
    required this.uri,
    this.backoff = const ReconnectBackoff(),
    WebSocketChannel Function(Uri uri)? connector,
  }) : _connector = connector ?? WebSocketChannel.connect;

  final Uri uri;
  final ReconnectBackoff backoff;
  final WebSocketChannel Function(Uri) _connector;

  final _statusController = StreamController<RoomConnectionStatus>.broadcast();
  final _membersController = StreamController<List<RoomMember>>.broadcast();
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  int _attempt = 0;
  bool _disposed = false;
  bool? _lastSentFocusing;

  Stream<RoomConnectionStatus> get status => _statusController.stream;
  Stream<List<RoomMember>> get members => _membersController.stream;

  void connect() {
    if (_disposed) return;
    _emitStatus(
      _attempt == 0
          ? RoomConnectionStatus.connecting
          : RoomConnectionStatus.reconnecting,
    );
    try {
      final channel = _connector(uri);
      _channel = channel;
      channel.ready.then((_) {
        if (_disposed) return;
        _attempt = 0;
        _emitStatus(RoomConnectionStatus.connected);
        final lastFocusing = _lastSentFocusing;
        if (lastFocusing != null) {
          sendStatus(lastFocusing);
        }
      }).catchError((Object _) {
        // Bağlantı hatası stream'in onError'ında da ele alınır.
      });
      channel.stream.listen(
        _onMessage,
        onDone: _scheduleReconnect,
        onError: (Object _) => _scheduleReconnect(),
      );
    } catch (_) {
      _scheduleReconnect();
    }
  }

  /// Kendi odak durumunu odaya bildirir.
  void sendStatus(bool focusing) {
    _lastSentFocusing = focusing;
    _channel?.sink.add(jsonEncode({'type': 'status', 'focusing': focusing}));
  }

  void _onMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message as String) as Map<String, dynamic>;
      if (decoded['type'] == 'room_state') {
        final members = (decoded['members'] as List<dynamic>)
            .map((item) => RoomMember.fromJson(item as Map<String, dynamic>))
            .toList();
        _membersController.add(members);
      }
    } catch (_) {
      // Tanınmayan mesajlar akışı düşürmesin.
    }
  }

  void _scheduleReconnect() {
    if (_disposed || _reconnectTimer != null) return;
    _emitStatus(RoomConnectionStatus.reconnecting);
    final delay = backoff.delayFor(_attempt);
    _attempt++;
    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      connect();
    });
  }

  void _emitStatus(RoomConnectionStatus value) {
    if (!_statusController.isClosed) {
      _statusController.add(value);
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _channel?.sink.close();
    await _statusController.close();
    await _membersController.close();
  }
}
