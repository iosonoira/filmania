// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_series_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TVSeriesDto {

 int get id; String get name; String get overview;@JsonKey(name: 'poster_path') String? get posterPath;@JsonKey(name: 'backdrop_path') String? get backdropPath;@JsonKey(name: 'first_air_date') String? get firstAirDate;@JsonKey(name: 'vote_average') double? get voteAverage;@JsonKey(name: 'episode_run_time') List<int> get episodeRunTime; List<TVSeasonDto> get seasons;
/// Create a copy of TVSeriesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TVSeriesDtoCopyWith<TVSeriesDto> get copyWith => _$TVSeriesDtoCopyWithImpl<TVSeriesDto>(this as TVSeriesDto, _$identity);

  /// Serializes this TVSeriesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TVSeriesDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&const DeepCollectionEquality().equals(other.episodeRunTime, episodeRunTime)&&const DeepCollectionEquality().equals(other.seasons, seasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,overview,posterPath,backdropPath,firstAirDate,voteAverage,const DeepCollectionEquality().hash(episodeRunTime),const DeepCollectionEquality().hash(seasons));

@override
String toString() {
  return 'TVSeriesDto(id: $id, name: $name, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, firstAirDate: $firstAirDate, voteAverage: $voteAverage, episodeRunTime: $episodeRunTime, seasons: $seasons)';
}


}

/// @nodoc
abstract mixin class $TVSeriesDtoCopyWith<$Res>  {
  factory $TVSeriesDtoCopyWith(TVSeriesDto value, $Res Function(TVSeriesDto) _then) = _$TVSeriesDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String overview,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'backdrop_path') String? backdropPath,@JsonKey(name: 'first_air_date') String? firstAirDate,@JsonKey(name: 'vote_average') double? voteAverage,@JsonKey(name: 'episode_run_time') List<int> episodeRunTime, List<TVSeasonDto> seasons
});




}
/// @nodoc
class _$TVSeriesDtoCopyWithImpl<$Res>
    implements $TVSeriesDtoCopyWith<$Res> {
  _$TVSeriesDtoCopyWithImpl(this._self, this._then);

  final TVSeriesDto _self;
  final $Res Function(TVSeriesDto) _then;

/// Create a copy of TVSeriesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? overview = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? firstAirDate = freezed,Object? voteAverage = freezed,Object? episodeRunTime = null,Object? seasons = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,episodeRunTime: null == episodeRunTime ? _self.episodeRunTime : episodeRunTime // ignore: cast_nullable_to_non_nullable
as List<int>,seasons: null == seasons ? _self.seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<TVSeasonDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [TVSeriesDto].
extension TVSeriesDtoPatterns on TVSeriesDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TVSeriesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TVSeriesDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TVSeriesDto value)  $default,){
final _that = this;
switch (_that) {
case _TVSeriesDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TVSeriesDto value)?  $default,){
final _that = this;
switch (_that) {
case _TVSeriesDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String overview, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'backdrop_path')  String? backdropPath, @JsonKey(name: 'first_air_date')  String? firstAirDate, @JsonKey(name: 'vote_average')  double? voteAverage, @JsonKey(name: 'episode_run_time')  List<int> episodeRunTime,  List<TVSeasonDto> seasons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TVSeriesDto() when $default != null:
return $default(_that.id,_that.name,_that.overview,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.voteAverage,_that.episodeRunTime,_that.seasons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String overview, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'backdrop_path')  String? backdropPath, @JsonKey(name: 'first_air_date')  String? firstAirDate, @JsonKey(name: 'vote_average')  double? voteAverage, @JsonKey(name: 'episode_run_time')  List<int> episodeRunTime,  List<TVSeasonDto> seasons)  $default,) {final _that = this;
switch (_that) {
case _TVSeriesDto():
return $default(_that.id,_that.name,_that.overview,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.voteAverage,_that.episodeRunTime,_that.seasons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String overview, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'backdrop_path')  String? backdropPath, @JsonKey(name: 'first_air_date')  String? firstAirDate, @JsonKey(name: 'vote_average')  double? voteAverage, @JsonKey(name: 'episode_run_time')  List<int> episodeRunTime,  List<TVSeasonDto> seasons)?  $default,) {final _that = this;
switch (_that) {
case _TVSeriesDto() when $default != null:
return $default(_that.id,_that.name,_that.overview,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.voteAverage,_that.episodeRunTime,_that.seasons);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TVSeriesDto extends TVSeriesDto {
  const _TVSeriesDto({required this.id, required this.name, required this.overview, @JsonKey(name: 'poster_path') this.posterPath, @JsonKey(name: 'backdrop_path') this.backdropPath, @JsonKey(name: 'first_air_date') this.firstAirDate, @JsonKey(name: 'vote_average') this.voteAverage, @JsonKey(name: 'episode_run_time') final  List<int> episodeRunTime = const [], final  List<TVSeasonDto> seasons = const []}): _episodeRunTime = episodeRunTime,_seasons = seasons,super._();
  factory _TVSeriesDto.fromJson(Map<String, dynamic> json) => _$TVSeriesDtoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String overview;
@override@JsonKey(name: 'poster_path') final  String? posterPath;
@override@JsonKey(name: 'backdrop_path') final  String? backdropPath;
@override@JsonKey(name: 'first_air_date') final  String? firstAirDate;
@override@JsonKey(name: 'vote_average') final  double? voteAverage;
 final  List<int> _episodeRunTime;
@override@JsonKey(name: 'episode_run_time') List<int> get episodeRunTime {
  if (_episodeRunTime is EqualUnmodifiableListView) return _episodeRunTime;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodeRunTime);
}

 final  List<TVSeasonDto> _seasons;
@override@JsonKey() List<TVSeasonDto> get seasons {
  if (_seasons is EqualUnmodifiableListView) return _seasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seasons);
}


/// Create a copy of TVSeriesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TVSeriesDtoCopyWith<_TVSeriesDto> get copyWith => __$TVSeriesDtoCopyWithImpl<_TVSeriesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TVSeriesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TVSeriesDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&const DeepCollectionEquality().equals(other._episodeRunTime, _episodeRunTime)&&const DeepCollectionEquality().equals(other._seasons, _seasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,overview,posterPath,backdropPath,firstAirDate,voteAverage,const DeepCollectionEquality().hash(_episodeRunTime),const DeepCollectionEquality().hash(_seasons));

@override
String toString() {
  return 'TVSeriesDto(id: $id, name: $name, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, firstAirDate: $firstAirDate, voteAverage: $voteAverage, episodeRunTime: $episodeRunTime, seasons: $seasons)';
}


}

