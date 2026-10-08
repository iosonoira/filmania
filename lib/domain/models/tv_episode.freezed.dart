// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_episode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TVEpisode {

 int get id; int get episodeNumber; int get seasonNumber; String get name; String get overview; String? get stillPath; double get voteAverage; String? get airDate; int? get runtime;
/// Create a copy of TVEpisode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TVEpisodeCopyWith<TVEpisode> get copyWith => _$TVEpisodeCopyWithImpl<TVEpisode>(this as TVEpisode, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TVEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.stillPath, stillPath) || other.stillPath == stillPath)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.runtime, runtime) || other.runtime == runtime));
}


@override
int get hashCode => Object.hash(runtimeType,id,episodeNumber,seasonNumber,name,overview,stillPath,voteAverage,airDate,runtime);

@override
String toString() {
  return 'TVEpisode(id: $id, episodeNumber: $episodeNumber, seasonNumber: $seasonNumber, name: $name, overview: $overview, stillPath: $stillPath, voteAverage: $voteAverage, airDate: $airDate, runtime: $runtime)';
}


}

/// @nodoc
abstract mixin class $TVEpisodeCopyWith<$Res>  {
  factory $TVEpisodeCopyWith(TVEpisode value, $Res Function(TVEpisode) _then) = _$TVEpisodeCopyWithImpl;
@useResult
$Res call({
 int id, int episodeNumber, int seasonNumber, String name, String overview, String? stillPath, double voteAverage, String? airDate, int? runtime
});




}
/// @nodoc
class _$TVEpisodeCopyWithImpl<$Res>
    implements $TVEpisodeCopyWith<$Res> {
  _$TVEpisodeCopyWithImpl(this._self, this._then);

  final TVEpisode _self;
  final $Res Function(TVEpisode) _then;

/// Create a copy of TVEpisode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? episodeNumber = null,Object? seasonNumber = null,Object? name = null,Object? overview = null,Object? stillPath = freezed,Object? voteAverage = null,Object? airDate = freezed,Object? runtime = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,stillPath: freezed == stillPath ? _self.stillPath : stillPath // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TVEpisode].
extension TVEpisodePatterns on TVEpisode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TVEpisode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TVEpisode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TVEpisode value)  $default,){
final _that = this;
switch (_that) {
case _TVEpisode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TVEpisode value)?  $default,){
final _that = this;
switch (_that) {
case _TVEpisode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int episodeNumber,  int seasonNumber,  String name,  String overview,  String? stillPath,  double voteAverage,  String? airDate,  int? runtime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TVEpisode() when $default != null:
return $default(_that.id,_that.episodeNumber,_that.seasonNumber,_that.name,_that.overview,_that.stillPath,_that.voteAverage,_that.airDate,_that.runtime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int episodeNumber,  int seasonNumber,  String name,  String overview,  String? stillPath,  double voteAverage,  String? airDate,  int? runtime)  $default,) {final _that = this;
switch (_that) {
case _TVEpisode():
return $default(_that.id,_that.episodeNumber,_that.seasonNumber,_that.name,_that.overview,_that.stillPath,_that.voteAverage,_that.airDate,_that.runtime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int episodeNumber,  int seasonNumber,  String name,  String overview,  String? stillPath,  double voteAverage,  String? airDate,  int? runtime)?  $default,) {final _that = this;
switch (_that) {
case _TVEpisode() when $default != null:
return $default(_that.id,_that.episodeNumber,_that.seasonNumber,_that.name,_that.overview,_that.stillPath,_that.voteAverage,_that.airDate,_that.runtime);case _:
  return null;

}
}

}

/// @nodoc


class _TVEpisode extends TVEpisode {
  const _TVEpisode({required this.id, required this.episodeNumber, required this.seasonNumber, required this.name, required this.overview, required this.stillPath, required this.voteAverage, required this.airDate, required this.runtime}): super._();
  

@override final  int id;
@override final  int episodeNumber;
@override final  int seasonNumber;
@override final  String name;
@override final  String overview;
@override final  String? stillPath;
@override final  double voteAverage;
@override final  String? airDate;
@override final  int? runtime;

/// Create a copy of TVEpisode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TVEpisodeCopyWith<_TVEpisode> get copyWith => __$TVEpisodeCopyWithImpl<_TVEpisode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TVEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.stillPath, stillPath) || other.stillPath == stillPath)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.runtime, runtime) || other.runtime == runtime));
}


@override
int get hashCode => Object.hash(runtimeType,id,episodeNumber,seasonNumber,name,overview,stillPath,voteAverage,airDate,runtime);

@override
String toString() {
  return 'TVEpisode(id: $id, episodeNumber: $episodeNumber, seasonNumber: $seasonNumber, name: $name, overview: $overview, stillPath: $stillPath, voteAverage: $voteAverage, airDate: $airDate, runtime: $runtime)';
}


}

/// @nodoc
abstract mixin class _$TVEpisodeCopyWith<$Res> implements $TVEpisodeCopyWith<$Res> {
  factory _$TVEpisodeCopyWith(_TVEpisode value, $Res Function(_TVEpisode) _then) = __$TVEpisodeCopyWithImpl;
@override @useResult
$Res call({
 int id, int episodeNumber, int seasonNumber, String name, String overview, String? stillPath, double voteAverage, String? airDate, int? runtime
});




}
/// @nodoc
class __$TVEpisodeCopyWithImpl<$Res>
    implements _$TVEpisodeCopyWith<$Res> {
  __$TVEpisodeCopyWithImpl(this._self, this._then);

  final _TVEpisode _self;
  final $Res Function(_TVEpisode) _then;

/// Create a copy of TVEpisode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? episodeNumber = null,Object? seasonNumber = null,Object? name = null,Object? overview = null,Object? stillPath = freezed,Object? voteAverage = null,Object? airDate = freezed,Object? runtime = freezed,}) {
  return _then(_TVEpisode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,stillPath: freezed == stillPath ? _self.stillPath : stillPath // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
