// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watched_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WatchedItem {

 String get id; String get userId; int get mediaId; String get mediaTitle; MediaType get mediaType; String? get posterPath; DateTime get watchedAt;
/// Create a copy of WatchedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchedItemCopyWith<WatchedItem> get copyWith => _$WatchedItemCopyWithImpl<WatchedItem>(this as WatchedItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.mediaTitle, mediaTitle) || other.mediaTitle == mediaTitle)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,mediaId,mediaTitle,mediaType,posterPath,watchedAt);

@override
String toString() {
  return 'WatchedItem(id: $id, userId: $userId, mediaId: $mediaId, mediaTitle: $mediaTitle, mediaType: $mediaType, posterPath: $posterPath, watchedAt: $watchedAt)';
}


}

/// @nodoc
abstract mixin class $WatchedItemCopyWith<$Res>  {
  factory $WatchedItemCopyWith(WatchedItem value, $Res Function(WatchedItem) _then) = _$WatchedItemCopyWithImpl;
@useResult
$Res call({
 String id, String userId, int mediaId, String mediaTitle, MediaType mediaType, String? posterPath, DateTime watchedAt
});




}
/// @nodoc
class _$WatchedItemCopyWithImpl<$Res>
    implements $WatchedItemCopyWith<$Res> {
  _$WatchedItemCopyWithImpl(this._self, this._then);

  final WatchedItem _self;
  final $Res Function(WatchedItem) _then;

/// Create a copy of WatchedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? mediaId = null,Object? mediaTitle = null,Object? mediaType = null,Object? posterPath = freezed,Object? watchedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,mediaTitle: null == mediaTitle ? _self.mediaTitle : mediaTitle // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,watchedAt: null == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchedItem].
extension WatchedItemPatterns on WatchedItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchedItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchedItem value)  $default,){
final _that = this;
switch (_that) {
case _WatchedItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchedItem value)?  $default,){
final _that = this;
switch (_that) {
case _WatchedItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  int mediaId,  String mediaTitle,  MediaType mediaType,  String? posterPath,  DateTime watchedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchedItem() when $default != null:
return $default(_that.id,_that.userId,_that.mediaId,_that.mediaTitle,_that.mediaType,_that.posterPath,_that.watchedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  int mediaId,  String mediaTitle,  MediaType mediaType,  String? posterPath,  DateTime watchedAt)  $default,) {final _that = this;
switch (_that) {
case _WatchedItem():
return $default(_that.id,_that.userId,_that.mediaId,_that.mediaTitle,_that.mediaType,_that.posterPath,_that.watchedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  int mediaId,  String mediaTitle,  MediaType mediaType,  String? posterPath,  DateTime watchedAt)?  $default,) {final _that = this;
switch (_that) {
case _WatchedItem() when $default != null:
return $default(_that.id,_that.userId,_that.mediaId,_that.mediaTitle,_that.mediaType,_that.posterPath,_that.watchedAt);case _:
  return null;

}
}

}

/// @nodoc


class _WatchedItem implements WatchedItem {
  const _WatchedItem({required this.id, required this.userId, required this.mediaId, required this.mediaTitle, required this.mediaType, this.posterPath, required this.watchedAt});
  

@override final  String id;
@override final  String userId;
@override final  int mediaId;
@override final  String mediaTitle;
@override final  MediaType mediaType;
@override final  String? posterPath;
@override final  DateTime watchedAt;

/// Create a copy of WatchedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchedItemCopyWith<_WatchedItem> get copyWith => __$WatchedItemCopyWithImpl<_WatchedItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.mediaTitle, mediaTitle) || other.mediaTitle == mediaTitle)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,mediaId,mediaTitle,mediaType,posterPath,watchedAt);

@override
String toString() {
  return 'WatchedItem(id: $id, userId: $userId, mediaId: $mediaId, mediaTitle: $mediaTitle, mediaType: $mediaType, posterPath: $posterPath, watchedAt: $watchedAt)';
}


}

/// @nodoc
abstract mixin class _$WatchedItemCopyWith<$Res> implements $WatchedItemCopyWith<$Res> {
  factory _$WatchedItemCopyWith(_WatchedItem value, $Res Function(_WatchedItem) _then) = __$WatchedItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, int mediaId, String mediaTitle, MediaType mediaType, String? posterPath, DateTime watchedAt
});




}
/// @nodoc
class __$WatchedItemCopyWithImpl<$Res>
    implements _$WatchedItemCopyWith<$Res> {
  __$WatchedItemCopyWithImpl(this._self, this._then);

  final _WatchedItem _self;
  final $Res Function(_WatchedItem) _then;

/// Create a copy of WatchedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? mediaId = null,Object? mediaTitle = null,Object? mediaType = null,Object? posterPath = freezed,Object? watchedAt = null,}) {
  return _then(_WatchedItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,mediaTitle: null == mediaTitle ? _self.mediaTitle : mediaTitle // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,watchedAt: null == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
