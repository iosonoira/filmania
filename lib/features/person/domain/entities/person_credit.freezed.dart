// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_credit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PersonCredit {

 int get mediaId; String get title; String? get posterPath; int? get releaseYear; double get voteAverage; MediaType get mediaType;
/// Create a copy of PersonCredit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonCreditCopyWith<PersonCredit> get copyWith => _$PersonCreditCopyWithImpl<PersonCredit>(this as PersonCredit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonCredit&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}


@override
int get hashCode => Object.hash(runtimeType,mediaId,title,posterPath,releaseYear,voteAverage,mediaType);

@override
String toString() {
  return 'PersonCredit(mediaId: $mediaId, title: $title, posterPath: $posterPath, releaseYear: $releaseYear, voteAverage: $voteAverage, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class $PersonCreditCopyWith<$Res>  {
  factory $PersonCreditCopyWith(PersonCredit value, $Res Function(PersonCredit) _then) = _$PersonCreditCopyWithImpl;
@useResult
$Res call({
 int mediaId, String title, String? posterPath, int? releaseYear, double voteAverage, MediaType mediaType
});




}
/// @nodoc
class _$PersonCreditCopyWithImpl<$Res>
    implements $PersonCreditCopyWith<$Res> {
  _$PersonCreditCopyWithImpl(this._self, this._then);

  final PersonCredit _self;
  final $Res Function(PersonCredit) _then;

/// Create a copy of PersonCredit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mediaId = null,Object? title = null,Object? posterPath = freezed,Object? releaseYear = freezed,Object? voteAverage = null,Object? mediaType = null,}) {
  return _then(_self.copyWith(
mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseYear: freezed == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int?,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonCredit].
extension PersonCreditPatterns on PersonCredit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonCredit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonCredit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonCredit value)  $default,){
final _that = this;
switch (_that) {
case _PersonCredit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonCredit value)?  $default,){
final _that = this;
switch (_that) {
case _PersonCredit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int mediaId,  String title,  String? posterPath,  int? releaseYear,  double voteAverage,  MediaType mediaType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonCredit() when $default != null:
return $default(_that.mediaId,_that.title,_that.posterPath,_that.releaseYear,_that.voteAverage,_that.mediaType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int mediaId,  String title,  String? posterPath,  int? releaseYear,  double voteAverage,  MediaType mediaType)  $default,) {final _that = this;
switch (_that) {
case _PersonCredit():
return $default(_that.mediaId,_that.title,_that.posterPath,_that.releaseYear,_that.voteAverage,_that.mediaType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int mediaId,  String title,  String? posterPath,  int? releaseYear,  double voteAverage,  MediaType mediaType)?  $default,) {final _that = this;
switch (_that) {
case _PersonCredit() when $default != null:
return $default(_that.mediaId,_that.title,_that.posterPath,_that.releaseYear,_that.voteAverage,_that.mediaType);case _:
  return null;

}
}

}

/// @nodoc


class _PersonCredit extends PersonCredit {
  const _PersonCredit({required this.mediaId, required this.title, required this.posterPath, required this.releaseYear, required this.voteAverage, required this.mediaType}): super._();
  

@override final  int mediaId;
@override final  String title;
@override final  String? posterPath;
@override final  int? releaseYear;
@override final  double voteAverage;
@override final  MediaType mediaType;

/// Create a copy of PersonCredit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonCreditCopyWith<_PersonCredit> get copyWith => __$PersonCreditCopyWithImpl<_PersonCredit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonCredit&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}


@override
int get hashCode => Object.hash(runtimeType,mediaId,title,posterPath,releaseYear,voteAverage,mediaType);

@override
String toString() {
  return 'PersonCredit(mediaId: $mediaId, title: $title, posterPath: $posterPath, releaseYear: $releaseYear, voteAverage: $voteAverage, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class _$PersonCreditCopyWith<$Res> implements $PersonCreditCopyWith<$Res> {
  factory _$PersonCreditCopyWith(_PersonCredit value, $Res Function(_PersonCredit) _then) = __$PersonCreditCopyWithImpl;
@override @useResult
$Res call({
 int mediaId, String title, String? posterPath, int? releaseYear, double voteAverage, MediaType mediaType
});




}
/// @nodoc
class __$PersonCreditCopyWithImpl<$Res>
    implements _$PersonCreditCopyWith<$Res> {
  __$PersonCreditCopyWithImpl(this._self, this._then);

  final _PersonCredit _self;
  final $Res Function(_PersonCredit) _then;

/// Create a copy of PersonCredit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mediaId = null,Object? title = null,Object? posterPath = freezed,Object? releaseYear = freezed,Object? voteAverage = null,Object? mediaType = null,}) {
  return _then(_PersonCredit(
mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,releaseYear: freezed == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int?,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,
  ));
}


}

// dart format on
