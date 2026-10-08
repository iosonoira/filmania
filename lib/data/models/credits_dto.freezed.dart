// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credits_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreditsDto {

 List<CastMemberDto> get cast; List<CrewMemberDto> get crew;
/// Create a copy of CreditsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreditsDtoCopyWith<CreditsDto> get copyWith => _$CreditsDtoCopyWithImpl<CreditsDto>(this as CreditsDto, _$identity);

  /// Serializes this CreditsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreditsDto&&const DeepCollectionEquality().equals(other.cast, cast)&&const DeepCollectionEquality().equals(other.crew, crew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cast),const DeepCollectionEquality().hash(crew));

@override
String toString() {
  return 'CreditsDto(cast: $cast, crew: $crew)';
}


}

/// @nodoc
abstract mixin class $CreditsDtoCopyWith<$Res>  {
  factory $CreditsDtoCopyWith(CreditsDto value, $Res Function(CreditsDto) _then) = _$CreditsDtoCopyWithImpl;
@useResult
$Res call({
 List<CastMemberDto> cast, List<CrewMemberDto> crew
});




}
/// @nodoc
class _$CreditsDtoCopyWithImpl<$Res>
    implements $CreditsDtoCopyWith<$Res> {
  _$CreditsDtoCopyWithImpl(this._self, this._then);

  final CreditsDto _self;
  final $Res Function(CreditsDto) _then;

/// Create a copy of CreditsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cast = null,Object? crew = null,}) {
  return _then(_self.copyWith(
cast: null == cast ? _self.cast : cast // ignore: cast_nullable_to_non_nullable
as List<CastMemberDto>,crew: null == crew ? _self.crew : crew // ignore: cast_nullable_to_non_nullable
as List<CrewMemberDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreditsDto].
extension CreditsDtoPatterns on CreditsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreditsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreditsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreditsDto value)  $default,){
final _that = this;
switch (_that) {
case _CreditsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreditsDto value)?  $default,){
final _that = this;
switch (_that) {
case _CreditsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CastMemberDto> cast,  List<CrewMemberDto> crew)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreditsDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CastMemberDto> cast,  List<CrewMemberDto> crew)  $default,) {final _that = this;
switch (_that) {
case _CreditsDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CastMemberDto> cast,  List<CrewMemberDto> crew)?  $default,) {final _that = this;
switch (_that) {
case _CreditsDto() when $default != null:
return $default(_that.cast,_that.crew);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreditsDto extends CreditsDto {
  const _CreditsDto({final  List<CastMemberDto> cast = const [], final  List<CrewMemberDto> crew = const []}): _cast = cast,_crew = crew,super._();
  factory _CreditsDto.fromJson(Map<String, dynamic> json) => _$CreditsDtoFromJson(json);

 final  List<CastMemberDto> _cast;
@override@JsonKey() List<CastMemberDto> get cast {
  if (_cast is EqualUnmodifiableListView) return _cast;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cast);
}

 final  List<CrewMemberDto> _crew;
@override@JsonKey() List<CrewMemberDto> get crew {
  if (_crew is EqualUnmodifiableListView) return _crew;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_crew);
}


/// Create a copy of CreditsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreditsDtoCopyWith<_CreditsDto> get copyWith => __$CreditsDtoCopyWithImpl<_CreditsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreditsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreditsDto&&const DeepCollectionEquality().equals(other._cast, _cast)&&const DeepCollectionEquality().equals(other._crew, _crew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cast),const DeepCollectionEquality().hash(_crew));

@override
String toString() {
  return 'CreditsDto(cast: $cast, crew: $crew)';
}


}

/// @nodoc
abstract mixin class _$CreditsDtoCopyWith<$Res> implements $CreditsDtoCopyWith<$Res> {
  factory _$CreditsDtoCopyWith(_CreditsDto value, $Res Function(_CreditsDto) _then) = __$CreditsDtoCopyWithImpl;
@override @useResult
$Res call({
 List<CastMemberDto> cast, List<CrewMemberDto> crew
});




}
/// @nodoc
class __$CreditsDtoCopyWithImpl<$Res>
    implements _$CreditsDtoCopyWith<$Res> {
  __$CreditsDtoCopyWithImpl(this._self, this._then);

  final _CreditsDto _self;
  final $Res Function(_CreditsDto) _then;

/// Create a copy of CreditsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cast = null,Object? crew = null,}) {
  return _then(_CreditsDto(
cast: null == cast ? _self._cast : cast // ignore: cast_nullable_to_non_nullable
as List<CastMemberDto>,crew: null == crew ? _self._crew : crew // ignore: cast_nullable_to_non_nullable
as List<CrewMemberDto>,
  ));
}


}

// dart format on
