// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tvtime_import_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TvTimeImportState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeImportState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TvTimeImportState()';
}


}

/// @nodoc
class $TvTimeImportStateCopyWith<$Res>  {
$TvTimeImportStateCopyWith(TvTimeImportState _, $Res Function(TvTimeImportState) __);
}


/// Adds pattern-matching-related methods to [TvTimeImportState].
extension TvTimeImportStatePatterns on TvTimeImportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TvTimeImportIdle value)?  idle,TResult Function( TvTimeImportProcessing value)?  processing,TResult Function( TvTimeImportReady value)?  ready,TResult Function( TvTimeImportWriting value)?  writing,TResult Function( TvTimeImportDone value)?  done,TResult Function( TvTimeImportError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TvTimeImportIdle() when idle != null:
return idle(_that);case TvTimeImportProcessing() when processing != null:
return processing(_that);case TvTimeImportReady() when ready != null:
return ready(_that);case TvTimeImportWriting() when writing != null:
return writing(_that);case TvTimeImportDone() when done != null:
return done(_that);case TvTimeImportError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TvTimeImportIdle value)  idle,required TResult Function( TvTimeImportProcessing value)  processing,required TResult Function( TvTimeImportReady value)  ready,required TResult Function( TvTimeImportWriting value)  writing,required TResult Function( TvTimeImportDone value)  done,required TResult Function( TvTimeImportError value)  error,}){
final _that = this;
switch (_that) {
case TvTimeImportIdle():
return idle(_that);case TvTimeImportProcessing():
return processing(_that);case TvTimeImportReady():
return ready(_that);case TvTimeImportWriting():
return writing(_that);case TvTimeImportDone():
return done(_that);case TvTimeImportError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TvTimeImportIdle value)?  idle,TResult? Function( TvTimeImportProcessing value)?  processing,TResult? Function( TvTimeImportReady value)?  ready,TResult? Function( TvTimeImportWriting value)?  writing,TResult? Function( TvTimeImportDone value)?  done,TResult? Function( TvTimeImportError value)?  error,}){
final _that = this;
switch (_that) {
case TvTimeImportIdle() when idle != null:
return idle(_that);case TvTimeImportProcessing() when processing != null:
return processing(_that);case TvTimeImportReady() when ready != null:
return ready(_that);case TvTimeImportWriting() when writing != null:
return writing(_that);case TvTimeImportDone() when done != null:
return done(_that);case TvTimeImportError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function( TvTimeImportProgress progress)?  processing,TResult Function( TvTimeMatchResult matchResult)?  ready,TResult Function( TvTimeImportProgress progress)?  writing,TResult Function( TvTimeMatchResult matchResult)?  done,TResult Function( TvTimeImportFailure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TvTimeImportIdle() when idle != null:
return idle();case TvTimeImportProcessing() when processing != null:
return processing(_that.progress);case TvTimeImportReady() when ready != null:
return ready(_that.matchResult);case TvTimeImportWriting() when writing != null:
return writing(_that.progress);case TvTimeImportDone() when done != null:
return done(_that.matchResult);case TvTimeImportError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function( TvTimeImportProgress progress)  processing,required TResult Function( TvTimeMatchResult matchResult)  ready,required TResult Function( TvTimeImportProgress progress)  writing,required TResult Function( TvTimeMatchResult matchResult)  done,required TResult Function( TvTimeImportFailure failure)  error,}) {final _that = this;
switch (_that) {
case TvTimeImportIdle():
return idle();case TvTimeImportProcessing():
return processing(_that.progress);case TvTimeImportReady():
return ready(_that.matchResult);case TvTimeImportWriting():
return writing(_that.progress);case TvTimeImportDone():
return done(_that.matchResult);case TvTimeImportError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function( TvTimeImportProgress progress)?  processing,TResult? Function( TvTimeMatchResult matchResult)?  ready,TResult? Function( TvTimeImportProgress progress)?  writing,TResult? Function( TvTimeMatchResult matchResult)?  done,TResult? Function( TvTimeImportFailure failure)?  error,}) {final _that = this;
switch (_that) {
case TvTimeImportIdle() when idle != null:
return idle();case TvTimeImportProcessing() when processing != null:
return processing(_that.progress);case TvTimeImportReady() when ready != null:
return ready(_that.matchResult);case TvTimeImportWriting() when writing != null:
return writing(_that.progress);case TvTimeImportDone() when done != null:
return done(_that.matchResult);case TvTimeImportError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class TvTimeImportIdle implements TvTimeImportState {
  const TvTimeImportIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeImportIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TvTimeImportState.idle()';
}


}




/// @nodoc


class TvTimeImportProcessing implements TvTimeImportState {
  const TvTimeImportProcessing(this.progress);
  

 final  TvTimeImportProgress progress;

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeImportProcessingCopyWith<TvTimeImportProcessing> get copyWith => _$TvTimeImportProcessingCopyWithImpl<TvTimeImportProcessing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeImportProcessing&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,progress);

@override
String toString() {
  return 'TvTimeImportState.processing(progress: $progress)';
}


}

/// @nodoc
abstract mixin class $TvTimeImportProcessingCopyWith<$Res> implements $TvTimeImportStateCopyWith<$Res> {
  factory $TvTimeImportProcessingCopyWith(TvTimeImportProcessing value, $Res Function(TvTimeImportProcessing) _then) = _$TvTimeImportProcessingCopyWithImpl;
@useResult
$Res call({
 TvTimeImportProgress progress
});


$TvTimeImportProgressCopyWith<$Res> get progress;

}
/// @nodoc
class _$TvTimeImportProcessingCopyWithImpl<$Res>
    implements $TvTimeImportProcessingCopyWith<$Res> {
  _$TvTimeImportProcessingCopyWithImpl(this._self, this._then);

  final TvTimeImportProcessing _self;
  final $Res Function(TvTimeImportProcessing) _then;

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? progress = null,}) {
  return _then(TvTimeImportProcessing(
null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as TvTimeImportProgress,
  ));
}

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TvTimeImportProgressCopyWith<$Res> get progress {
  
  return $TvTimeImportProgressCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}

