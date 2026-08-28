// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FocusRoom _$FocusRoomFromJson(Map<String, dynamic> json) => _FocusRoom(
  id: json['id'] as String,
  name: json['name'] as String,
  memberCount: (json['memberCount'] as num).toInt(),
);

Map<String, dynamic> _$FocusRoomToJson(_FocusRoom instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'memberCount': instance.memberCount,
    };
