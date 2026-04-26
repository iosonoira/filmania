// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_episode_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TVEpisodeDto {

 int get id;@JsonKey(name: 'episode_number') int get episodeNumber;@JsonKey(name: 'season_number') int get seasonNumber; String get name; String get overview;@JsonKey(name: 'still_path') String? get stillPath;@JsonKey(name: 'vote_average') double? get voteAverage;@JsonKey(name: 'air_date') String? get airDate; int? get runtime;
/// Create a copy of TVEpisodeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TVEpisodeDtoCopyWith<TVEpisodeDto> get copyWith => _$TVEpisodeDtoCopyWithImpl<TVEpisodeDto>(this as TVEpisodeDto, _$identity);

  /// Serializes this TVEpisodeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TVEpisodeDto&&(identical(other.id, id) || other.id == id)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.stillPath, stillPath) || other.stillPath == stillPath)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.runtime, runtime) || other.runtime == runtime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,episodeNumber,seasonNumber,name,overview,stillPath,voteAverage,airDate,runtime);

@override
String toString() {
  return 'TVEpisodeDto(id: $id, episodeNumber: $episodeNumber, seasonNumber: $seasonNumber, name: $name, overview: $overview, stillPath: $stillPath, voteAverage: $voteAverage, airDate: $airDate, runtime: $runtime)';
}


}

/// @nodoc
abstract mixin class $TVEpisodeDtoCopyWith<$Res>  {
  factory $TVEpisodeDtoCopyWith(TVEpisodeDto value, $Res Function(TVEpisodeDto) _then) = _$TVEpisodeDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'episode_number') int episodeNumber,@JsonKey(name: 'season_number') int seasonNumber, String name, String overview,@JsonKey(name: 'still_path') String? stillPath,@JsonKey(name: 'vote_average') double? voteAverage,@JsonKey(name: 'air_date') String? airDate, int? runtime
});




}
/// @nodoc
class _$TVEpisodeDtoCopyWithImpl<$Res>
    implements $TVEpisodeDtoCopyWith<$Res> {
  _$TVEpisodeDtoCopyWithImpl(this._self, this._then);

  final TVEpisodeDto _self;
  final $Res Function(TVEpisodeDto) _then;

/// Create a copy of TVEpisodeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? episodeNumber = null,Object? seasonNumber = null,Object? name = null,Object? overview = null,Object? stillPath = freezed,Object? voteAverage = freezed,Object? airDate = freezed,Object? runtime = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,stillPath: freezed == stillPath ? _self.stillPath : stillPath // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TVEpisodeDto].
extension TVEpisodeDtoPatterns on TVEpisodeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TVEpisodeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TVEpisodeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TVEpisodeDto value)  $default,){
final _that = this;
switch (_that) {
case _TVEpisodeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TVEpisodeDto value)?  $default,){
final _that = this;
switch (_that) {
case _TVEpisodeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'episode_number')  int episodeNumber, @JsonKey(name: 'season_number')  int seasonNumber,  String name,  String overview, @JsonKey(name: 'still_path')  String? stillPath, @JsonKey(name: 'vote_average')  double? voteAverage, @JsonKey(name: 'air_date')  String? airDate,  int? runtime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TVEpisodeDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'episode_number')  int episodeNumber, @JsonKey(name: 'season_number')  int seasonNumber,  String name,  String overview, @JsonKey(name: 'still_path')  String? stillPath, @JsonKey(name: 'vote_average')  double? voteAverage, @JsonKey(name: 'air_date')  String? airDate,  int? runtime)  $default,) {final _that = this;
switch (_that) {
case _TVEpisodeDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'episode_number')  int episodeNumber, @JsonKey(name: 'season_number')  int seasonNumber,  String name,  String overview, @JsonKey(name: 'still_path')  String? stillPath, @JsonKey(name: 'vote_average')  double? voteAverage, @JsonKey(name: 'air_date')  String? airDate,  int? runtime)?  $default,) {final _that = this;
switch (_that) {
case _TVEpisodeDto() when $default != null:
return $default(_that.id,_that.episodeNumber,_that.seasonNumber,_that.name,_that.overview,_that.stillPath,_that.voteAverage,_that.airDate,_that.runtime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TVEpisodeDto extends TVEpisodeDto {
  const _TVEpisodeDto({required this.id, @JsonKey(name: 'episode_number') required this.episodeNumber, @JsonKey(name: 'season_number') required this.seasonNumber, required this.name, required this.overview, @JsonKey(name: 'still_path') this.stillPath, @JsonKey(name: 'vote_average') this.voteAverage, @JsonKey(name: 'air_date') this.airDate, this.runtime}): super._();
  factory _TVEpisodeDto.fromJson(Map<String, dynamic> json) => _$TVEpisodeDtoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'episode_number') final  int episodeNumber;
@override@JsonKey(name: 'season_number') final  int seasonNumber;
@override final  String name;
@override final  String overview;
@override@JsonKey(name: 'still_path') final  String? stillPath;
@override@JsonKey(name: 'vote_average') final  double? voteAverage;
@override@JsonKey(name: 'air_date') final  String? airDate;
@override final  int? runtime;

/// Create a copy of TVEpisodeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TVEpisodeDtoCopyWith<_TVEpisodeDto> get copyWith => __$TVEpisodeDtoCopyWithImpl<_TVEpisodeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TVEpisodeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TVEpisodeDto&&(identical(other.id, id) || other.id == id)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.stillPath, stillPath) || other.stillPath == stillPath)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.runtime, runtime) || other.runtime == runtime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,episodeNumber,seasonNumber,name,overview,stillPath,voteAverage,airDate,runtime);

@override
String toString() {
  return 'TVEpisodeDto(id: $id, episodeNumber: $episodeNumber, seasonNumber: $seasonNumber, name: $name, overview: $overview, stillPath: $stillPath, voteAverage: $voteAverage, airDate: $airDate, runtime: $runtime)';
}


}

/// @nodoc
abstract mixin class _$TVEpisodeDtoCopyWith<$Res> implements $TVEpisodeDtoCopyWith<$Res> {
  factory _$TVEpisodeDtoCopyWith(_TVEpisodeDto value, $Res Function(_TVEpisodeDto) _then) = __$TVEpisodeDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'episode_number') int episodeNumber,@JsonKey(name: 'season_number') int seasonNumber, String name, String overview,@JsonKey(name: 'still_path') String? stillPath,@JsonKey(name: 'vote_average') double? voteAverage,@JsonKey(name: 'air_date') String? airDate, int? runtime
});




}
/// @nodoc
class __$TVEpisodeDtoCopyWithImpl<$Res>
    implements _$TVEpisodeDtoCopyWith<$Res> {
  __$TVEpisodeDtoCopyWithImpl(this._self, this._then);

  final _TVEpisodeDto _self;
  final $Res Function(_TVEpisodeDto) _then;

/// Create a copy of TVEpisodeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? episodeNumber = null,Object? seasonNumber = null,Object? name = null,Object? overview = null,Object? stillPath = freezed,Object? voteAverage = freezed,Object? airDate = freezed,Object? runtime = freezed,}) {
  return _then(_TVEpisodeDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,stillPath: freezed == stillPath ? _self.stillPath : stillPath // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,runtime: freezed == runtime ? _self.runtime : runtime // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
