import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_member.freezed.dart';
part 'room_member.g.dart';

/// Bir odadaki üyenin anlık durumu.
@freezed
abstract class RoomMember with _$RoomMember {
  const factory RoomMember({
    required String name,
    required bool focusing,
  }) = _RoomMember;

  factory RoomMember.fromJson(Map<String, dynamic> json) =>
      _$RoomMemberFromJson(json);
}
