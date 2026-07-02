// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_combined_credits_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonCombinedCreditsDto {

 List<PersonCreditDto> get cast; List<PersonCreditDto> get crew;
/// Create a copy of PersonCombinedCreditsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonCombinedCreditsDtoCopyWith<PersonCombinedCreditsDto> get copyWith => _$PersonCombinedCreditsDtoCopyWithImpl<PersonCombinedCreditsDto>(this as PersonCombinedCreditsDto, _$identity);

  /// Serializes this PersonCombinedCreditsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonCombinedCreditsDto&&const DeepCollectionEquality().equals(other.cast, cast)&&const DeepCollectionEquality().equals(other.crew, crew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cast),const DeepCollectionEquality().hash(crew));

@override
String toString() {
  return 'PersonCombinedCreditsDto(cast: $cast, crew: $crew)';
}


}

/// @nodoc
abstract mixin class $PersonCombinedCreditsDtoCopyWith<$Res>  {
  factory $PersonCombinedCreditsDtoCopyWith(PersonCombinedCreditsDto value, $Res Function(PersonCombinedCreditsDto) _then) = _$PersonCombinedCreditsDtoCopyWithImpl;
@useResult
$Res call({
 List<PersonCreditDto> cast, List<PersonCreditDto> crew
});




}
/// @nodoc
class _$PersonCombinedCreditsDtoCopyWithImpl<$Res>
    implements $PersonCombinedCreditsDtoCopyWith<$Res> {
  _$PersonCombinedCreditsDtoCopyWithImpl(this._self, this._then);

  final PersonCombinedCreditsDto _self;
  final $Res Function(PersonCombinedCreditsDto) _then;

/// Create a copy of PersonCombinedCreditsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cast = null,Object? crew = null,}) {
  return _then(_self.copyWith(
cast: null == cast ? _self.cast : cast // ignore: cast_nullable_to_non_nullable
as List<PersonCreditDto>,crew: null == crew ? _self.crew : crew // ignore: cast_nullable_to_non_nullable
as List<PersonCreditDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonCombinedCreditsDto].
extension PersonCombinedCreditsDtoPatterns on PersonCombinedCreditsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonCombinedCreditsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonCombinedCreditsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonCombinedCreditsDto value)  $default,){
final _that = this;
switch (_that) {
case _PersonCombinedCreditsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonCombinedCreditsDto value)?  $default,){
final _that = this;
switch (_that) {
case _PersonCombinedCreditsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PersonCreditDto> cast,  List<PersonCreditDto> crew)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonCombinedCreditsDto() when $default != null:
return $default(_that.cast,_that.crew);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PersonCreditDto> cast,  List<PersonCreditDto> crew)  $default,) {final _that = this;
switch (_that) {
case _PersonCombinedCreditsDto():
return $default(_that.cast,_that.crew);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PersonCreditDto> cast,  List<PersonCreditDto> crew)?  $default,) {final _that = this;
switch (_that) {
case _PersonCombinedCreditsDto() when $default != null:
return $default(_that.cast,_that.crew);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonCombinedCreditsDto extends PersonCombinedCreditsDto {
  const _PersonCombinedCreditsDto({final  List<PersonCreditDto> cast = const [], final  List<PersonCreditDto> crew = const []}): _cast = cast,_crew = crew,super._();
  factory _PersonCombinedCreditsDto.fromJson(Map<String, dynamic> json) => _$PersonCombinedCreditsDtoFromJson(json);

 final  List<PersonCreditDto> _cast;
@override@JsonKey() List<PersonCreditDto> get cast {
  if (_cast is EqualUnmodifiableListView) return _cast;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cast);
}

 final  List<PersonCreditDto> _crew;
@override@JsonKey() List<PersonCreditDto> get crew {
  if (_crew is EqualUnmodifiableListView) return _crew;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_crew);
}


/// Create a copy of PersonCombinedCreditsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonCombinedCreditsDtoCopyWith<_PersonCombinedCreditsDto> get copyWith => __$PersonCombinedCreditsDtoCopyWithImpl<_PersonCombinedCreditsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonCombinedCreditsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonCombinedCreditsDto&&const DeepCollectionEquality().equals(other._cast, _cast)&&const DeepCollectionEquality().equals(other._crew, _crew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cast),const DeepCollectionEquality().hash(_crew));

@override
String toString() {
  return 'PersonCombinedCreditsDto(cast: $cast, crew: $crew)';
}


}

/// @nodoc
abstract mixin class _$PersonCombinedCreditsDtoCopyWith<$Res> implements $PersonCombinedCreditsDtoCopyWith<$Res> {
  factory _$PersonCombinedCreditsDtoCopyWith(_PersonCombinedCreditsDto value, $Res Function(_PersonCombinedCreditsDto) _then) = __$PersonCombinedCreditsDtoCopyWithImpl;
@override @useResult
$Res call({
 List<PersonCreditDto> cast, List<PersonCreditDto> crew
});




}
/// @nodoc
class __$PersonCombinedCreditsDtoCopyWithImpl<$Res>
    implements _$PersonCombinedCreditsDtoCopyWith<$Res> {
  __$PersonCombinedCreditsDtoCopyWithImpl(this._self, this._then);

  final _PersonCombinedCreditsDto _self;
  final $Res Function(_PersonCombinedCreditsDto) _then;

/// Create a copy of PersonCombinedCreditsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cast = null,Object? crew = null,}) {
  return _then(_PersonCombinedCreditsDto(
cast: null == cast ? _self._cast : cast // ignore: cast_nullable_to_non_nullable
as List<PersonCreditDto>,crew: null == crew ? _self._crew : crew // ignore: cast_nullable_to_non_nullable
as List<PersonCreditDto>,
  ));
}


}

// dart format on
