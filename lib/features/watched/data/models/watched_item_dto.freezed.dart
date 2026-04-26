// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watched_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchedItemDto {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'media_id') int get mediaId;@JsonKey(name: 'media_title') String get mediaTitle;@JsonKey(name: 'media_type') String get mediaType;@JsonKey(name: 'poster_path') String? get posterPath;@JsonKey(name: 'watched_at') DateTime? get watchedAt;@JsonKey(name: 'runtime_minutes') int? get runtimeMinutes;
/// Create a copy of WatchedItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchedItemDtoCopyWith<WatchedItemDto> get copyWith => _$WatchedItemDtoCopyWithImpl<WatchedItemDto>(this as WatchedItemDto, _$identity);

  /// Serializes this WatchedItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchedItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.mediaTitle, mediaTitle) || other.mediaTitle == mediaTitle)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt)&&(identical(other.runtimeMinutes, runtimeMinutes) || other.runtimeMinutes == runtimeMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mediaId,mediaTitle,mediaType,posterPath,watchedAt,runtimeMinutes);

@override
String toString() {
  return 'WatchedItemDto(id: $id, userId: $userId, mediaId: $mediaId, mediaTitle: $mediaTitle, mediaType: $mediaType, posterPath: $posterPath, watchedAt: $watchedAt, runtimeMinutes: $runtimeMinutes)';
}


}

/// @nodoc
abstract mixin class $WatchedItemDtoCopyWith<$Res>  {
  factory $WatchedItemDtoCopyWith(WatchedItemDto value, $Res Function(WatchedItemDto) _then) = _$WatchedItemDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'media_id') int mediaId,@JsonKey(name: 'media_title') String mediaTitle,@JsonKey(name: 'media_type') String mediaType,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'watched_at') DateTime? watchedAt,@JsonKey(name: 'runtime_minutes') int? runtimeMinutes
});




}
/// @nodoc
class _$WatchedItemDtoCopyWithImpl<$Res>
    implements $WatchedItemDtoCopyWith<$Res> {
  _$WatchedItemDtoCopyWithImpl(this._self, this._then);

  final WatchedItemDto _self;
  final $Res Function(WatchedItemDto) _then;

/// Create a copy of WatchedItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? mediaId = null,Object? mediaTitle = null,Object? mediaType = null,Object? posterPath = freezed,Object? watchedAt = freezed,Object? runtimeMinutes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,mediaTitle: null == mediaTitle ? _self.mediaTitle : mediaTitle // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,watchedAt: freezed == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,runtimeMinutes: freezed == runtimeMinutes ? _self.runtimeMinutes : runtimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchedItemDto].
extension WatchedItemDtoPatterns on WatchedItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchedItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchedItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchedItemDto value)  $default,){
final _that = this;
switch (_that) {
case _WatchedItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchedItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _WatchedItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'media_id')  int mediaId, @JsonKey(name: 'media_title')  String mediaTitle, @JsonKey(name: 'media_type')  String mediaType, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'watched_at')  DateTime? watchedAt, @JsonKey(name: 'runtime_minutes')  int? runtimeMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchedItemDto() when $default != null:
return $default(_that.id,_that.userId,_that.mediaId,_that.mediaTitle,_that.mediaType,_that.posterPath,_that.watchedAt,_that.runtimeMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'media_id')  int mediaId, @JsonKey(name: 'media_title')  String mediaTitle, @JsonKey(name: 'media_type')  String mediaType, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'watched_at')  DateTime? watchedAt, @JsonKey(name: 'runtime_minutes')  int? runtimeMinutes)  $default,) {final _that = this;
switch (_that) {
case _WatchedItemDto():
return $default(_that.id,_that.userId,_that.mediaId,_that.mediaTitle,_that.mediaType,_that.posterPath,_that.watchedAt,_that.runtimeMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'media_id')  int mediaId, @JsonKey(name: 'media_title')  String mediaTitle, @JsonKey(name: 'media_type')  String mediaType, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'watched_at')  DateTime? watchedAt, @JsonKey(name: 'runtime_minutes')  int? runtimeMinutes)?  $default,) {final _that = this;
switch (_that) {
case _WatchedItemDto() when $default != null:
return $default(_that.id,_that.userId,_that.mediaId,_that.mediaTitle,_that.mediaType,_that.posterPath,_that.watchedAt,_that.runtimeMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchedItemDto extends WatchedItemDto {
  const _WatchedItemDto({@JsonKey(name: 'id') this.id = '', @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'media_id') required this.mediaId, @JsonKey(name: 'media_title') required this.mediaTitle, @JsonKey(name: 'media_type') required this.mediaType, @JsonKey(name: 'poster_path') this.posterPath, @JsonKey(name: 'watched_at') this.watchedAt, @JsonKey(name: 'runtime_minutes') this.runtimeMinutes}): super._();
  factory _WatchedItemDto.fromJson(Map<String, dynamic> json) => _$WatchedItemDtoFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'media_id') final  int mediaId;
@override@JsonKey(name: 'media_title') final  String mediaTitle;
@override@JsonKey(name: 'media_type') final  String mediaType;
@override@JsonKey(name: 'poster_path') final  String? posterPath;
@override@JsonKey(name: 'watched_at') final  DateTime? watchedAt;
@override@JsonKey(name: 'runtime_minutes') final  int? runtimeMinutes;

/// Create a copy of WatchedItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchedItemDtoCopyWith<_WatchedItemDto> get copyWith => __$WatchedItemDtoCopyWithImpl<_WatchedItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchedItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchedItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.mediaTitle, mediaTitle) || other.mediaTitle == mediaTitle)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt)&&(identical(other.runtimeMinutes, runtimeMinutes) || other.runtimeMinutes == runtimeMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mediaId,mediaTitle,mediaType,posterPath,watchedAt,runtimeMinutes);

@override
String toString() {
  return 'WatchedItemDto(id: $id, userId: $userId, mediaId: $mediaId, mediaTitle: $mediaTitle, mediaType: $mediaType, posterPath: $posterPath, watchedAt: $watchedAt, runtimeMinutes: $runtimeMinutes)';
}


}

/// @nodoc
abstract mixin class _$WatchedItemDtoCopyWith<$Res> implements $WatchedItemDtoCopyWith<$Res> {
  factory _$WatchedItemDtoCopyWith(_WatchedItemDto value, $Res Function(_WatchedItemDto) _then) = __$WatchedItemDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'media_id') int mediaId,@JsonKey(name: 'media_title') String mediaTitle,@JsonKey(name: 'media_type') String mediaType,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'watched_at') DateTime? watchedAt,@JsonKey(name: 'runtime_minutes') int? runtimeMinutes
});




}
/// @nodoc
class __$WatchedItemDtoCopyWithImpl<$Res>
    implements _$WatchedItemDtoCopyWith<$Res> {
  __$WatchedItemDtoCopyWithImpl(this._self, this._then);

  final _WatchedItemDto _self;
  final $Res Function(_WatchedItemDto) _then;

/// Create a copy of WatchedItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? mediaId = null,Object? mediaTitle = null,Object? mediaType = null,Object? posterPath = freezed,Object? watchedAt = freezed,Object? runtimeMinutes = freezed,}) {
  return _then(_WatchedItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,mediaTitle: null == mediaTitle ? _self.mediaTitle : mediaTitle // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,watchedAt: freezed == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,runtimeMinutes: freezed == runtimeMinutes ? _self.runtimeMinutes : runtimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
