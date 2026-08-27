// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeofenceEvent _$GeofenceEventFromJson(Map<String, dynamic> json) =>
    _GeofenceEvent(
      areaId: json['areaId'] as String,
      transition: $enumDecode(_$GeofenceTransitionEnumMap, json['transition']),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$GeofenceEventToJson(_GeofenceEvent instance) =>
    <String, dynamic>{
      'areaId': instance.areaId,
      'transition': _$GeofenceTransitionEnumMap[instance.transition]!,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$GeofenceTransitionEnumMap = {
  GeofenceTransition.enter: 'enter',
  GeofenceTransition.exit: 'exit',
};
