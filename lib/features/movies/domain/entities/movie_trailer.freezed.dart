// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_trailer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MovieTrailer {

 String get key; String get site; String get type;
/// Create a copy of MovieTrailer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MovieTrailerCopyWith<MovieTrailer> get copyWith => _$MovieTrailerCopyWithImpl<MovieTrailer>(this as MovieTrailer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MovieTrailer&&(identical(other.key, key) || other.key == key)&&(identical(other.site, site) || other.site == site)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,key,site,type);

@override
String toString() {
  return 'MovieTrailer(key: $key, site: $site, type: $type)';
}


}

/// @nodoc
abstract mixin class $MovieTrailerCopyWith<$Res>  {
  factory $MovieTrailerCopyWith(MovieTrailer value, $Res Function(MovieTrailer) _then) = _$MovieTrailerCopyWithImpl;
@useResult
$Res call({
 String key, String site, String type
});




}
/// @nodoc
class _$MovieTrailerCopyWithImpl<$Res>
    implements $MovieTrailerCopyWith<$Res> {
  _$MovieTrailerCopyWithImpl(this._self, this._then);

  final MovieTrailer _self;
  final $Res Function(MovieTrailer) _then;

/// Create a copy of MovieTrailer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? site = null,Object? type = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MovieTrailer].
extension MovieTrailerPatterns on MovieTrailer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MovieTrailer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MovieTrailer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MovieTrailer value)  $default,){
final _that = this;
switch (_that) {
case _MovieTrailer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MovieTrailer value)?  $default,){
final _that = this;
switch (_that) {
case _MovieTrailer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String site,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MovieTrailer() when $default != null:
return $default(_that.key,_that.site,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String site,  String type)  $default,) {final _that = this;
switch (_that) {
case _MovieTrailer():
return $default(_that.key,_that.site,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String site,  String type)?  $default,) {final _that = this;
switch (_that) {
case _MovieTrailer() when $default != null:
return $default(_that.key,_that.site,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _MovieTrailer extends MovieTrailer {
  const _MovieTrailer({required this.key, required this.site, required this.type}): super._();
  

@override final  String key;
@override final  String site;
@override final  String type;

/// Create a copy of MovieTrailer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MovieTrailerCopyWith<_MovieTrailer> get copyWith => __$MovieTrailerCopyWithImpl<_MovieTrailer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MovieTrailer&&(identical(other.key, key) || other.key == key)&&(identical(other.site, site) || other.site == site)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,key,site,type);

@override
String toString() {
  return 'MovieTrailer(key: $key, site: $site, type: $type)';
}


}

/// @nodoc
abstract mixin class _$MovieTrailerCopyWith<$Res> implements $MovieTrailerCopyWith<$Res> {
  factory _$MovieTrailerCopyWith(_MovieTrailer value, $Res Function(_MovieTrailer) _then) = __$MovieTrailerCopyWithImpl;
@override @useResult
$Res call({
 String key, String site, String type
});




}
/// @nodoc
class __$MovieTrailerCopyWithImpl<$Res>
    implements _$MovieTrailerCopyWith<$Res> {
  __$MovieTrailerCopyWithImpl(this._self, this._then);

  final _MovieTrailer _self;
  final $Res Function(_MovieTrailer) _then;

/// Create a copy of MovieTrailer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? site = null,Object? type = null,}) {
  return _then(_MovieTrailer(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,site: null == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
