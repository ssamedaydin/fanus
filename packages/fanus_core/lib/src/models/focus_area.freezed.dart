// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_area.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FocusArea {

 String get id; String get name; double get latitude; double get longitude; double get radiusMeters;
/// Create a copy of FocusArea
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FocusAreaCopyWith<FocusArea> get copyWith => _$FocusAreaCopyWithImpl<FocusArea>(this as FocusArea, _$identity);

  /// Serializes this FocusArea to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FocusArea&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,latitude,longitude,radiusMeters);

@override
String toString() {
  return 'FocusArea(id: $id, name: $name, latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters)';
}


}

/// @nodoc
abstract mixin class $FocusAreaCopyWith<$Res>  {
  factory $FocusAreaCopyWith(FocusArea value, $Res Function(FocusArea) _then) = _$FocusAreaCopyWithImpl;
@useResult
$Res call({
 String id, String name, double latitude, double longitude, double radiusMeters
});




}
/// @nodoc
class _$FocusAreaCopyWithImpl<$Res>
    implements $FocusAreaCopyWith<$Res> {
  _$FocusAreaCopyWithImpl(this._self, this._then);

  final FocusArea _self;
  final $Res Function(FocusArea) _then;

/// Create a copy of FocusArea
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? radiusMeters = null,}) {
  return _then(FocusArea(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FocusArea].
extension FocusAreaPatterns on FocusArea {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FocusArea value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FocusArea() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FocusArea value)  $default,){
final _that = this;
switch (_that) {
case _FocusArea():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FocusArea value)?  $default,){
final _that = this;
switch (_that) {
case _FocusArea() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double latitude,  double longitude,  double radiusMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FocusArea() when $default != null:
return $default(_that.id,_that.name,_that.latitude,_that.longitude,_that.radiusMeters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double latitude,  double longitude,  double radiusMeters)  $default,) {final _that = this;
switch (_that) {
case _FocusArea():
return $default(_that.id,_that.name,_that.latitude,_that.longitude,_that.radiusMeters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double latitude,  double longitude,  double radiusMeters)?  $default,) {final _that = this;
switch (_that) {
case _FocusArea() when $default != null:
return $default(_that.id,_that.name,_that.latitude,_that.longitude,_that.radiusMeters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FocusArea implements FocusArea {
  const _FocusArea({required this.id, required this.name, required this.latitude, required this.longitude, required this.radiusMeters});
  factory _FocusArea.fromJson(Map<String, dynamic> json) => _$FocusAreaFromJson(json);

@override final  String id;
@override final  String name;
@override final  double latitude;
@override final  double longitude;
@override final  double radiusMeters;

/// Create a copy of FocusArea
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FocusAreaCopyWith<_FocusArea> get copyWith => __$FocusAreaCopyWithImpl<_FocusArea>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FocusAreaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FocusArea&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,latitude,longitude,radiusMeters);

@override
String toString() {
  return 'FocusArea(id: $id, name: $name, latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters)';
}


}

/// @nodoc
abstract mixin class _$FocusAreaCopyWith<$Res> implements $FocusAreaCopyWith<$Res> {
  factory _$FocusAreaCopyWith(_FocusArea value, $Res Function(_FocusArea) _then) = __$FocusAreaCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double latitude, double longitude, double radiusMeters
});




}
/// @nodoc
class __$FocusAreaCopyWithImpl<$Res>
    implements _$FocusAreaCopyWith<$Res> {
  __$FocusAreaCopyWithImpl(this._self, this._then);

  final _FocusArea _self;
  final $Res Function(_FocusArea) _then;

/// Create a copy of FocusArea
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? radiusMeters = null,}) {
  return _then(_FocusArea(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
