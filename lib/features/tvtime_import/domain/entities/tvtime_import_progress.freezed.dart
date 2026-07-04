// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tvtime_import_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TvTimeImportProgress {

 TvTimeImportPhase get phase; int get current; int get total;
/// Create a copy of TvTimeImportProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeImportProgressCopyWith<TvTimeImportProgress> get copyWith => _$TvTimeImportProgressCopyWithImpl<TvTimeImportProgress>(this as TvTimeImportProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeImportProgress&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,phase,current,total);

@override
String toString() {
  return 'TvTimeImportProgress(phase: $phase, current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class $TvTimeImportProgressCopyWith<$Res>  {
  factory $TvTimeImportProgressCopyWith(TvTimeImportProgress value, $Res Function(TvTimeImportProgress) _then) = _$TvTimeImportProgressCopyWithImpl;
@useResult
$Res call({
 TvTimeImportPhase phase, int current, int total
});




}
/// @nodoc
class _$TvTimeImportProgressCopyWithImpl<$Res>
    implements $TvTimeImportProgressCopyWith<$Res> {
  _$TvTimeImportProgressCopyWithImpl(this._self, this._then);

  final TvTimeImportProgress _self;
  final $Res Function(TvTimeImportProgress) _then;

/// Create a copy of TvTimeImportProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? current = null,Object? total = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as TvTimeImportPhase,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTimeImportProgress].
extension TvTimeImportProgressPatterns on TvTimeImportProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTimeImportProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTimeImportProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTimeImportProgress value)  $default,){
final _that = this;
switch (_that) {
case _TvTimeImportProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTimeImportProgress value)?  $default,){
final _that = this;
switch (_that) {
case _TvTimeImportProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TvTimeImportPhase phase,  int current,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTimeImportProgress() when $default != null:
return $default(_that.phase,_that.current,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TvTimeImportPhase phase,  int current,  int total)  $default,) {final _that = this;
switch (_that) {
case _TvTimeImportProgress():
return $default(_that.phase,_that.current,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TvTimeImportPhase phase,  int current,  int total)?  $default,) {final _that = this;
switch (_that) {
case _TvTimeImportProgress() when $default != null:
return $default(_that.phase,_that.current,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _TvTimeImportProgress implements TvTimeImportProgress {
  const _TvTimeImportProgress({required this.phase, required this.current, required this.total});
  

@override final  TvTimeImportPhase phase;
@override final  int current;
@override final  int total;

/// Create a copy of TvTimeImportProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTimeImportProgressCopyWith<_TvTimeImportProgress> get copyWith => __$TvTimeImportProgressCopyWithImpl<_TvTimeImportProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTimeImportProgress&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,phase,current,total);

@override
String toString() {
  return 'TvTimeImportProgress(phase: $phase, current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class _$TvTimeImportProgressCopyWith<$Res> implements $TvTimeImportProgressCopyWith<$Res> {
  factory _$TvTimeImportProgressCopyWith(_TvTimeImportProgress value, $Res Function(_TvTimeImportProgress) _then) = __$TvTimeImportProgressCopyWithImpl;
@override @useResult
$Res call({
 TvTimeImportPhase phase, int current, int total
});




}
/// @nodoc
class __$TvTimeImportProgressCopyWithImpl<$Res>
    implements _$TvTimeImportProgressCopyWith<$Res> {
  __$TvTimeImportProgressCopyWithImpl(this._self, this._then);

  final _TvTimeImportProgress _self;
  final $Res Function(_TvTimeImportProgress) _then;

/// Create a copy of TvTimeImportProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? current = null,Object? total = null,}) {
  return _then(_TvTimeImportProgress(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as TvTimeImportPhase,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
