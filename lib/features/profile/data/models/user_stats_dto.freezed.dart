// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserStatsDto {

@JsonKey(name: 'movies_watched_count') int get moviesWatchedCount;@JsonKey(name: 'tv_series_watched_count') int get tvSeriesWatchedCount;@JsonKey(name: 'episodes_watched_count') int get episodesWatchedCount;@JsonKey(name: 'total_watch_time_minutes') int get totalWatchTimeMinutes;@JsonKey(name: 'movies_watch_time_minutes') int get moviesWatchTimeMinutes;@JsonKey(name: 'tv_watch_time_minutes') int get tvWatchTimeMinutes;@JsonKey(name: 'last_updated_at') DateTime? get lastUpdatedAt;
/// Create a copy of UserStatsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStatsDtoCopyWith<UserStatsDto> get copyWith => _$UserStatsDtoCopyWithImpl<UserStatsDto>(this as UserStatsDto, _$identity);

  /// Serializes this UserStatsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStatsDto&&(identical(other.moviesWatchedCount, moviesWatchedCount) || other.moviesWatchedCount == moviesWatchedCount)&&(identical(other.tvSeriesWatchedCount, tvSeriesWatchedCount) || other.tvSeriesWatchedCount == tvSeriesWatchedCount)&&(identical(other.episodesWatchedCount, episodesWatchedCount) || other.episodesWatchedCount == episodesWatchedCount)&&(identical(other.totalWatchTimeMinutes, totalWatchTimeMinutes) || other.totalWatchTimeMinutes == totalWatchTimeMinutes)&&(identical(other.moviesWatchTimeMinutes, moviesWatchTimeMinutes) || other.moviesWatchTimeMinutes == moviesWatchTimeMinutes)&&(identical(other.tvWatchTimeMinutes, tvWatchTimeMinutes) || other.tvWatchTimeMinutes == tvWatchTimeMinutes)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,moviesWatchedCount,tvSeriesWatchedCount,episodesWatchedCount,totalWatchTimeMinutes,moviesWatchTimeMinutes,tvWatchTimeMinutes,lastUpdatedAt);

@override
String toString() {
  return 'UserStatsDto(moviesWatchedCount: $moviesWatchedCount, tvSeriesWatchedCount: $tvSeriesWatchedCount, episodesWatchedCount: $episodesWatchedCount, totalWatchTimeMinutes: $totalWatchTimeMinutes, moviesWatchTimeMinutes: $moviesWatchTimeMinutes, tvWatchTimeMinutes: $tvWatchTimeMinutes, lastUpdatedAt: $lastUpdatedAt)';
}


}

