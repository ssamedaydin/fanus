// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FocusArea _$FocusAreaFromJson(Map<String, dynamic> json) => _FocusArea(
  id: json['id'] as String,
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  radiusMeters: (json['radiusMeters'] as num).toDouble(),
);

Map<String, dynamic> _$FocusAreaToJson(_FocusArea instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radiusMeters': instance.radiusMeters,
    };
