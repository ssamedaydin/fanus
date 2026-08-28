import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_room.freezed.dart';
part 'focus_room.g.dart';

/// Ortak odaklanılan bir oda.
@freezed
abstract class FocusRoom with _$FocusRoom {
  const factory FocusRoom({
    required String id,
    required String name,
    required int memberCount,
  }) = _FocusRoom;

  factory FocusRoom.fromJson(Map<String, dynamic> json) =>
      _$FocusRoomFromJson(json);
}
