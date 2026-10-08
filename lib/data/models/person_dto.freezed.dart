// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonDto {

 int get id; String get name; String? get biography; String? get birthday;@JsonKey(name: 'place_of_birth') String? get placeOfBirth;@JsonKey(name: 'profile_path') String? get profilePath;
/// Create a copy of PersonDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonDtoCopyWith<PersonDto> get copyWith => _$PersonDtoCopyWithImpl<PersonDto>(this as PersonDto, _$identity);

  /// Serializes this PersonDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.biography, biography) || other.biography == biography)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.placeOfBirth, placeOfBirth) || other.placeOfBirth == placeOfBirth)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,biography,birthday,placeOfBirth,profilePath);

@override
String toString() {
  return 'PersonDto(id: $id, name: $name, biography: $biography, birthday: $birthday, placeOfBirth: $placeOfBirth, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class $PersonDtoCopyWith<$Res>  {
  factory $PersonDtoCopyWith(PersonDto value, $Res Function(PersonDto) _then) = _$PersonDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? biography, String? birthday,@JsonKey(name: 'place_of_birth') String? placeOfBirth,@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class _$PersonDtoCopyWithImpl<$Res>
    implements $PersonDtoCopyWith<$Res> {
  _$PersonDtoCopyWithImpl(this._self, this._then);

  final PersonDto _self;
  final $Res Function(PersonDto) _then;

/// Create a copy of PersonDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? biography = freezed,Object? birthday = freezed,Object? placeOfBirth = freezed,Object? profilePath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,biography: freezed == biography ? _self.biography : biography // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,placeOfBirth: freezed == placeOfBirth ? _self.placeOfBirth : placeOfBirth // ignore: cast_nullable_to_non_nullable
as String?,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonDto].
extension PersonDtoPatterns on PersonDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonDto value)  $default,){
final _that = this;
switch (_that) {
case _PersonDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonDto value)?  $default,){
final _that = this;
switch (_that) {
case _PersonDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? biography,  String? birthday, @JsonKey(name: 'place_of_birth')  String? placeOfBirth, @JsonKey(name: 'profile_path')  String? profilePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonDto() when $default != null:
return $default(_that.id,_that.name,_that.biography,_that.birthday,_that.placeOfBirth,_that.profilePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? biography,  String? birthday, @JsonKey(name: 'place_of_birth')  String? placeOfBirth, @JsonKey(name: 'profile_path')  String? profilePath)  $default,) {final _that = this;
switch (_that) {
case _PersonDto():
return $default(_that.id,_that.name,_that.biography,_that.birthday,_that.placeOfBirth,_that.profilePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? biography,  String? birthday, @JsonKey(name: 'place_of_birth')  String? placeOfBirth, @JsonKey(name: 'profile_path')  String? profilePath)?  $default,) {final _that = this;
switch (_that) {
case _PersonDto() when $default != null:
return $default(_that.id,_that.name,_that.biography,_that.birthday,_that.placeOfBirth,_that.profilePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonDto extends PersonDto {
  const _PersonDto({required this.id, required this.name, this.biography, this.birthday, @JsonKey(name: 'place_of_birth') this.placeOfBirth, @JsonKey(name: 'profile_path') this.profilePath}): super._();
  factory _PersonDto.fromJson(Map<String, dynamic> json) => _$PersonDtoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? biography;
@override final  String? birthday;
@override@JsonKey(name: 'place_of_birth') final  String? placeOfBirth;
@override@JsonKey(name: 'profile_path') final  String? profilePath;

/// Create a copy of PersonDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonDtoCopyWith<_PersonDto> get copyWith => __$PersonDtoCopyWithImpl<_PersonDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.biography, biography) || other.biography == biography)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.placeOfBirth, placeOfBirth) || other.placeOfBirth == placeOfBirth)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,biography,birthday,placeOfBirth,profilePath);

@override
String toString() {
  return 'PersonDto(id: $id, name: $name, biography: $biography, birthday: $birthday, placeOfBirth: $placeOfBirth, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class _$PersonDtoCopyWith<$Res> implements $PersonDtoCopyWith<$Res> {
  factory _$PersonDtoCopyWith(_PersonDto value, $Res Function(_PersonDto) _then) = __$PersonDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? biography, String? birthday,@JsonKey(name: 'place_of_birth') String? placeOfBirth,@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class __$PersonDtoCopyWithImpl<$Res>
    implements _$PersonDtoCopyWith<$Res> {
  __$PersonDtoCopyWithImpl(this._self, this._then);

  final _PersonDto _self;
  final $Res Function(_PersonDto) _then;

/// Create a copy of PersonDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? biography = freezed,Object? birthday = freezed,Object? placeOfBirth = freezed,Object? profilePath = freezed,}) {
  return _then(_PersonDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,biography: freezed == biography ? _self.biography : biography // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,placeOfBirth: freezed == placeOfBirth ? _self.placeOfBirth : placeOfBirth // ignore: cast_nullable_to_non_nullable
as String?,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
