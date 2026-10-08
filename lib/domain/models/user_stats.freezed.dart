// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserStats {

 int get moviesWatchedCount; int get tvSeriesWatchedCount; int get episodesWatchedCount; int get totalWatchTimeMinutes; int get moviesWatchTimeMinutes; int get tvWatchTimeMinutes; DateTime? get lastUpdatedAt;
/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStatsCopyWith<UserStats> get copyWith => _$UserStatsCopyWithImpl<UserStats>(this as UserStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStats&&(identical(other.moviesWatchedCount, moviesWatchedCount) || other.moviesWatchedCount == moviesWatchedCount)&&(identical(other.tvSeriesWatchedCount, tvSeriesWatchedCount) || other.tvSeriesWatchedCount == tvSeriesWatchedCount)&&(identical(other.episodesWatchedCount, episodesWatchedCount) || other.episodesWatchedCount == episodesWatchedCount)&&(identical(other.totalWatchTimeMinutes, totalWatchTimeMinutes) || other.totalWatchTimeMinutes == totalWatchTimeMinutes)&&(identical(other.moviesWatchTimeMinutes, moviesWatchTimeMinutes) || other.moviesWatchTimeMinutes == moviesWatchTimeMinutes)&&(identical(other.tvWatchTimeMinutes, tvWatchTimeMinutes) || other.tvWatchTimeMinutes == tvWatchTimeMinutes)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,moviesWatchedCount,tvSeriesWatchedCount,episodesWatchedCount,totalWatchTimeMinutes,moviesWatchTimeMinutes,tvWatchTimeMinutes,lastUpdatedAt);

@override
String toString() {
  return 'UserStats(moviesWatchedCount: $moviesWatchedCount, tvSeriesWatchedCount: $tvSeriesWatchedCount, episodesWatchedCount: $episodesWatchedCount, totalWatchTimeMinutes: $totalWatchTimeMinutes, moviesWatchTimeMinutes: $moviesWatchTimeMinutes, tvWatchTimeMinutes: $tvWatchTimeMinutes, lastUpdatedAt: $lastUpdatedAt)';
}


}

/// @nodoc
abstract mixin class $UserStatsCopyWith<$Res>  {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) _then) = _$UserStatsCopyWithImpl;
@useResult
$Res call({
 int moviesWatchedCount, int tvSeriesWatchedCount, int episodesWatchedCount, int totalWatchTimeMinutes, int moviesWatchTimeMinutes, int tvWatchTimeMinutes, DateTime? lastUpdatedAt
});




}
/// @nodoc
class _$UserStatsCopyWithImpl<$Res>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._self, this._then);

  final UserStats _self;
  final $Res Function(UserStats) _then;

/// Create a copy of UserStats
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


/// Adds pattern-matching-related methods to [UserStats].
extension UserStatsPatterns on UserStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStats value)  $default,){
final _that = this;
switch (_that) {
case _UserStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStats value)?  $default,){
final _that = this;
switch (_that) {
case _UserStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int moviesWatchedCount,  int tvSeriesWatchedCount,  int episodesWatchedCount,  int totalWatchTimeMinutes,  int moviesWatchTimeMinutes,  int tvWatchTimeMinutes,  DateTime? lastUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStats() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int moviesWatchedCount,  int tvSeriesWatchedCount,  int episodesWatchedCount,  int totalWatchTimeMinutes,  int moviesWatchTimeMinutes,  int tvWatchTimeMinutes,  DateTime? lastUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserStats():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int moviesWatchedCount,  int tvSeriesWatchedCount,  int episodesWatchedCount,  int totalWatchTimeMinutes,  int moviesWatchTimeMinutes,  int tvWatchTimeMinutes,  DateTime? lastUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that.moviesWatchedCount,_that.tvSeriesWatchedCount,_that.episodesWatchedCount,_that.totalWatchTimeMinutes,_that.moviesWatchTimeMinutes,_that.tvWatchTimeMinutes,_that.lastUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _UserStats implements UserStats {
  const _UserStats({required this.moviesWatchedCount, required this.tvSeriesWatchedCount, required this.episodesWatchedCount, required this.totalWatchTimeMinutes, required this.moviesWatchTimeMinutes, required this.tvWatchTimeMinutes, required this.lastUpdatedAt});
  

@override final  int moviesWatchedCount;
@override final  int tvSeriesWatchedCount;
@override final  int episodesWatchedCount;
@override final  int totalWatchTimeMinutes;
@override final  int moviesWatchTimeMinutes;
@override final  int tvWatchTimeMinutes;
@override final  DateTime? lastUpdatedAt;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStatsCopyWith<_UserStats> get copyWith => __$UserStatsCopyWithImpl<_UserStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStats&&(identical(other.moviesWatchedCount, moviesWatchedCount) || other.moviesWatchedCount == moviesWatchedCount)&&(identical(other.tvSeriesWatchedCount, tvSeriesWatchedCount) || other.tvSeriesWatchedCount == tvSeriesWatchedCount)&&(identical(other.episodesWatchedCount, episodesWatchedCount) || other.episodesWatchedCount == episodesWatchedCount)&&(identical(other.totalWatchTimeMinutes, totalWatchTimeMinutes) || other.totalWatchTimeMinutes == totalWatchTimeMinutes)&&(identical(other.moviesWatchTimeMinutes, moviesWatchTimeMinutes) || other.moviesWatchTimeMinutes == moviesWatchTimeMinutes)&&(identical(other.tvWatchTimeMinutes, tvWatchTimeMinutes) || other.tvWatchTimeMinutes == tvWatchTimeMinutes)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,moviesWatchedCount,tvSeriesWatchedCount,episodesWatchedCount,totalWatchTimeMinutes,moviesWatchTimeMinutes,tvWatchTimeMinutes,lastUpdatedAt);

@override
String toString() {
  return 'UserStats(moviesWatchedCount: $moviesWatchedCount, tvSeriesWatchedCount: $tvSeriesWatchedCount, episodesWatchedCount: $episodesWatchedCount, totalWatchTimeMinutes: $totalWatchTimeMinutes, moviesWatchTimeMinutes: $moviesWatchTimeMinutes, tvWatchTimeMinutes: $tvWatchTimeMinutes, lastUpdatedAt: $lastUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserStatsCopyWith<$Res> implements $UserStatsCopyWith<$Res> {
  factory _$UserStatsCopyWith(_UserStats value, $Res Function(_UserStats) _then) = __$UserStatsCopyWithImpl;
@override @useResult
$Res call({
 int moviesWatchedCount, int tvSeriesWatchedCount, int episodesWatchedCount, int totalWatchTimeMinutes, int moviesWatchTimeMinutes, int tvWatchTimeMinutes, DateTime? lastUpdatedAt
});




}
/// @nodoc
class __$UserStatsCopyWithImpl<$Res>
    implements _$UserStatsCopyWith<$Res> {
  __$UserStatsCopyWithImpl(this._self, this._then);

  final _UserStats _self;
  final $Res Function(_UserStats) _then;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? moviesWatchedCount = null,Object? tvSeriesWatchedCount = null,Object? episodesWatchedCount = null,Object? totalWatchTimeMinutes = null,Object? moviesWatchTimeMinutes = null,Object? tvWatchTimeMinutes = null,Object? lastUpdatedAt = freezed,}) {
  return _then(_UserStats(
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
