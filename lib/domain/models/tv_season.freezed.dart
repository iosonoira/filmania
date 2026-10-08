// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_season.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TVSeason {

 int get id; int get seasonNumber; String get name; int get episodeCount; String? get posterPath; String? get airDate;
/// Create a copy of TVSeason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TVSeasonCopyWith<TVSeason> get copyWith => _$TVSeasonCopyWithImpl<TVSeason>(this as TVSeason, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TVSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.airDate, airDate) || other.airDate == airDate));
}


@override
int get hashCode => Object.hash(runtimeType,id,seasonNumber,name,episodeCount,posterPath,airDate);

@override
String toString() {
  return 'TVSeason(id: $id, seasonNumber: $seasonNumber, name: $name, episodeCount: $episodeCount, posterPath: $posterPath, airDate: $airDate)';
}


}

/// @nodoc
abstract mixin class $TVSeasonCopyWith<$Res>  {
  factory $TVSeasonCopyWith(TVSeason value, $Res Function(TVSeason) _then) = _$TVSeasonCopyWithImpl;
@useResult
$Res call({
 int id, int seasonNumber, String name, int episodeCount, String? posterPath, String? airDate
});




}
/// @nodoc
class _$TVSeasonCopyWithImpl<$Res>
    implements $TVSeasonCopyWith<$Res> {
  _$TVSeasonCopyWithImpl(this._self, this._then);

  final TVSeason _self;
  final $Res Function(TVSeason) _then;

/// Create a copy of TVSeason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonNumber = null,Object? name = null,Object? episodeCount = null,Object? posterPath = freezed,Object? airDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TVSeason].
extension TVSeasonPatterns on TVSeason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TVSeason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TVSeason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TVSeason value)  $default,){
final _that = this;
switch (_that) {
case _TVSeason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TVSeason value)?  $default,){
final _that = this;
switch (_that) {
case _TVSeason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int seasonNumber,  String name,  int episodeCount,  String? posterPath,  String? airDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TVSeason() when $default != null:
return $default(_that.id,_that.seasonNumber,_that.name,_that.episodeCount,_that.posterPath,_that.airDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int seasonNumber,  String name,  int episodeCount,  String? posterPath,  String? airDate)  $default,) {final _that = this;
switch (_that) {
case _TVSeason():
return $default(_that.id,_that.seasonNumber,_that.name,_that.episodeCount,_that.posterPath,_that.airDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int seasonNumber,  String name,  int episodeCount,  String? posterPath,  String? airDate)?  $default,) {final _that = this;
switch (_that) {
case _TVSeason() when $default != null:
return $default(_that.id,_that.seasonNumber,_that.name,_that.episodeCount,_that.posterPath,_that.airDate);case _:
  return null;

}
}

}

/// @nodoc


class _TVSeason extends TVSeason {
  const _TVSeason({required this.id, required this.seasonNumber, required this.name, required this.episodeCount, required this.posterPath, required this.airDate}): super._();
  

@override final  int id;
@override final  int seasonNumber;
@override final  String name;
@override final  int episodeCount;
@override final  String? posterPath;
@override final  String? airDate;

/// Create a copy of TVSeason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TVSeasonCopyWith<_TVSeason> get copyWith => __$TVSeasonCopyWithImpl<_TVSeason>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TVSeason&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.airDate, airDate) || other.airDate == airDate));
}


@override
int get hashCode => Object.hash(runtimeType,id,seasonNumber,name,episodeCount,posterPath,airDate);

@override
String toString() {
  return 'TVSeason(id: $id, seasonNumber: $seasonNumber, name: $name, episodeCount: $episodeCount, posterPath: $posterPath, airDate: $airDate)';
}


}

/// @nodoc
abstract mixin class _$TVSeasonCopyWith<$Res> implements $TVSeasonCopyWith<$Res> {
  factory _$TVSeasonCopyWith(_TVSeason value, $Res Function(_TVSeason) _then) = __$TVSeasonCopyWithImpl;
@override @useResult
$Res call({
 int id, int seasonNumber, String name, int episodeCount, String? posterPath, String? airDate
});




}
/// @nodoc
class __$TVSeasonCopyWithImpl<$Res>
    implements _$TVSeasonCopyWith<$Res> {
  __$TVSeasonCopyWithImpl(this._self, this._then);

  final _TVSeason _self;
  final $Res Function(_TVSeason) _then;

/// Create a copy of TVSeason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonNumber = null,Object? name = null,Object? episodeCount = null,Object? posterPath = freezed,Object? airDate = freezed,}) {
  return _then(_TVSeason(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
