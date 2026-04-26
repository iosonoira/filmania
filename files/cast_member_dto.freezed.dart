// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cast_member_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CastMemberDto {

 int get id; String get name; String get character;@JsonKey(name: 'profile_path') String? get profilePath;
/// Create a copy of CastMemberDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CastMemberDtoCopyWith<CastMemberDto> get copyWith => _$CastMemberDtoCopyWithImpl<CastMemberDto>(this as CastMemberDto, _$identity);

  /// Serializes this CastMemberDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CastMemberDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.character, character) || other.character == character)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,character,profilePath);

@override
String toString() {
  return 'CastMemberDto(id: $id, name: $name, character: $character, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class $CastMemberDtoCopyWith<$Res>  {
  factory $CastMemberDtoCopyWith(CastMemberDto value, $Res Function(CastMemberDto) _then) = _$CastMemberDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String character,@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class _$CastMemberDtoCopyWithImpl<$Res>
    implements $CastMemberDtoCopyWith<$Res> {
  _$CastMemberDtoCopyWithImpl(this._self, this._then);

  final CastMemberDto _self;
  final $Res Function(CastMemberDto) _then;

/// Create a copy of CastMemberDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? character = null,Object? profilePath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CastMemberDto].
extension CastMemberDtoPatterns on CastMemberDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CastMemberDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CastMemberDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CastMemberDto value)  $default,){
final _that = this;
switch (_that) {
case _CastMemberDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CastMemberDto value)?  $default,){
final _that = this;
switch (_that) {
case _CastMemberDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String character, @JsonKey(name: 'profile_path')  String? profilePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CastMemberDto() when $default != null:
return $default(_that.id,_that.name,_that.character,_that.profilePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String character, @JsonKey(name: 'profile_path')  String? profilePath)  $default,) {final _that = this;
switch (_that) {
case _CastMemberDto():
return $default(_that.id,_that.name,_that.character,_that.profilePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String character, @JsonKey(name: 'profile_path')  String? profilePath)?  $default,) {final _that = this;
switch (_that) {
case _CastMemberDto() when $default != null:
return $default(_that.id,_that.name,_that.character,_that.profilePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CastMemberDto extends CastMemberDto {
  const _CastMemberDto({required this.id, required this.name, required this.character, @JsonKey(name: 'profile_path') this.profilePath}): super._();
  factory _CastMemberDto.fromJson(Map<String, dynamic> json) => _$CastMemberDtoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String character;
@override@JsonKey(name: 'profile_path') final  String? profilePath;

/// Create a copy of CastMemberDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CastMemberDtoCopyWith<_CastMemberDto> get copyWith => __$CastMemberDtoCopyWithImpl<_CastMemberDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CastMemberDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CastMemberDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.character, character) || other.character == character)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,character,profilePath);

@override
String toString() {
  return 'CastMemberDto(id: $id, name: $name, character: $character, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class _$CastMemberDtoCopyWith<$Res> implements $CastMemberDtoCopyWith<$Res> {
  factory _$CastMemberDtoCopyWith(_CastMemberDto value, $Res Function(_CastMemberDto) _then) = __$CastMemberDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String character,@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class __$CastMemberDtoCopyWithImpl<$Res>
    implements _$CastMemberDtoCopyWith<$Res> {
  __$CastMemberDtoCopyWithImpl(this._self, this._then);

  final _CastMemberDto _self;
  final $Res Function(_CastMemberDto) _then;

/// Create a copy of CastMemberDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? character = null,Object? profilePath = freezed,}) {
  return _then(_CastMemberDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
