// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crew_member_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CrewMemberDto {

 int get id; String get name; String get job; String get department;@JsonKey(name: 'profile_path') String? get profilePath;
/// Create a copy of CrewMemberDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrewMemberDtoCopyWith<CrewMemberDto> get copyWith => _$CrewMemberDtoCopyWithImpl<CrewMemberDto>(this as CrewMemberDto, _$identity);

  /// Serializes this CrewMemberDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrewMemberDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.job, job) || other.job == job)&&(identical(other.department, department) || other.department == department)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,job,department,profilePath);

@override
String toString() {
  return 'CrewMemberDto(id: $id, name: $name, job: $job, department: $department, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class $CrewMemberDtoCopyWith<$Res>  {
  factory $CrewMemberDtoCopyWith(CrewMemberDto value, $Res Function(CrewMemberDto) _then) = _$CrewMemberDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String job, String department,@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class _$CrewMemberDtoCopyWithImpl<$Res>
    implements $CrewMemberDtoCopyWith<$Res> {
  _$CrewMemberDtoCopyWithImpl(this._self, this._then);

  final CrewMemberDto _self;
  final $Res Function(CrewMemberDto) _then;

/// Create a copy of CrewMemberDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? job = null,Object? department = null,Object? profilePath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CrewMemberDto].
extension CrewMemberDtoPatterns on CrewMemberDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrewMemberDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrewMemberDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrewMemberDto value)  $default,){
final _that = this;
switch (_that) {
case _CrewMemberDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrewMemberDto value)?  $default,){
final _that = this;
switch (_that) {
case _CrewMemberDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String job,  String department, @JsonKey(name: 'profile_path')  String? profilePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrewMemberDto() when $default != null:
return $default(_that.id,_that.name,_that.job,_that.department,_that.profilePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String job,  String department, @JsonKey(name: 'profile_path')  String? profilePath)  $default,) {final _that = this;
switch (_that) {
case _CrewMemberDto():
return $default(_that.id,_that.name,_that.job,_that.department,_that.profilePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String job,  String department, @JsonKey(name: 'profile_path')  String? profilePath)?  $default,) {final _that = this;
switch (_that) {
case _CrewMemberDto() when $default != null:
return $default(_that.id,_that.name,_that.job,_that.department,_that.profilePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrewMemberDto extends CrewMemberDto {
  const _CrewMemberDto({required this.id, required this.name, required this.job, required this.department, @JsonKey(name: 'profile_path') this.profilePath}): super._();
  factory _CrewMemberDto.fromJson(Map<String, dynamic> json) => _$CrewMemberDtoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String job;
@override final  String department;
@override@JsonKey(name: 'profile_path') final  String? profilePath;

/// Create a copy of CrewMemberDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrewMemberDtoCopyWith<_CrewMemberDto> get copyWith => __$CrewMemberDtoCopyWithImpl<_CrewMemberDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrewMemberDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrewMemberDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.job, job) || other.job == job)&&(identical(other.department, department) || other.department == department)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,job,department,profilePath);

@override
String toString() {
  return 'CrewMemberDto(id: $id, name: $name, job: $job, department: $department, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class _$CrewMemberDtoCopyWith<$Res> implements $CrewMemberDtoCopyWith<$Res> {
  factory _$CrewMemberDtoCopyWith(_CrewMemberDto value, $Res Function(_CrewMemberDto) _then) = __$CrewMemberDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String job, String department,@JsonKey(name: 'profile_path') String? profilePath
});




}
/// @nodoc
class __$CrewMemberDtoCopyWithImpl<$Res>
    implements _$CrewMemberDtoCopyWith<$Res> {
  __$CrewMemberDtoCopyWithImpl(this._self, this._then);

  final _CrewMemberDto _self;
  final $Res Function(_CrewMemberDto) _then;

/// Create a copy of CrewMemberDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? job = null,Object? department = null,Object? profilePath = freezed,}) {
  return _then(_CrewMemberDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as String,department: null == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
