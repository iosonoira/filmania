// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_credit_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonCreditDto {

 int get id; String? get title; String? get name;@JsonKey(name: 'poster_path') String? get posterPath;@JsonKey(name: 'release_date') String? get releaseDate;@JsonKey(name: 'first_air_date') String? get firstAirDate;@JsonKey(name: 'vote_average') double? get voteAverage;@JsonKey(name: 'media_type') MediaType get mediaType;
/// Create a copy of PersonCreditDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonCreditDtoCopyWith<PersonCreditDto> get copyWith => _$PersonCreditDtoCopyWithImpl<PersonCreditDto>(this as PersonCreditDto, _$identity);

  /// Serializes this PersonCreditDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonCreditDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.name, name) || other.name == name)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,name,posterPath,releaseDate,firstAirDate,voteAverage,mediaType);

@override
String toString() {
  return 'PersonCreditDto(id: $id, title: $title, name: $name, posterPath: $posterPath, releaseDate: $releaseDate, firstAirDate: $firstAirDate, voteAverage: $voteAverage, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class $PersonCreditDtoCopyWith<$Res>  {
  factory $PersonCreditDtoCopyWith(PersonCreditDto value, $Res Function(PersonCreditDto) _then) = _$PersonCreditDtoCopyWithImpl;
@useResult
$Res call({
 int id, String? title, String? name,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'release_date') String? releaseDate,@JsonKey(name: 'first_air_date') String? firstAirDate,@JsonKey(name: 'vote_average') double? voteAverage,@JsonKey(name: 'media_type') MediaType mediaType
});




}
/// @nodoc
class _$PersonCreditDtoCopyWithImpl<$Res>
    implements $PersonCreditDtoCopyWith<$Res> {
  _$PersonCreditDtoCopyWithImpl(this._self, this._then);

  final PersonCreditDto _self;
  final $Res Function(PersonCreditDto) _then;

/// Create a copy of PersonCreditDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? name = freezed,Object? posterPath = freezed,Object? releaseDate = freezed,Object? firstAirDate = freezed,Object? voteAverage = freezed,Object? mediaType = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonCreditDto].
extension PersonCreditDtoPatterns on PersonCreditDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonCreditDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonCreditDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonCreditDto value)  $default,){
final _that = this;
switch (_that) {
case _PersonCreditDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonCreditDto value)?  $default,){
final _that = this;
switch (_that) {
case _PersonCreditDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? title,  String? name, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'release_date')  String? releaseDate, @JsonKey(name: 'first_air_date')  String? firstAirDate, @JsonKey(name: 'vote_average')  double? voteAverage, @JsonKey(name: 'media_type')  MediaType mediaType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonCreditDto() when $default != null:
return $default(_that.id,_that.title,_that.name,_that.posterPath,_that.releaseDate,_that.firstAirDate,_that.voteAverage,_that.mediaType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? title,  String? name, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'release_date')  String? releaseDate, @JsonKey(name: 'first_air_date')  String? firstAirDate, @JsonKey(name: 'vote_average')  double? voteAverage, @JsonKey(name: 'media_type')  MediaType mediaType)  $default,) {final _that = this;
switch (_that) {
case _PersonCreditDto():
return $default(_that.id,_that.title,_that.name,_that.posterPath,_that.releaseDate,_that.firstAirDate,_that.voteAverage,_that.mediaType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? title,  String? name, @JsonKey(name: 'poster_path')  String? posterPath, @JsonKey(name: 'release_date')  String? releaseDate, @JsonKey(name: 'first_air_date')  String? firstAirDate, @JsonKey(name: 'vote_average')  double? voteAverage, @JsonKey(name: 'media_type')  MediaType mediaType)?  $default,) {final _that = this;
switch (_that) {
case _PersonCreditDto() when $default != null:
return $default(_that.id,_that.title,_that.name,_that.posterPath,_that.releaseDate,_that.firstAirDate,_that.voteAverage,_that.mediaType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonCreditDto extends PersonCreditDto {
  const _PersonCreditDto({required this.id, this.title, this.name, @JsonKey(name: 'poster_path') this.posterPath, @JsonKey(name: 'release_date') this.releaseDate, @JsonKey(name: 'first_air_date') this.firstAirDate, @JsonKey(name: 'vote_average') this.voteAverage, @JsonKey(name: 'media_type') required this.mediaType}): super._();
  factory _PersonCreditDto.fromJson(Map<String, dynamic> json) => _$PersonCreditDtoFromJson(json);

@override final  int id;
@override final  String? title;
@override final  String? name;
@override@JsonKey(name: 'poster_path') final  String? posterPath;
@override@JsonKey(name: 'release_date') final  String? releaseDate;
@override@JsonKey(name: 'first_air_date') final  String? firstAirDate;
@override@JsonKey(name: 'vote_average') final  double? voteAverage;
@override@JsonKey(name: 'media_type') final  MediaType mediaType;

/// Create a copy of PersonCreditDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonCreditDtoCopyWith<_PersonCreditDto> get copyWith => __$PersonCreditDtoCopyWithImpl<_PersonCreditDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonCreditDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonCreditDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.name, name) || other.name == name)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,name,posterPath,releaseDate,firstAirDate,voteAverage,mediaType);

@override
String toString() {
  return 'PersonCreditDto(id: $id, title: $title, name: $name, posterPath: $posterPath, releaseDate: $releaseDate, firstAirDate: $firstAirDate, voteAverage: $voteAverage, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class _$PersonCreditDtoCopyWith<$Res> implements $PersonCreditDtoCopyWith<$Res> {
  factory _$PersonCreditDtoCopyWith(_PersonCreditDto value, $Res Function(_PersonCreditDto) _then) = __$PersonCreditDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String? title, String? name,@JsonKey(name: 'poster_path') String? posterPath,@JsonKey(name: 'release_date') String? releaseDate,@JsonKey(name: 'first_air_date') String? firstAirDate,@JsonKey(name: 'vote_average') double? voteAverage,@JsonKey(name: 'media_type') MediaType mediaType
});




}
/// @nodoc
class __$PersonCreditDtoCopyWithImpl<$Res>
    implements _$PersonCreditDtoCopyWith<$Res> {
  __$PersonCreditDtoCopyWithImpl(this._self, this._then);

  final _PersonCreditDto _self;
  final $Res Function(_PersonCreditDto) _then;

/// Create a copy of PersonCreditDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? name = freezed,Object? posterPath = freezed,Object? releaseDate = freezed,Object? firstAirDate = freezed,Object? voteAverage = freezed,Object? mediaType = null,}) {
  return _then(_PersonCreditDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as String?,voteAverage: freezed == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double?,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,
  ));
}


}

// dart format on