/// @nodoc
abstract mixin class _$TVSeriesDtoCopyWith<$Res> implements $TVSeriesDtoCopyWith<$Res> {
  factory _$TVSeriesDtoCopyWith(_TVSeriesDto value, $Res Function(_TVSeriesDto) _then) = __$TVSeriesDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String overview,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'backdrop_path') String? backdropPath,@JsonKey(name: 'first_air_date') String? firstAirDate,@JsonKey(name: 'vote_average') double? voteAverage,@JsonKey(name: 'episode_run_time') List<int> episodeRunTime, List<TVSeasonDto> seasons
});




}
/// @nodoc
class __$TVSeriesDtoCopyWithImpl<$Res>
    implements _$TVSeriesDtoCopyWith<$Res> {
  __$TVSeriesDtoCopyWithImpl(this._self, this._then);

  final _TVSeriesDto _self;
  final $Res Function(_TVSeriesDto) _then;

/// Create a copy of TVSeriesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? overview = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? firstAirDate = freezed,Object? voteAverage = freezed,Object? episodeRunTime = null,Object? seasons = null,}) {
  return _then(_TVSeriesDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,episodeRunTime: null == episodeRunTime ? _self._episodeRunTime : episodeRunTime // ignore: cast_nullable_to_non_nullable
as List<int>,seasons: null == seasons ? _self._seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<TVSeasonDto>,
  ));
}


}

// dart format on
