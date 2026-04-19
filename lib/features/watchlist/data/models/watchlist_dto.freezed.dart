// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watchlist_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchlistDto {

 String get id;@JsonKey(name: 'user_id') String get userId; String get name;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of WatchlistDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistDtoCopyWith<WatchlistDto> get copyWith => _$WatchlistDtoCopyWithImpl<WatchlistDto>(this as WatchlistDto, _$identity);

  /// Serializes this WatchlistDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,createdAt);

@override
String toString() {
  return 'WatchlistDto(id: $id, userId: $userId, name: $name, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WatchlistDtoCopyWith<$Res>  {
  factory $WatchlistDtoCopyWith(WatchlistDto value, $Res Function(WatchlistDto) _then) = _$WatchlistDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$WatchlistDtoCopyWithImpl<$Res>
    implements $WatchlistDtoCopyWith<$Res> {
  _$WatchlistDtoCopyWithImpl(this._self, this._then);

  final WatchlistDto _self;
  final $Res Function(WatchlistDto) _then;

/// Create a copy of WatchlistDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchlistDto].
extension WatchlistDtoPatterns on WatchlistDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchlistDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchlistDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchlistDto value)  $default,){
final _that = this;
switch (_that) {
case _WatchlistDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchlistDto value)?  $default,){
final _that = this;
switch (_that) {
case _WatchlistDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchlistDto() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WatchlistDto():
return $default(_that.id,_that.userId,_that.name,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WatchlistDto() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchlistDto extends WatchlistDto {
  const _WatchlistDto({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.name, @JsonKey(name: 'created_at') required this.createdAt}): super._();
  factory _WatchlistDto.fromJson(Map<String, dynamic> json) => _$WatchlistDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String name;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of WatchlistDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchlistDtoCopyWith<_WatchlistDto> get copyWith => __$WatchlistDtoCopyWithImpl<_WatchlistDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchlistDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchlistDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,createdAt);

@override
String toString() {
  return 'WatchlistDto(id: $id, userId: $userId, name: $name, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WatchlistDtoCopyWith<$Res> implements $WatchlistDtoCopyWith<$Res> {
  factory _$WatchlistDtoCopyWith(_WatchlistDto value, $Res Function(_WatchlistDto) _then) = __$WatchlistDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$WatchlistDtoCopyWithImpl<$Res>
    implements _$WatchlistDtoCopyWith<$Res> {
  __$WatchlistDtoCopyWithImpl(this._self, this._then);

  final _WatchlistDto _self;
  final $Res Function(_WatchlistDto) _then;

/// Create a copy of WatchlistDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? createdAt = null,}) {
  return _then(_WatchlistDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
