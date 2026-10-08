// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watched_episode_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchedEpisodeDto {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'series_id') int get seriesId;@JsonKey(name: 'season_number') int get seasonNumber;@JsonKey(name: 'episode_number') int get episodeNumber;@JsonKey(name: 'watched_at') DateTime? get watchedAt;@JsonKey(name: 'runtime_minutes') int? get runtimeMinutes;
/// Create a copy of WatchedEpisodeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchedEpisodeDtoCopyWith<WatchedEpisodeDto> get copyWith => _$WatchedEpisodeDtoCopyWithImpl<WatchedEpisodeDto>(this as WatchedEpisodeDto, _$identity);

  /// Serializes this WatchedEpisodeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchedEpisodeDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt)&&(identical(other.runtimeMinutes, runtimeMinutes) || other.runtimeMinutes == runtimeMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,seriesId,seasonNumber,episodeNumber,watchedAt,runtimeMinutes);

@override
String toString() {
  return 'WatchedEpisodeDto(id: $id, userId: $userId, seriesId: $seriesId, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, watchedAt: $watchedAt, runtimeMinutes: $runtimeMinutes)';
}


}

/// @nodoc
abstract mixin class $WatchedEpisodeDtoCopyWith<$Res>  {
  factory $WatchedEpisodeDtoCopyWith(WatchedEpisodeDto value, $Res Function(WatchedEpisodeDto) _then) = _$WatchedEpisodeDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'series_id') int seriesId,@JsonKey(name: 'season_number') int seasonNumber,@JsonKey(name: 'episode_number') int episodeNumber,@JsonKey(name: 'watched_at') DateTime? watchedAt,@JsonKey(name: 'runtime_minutes') int? runtimeMinutes
});




}
/// @nodoc
class _$WatchedEpisodeDtoCopyWithImpl<$Res>
    implements $WatchedEpisodeDtoCopyWith<$Res> {
  _$WatchedEpisodeDtoCopyWithImpl(this._self, this._then);

  final WatchedEpisodeDto _self;
  final $Res Function(WatchedEpisodeDto) _then;

/// Create a copy of WatchedEpisodeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = null,Object? seriesId = null,Object? seasonNumber = null,Object? episodeNumber = null,Object? watchedAt = freezed,Object? runtimeMinutes = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,watchedAt: freezed == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,runtimeMinutes: freezed == runtimeMinutes ? _self.runtimeMinutes : runtimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchedEpisodeDto].
extension WatchedEpisodeDtoPatterns on WatchedEpisodeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchedEpisodeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchedEpisodeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchedEpisodeDto value)  $default,){
final _that = this;
switch (_that) {
case _WatchedEpisodeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchedEpisodeDto value)?  $default,){
final _that = this;
switch (_that) {
case _WatchedEpisodeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'series_id')  int seriesId, @JsonKey(name: 'season_number')  int seasonNumber, @JsonKey(name: 'episode_number')  int episodeNumber, @JsonKey(name: 'watched_at')  DateTime? watchedAt, @JsonKey(name: 'runtime_minutes')  int? runtimeMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchedEpisodeDto() when $default != null:
return $default(_that.id,_that.userId,_that.seriesId,_that.seasonNumber,_that.episodeNumber,_that.watchedAt,_that.runtimeMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'series_id')  int seriesId, @JsonKey(name: 'season_number')  int seasonNumber, @JsonKey(name: 'episode_number')  int episodeNumber, @JsonKey(name: 'watched_at')  DateTime? watchedAt, @JsonKey(name: 'runtime_minutes')  int? runtimeMinutes)  $default,) {final _that = this;
switch (_that) {
case _WatchedEpisodeDto():
return $default(_that.id,_that.userId,_that.seriesId,_that.seasonNumber,_that.episodeNumber,_that.watchedAt,_that.runtimeMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'series_id')  int seriesId, @JsonKey(name: 'season_number')  int seasonNumber, @JsonKey(name: 'episode_number')  int episodeNumber, @JsonKey(name: 'watched_at')  DateTime? watchedAt, @JsonKey(name: 'runtime_minutes')  int? runtimeMinutes)?  $default,) {final _that = this;
switch (_that) {
case _WatchedEpisodeDto() when $default != null:
return $default(_that.id,_that.userId,_that.seriesId,_that.seasonNumber,_that.episodeNumber,_that.watchedAt,_that.runtimeMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchedEpisodeDto extends WatchedEpisodeDto {
  const _WatchedEpisodeDto({@JsonKey(name: 'id') this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'series_id') required this.seriesId, @JsonKey(name: 'season_number') required this.seasonNumber, @JsonKey(name: 'episode_number') required this.episodeNumber, @JsonKey(name: 'watched_at') this.watchedAt, @JsonKey(name: 'runtime_minutes') this.runtimeMinutes}): super._();
  factory _WatchedEpisodeDto.fromJson(Map<String, dynamic> json) => _$WatchedEpisodeDtoFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'series_id') final  int seriesId;
@override@JsonKey(name: 'season_number') final  int seasonNumber;
@override@JsonKey(name: 'episode_number') final  int episodeNumber;
@override@JsonKey(name: 'watched_at') final  DateTime? watchedAt;
@override@JsonKey(name: 'runtime_minutes') final  int? runtimeMinutes;

/// Create a copy of WatchedEpisodeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchedEpisodeDtoCopyWith<_WatchedEpisodeDto> get copyWith => __$WatchedEpisodeDtoCopyWithImpl<_WatchedEpisodeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchedEpisodeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchedEpisodeDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt)&&(identical(other.runtimeMinutes, runtimeMinutes) || other.runtimeMinutes == runtimeMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,seriesId,seasonNumber,episodeNumber,watchedAt,runtimeMinutes);

@override
String toString() {
  return 'WatchedEpisodeDto(id: $id, userId: $userId, seriesId: $seriesId, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, watchedAt: $watchedAt, runtimeMinutes: $runtimeMinutes)';
}


}

/// @nodoc
abstract mixin class _$WatchedEpisodeDtoCopyWith<$Res> implements $WatchedEpisodeDtoCopyWith<$Res> {
  factory _$WatchedEpisodeDtoCopyWith(_WatchedEpisodeDto value, $Res Function(_WatchedEpisodeDto) _then) = __$WatchedEpisodeDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'series_id') int seriesId,@JsonKey(name: 'season_number') int seasonNumber,@JsonKey(name: 'episode_number') int episodeNumber,@JsonKey(name: 'watched_at') DateTime? watchedAt,@JsonKey(name: 'runtime_minutes') int? runtimeMinutes
});




}
/// @nodoc
class __$WatchedEpisodeDtoCopyWithImpl<$Res>
    implements _$WatchedEpisodeDtoCopyWith<$Res> {
  __$WatchedEpisodeDtoCopyWithImpl(this._self, this._then);

  final _WatchedEpisodeDto _self;
  final $Res Function(_WatchedEpisodeDto) _then;

/// Create a copy of WatchedEpisodeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = null,Object? seriesId = null,Object? seasonNumber = null,Object? episodeNumber = null,Object? watchedAt = freezed,Object? runtimeMinutes = freezed,}) {
  return _then(_WatchedEpisodeDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,watchedAt: freezed == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,runtimeMinutes: freezed == runtimeMinutes ? _self.runtimeMinutes : runtimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