/// @nodoc


class TvTimeImportReady implements TvTimeImportState {
  const TvTimeImportReady(this.matchResult);
  

 final  TvTimeMatchResult matchResult;

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeImportReadyCopyWith<TvTimeImportReady> get copyWith => _$TvTimeImportReadyCopyWithImpl<TvTimeImportReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeImportReady&&(identical(other.matchResult, matchResult) || other.matchResult == matchResult));
}


@override
int get hashCode => Object.hash(runtimeType,matchResult);

@override
String toString() {
  return 'TvTimeImportState.ready(matchResult: $matchResult)';
}


}

/// @nodoc
abstract mixin class $TvTimeImportReadyCopyWith<$Res> implements $TvTimeImportStateCopyWith<$Res> {
  factory $TvTimeImportReadyCopyWith(TvTimeImportReady value, $Res Function(TvTimeImportReady) _then) = _$TvTimeImportReadyCopyWithImpl;
@useResult
$Res call({
 TvTimeMatchResult matchResult
});


$TvTimeMatchResultCopyWith<$Res> get matchResult;

}
/// @nodoc
class _$TvTimeImportReadyCopyWithImpl<$Res>
    implements $TvTimeImportReadyCopyWith<$Res> {
  _$TvTimeImportReadyCopyWithImpl(this._self, this._then);

  final TvTimeImportReady _self;
  final $Res Function(TvTimeImportReady) _then;

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? matchResult = null,}) {
  return _then(TvTimeImportReady(
null == matchResult ? _self.matchResult : matchResult // ignore: cast_nullable_to_non_nullable
as TvTimeMatchResult,
  ));
}

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TvTimeMatchResultCopyWith<$Res> get matchResult {
  
  return $TvTimeMatchResultCopyWith<$Res>(_self.matchResult, (value) {
    return _then(_self.copyWith(matchResult: value));
  });
}
}

/// @nodoc


class TvTimeImportWriting implements TvTimeImportState {
  const TvTimeImportWriting(this.progress);
  

 final  TvTimeImportProgress progress;

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeImportWritingCopyWith<TvTimeImportWriting> get copyWith => _$TvTimeImportWritingCopyWithImpl<TvTimeImportWriting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeImportWriting&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,progress);

