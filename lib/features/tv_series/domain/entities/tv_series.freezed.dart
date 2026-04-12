// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TVSeries {

 int get id; String get name; String get overview; String? get posterPath; String? get backdropPath; DateTime? get firstAirDate; double get voteAverage;
/// Create a copy of TVSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TVSeriesCopyWith<TVSeries> get copyWith => _$TVSeriesCopyWithImpl<TVSeries>(this as TVSeries, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TVSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,overview,posterPath,backdropPath,firstAirDate,voteAverage);

@override
String toString() {
  return 'TVSeries(id: $id, name: $name, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, firstAirDate: $firstAirDate, voteAverage: $voteAverage)';
}


}

/// @nodoc
abstract mixin class $TVSeriesCopyWith<$Res>  {
  factory $TVSeriesCopyWith(TVSeries value, $Res Function(TVSeries) _then) = _$TVSeriesCopyWithImpl;
@useResult
$Res call({
 int id, String name, String overview, String? posterPath, String? backdropPath, DateTime? firstAirDate, double voteAverage
});




}
/// @nodoc
class _$TVSeriesCopyWithImpl<$Res>
    implements $TVSeriesCopyWith<$Res> {
  _$TVSeriesCopyWithImpl(this._self, this._then);

  final TVSeries _self;
  final $Res Function(TVSeries) _then;

/// Create a copy of TVSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? overview = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? firstAirDate = freezed,Object? voteAverage = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as DateTime?,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TVSeries].
extension TVSeriesPatterns on TVSeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TVSeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TVSeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TVSeries value)  $default,){
final _that = this;
switch (_that) {
case _TVSeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TVSeries value)?  $default,){
final _that = this;
switch (_that) {
case _TVSeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String overview,  String? posterPath,  String? backdropPath,  DateTime? firstAirDate,  double voteAverage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TVSeries() when $default != null:
return $default(_that.id,_that.name,_that.overview,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.voteAverage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String overview,  String? posterPath,  String? backdropPath,  DateTime? firstAirDate,  double voteAverage)  $default,) {final _that = this;
switch (_that) {
case _TVSeries():
return $default(_that.id,_that.name,_that.overview,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.voteAverage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String overview,  String? posterPath,  String? backdropPath,  DateTime? firstAirDate,  double voteAverage)?  $default,) {final _that = this;
switch (_that) {
case _TVSeries() when $default != null:
return $default(_that.id,_that.name,_that.overview,_that.posterPath,_that.backdropPath,_that.firstAirDate,_that.voteAverage);case _:
  return null;

}
}

}

/// @nodoc


class _TVSeries extends TVSeries {
  const _TVSeries({required this.id, required this.name, required this.overview, required this.posterPath, required this.backdropPath, required this.firstAirDate, required this.voteAverage}): super._();
  

@override final  int id;
@override final  String name;
@override final  String overview;
@override final  String? posterPath;
@override final  String? backdropPath;
@override final  DateTime? firstAirDate;
@override final  double voteAverage;

/// Create a copy of TVSeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TVSeriesCopyWith<_TVSeries> get copyWith => __$TVSeriesCopyWithImpl<_TVSeries>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TVSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.backdropPath, backdropPath) || other.backdropPath == backdropPath)&&(identical(other.firstAirDate, firstAirDate) || other.firstAirDate == firstAirDate)&&(identical(other.voteAverage, voteAverage) || other.voteAverage == voteAverage));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,overview,posterPath,backdropPath,firstAirDate,voteAverage);

@override
String toString() {
  return 'TVSeries(id: $id, name: $name, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, firstAirDate: $firstAirDate, voteAverage: $voteAverage)';
}


}

/// @nodoc
abstract mixin class _$TVSeriesCopyWith<$Res> implements $TVSeriesCopyWith<$Res> {
  factory _$TVSeriesCopyWith(_TVSeries value, $Res Function(_TVSeries) _then) = __$TVSeriesCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String overview, String? posterPath, String? backdropPath, DateTime? firstAirDate, double voteAverage
});




}
/// @nodoc
class __$TVSeriesCopyWithImpl<$Res>
    implements _$TVSeriesCopyWith<$Res> {
  __$TVSeriesCopyWithImpl(this._self, this._then);

  final _TVSeries _self;
  final $Res Function(_TVSeries) _then;

/// Create a copy of TVSeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? overview = null,Object? posterPath = freezed,Object? backdropPath = freezed,Object? firstAirDate = freezed,Object? voteAverage = null,}) {
  return _then(_TVSeries(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,backdropPath: freezed == backdropPath ? _self.backdropPath : backdropPath // ignore: cast_nullable_to_non_nullable
as String?,firstAirDate: freezed == firstAirDate ? _self.firstAirDate : firstAirDate // ignore: cast_nullable_to_non_nullable
as DateTime?,voteAverage: null == voteAverage ? _self.voteAverage : voteAverage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
