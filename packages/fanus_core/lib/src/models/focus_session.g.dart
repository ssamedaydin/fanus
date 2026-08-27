// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FocusSession _$FocusSessionFromJson(Map<String, dynamic> json) =>
    _FocusSession(
      id: json['id'] as String,
      areaId: json['areaId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
    );

Map<String, dynamic> _$FocusSessionToJson(_FocusSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'areaId': instance.areaId,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
    };
