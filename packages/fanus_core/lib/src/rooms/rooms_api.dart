import 'package:dio/dio.dart';

import '../models/focus_room.dart';

/// Oda listesini REST üzerinden çeken istemci.
class RoomsApi {
  RoomsApi({required String baseUrl, Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 5),
              ),
            );

  final Dio _dio;

  Future<List<FocusRoom>> fetchRooms() async {
    final response = await _dio.get<List<dynamic>>('/rooms');
    return (response.data ?? const [])
        .map((item) => FocusRoom.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