@override
String toString() {
  return 'TvTimeImportState.writing(progress: $progress)';
}


}

/// @nodoc
abstract mixin class $TvTimeImportWritingCopyWith<$Res> implements $TvTimeImportStateCopyWith<$Res> {
  factory $TvTimeImportWritingCopyWith(TvTimeImportWriting value, $Res Function(TvTimeImportWriting) _then) = _$TvTimeImportWritingCopyWithImpl;
@useResult
$Res call({
 TvTimeImportProgress progress
});


$TvTimeImportProgressCopyWith<$Res> get progress;

}
/// @nodoc
class _$TvTimeImportWritingCopyWithImpl<$Res>
    implements $TvTimeImportWritingCopyWith<$Res> {
  _$TvTimeImportWritingCopyWithImpl(this._self, this._then);

  final TvTimeImportWriting _self;
  final $Res Function(TvTimeImportWriting) _then;

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? progress = null,}) {
  return _then(TvTimeImportWriting(
null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as TvTimeImportProgress,
  ));
}

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TvTimeImportProgressCopyWith<$Res> get progress {
  
  return $TvTimeImportProgressCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}

/// @nodoc


class TvTimeImportDone implements TvTimeImportState {
  const TvTimeImportDone(this.matchResult);
  

 final  TvTimeMatchResult matchResult;

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeImportDoneCopyWith<TvTimeImportDone> get copyWith => _$TvTimeImportDoneCopyWithImpl<TvTimeImportDone>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeImportDone&&(identical(other.matchResult, matchResult) || other.matchResult == matchResult));
}


@override
int get hashCode => Object.hash(runtimeType,matchResult);

@override
String toString() {
  return 'TvTimeImportState.done(matchResult: $matchResult)';
}


}

/// @nodoc
abstract mixin class $TvTimeImportDoneCopyWith<$Res> implements $TvTimeImportStateCopyWith<$Res> {
  factory $TvTimeImportDoneCopyWith(TvTimeImportDone value, $Res Function(TvTimeImportDone) _then) = _$TvTimeImportDoneCopyWithImpl;
@useResult
$Res call({
 TvTimeMatchResult matchResult
});


$TvTimeMatchResultCopyWith<$Res> get matchResult;

}
/// @nodoc
class _$TvTimeImportDoneCopyWithImpl<$Res>
    implements $TvTimeImportDoneCopyWith<$Res> {
  _$TvTimeImportDoneCopyWithImpl(this._self, this._then);

  final TvTimeImportDone _self;
  final $Res Function(TvTimeImportDone) _then;

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? matchResult = null,}) {
  return _then(TvTimeImportDone(
null == matchResult ? _self.matchResult : matchResult // ignore: cast_nullable_to_non_nullable
as TvTimeMatchResult,
  ));
}

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TvTimeMatchResultCopyWith<$Res> get matchResult {
  
  return $TvTimeMatchResultCopyWith<$Res>(_self.matchResult, (value) {
    return _then(_self.copyWith(matchResult: value));
  });
}
}

/// @nodoc


class TvTimeImportError implements TvTimeImportState {
  const TvTimeImportError(this.failure);
  

 final  TvTimeImportFailure failure;

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeImportErrorCopyWith<TvTimeImportError> get copyWith => _$TvTimeImportErrorCopyWithImpl<TvTimeImportError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeImportError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'TvTimeImportState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $TvTimeImportErrorCopyWith<$Res> implements $TvTimeImportStateCopyWith<$Res> {
  factory $TvTimeImportErrorCopyWith(TvTimeImportError value, $Res Function(TvTimeImportError) _then) = _$TvTimeImportErrorCopyWithImpl;
@useResult
$Res call({
 TvTimeImportFailure failure
});




}
/// @nodoc
class _$TvTimeImportErrorCopyWithImpl<$Res>
    implements $TvTimeImportErrorCopyWith<$Res> {
  _$TvTimeImportErrorCopyWithImpl(this._self, this._then);

  final TvTimeImportError _self;
  final $Res Function(TvTimeImportError) _then;

/// Create a copy of TvTimeImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(TvTimeImportError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as TvTimeImportFailure,
  ));
}


}

// dart format on
