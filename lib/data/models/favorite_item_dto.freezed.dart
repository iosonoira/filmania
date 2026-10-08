// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoriteItemDto {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'media_id') int get mediaId;@JsonKey(name: 'media_title') String get mediaTitle;@JsonKey(name: 'media_type') String get mediaType;@JsonKey(name: 'poster_path') String? get posterPath;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of FavoriteItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteItemDtoCopyWith<FavoriteItemDto> get copyWith => _$FavoriteItemDtoCopyWithImpl<FavoriteItemDto>(this as FavoriteItemDto, _$identity);

  /// Serializes this FavoriteItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.mediaTitle, mediaTitle) || other.mediaTitle == mediaTitle)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mediaId,mediaTitle,mediaType,posterPath,createdAt);

@override
String toString() {
  return 'FavoriteItemDto(id: $id, userId: $userId, mediaId: $mediaId, mediaTitle: $mediaTitle, mediaType: $mediaType, posterPath: $posterPath, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FavoriteItemDtoCopyWith<$Res>  {
  factory $FavoriteItemDtoCopyWith(FavoriteItemDto value, $Res Function(FavoriteItemDto) _then) = _$FavoriteItemDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'media_id') int mediaId,@JsonKey(name: 'media_title') String mediaTitle,@JsonKey(name: 'media_type') String mediaType,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$FavoriteItemDtoCopyWithImpl<$Res>
    implements $FavoriteItemDtoCopyWith<$Res> {
  _$FavoriteItemDtoCopyWithImpl(this._self, this._then);

  final FavoriteItemDto _self;
  final $Res Function(FavoriteItemDto) _then;

/// Create a copy of FavoriteItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? mediaId = null,Object? mediaTitle = null,Object? mediaType = null,Object? posterPath = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,mediaTitle: null == mediaTitle ? _self.mediaTitle : mediaTitle // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoriteItemDto].
extension FavoriteItemDtoPatterns on FavoriteItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteItemDto value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'media_id')  int mediaId, @JsonKey(name: 'media_title')  String mediaTitle, @JsonKey(name: 'media_type')  String mediaType, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteItemDto() when $default != null:
return $default(_that.id,_that.userId,_that.mediaId,_that.mediaTitle,_that.mediaType,_that.posterPath,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'media_id')  int mediaId, @JsonKey(name: 'media_title')  String mediaTitle, @JsonKey(name: 'media_type')  String mediaType, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _FavoriteItemDto():
return $default(_that.id,_that.userId,_that.mediaId,_that.mediaTitle,_that.mediaType,_that.posterPath,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'media_id')  int mediaId, @JsonKey(name: 'media_title')  String mediaTitle, @JsonKey(name: 'media_type')  String mediaType, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteItemDto() when $default != null:
return $default(_that.id,_that.userId,_that.mediaId,_that.mediaTitle,_that.mediaType,_that.posterPath,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavoriteItemDto extends FavoriteItemDto {
  const _FavoriteItemDto({@JsonKey(name: 'id') this.id = '', @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'media_id') required this.mediaId, @JsonKey(name: 'media_title') required this.mediaTitle, @JsonKey(name: 'media_type') required this.mediaType, @JsonKey(name: 'poster_path') this.posterPath, @JsonKey(name: 'created_at') this.createdAt}): super._();
  factory _FavoriteItemDto.fromJson(Map<String, dynamic> json) => _$FavoriteItemDtoFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'media_id') final  int mediaId;
@override@JsonKey(name: 'media_title') final  String mediaTitle;
@override@JsonKey(name: 'media_type') final  String mediaType;
@override@JsonKey(name: 'poster_path') final  String? posterPath;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of FavoriteItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteItemDtoCopyWith<_FavoriteItemDto> get copyWith => __$FavoriteItemDtoCopyWithImpl<_FavoriteItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.mediaTitle, mediaTitle) || other.mediaTitle == mediaTitle)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,mediaId,mediaTitle,mediaType,posterPath,createdAt);

@override
String toString() {
  return 'FavoriteItemDto(id: $id, userId: $userId, mediaId: $mediaId, mediaTitle: $mediaTitle, mediaType: $mediaType, posterPath: $posterPath, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FavoriteItemDtoCopyWith<$Res> implements $FavoriteItemDtoCopyWith<$Res> {
  factory _$FavoriteItemDtoCopyWith(_FavoriteItemDto value, $Res Function(_FavoriteItemDto) _then) = __$FavoriteItemDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'media_id') int mediaId,@JsonKey(name: 'media_title') String mediaTitle,@JsonKey(name: 'media_type') String mediaType,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$FavoriteItemDtoCopyWithImpl<$Res>
    implements _$FavoriteItemDtoCopyWith<$Res> {
  __$FavoriteItemDtoCopyWithImpl(this._self, this._then);

  final _FavoriteItemDto _self;
  final $Res Function(_FavoriteItemDto) _then;

/// Create a copy of FavoriteItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? mediaId = null,Object? mediaTitle = null,Object? mediaType = null,Object? posterPath = freezed,Object? createdAt = freezed,}) {
  return _then(_FavoriteItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,mediaTitle: null == mediaTitle ? _self.mediaTitle : mediaTitle // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
