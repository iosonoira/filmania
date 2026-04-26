// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watchlist_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchlistItemDto {

 String get id;@JsonKey(name: 'watchlist_id') String get watchlistId;@JsonKey(name: 'media_id') int get mediaId;@JsonKey(name: 'media_title') String get title;@JsonKey(name: 'media_type') MediaType get mediaType;@JsonKey(name: 'poster_path') String? get posterPath;@JsonKey(name: 'added_at') DateTime get addedAt;
/// Create a copy of WatchlistItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistItemDtoCopyWith<WatchlistItemDto> get copyWith => _$WatchlistItemDtoCopyWithImpl<WatchlistItemDto>(this as WatchlistItemDto, _$identity);

  /// Serializes this WatchlistItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchlistItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.watchlistId, watchlistId) || other.watchlistId == watchlistId)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.title, title) || other.title == title)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,watchlistId,mediaId,title,mediaType,posterPath,addedAt);

@override
String toString() {
  return 'WatchlistItemDto(id: $id, watchlistId: $watchlistId, mediaId: $mediaId, title: $title, mediaType: $mediaType, posterPath: $posterPath, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class $WatchlistItemDtoCopyWith<$Res>  {
  factory $WatchlistItemDtoCopyWith(WatchlistItemDto value, $Res Function(WatchlistItemDto) _then) = _$WatchlistItemDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'watchlist_id') String watchlistId,@JsonKey(name: 'media_id') int mediaId,@JsonKey(name: 'media_title') String title,@JsonKey(name: 'media_type') MediaType mediaType,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'added_at') DateTime addedAt
});




}
/// @nodoc
class _$WatchlistItemDtoCopyWithImpl<$Res>
    implements $WatchlistItemDtoCopyWith<$Res> {
  _$WatchlistItemDtoCopyWithImpl(this._self, this._then);

  final WatchlistItemDto _self;
  final $Res Function(WatchlistItemDto) _then;

/// Create a copy of WatchlistItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? watchlistId = null,Object? mediaId = null,Object? title = null,Object? mediaType = null,Object? posterPath = freezed,Object? addedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,watchlistId: null == watchlistId ? _self.watchlistId : watchlistId // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchlistItemDto].
extension WatchlistItemDtoPatterns on WatchlistItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchlistItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchlistItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchlistItemDto value)  $default,){
final _that = this;
switch (_that) {
case _WatchlistItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchlistItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _WatchlistItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'watchlist_id')  String watchlistId, @JsonKey(name: 'media_id')  int mediaId, @JsonKey(name: 'media_title')  String title, @JsonKey(name: 'media_type')  MediaType mediaType, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'added_at')  DateTime addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchlistItemDto() when $default != null:
return $default(_that.id,_that.watchlistId,_that.mediaId,_that.title,_that.mediaType,_that.posterPath,_that.addedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'watchlist_id')  String watchlistId, @JsonKey(name: 'media_id')  int mediaId, @JsonKey(name: 'media_title')  String title, @JsonKey(name: 'media_type')  MediaType mediaType, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'added_at')  DateTime addedAt)  $default,) {final _that = this;
switch (_that) {
case _WatchlistItemDto():
return $default(_that.id,_that.watchlistId,_that.mediaId,_that.title,_that.mediaType,_that.posterPath,_that.addedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'watchlist_id')  String watchlistId, @JsonKey(name: 'media_id')  int mediaId, @JsonKey(name: 'media_title')  String title, @JsonKey(name: 'media_type')  MediaType mediaType, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'added_at')  DateTime addedAt)?  $default,) {final _that = this;
switch (_that) {
case _WatchlistItemDto() when $default != null:
return $default(_that.id,_that.watchlistId,_that.mediaId,_that.title,_that.mediaType,_that.posterPath,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchlistItemDto extends WatchlistItemDto {
  const _WatchlistItemDto({required this.id, @JsonKey(name: 'watchlist_id') required this.watchlistId, @JsonKey(name: 'media_id') required this.mediaId, @JsonKey(name: 'media_title') required this.title, @JsonKey(name: 'media_type') this.mediaType = MediaType.movie, @JsonKey(name: 'poster_path') required this.posterPath, @JsonKey(name: 'added_at') required this.addedAt}): super._();
  factory _WatchlistItemDto.fromJson(Map<String, dynamic> json) => _$WatchlistItemDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'watchlist_id') final  String watchlistId;
@override@JsonKey(name: 'media_id') final  int mediaId;
@override@JsonKey(name: 'media_title') final  String title;
@override@JsonKey(name: 'media_type') final  MediaType mediaType;
@override@JsonKey(name: 'poster_path') final  String? posterPath;
@override@JsonKey(name: 'added_at') final  DateTime addedAt;

/// Create a copy of WatchlistItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchlistItemDtoCopyWith<_WatchlistItemDto> get copyWith => __$WatchlistItemDtoCopyWithImpl<_WatchlistItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchlistItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchlistItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.watchlistId, watchlistId) || other.watchlistId == watchlistId)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.title, title) || other.title == title)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,watchlistId,mediaId,title,mediaType,posterPath,addedAt);

@override
String toString() {
  return 'WatchlistItemDto(id: $id, watchlistId: $watchlistId, mediaId: $mediaId, title: $title, mediaType: $mediaType, posterPath: $posterPath, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$WatchlistItemDtoCopyWith<$Res> implements $WatchlistItemDtoCopyWith<$Res> {
  factory _$WatchlistItemDtoCopyWith(_WatchlistItemDto value, $Res Function(_WatchlistItemDto) _then) = __$WatchlistItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'watchlist_id') String watchlistId,@JsonKey(name: 'media_id') int mediaId,@JsonKey(name: 'media_title') String title,@JsonKey(name: 'media_type') MediaType mediaType,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'added_at') DateTime addedAt
});




}
/// @nodoc
class __$WatchlistItemDtoCopyWithImpl<$Res>
    implements _$WatchlistItemDtoCopyWith<$Res> {
  __$WatchlistItemDtoCopyWithImpl(this._self, this._then);

  final _WatchlistItemDto _self;
  final $Res Function(_WatchlistItemDto) _then;

/// Create a copy of WatchlistItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? watchlistId = null,Object? mediaId = null,Object? title = null,Object? mediaType = null,Object? posterPath = freezed,Object? addedAt = null,}) {
  return _then(_WatchlistItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,watchlistId: null == watchlistId ? _self.watchlistId : watchlistId // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
