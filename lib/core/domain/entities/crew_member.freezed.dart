// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crew_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CrewMember {

 int get id; String get name; String get job; String get department; String? get profilePath;
/// Create a copy of CrewMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrewMemberCopyWith<CrewMember> get copyWith => _$CrewMemberCopyWithImpl<CrewMember>(this as CrewMember, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrewMember&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.job, job) || other.job == job)&&(identical(other.department, department) || other.department == department)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,job,department,profilePath);

@override
String toString() {
  return 'CrewMember(id: $id, name: $name, job: $job, department: $department, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class $CrewMemberCopyWith<$Res>  {
  factory $CrewMemberCopyWith(CrewMember value, $Res Function(CrewMember) _then) = _$CrewMemberCopyWithImpl;
@useResult
$Res call({
 int id, String name, String job, String department, String? profilePath
});




}
/// @nodoc
class _$CrewMemberCopyWithImpl<$Res>
    implements $CrewMemberCopyWith<$Res> {
  _$CrewMemberCopyWithImpl(this._self, this._then);

  final CrewMember _self;
  final $Res Function(CrewMember) _then;

/// Create a copy of CrewMember
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


/// Adds pattern-matching-related methods to [CrewMember].
extension CrewMemberPatterns on CrewMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrewMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrewMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrewMember value)  $default,){
final _that = this;
switch (_that) {
case _CrewMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrewMember value)?  $default,){
final _that = this;
switch (_that) {
case _CrewMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String job,  String department,  String? profilePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrewMember() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String job,  String department,  String? profilePath)  $default,) {final _that = this;
switch (_that) {
case _CrewMember():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String job,  String department,  String? profilePath)?  $default,) {final _that = this;
switch (_that) {
case _CrewMember() when $default != null:
return $default(_that.id,_that.name,_that.job,_that.department,_that.profilePath);case _:
  return null;

}
}

}

/// @nodoc


class _CrewMember extends CrewMember {
  const _CrewMember({required this.id, required this.name, required this.job, required this.department, required this.profilePath}): super._();
  

@override final  int id;
@override final  String name;
@override final  String job;
@override final  String department;
@override final  String? profilePath;

/// Create a copy of CrewMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrewMemberCopyWith<_CrewMember> get copyWith => __$CrewMemberCopyWithImpl<_CrewMember>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrewMember&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.job, job) || other.job == job)&&(identical(other.department, department) || other.department == department)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,job,department,profilePath);

@override
String toString() {
  return 'CrewMember(id: $id, name: $name, job: $job, department: $department, profilePath: $profilePath)';
}


}

/// @nodoc
abstract mixin class _$CrewMemberCopyWith<$Res> implements $CrewMemberCopyWith<$Res> {
  factory _$CrewMemberCopyWith(_CrewMember value, $Res Function(_CrewMember) _then) = __$CrewMemberCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String job, String department, String? profilePath
});




}
/// @nodoc
class __$CrewMemberCopyWithImpl<$Res>
    implements _$CrewMemberCopyWith<$Res> {
  __$CrewMemberCopyWithImpl(this._self, this._then);

  final _CrewMember _self;
  final $Res Function(_CrewMember) _then;

/// Create a copy of CrewMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? job = null,Object? department = null,Object? profilePath = freezed,}) {
  return _then(_CrewMember(
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
