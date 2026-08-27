// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeofenceEvent {

 String get areaId; GeofenceTransition get transition; DateTime get timestamp;
/// Create a copy of GeofenceEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeofenceEventCopyWith<GeofenceEvent> get copyWith => _$GeofenceEventCopyWithImpl<GeofenceEvent>(this as GeofenceEvent, _$identity);

  /// Serializes this GeofenceEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeofenceEvent&&(identical(other.areaId, areaId) || other.areaId == areaId)&&(identical(other.transition, transition) || other.transition == transition)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,areaId,transition,timestamp);

@override
String toString() {
  return 'GeofenceEvent(areaId: $areaId, transition: $transition, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $GeofenceEventCopyWith<$Res>  {
  factory $GeofenceEventCopyWith(GeofenceEvent value, $Res Function(GeofenceEvent) _then) = _$GeofenceEventCopyWithImpl;
@useResult
$Res call({
 String areaId, GeofenceTransition transition, DateTime timestamp
});




}
/// @nodoc
class _$GeofenceEventCopyWithImpl<$Res>
    implements $GeofenceEventCopyWith<$Res> {
  _$GeofenceEventCopyWithImpl(this._self, this._then);

  final GeofenceEvent _self;
  final $Res Function(GeofenceEvent) _then;

/// Create a copy of GeofenceEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? areaId = null,Object? transition = null,Object? timestamp = null,}) {
  return _then(GeofenceEvent(
areaId: null == areaId ? _self.areaId : areaId // ignore: cast_nullable_to_non_nullable
as String,transition: null == transition ? _self.transition : transition // ignore: cast_nullable_to_non_nullable
as GeofenceTransition,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GeofenceEvent].
extension GeofenceEventPatterns on GeofenceEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeofenceEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeofenceEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeofenceEvent value)  $default,){
final _that = this;
switch (_that) {
case _GeofenceEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeofenceEvent value)?  $default,){
final _that = this;
switch (_that) {
case _GeofenceEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String areaId,  GeofenceTransition transition,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeofenceEvent() when $default != null:
return $default(_that.areaId,_that.transition,_that.timestamp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String areaId,  GeofenceTransition transition,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _GeofenceEvent():
return $default(_that.areaId,_that.transition,_that.timestamp);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String areaId,  GeofenceTransition transition,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _GeofenceEvent() when $default != null:
return $default(_that.areaId,_that.transition,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeofenceEvent implements GeofenceEvent {
  const _GeofenceEvent({required this.areaId, required this.transition, required this.timestamp});
  factory _GeofenceEvent.fromJson(Map<String, dynamic> json) => _$GeofenceEventFromJson(json);

@override final  String areaId;
@override final  GeofenceTransition transition;
@override final  DateTime timestamp;

/// Create a copy of GeofenceEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeofenceEventCopyWith<_GeofenceEvent> get copyWith => __$GeofenceEventCopyWithImpl<_GeofenceEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeofenceEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeofenceEvent&&(identical(other.areaId, areaId) || other.areaId == areaId)&&(identical(other.transition, transition) || other.transition == transition)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,areaId,transition,timestamp);

@override
String toString() {
  return 'GeofenceEvent(areaId: $areaId, transition: $transition, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$GeofenceEventCopyWith<$Res> implements $GeofenceEventCopyWith<$Res> {
  factory _$GeofenceEventCopyWith(_GeofenceEvent value, $Res Function(_GeofenceEvent) _then) = __$GeofenceEventCopyWithImpl;
@override @useResult
$Res call({
 String areaId, GeofenceTransition transition, DateTime timestamp
});




}
/// @nodoc
class __$GeofenceEventCopyWithImpl<$Res>
    implements _$GeofenceEventCopyWith<$Res> {
  __$GeofenceEventCopyWithImpl(this._self, this._then);

  final _GeofenceEvent _self;
  final $Res Function(_GeofenceEvent) _then;

/// Create a copy of GeofenceEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? areaId = null,Object? transition = null,Object? timestamp = null,}) {
  return _then(_GeofenceEvent(
areaId: null == areaId ? _self.areaId : areaId // ignore: cast_nullable_to_non_nullable
as String,transition: null == transition ? _self.transition : transition // ignore: cast_nullable_to_non_nullable
as GeofenceTransition,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