/// @nodoc
abstract mixin class $UserStatsDtoCopyWith<$Res>  {
  factory $UserStatsDtoCopyWith(UserStatsDto value, $Res Function(UserStatsDto) _then) = _$UserStatsDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'movies_watched_count') int moviesWatchedCount,@JsonKey(name: 'tv_series_watched_count') int tvSeriesWatchedCount,@JsonKey(name: 'episodes_watched_count') int episodesWatchedCount,@JsonKey(name: 'total_watch_time_minutes') int totalWatchTimeMinutes,@JsonKey(name: 'movies_watch_time_minutes') int moviesWatchTimeMinutes,@JsonKey(name: 'tv_watch_time_minutes') int tvWatchTimeMinutes,@JsonKey(name: 'last_updated_at') DateTime? lastUpdatedAt
});




}
/// @nodoc
class _$UserStatsDtoCopyWithImpl<$Res>
    implements $UserStatsDtoCopyWith<$Res> {
  _$UserStatsDtoCopyWithImpl(this._self, this._then);

  final UserStatsDto _self;
  final $Res Function(UserStatsDto) _then;

/// Create a copy of UserStatsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? moviesWatchedCount = null,Object? tvSeriesWatchedCount = null,Object? episodesWatchedCount = null,Object? totalWatchTimeMinutes = null,Object? moviesWatchTimeMinutes = null,Object? tvWatchTimeMinutes = null,Object? lastUpdatedAt = freezed,}) {
  return _then(_self.copyWith(
moviesWatchedCount: null == moviesWatchedCount ? _self.moviesWatchedCount : moviesWatchedCount // ignore: cast_nullable_to_non_nullable
as int,tvSeriesWatchedCount: null == tvSeriesWatchedCount ? _self.tvSeriesWatchedCount : tvSeriesWatchedCount // ignore: cast_nullable_to_non_nullable
as int,episodesWatchedCount: null == episodesWatchedCount ? _self.episodesWatchedCount : episodesWatchedCount // ignore: cast_nullable_to_non_nullable
as int,totalWatchTimeMinutes: null == totalWatchTimeMinutes ? _self.totalWatchTimeMinutes : totalWatchTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,moviesWatchTimeMinutes: null == moviesWatchTimeMinutes ? _self.moviesWatchTimeMinutes : moviesWatchTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,tvWatchTimeMinutes: null == tvWatchTimeMinutes ? _self.tvWatchTimeMinutes : tvWatchTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,lastUpdatedAt: freezed == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserStatsDto].
extension UserStatsDtoPatterns on UserStatsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStatsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStatsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStatsDto value)  $default,){
final _that = this;
switch (_that) {
case _UserStatsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStatsDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserStatsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'movies_watched_count')  int moviesWatchedCount, @JsonKey(name: 'tv_series_watched_count')  int tvSeriesWatchedCount, @JsonKey(name: 'episodes_watched_count')  int episodesWatchedCount, @JsonKey(name: 'total_watch_time_minutes')  int totalWatchTimeMinutes, @JsonKey(name: 'movies_watch_time_minutes')  int moviesWatchTimeMinutes, @JsonKey(name: 'tv_watch_time_minutes')  int tvWatchTimeMinutes, @JsonKey(name: 'last_updated_at')  DateTime? lastUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStatsDto() when $default != null:
return $default(_that.moviesWatchedCount,_that.tvSeriesWatchedCount,_that.episodesWatchedCount,_that.totalWatchTimeMinutes,_that.moviesWatchTimeMinutes,_that.tvWatchTimeMinutes,_that.lastUpdatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'movies_watched_count')  int moviesWatchedCount, @JsonKey(name: 'tv_series_watched_count')  int tvSeriesWatchedCount, @JsonKey(name: 'episodes_watched_count')  int episodesWatchedCount, @JsonKey(name: 'total_watch_time_minutes')  int totalWatchTimeMinutes, @JsonKey(name: 'movies_watch_time_minutes')  int moviesWatchTimeMinutes, @JsonKey(name: 'tv_watch_time_minutes')  int tvWatchTimeMinutes, @JsonKey(name: 'last_updated_at')  DateTime? lastUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserStatsDto():
return $default(_that.moviesWatchedCount,_that.tvSeriesWatchedCount,_that.episodesWatchedCount,_that.totalWatchTimeMinutes,_that.moviesWatchTimeMinutes,_that.tvWatchTimeMinutes,_that.lastUpdatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'movies_watched_count')  int moviesWatchedCount, @JsonKey(name: 'tv_series_watched_count')  int tvSeriesWatchedCount, @JsonKey(name: 'episodes_watched_count')  int episodesWatchedCount, @JsonKey(name: 'total_watch_time_minutes')  int totalWatchTimeMinutes, @JsonKey(name: 'movies_watch_time_minutes')  int moviesWatchTimeMinutes, @JsonKey(name: 'tv_watch_time_minutes')  int tvWatchTimeMinutes, @JsonKey(name: 'last_updated_at')  DateTime? lastUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserStatsDto() when $default != null:
return $default(_that.moviesWatchedCount,_that.tvSeriesWatchedCount,_that.episodesWatchedCount,_that.totalWatchTimeMinutes,_that.moviesWatchTimeMinutes,_that.tvWatchTimeMinutes,_that.lastUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserStatsDto extends UserStatsDto {
  const _UserStatsDto({@JsonKey(name: 'movies_watched_count') required this.moviesWatchedCount, @JsonKey(name: 'tv_series_watched_count') required this.tvSeriesWatchedCount, @JsonKey(name: 'episodes_watched_count') required this.episodesWatchedCount, @JsonKey(name: 'total_watch_time_minutes') required this.totalWatchTimeMinutes, @JsonKey(name: 'movies_watch_time_minutes') required this.moviesWatchTimeMinutes, @JsonKey(name: 'tv_watch_time_minutes') required this.tvWatchTimeMinutes, @JsonKey(name: 'last_updated_at') this.lastUpdatedAt}): super._();
  factory _UserStatsDto.fromJson(Map<String, dynamic> json) => _$UserStatsDtoFromJson(json);

@override@JsonKey(name: 'movies_watched_count') final  int moviesWatchedCount;
@override@JsonKey(name: 'tv_series_watched_count') final  int tvSeriesWatchedCount;
@override@JsonKey(name: 'episodes_watched_count') final  int episodesWatchedCount;
@override@JsonKey(name: 'total_watch_time_minutes') final  int totalWatchTimeMinutes;
@override@JsonKey(name: 'movies_watch_time_minutes') final  int moviesWatchTimeMinutes;
@override@JsonKey(name: 'tv_watch_time_minutes') final  int tvWatchTimeMinutes;
@override@JsonKey(name: 'last_updated_at') final  DateTime? lastUpdatedAt;

/// Create a copy of UserStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStatsDtoCopyWith<_UserStatsDto> get copyWith => __$UserStatsDtoCopyWithImpl<_UserStatsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserStatsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStatsDto&&(identical(other.moviesWatchedCount, moviesWatchedCount) || other.moviesWatchedCount == moviesWatchedCount)&&(identical(other.tvSeriesWatchedCount, tvSeriesWatchedCount) || other.tvSeriesWatchedCount == tvSeriesWatchedCount)&&(identical(other.episodesWatchedCount, episodesWatchedCount) || other.episodesWatchedCount == episodesWatchedCount)&&(identical(other.totalWatchTimeMinutes, totalWatchTimeMinutes) || other.totalWatchTimeMinutes == totalWatchTimeMinutes)&&(identical(other.moviesWatchTimeMinutes, moviesWatchTimeMinutes) || other.moviesWatchTimeMinutes == moviesWatchTimeMinutes)&&(identical(other.tvWatchTimeMinutes, tvWatchTimeMinutes) || other.tvWatchTimeMinutes == tvWatchTimeMinutes)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,moviesWatchedCount,tvSeriesWatchedCount,episodesWatchedCount,totalWatchTimeMinutes,moviesWatchTimeMinutes,tvWatchTimeMinutes,lastUpdatedAt);

@override
String toString() {
  return 'UserStatsDto(moviesWatchedCount: $moviesWatchedCount, tvSeriesWatchedCount: $tvSeriesWatchedCount, episodesWatchedCount: $episodesWatchedCount, totalWatchTimeMinutes: $totalWatchTimeMinutes, moviesWatchTimeMinutes: $moviesWatchTimeMinutes, tvWatchTimeMinutes: $tvWatchTimeMinutes, lastUpdatedAt: $lastUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserStatsDtoCopyWith<$Res> implements $UserStatsDtoCopyWith<$Res> {
  factory _$UserStatsDtoCopyWith(_UserStatsDto value, $Res Function(_UserStatsDto) _then) = __$UserStatsDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'movies_watched_count') int moviesWatchedCount,@JsonKey(name: 'tv_series_watched_count') int tvSeriesWatchedCount,@JsonKey(name: 'episodes_watched_count') int episodesWatchedCount,@JsonKey(name: 'total_watch_time_minutes') int totalWatchTimeMinutes,@JsonKey(name: 'movies_watch_time_minutes') int moviesWatchTimeMinutes,@JsonKey(name: 'tv_watch_time_minutes') int tvWatchTimeMinutes,@JsonKey(name: 'last_updated_at') DateTime? lastUpdatedAt
});




}
/// @nodoc
class __$UserStatsDtoCopyWithImpl<$Res>
    implements _$UserStatsDtoCopyWith<$Res> {
  __$UserStatsDtoCopyWithImpl(this._self, this._then);

  final _UserStatsDto _self;
  final $Res Function(_UserStatsDto) _then;

/// Create a copy of UserStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? moviesWatchedCount = null,Object? tvSeriesWatchedCount = null,Object? episodesWatchedCount = null,Object? totalWatchTimeMinutes = null,Object? moviesWatchTimeMinutes = null,Object? tvWatchTimeMinutes = null,Object? lastUpdatedAt = freezed,}) {
  return _then(_UserStatsDto(
moviesWatchedCount: null == moviesWatchedCount ? _self.moviesWatchedCount : moviesWatchedCount // ignore: cast_nullable_to_non_nullable
as int,tvSeriesWatchedCount: null == tvSeriesWatchedCount ? _self.tvSeriesWatchedCount : tvSeriesWatchedCount // ignore: cast_nullable_to_non_nullable
as int,episodesWatchedCount: null == episodesWatchedCount ? _self.episodesWatchedCount : episodesWatchedCount // ignore: cast_nullable_to_non_nullable
as int,totalWatchTimeMinutes: null == totalWatchTimeMinutes ? _self.totalWatchTimeMinutes : totalWatchTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,moviesWatchTimeMinutes: null == moviesWatchTimeMinutes ? _self.moviesWatchTimeMinutes : moviesWatchTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,tvWatchTimeMinutes: null == tvWatchTimeMinutes ? _self.tvWatchTimeMinutes : tvWatchTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,lastUpdatedAt: freezed == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
