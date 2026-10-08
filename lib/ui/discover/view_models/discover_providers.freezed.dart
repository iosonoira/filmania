// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoverFilters {

 Set<int> get genreIds; int? get yearFrom; int? get yearTo;
/// Create a copy of DiscoverFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoverFiltersCopyWith<DiscoverFilters> get copyWith => _$DiscoverFiltersCopyWithImpl<DiscoverFilters>(this as DiscoverFilters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoverFilters&&const DeepCollectionEquality().equals(other.genreIds, genreIds)&&(identical(other.yearFrom, yearFrom) || other.yearFrom == yearFrom)&&(identical(other.yearTo, yearTo) || other.yearTo == yearTo));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(genreIds),yearFrom,yearTo);

@override
String toString() {
  return 'DiscoverFilters(genreIds: $genreIds, yearFrom: $yearFrom, yearTo: $yearTo)';
}


}

/// @nodoc
abstract mixin class $DiscoverFiltersCopyWith<$Res>  {
  factory $DiscoverFiltersCopyWith(DiscoverFilters value, $Res Function(DiscoverFilters) _then) = _$DiscoverFiltersCopyWithImpl;
@useResult
$Res call({
 Set<int> genreIds, int? yearFrom, int? yearTo
});




}
/// @nodoc
class _$DiscoverFiltersCopyWithImpl<$Res>
    implements $DiscoverFiltersCopyWith<$Res> {
  _$DiscoverFiltersCopyWithImpl(this._self, this._then);

  final DiscoverFilters _self;
  final $Res Function(DiscoverFilters) _then;

/// Create a copy of DiscoverFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genreIds = null,Object? yearFrom = freezed,Object? yearTo = freezed,}) {
  return _then(_self.copyWith(
genreIds: null == genreIds ? _self.genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as Set<int>,yearFrom: freezed == yearFrom ? _self.yearFrom : yearFrom // ignore: cast_nullable_to_non_nullable
as int?,yearTo: freezed == yearTo ? _self.yearTo : yearTo // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoverFilters].
extension DiscoverFiltersPatterns on DiscoverFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoverFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoverFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoverFilters value)  $default,){
final _that = this;
switch (_that) {
case _DiscoverFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoverFilters value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoverFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<int> genreIds,  int? yearFrom,  int? yearTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoverFilters() when $default != null:
return $default(_that.genreIds,_that.yearFrom,_that.yearTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<int> genreIds,  int? yearFrom,  int? yearTo)  $default,) {final _that = this;
switch (_that) {
case _DiscoverFilters():
return $default(_that.genreIds,_that.yearFrom,_that.yearTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<int> genreIds,  int? yearFrom,  int? yearTo)?  $default,) {final _that = this;
switch (_that) {
case _DiscoverFilters() when $default != null:
return $default(_that.genreIds,_that.yearFrom,_that.yearTo);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoverFilters extends DiscoverFilters {
  const _DiscoverFilters({final  Set<int> genreIds = const <int>{}, this.yearFrom, this.yearTo}): _genreIds = genreIds,super._();
  

 final  Set<int> _genreIds;
@override@JsonKey() Set<int> get genreIds {
  if (_genreIds is EqualUnmodifiableSetView) return _genreIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_genreIds);
}

@override final  int? yearFrom;
@override final  int? yearTo;

/// Create a copy of DiscoverFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoverFiltersCopyWith<_DiscoverFilters> get copyWith => __$DiscoverFiltersCopyWithImpl<_DiscoverFilters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoverFilters&&const DeepCollectionEquality().equals(other._genreIds, _genreIds)&&(identical(other.yearFrom, yearFrom) || other.yearFrom == yearFrom)&&(identical(other.yearTo, yearTo) || other.yearTo == yearTo));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_genreIds),yearFrom,yearTo);

@override
String toString() {
  return 'DiscoverFilters(genreIds: $genreIds, yearFrom: $yearFrom, yearTo: $yearTo)';
}


}

/// @nodoc
abstract mixin class _$DiscoverFiltersCopyWith<$Res> implements $DiscoverFiltersCopyWith<$Res> {
  factory _$DiscoverFiltersCopyWith(_DiscoverFilters value, $Res Function(_DiscoverFilters) _then) = __$DiscoverFiltersCopyWithImpl;
@override @useResult
$Res call({
 Set<int> genreIds, int? yearFrom, int? yearTo
});




}
/// @nodoc
class __$DiscoverFiltersCopyWithImpl<$Res>
    implements _$DiscoverFiltersCopyWith<$Res> {
  __$DiscoverFiltersCopyWithImpl(this._self, this._then);

  final _DiscoverFilters _self;
  final $Res Function(_DiscoverFilters) _then;

/// Create a copy of DiscoverFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genreIds = null,Object? yearFrom = freezed,Object? yearTo = freezed,}) {
  return _then(_DiscoverFilters(
genreIds: null == genreIds ? _self._genreIds : genreIds // ignore: cast_nullable_to_non_nullable
as Set<int>,yearFrom: freezed == yearFrom ? _self.yearFrom : yearFrom // ignore: cast_nullable_to_non_nullable
as int?,yearTo: freezed == yearTo ? _self.yearTo : yearTo // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
