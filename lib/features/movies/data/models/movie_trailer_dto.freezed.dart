// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_trailer_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieTrailerDto {

 String get key; String get site; String get type;
/// Create a copy of MovieTrailerDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieTrailerDtoCopyWith<MovieTrailerDto> get copyWith => _$MovieTrailerDtoCopyWithImpl<MovieTrailerDto>(this as MovieTrailerDto, _$identity);

  /// Serializes this MovieTrailerDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieTrailerDto&&(identical(other.key, key) || other.key == key)&&(identical(other.site, site) || other.site == site)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,site,type);

@override
String toString() {
  return 'MovieTrailerDto(key: $key, site: $site, type: $type)';
}


}

/// @nodoc
abstract mixin class $MovieTrailerDtoCopyWith<$Res>  {
  factory $MovieTrailerDtoCopyWith(MovieTrailerDto value, $Res Function(MovieTrailerDto) _then) = _$MovieTrailerDtoCopyWithImpl;
@useResult
$Res call({
 String key, String site, String type
});




}
/// @nodoc
class _$MovieTrailerDtoCopyWithImpl<$Res>
    implements $MovieTrailerDtoCopyWith<$Res> {
  _$MovieTrailerDtoCopyWithImpl(this._self, this._then);

  final MovieTrailerDto _self;
  final $Res Function(MovieTrailerDto) _then;

/// Create a copy of MovieTrailerDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? site = null,Object? type = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieTrailerDto].
extension MovieTrailerDtoPatterns on MovieTrailerDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieTrailerDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieTrailerDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieTrailerDto value)  $default,){
final _that = this;
switch (_that) {
case _MovieTrailerDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieTrailerDto value)?  $default,){
final _that = this;
switch (_that) {
case _MovieTrailerDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String site,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieTrailerDto() when $default != null:
return $default(_that.key,_that.site,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String site,  String type)  $default,) {final _that = this;
switch (_that) {
case _MovieTrailerDto():
return $default(_that.key,_that.site,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String site,  String type)?  $default,) {final _that = this;
switch (_that) {
case _MovieTrailerDto() when $default != null:
return $default(_that.key,_that.site,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MovieTrailerDto extends MovieTrailerDto {
  const _MovieTrailerDto({required this.key, required this.site, required this.type}): super._();
  factory _MovieTrailerDto.fromJson(Map<String, dynamic> json) => _$MovieTrailerDtoFromJson(json);

@override final  String key;
@override final  String site;
@override final  String type;

/// Create a copy of MovieTrailerDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieTrailerDtoCopyWith<_MovieTrailerDto> get copyWith => __$MovieTrailerDtoCopyWithImpl<_MovieTrailerDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MovieTrailerDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieTrailerDto&&(identical(other.key, key) || other.key == key)&&(identical(other.site, site) || other.site == site)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,site,type);

@override
String toString() {
  return 'MovieTrailerDto(key: $key, site: $site, type: $type)';
}


}

/// @nodoc
abstract mixin class _$MovieTrailerDtoCopyWith<$Res> implements $MovieTrailerDtoCopyWith<$Res> {
  factory _$MovieTrailerDtoCopyWith(_MovieTrailerDto value, $Res Function(_MovieTrailerDto) _then) = __$MovieTrailerDtoCopyWithImpl;
@override @useResult
$Res call({
 String key, String site, String type
});




}
/// @nodoc
class __$MovieTrailerDtoCopyWithImpl<$Res>
    implements _$MovieTrailerDtoCopyWith<$Res> {
  __$MovieTrailerDtoCopyWithImpl(this._self, this._then);

  final _MovieTrailerDto _self;
  final $Res Function(_MovieTrailerDto) _then;

/// Create a copy of MovieTrailerDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? site = null,Object? type = null,}) {
  return _then(_MovieTrailerDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
