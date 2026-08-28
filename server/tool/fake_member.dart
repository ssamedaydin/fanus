import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

/// Demo aracı: bir odaya sahte üye sokar (varsayılan: derin-odak, odakta).
///
/// Kullanım: dart run tool/fake_member.dart [isim] [oda] [dakika]
Future<void> main(List<String> args) async {
  final name = args.isNotEmpty ? args[0] : 'Kiraz';
  final room = args.length > 1 ? args[1] : 'derin-odak';
  final minutes = args.length > 2 ? int.tryParse(args[2]) ?? 10 : 10;

  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8787/ws?room=$room&user=$name'),
  );
  await channel.ready;
  channel.sink.add(jsonEncode({'type': 'status', 'focusing': true}));
  stdout.writeln('$name "$room" odasına bağlandı (odakta), $minutes dk kalacak.');
  channel.stream.listen((message) => stdout.writeln('oda durumu: $message'));

  await Future<void>.delayed(Duration(minutes: minutes));
  await channel.sink.close();
  stdout.writeln('$name odadan ayrıldı.');
}
