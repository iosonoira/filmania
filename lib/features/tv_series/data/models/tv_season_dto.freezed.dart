// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_season_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TVSeasonDto {

 int get id;@JsonKey(name: 'season_number') int get seasonNumber; String get name;@JsonKey(name: 'episode_count') int? get episodeCount;@JsonKey(name: 'poster_path') String? get posterPath;@JsonKey(name: 'air_date') String? get airDate;
/// Create a copy of TVSeasonDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TVSeasonDtoCopyWith<TVSeasonDto> get copyWith => _$TVSeasonDtoCopyWithImpl<TVSeasonDto>(this as TVSeasonDto, _$identity);

  /// Serializes this TVSeasonDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TVSeasonDto&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.airDate, airDate) || other.airDate == airDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonNumber,name,episodeCount,posterPath,airDate);

@override
String toString() {
  return 'TVSeasonDto(id: $id, seasonNumber: $seasonNumber, name: $name, episodeCount: $episodeCount, posterPath: $posterPath, airDate: $airDate)';
}


}

/// @nodoc
abstract mixin class $TVSeasonDtoCopyWith<$Res>  {
  factory $TVSeasonDtoCopyWith(TVSeasonDto value, $Res Function(TVSeasonDto) _then) = _$TVSeasonDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'season_number') int seasonNumber, String name,@JsonKey(name: 'episode_count') int? episodeCount,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'air_date') String? airDate
});




}
/// @nodoc
class _$TVSeasonDtoCopyWithImpl<$Res>
    implements $TVSeasonDtoCopyWith<$Res> {
  _$TVSeasonDtoCopyWithImpl(this._self, this._then);

  final TVSeasonDto _self;
  final $Res Function(TVSeasonDto) _then;

/// Create a copy of TVSeasonDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonNumber = null,Object? name = null,Object? episodeCount = freezed,Object? posterPath = freezed,Object? airDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,episodeCount: freezed == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TVSeasonDto].
extension TVSeasonDtoPatterns on TVSeasonDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TVSeasonDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TVSeasonDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TVSeasonDto value)  $default,){
final _that = this;
switch (_that) {
case _TVSeasonDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TVSeasonDto value)?  $default,){
final _that = this;
switch (_that) {
case _TVSeasonDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'season_number')  int seasonNumber,  String name, @JsonKey(name: 'episode_count')  int? episodeCount, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'air_date')  String? airDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TVSeasonDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'season_number')  int seasonNumber,  String name, @JsonKey(name: 'episode_count')  int? episodeCount, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'air_date')  String? airDate)  $default,) {final _that = this;
switch (_that) {
case _TVSeasonDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'season_number')  int seasonNumber,  String name, @JsonKey(name: 'episode_count')  int? episodeCount, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'air_date')  String? airDate)?  $default,) {final _that = this;
switch (_that) {
case _TVSeasonDto() when $default != null:
return $default(_that.id,_that.seasonNumber,_that.name,_that.episodeCount,_that.posterPath,_that.airDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TVSeasonDto extends TVSeasonDto {
  const _TVSeasonDto({required this.id, @JsonKey(name: 'season_number') required this.seasonNumber, required this.name, @JsonKey(name: 'episode_count') this.episodeCount, @JsonKey(name: 'poster_path') this.posterPath, @JsonKey(name: 'air_date') this.airDate}): super._();
  factory _TVSeasonDto.fromJson(Map<String, dynamic> json) => _$TVSeasonDtoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'season_number') final  int seasonNumber;
@override final  String name;
@override@JsonKey(name: 'episode_count') final  int? episodeCount;
@override@JsonKey(name: 'poster_path') final  String? posterPath;
@override@JsonKey(name: 'air_date') final  String? airDate;

/// Create a copy of TVSeasonDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TVSeasonDtoCopyWith<_TVSeasonDto> get copyWith => __$TVSeasonDtoCopyWithImpl<_TVSeasonDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TVSeasonDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TVSeasonDto&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.airDate, airDate) || other.airDate == airDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seasonNumber,name,episodeCount,posterPath,airDate);

@override
String toString() {
  return 'TVSeasonDto(id: $id, seasonNumber: $seasonNumber, name: $name, episodeCount: $episodeCount, posterPath: $posterPath, airDate: $airDate)';
}


}

/// @nodoc
abstract mixin class _$TVSeasonDtoCopyWith<$Res> implements $TVSeasonDtoCopyWith<$Res> {
  factory _$TVSeasonDtoCopyWith(_TVSeasonDto value, $Res Function(_TVSeasonDto) _then) = __$TVSeasonDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'season_number') int seasonNumber, String name,@JsonKey(name: 'episode_count') int? episodeCount,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'air_date') String? airDate
});




}
/// @nodoc
class __$TVSeasonDtoCopyWithImpl<$Res>
    implements _$TVSeasonDtoCopyWith<$Res> {
  __$TVSeasonDtoCopyWithImpl(this._self, this._then);

  final _TVSeasonDto _self;
  final $Res Function(_TVSeasonDto) _then;

/// Create a copy of TVSeasonDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonNumber = null,Object? name = null,Object? episodeCount = freezed,Object? posterPath = freezed,Object? airDate = freezed,}) {
  return _then(_TVSeasonDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,episodeCount: freezed == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,airDate: freezed == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
