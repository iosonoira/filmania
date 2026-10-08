// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tvtime_matched_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TvTimeMatchedMovie {

 int get tmdbId; String get title; String? get posterPath; DateTime? get watchedAt;
/// Create a copy of TvTimeMatchedMovie
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeMatchedMovieCopyWith<TvTimeMatchedMovie> get copyWith => _$TvTimeMatchedMovieCopyWithImpl<TvTimeMatchedMovie>(this as TvTimeMatchedMovie, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeMatchedMovie&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt));
}


@override
int get hashCode => Object.hash(runtimeType,tmdbId,title,posterPath,watchedAt);

@override
String toString() {
  return 'TvTimeMatchedMovie(tmdbId: $tmdbId, title: $title, posterPath: $posterPath, watchedAt: $watchedAt)';
}


}

/// @nodoc
abstract mixin class $TvTimeMatchedMovieCopyWith<$Res>  {
  factory $TvTimeMatchedMovieCopyWith(TvTimeMatchedMovie value, $Res Function(TvTimeMatchedMovie) _then) = _$TvTimeMatchedMovieCopyWithImpl;
@useResult
$Res call({
 int tmdbId, String title, String? posterPath, DateTime? watchedAt
});




}
/// @nodoc
class _$TvTimeMatchedMovieCopyWithImpl<$Res>
    implements $TvTimeMatchedMovieCopyWith<$Res> {
  _$TvTimeMatchedMovieCopyWithImpl(this._self, this._then);

  final TvTimeMatchedMovie _self;
  final $Res Function(TvTimeMatchedMovie) _then;

/// Create a copy of TvTimeMatchedMovie
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tmdbId = null,Object? title = null,Object? posterPath = freezed,Object? watchedAt = freezed,}) {
  return _then(_self.copyWith(
tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,watchedAt: freezed == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTimeMatchedMovie].
extension TvTimeMatchedMoviePatterns on TvTimeMatchedMovie {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTimeMatchedMovie value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTimeMatchedMovie() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTimeMatchedMovie value)  $default,){
final _that = this;
switch (_that) {
case _TvTimeMatchedMovie():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTimeMatchedMovie value)?  $default,){
final _that = this;
switch (_that) {
case _TvTimeMatchedMovie() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tmdbId,  String title,  String? posterPath,  DateTime? watchedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTimeMatchedMovie() when $default != null:
return $default(_that.tmdbId,_that.title,_that.posterPath,_that.watchedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tmdbId,  String title,  String? posterPath,  DateTime? watchedAt)  $default,) {final _that = this;
switch (_that) {
case _TvTimeMatchedMovie():
return $default(_that.tmdbId,_that.title,_that.posterPath,_that.watchedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tmdbId,  String title,  String? posterPath,  DateTime? watchedAt)?  $default,) {final _that = this;
switch (_that) {
case _TvTimeMatchedMovie() when $default != null:
return $default(_that.tmdbId,_that.title,_that.posterPath,_that.watchedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TvTimeMatchedMovie implements TvTimeMatchedMovie {
  const _TvTimeMatchedMovie({required this.tmdbId, required this.title, this.posterPath, this.watchedAt});
  

@override final  int tmdbId;
@override final  String title;
@override final  String? posterPath;
@override final  DateTime? watchedAt;

/// Create a copy of TvTimeMatchedMovie
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTimeMatchedMovieCopyWith<_TvTimeMatchedMovie> get copyWith => __$TvTimeMatchedMovieCopyWithImpl<_TvTimeMatchedMovie>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTimeMatchedMovie&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt));
}


@override
int get hashCode => Object.hash(runtimeType,tmdbId,title,posterPath,watchedAt);

@override
String toString() {
  return 'TvTimeMatchedMovie(tmdbId: $tmdbId, title: $title, posterPath: $posterPath, watchedAt: $watchedAt)';
}


}

/// @nodoc
abstract mixin class _$TvTimeMatchedMovieCopyWith<$Res> implements $TvTimeMatchedMovieCopyWith<$Res> {
  factory _$TvTimeMatchedMovieCopyWith(_TvTimeMatchedMovie value, $Res Function(_TvTimeMatchedMovie) _then) = __$TvTimeMatchedMovieCopyWithImpl;
@override @useResult
$Res call({
 int tmdbId, String title, String? posterPath, DateTime? watchedAt
});




}
/// @nodoc
class __$TvTimeMatchedMovieCopyWithImpl<$Res>
    implements _$TvTimeMatchedMovieCopyWith<$Res> {
  __$TvTimeMatchedMovieCopyWithImpl(this._self, this._then);

  final _TvTimeMatchedMovie _self;
  final $Res Function(_TvTimeMatchedMovie) _then;

/// Create a copy of TvTimeMatchedMovie
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tmdbId = null,Object? title = null,Object? posterPath = freezed,Object? watchedAt = freezed,}) {
  return _then(_TvTimeMatchedMovie(
tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,watchedAt: freezed == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$TvTimeMatchedEpisode {

 int get seriesTmdbId; String get seriesTitle; String? get seriesPosterPath; int get seasonNumber; int get episodeNumber; DateTime? get watchedAt; bool get isDropped; bool get isWatchLater;
/// Create a copy of TvTimeMatchedEpisode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeMatchedEpisodeCopyWith<TvTimeMatchedEpisode> get copyWith => _$TvTimeMatchedEpisodeCopyWithImpl<TvTimeMatchedEpisode>(this as TvTimeMatchedEpisode, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeMatchedEpisode&&(identical(other.seriesTmdbId, seriesTmdbId) || other.seriesTmdbId == seriesTmdbId)&&(identical(other.seriesTitle, seriesTitle) || other.seriesTitle == seriesTitle)&&(identical(other.seriesPosterPath, seriesPosterPath) || other.seriesPosterPath == seriesPosterPath)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt)&&(identical(other.isDropped, isDropped) || other.isDropped == isDropped)&&(identical(other.isWatchLater, isWatchLater) || other.isWatchLater == isWatchLater));
}


@override
int get hashCode => Object.hash(runtimeType,seriesTmdbId,seriesTitle,seriesPosterPath,seasonNumber,episodeNumber,watchedAt,isDropped,isWatchLater);

@override
String toString() {
  return 'TvTimeMatchedEpisode(seriesTmdbId: $seriesTmdbId, seriesTitle: $seriesTitle, seriesPosterPath: $seriesPosterPath, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, watchedAt: $watchedAt, isDropped: $isDropped, isWatchLater: $isWatchLater)';
}


}

/// @nodoc
abstract mixin class $TvTimeMatchedEpisodeCopyWith<$Res>  {
  factory $TvTimeMatchedEpisodeCopyWith(TvTimeMatchedEpisode value, $Res Function(TvTimeMatchedEpisode) _then) = _$TvTimeMatchedEpisodeCopyWithImpl;
@useResult
$Res call({
 int seriesTmdbId, String seriesTitle, String? seriesPosterPath, int seasonNumber, int episodeNumber, DateTime? watchedAt, bool isDropped, bool isWatchLater
});




}
/// @nodoc
class _$TvTimeMatchedEpisodeCopyWithImpl<$Res>
    implements $TvTimeMatchedEpisodeCopyWith<$Res> {
  _$TvTimeMatchedEpisodeCopyWithImpl(this._self, this._then);

  final TvTimeMatchedEpisode _self;
  final $Res Function(TvTimeMatchedEpisode) _then;

/// Create a copy of TvTimeMatchedEpisode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seriesTmdbId = null,Object? seriesTitle = null,Object? seriesPosterPath = freezed,Object? seasonNumber = null,Object? episodeNumber = null,Object? watchedAt = freezed,Object? isDropped = null,Object? isWatchLater = null,}) {
  return _then(_self.copyWith(
seriesTmdbId: null == seriesTmdbId ? _self.seriesTmdbId : seriesTmdbId // ignore: cast_nullable_to_non_nullable
as int,seriesTitle: null == seriesTitle ? _self.seriesTitle : seriesTitle // ignore: cast_nullable_to_non_nullable
as String,seriesPosterPath: freezed == seriesPosterPath ? _self.seriesPosterPath : seriesPosterPath // ignore: cast_nullable_to_non_nullable
as String?,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,watchedAt: freezed == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDropped: null == isDropped ? _self.isDropped : isDropped // ignore: cast_nullable_to_non_nullable
as bool,isWatchLater: null == isWatchLater ? _self.isWatchLater : isWatchLater // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTimeMatchedEpisode].
extension TvTimeMatchedEpisodePatterns on TvTimeMatchedEpisode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTimeMatchedEpisode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTimeMatchedEpisode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTimeMatchedEpisode value)  $default,){
final _that = this;
switch (_that) {
case _TvTimeMatchedEpisode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTimeMatchedEpisode value)?  $default,){
final _that = this;
switch (_that) {
case _TvTimeMatchedEpisode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seriesTmdbId,  String seriesTitle,  String? seriesPosterPath,  int seasonNumber,  int episodeNumber,  DateTime? watchedAt,  bool isDropped,  bool isWatchLater)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTimeMatchedEpisode() when $default != null:
return $default(_that.seriesTmdbId,_that.seriesTitle,_that.seriesPosterPath,_that.seasonNumber,_that.episodeNumber,_that.watchedAt,_that.isDropped,_that.isWatchLater);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seriesTmdbId,  String seriesTitle,  String? seriesPosterPath,  int seasonNumber,  int episodeNumber,  DateTime? watchedAt,  bool isDropped,  bool isWatchLater)  $default,) {final _that = this;
switch (_that) {
case _TvTimeMatchedEpisode():
return $default(_that.seriesTmdbId,_that.seriesTitle,_that.seriesPosterPath,_that.seasonNumber,_that.episodeNumber,_that.watchedAt,_that.isDropped,_that.isWatchLater);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seriesTmdbId,  String seriesTitle,  String? seriesPosterPath,  int seasonNumber,  int episodeNumber,  DateTime? watchedAt,  bool isDropped,  bool isWatchLater)?  $default,) {final _that = this;
switch (_that) {
case _TvTimeMatchedEpisode() when $default != null:
return $default(_that.seriesTmdbId,_that.seriesTitle,_that.seriesPosterPath,_that.seasonNumber,_that.episodeNumber,_that.watchedAt,_that.isDropped,_that.isWatchLater);case _:
  return null;

}
}

}

/// @nodoc


class _TvTimeMatchedEpisode implements TvTimeMatchedEpisode {
  const _TvTimeMatchedEpisode({required this.seriesTmdbId, required this.seriesTitle, this.seriesPosterPath, required this.seasonNumber, required this.episodeNumber, this.watchedAt, this.isDropped = false, this.isWatchLater = false});
  

@override final  int seriesTmdbId;
@override final  String seriesTitle;
@override final  String? seriesPosterPath;
@override final  int seasonNumber;
@override final  int episodeNumber;
@override final  DateTime? watchedAt;
@override@JsonKey() final  bool isDropped;
@override@JsonKey() final  bool isWatchLater;

/// Create a copy of TvTimeMatchedEpisode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTimeMatchedEpisodeCopyWith<_TvTimeMatchedEpisode> get copyWith => __$TvTimeMatchedEpisodeCopyWithImpl<_TvTimeMatchedEpisode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTimeMatchedEpisode&&(identical(other.seriesTmdbId, seriesTmdbId) || other.seriesTmdbId == seriesTmdbId)&&(identical(other.seriesTitle, seriesTitle) || other.seriesTitle == seriesTitle)&&(identical(other.seriesPosterPath, seriesPosterPath) || other.seriesPosterPath == seriesPosterPath)&&(identical(other.seasonNumber, seasonNumber) || other.seasonNumber == seasonNumber)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt)&&(identical(other.isDropped, isDropped) || other.isDropped == isDropped)&&(identical(other.isWatchLater, isWatchLater) || other.isWatchLater == isWatchLater));
}


@override
int get hashCode => Object.hash(runtimeType,seriesTmdbId,seriesTitle,seriesPosterPath,seasonNumber,episodeNumber,watchedAt,isDropped,isWatchLater);

@override
String toString() {
  return 'TvTimeMatchedEpisode(seriesTmdbId: $seriesTmdbId, seriesTitle: $seriesTitle, seriesPosterPath: $seriesPosterPath, seasonNumber: $seasonNumber, episodeNumber: $episodeNumber, watchedAt: $watchedAt, isDropped: $isDropped, isWatchLater: $isWatchLater)';
}


}

/// @nodoc
abstract mixin class _$TvTimeMatchedEpisodeCopyWith<$Res> implements $TvTimeMatchedEpisodeCopyWith<$Res> {
  factory _$TvTimeMatchedEpisodeCopyWith(_TvTimeMatchedEpisode value, $Res Function(_TvTimeMatchedEpisode) _then) = __$TvTimeMatchedEpisodeCopyWithImpl;
@override @useResult
$Res call({
 int seriesTmdbId, String seriesTitle, String? seriesPosterPath, int seasonNumber, int episodeNumber, DateTime? watchedAt, bool isDropped, bool isWatchLater
});




}
/// @nodoc
class __$TvTimeMatchedEpisodeCopyWithImpl<$Res>
    implements _$TvTimeMatchedEpisodeCopyWith<$Res> {
  __$TvTimeMatchedEpisodeCopyWithImpl(this._self, this._then);

  final _TvTimeMatchedEpisode _self;
  final $Res Function(_TvTimeMatchedEpisode) _then;

/// Create a copy of TvTimeMatchedEpisode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seriesTmdbId = null,Object? seriesTitle = null,Object? seriesPosterPath = freezed,Object? seasonNumber = null,Object? episodeNumber = null,Object? watchedAt = freezed,Object? isDropped = null,Object? isWatchLater = null,}) {
  return _then(_TvTimeMatchedEpisode(
seriesTmdbId: null == seriesTmdbId ? _self.seriesTmdbId : seriesTmdbId // ignore: cast_nullable_to_non_nullable
as int,seriesTitle: null == seriesTitle ? _self.seriesTitle : seriesTitle // ignore: cast_nullable_to_non_nullable
as String,seriesPosterPath: freezed == seriesPosterPath ? _self.seriesPosterPath : seriesPosterPath // ignore: cast_nullable_to_non_nullable
as String?,seasonNumber: null == seasonNumber ? _self.seasonNumber : seasonNumber // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,watchedAt: freezed == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDropped: null == isDropped ? _self.isDropped : isDropped // ignore: cast_nullable_to_non_nullable
as bool,isWatchLater: null == isWatchLater ? _self.isWatchLater : isWatchLater // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$TvTimeMatchedListItem {

 int get tmdbId; String get title; MediaType get mediaType; String? get posterPath;
/// Create a copy of TvTimeMatchedListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeMatchedListItemCopyWith<TvTimeMatchedListItem> get copyWith => _$TvTimeMatchedListItemCopyWithImpl<TvTimeMatchedListItem>(this as TvTimeMatchedListItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeMatchedListItem&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath));
}


@override
int get hashCode => Object.hash(runtimeType,tmdbId,title,mediaType,posterPath);

@override
String toString() {
  return 'TvTimeMatchedListItem(tmdbId: $tmdbId, title: $title, mediaType: $mediaType, posterPath: $posterPath)';
}


}

/// @nodoc
abstract mixin class $TvTimeMatchedListItemCopyWith<$Res>  {
  factory $TvTimeMatchedListItemCopyWith(TvTimeMatchedListItem value, $Res Function(TvTimeMatchedListItem) _then) = _$TvTimeMatchedListItemCopyWithImpl;
@useResult
$Res call({
 int tmdbId, String title, MediaType mediaType, String? posterPath
});




}
/// @nodoc
class _$TvTimeMatchedListItemCopyWithImpl<$Res>
    implements $TvTimeMatchedListItemCopyWith<$Res> {
  _$TvTimeMatchedListItemCopyWithImpl(this._self, this._then);

  final TvTimeMatchedListItem _self;
  final $Res Function(TvTimeMatchedListItem) _then;

/// Create a copy of TvTimeMatchedListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tmdbId = null,Object? title = null,Object? mediaType = null,Object? posterPath = freezed,}) {
  return _then(_self.copyWith(
tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTimeMatchedListItem].
extension TvTimeMatchedListItemPatterns on TvTimeMatchedListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTimeMatchedListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTimeMatchedListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTimeMatchedListItem value)  $default,){
final _that = this;
switch (_that) {
case _TvTimeMatchedListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTimeMatchedListItem value)?  $default,){
final _that = this;
switch (_that) {
case _TvTimeMatchedListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tmdbId,  String title,  MediaType mediaType,  String? posterPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTimeMatchedListItem() when $default != null:
return $default(_that.tmdbId,_that.title,_that.mediaType,_that.posterPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tmdbId,  String title,  MediaType mediaType,  String? posterPath)  $default,) {final _that = this;
switch (_that) {
case _TvTimeMatchedListItem():
return $default(_that.tmdbId,_that.title,_that.mediaType,_that.posterPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tmdbId,  String title,  MediaType mediaType,  String? posterPath)?  $default,) {final _that = this;
switch (_that) {
case _TvTimeMatchedListItem() when $default != null:
return $default(_that.tmdbId,_that.title,_that.mediaType,_that.posterPath);case _:
  return null;

}
}

}

/// @nodoc


class _TvTimeMatchedListItem implements TvTimeMatchedListItem {
  const _TvTimeMatchedListItem({required this.tmdbId, required this.title, required this.mediaType, this.posterPath});
  

@override final  int tmdbId;
@override final  String title;
@override final  MediaType mediaType;
@override final  String? posterPath;

/// Create a copy of TvTimeMatchedListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTimeMatchedListItemCopyWith<_TvTimeMatchedListItem> get copyWith => __$TvTimeMatchedListItemCopyWithImpl<_TvTimeMatchedListItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTimeMatchedListItem&&(identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.posterPath, posterPath) || other.posterPath == posterPath));
}


@override
int get hashCode => Object.hash(runtimeType,tmdbId,title,mediaType,posterPath);

@override
String toString() {
  return 'TvTimeMatchedListItem(tmdbId: $tmdbId, title: $title, mediaType: $mediaType, posterPath: $posterPath)';
}


}

/// @nodoc
abstract mixin class _$TvTimeMatchedListItemCopyWith<$Res> implements $TvTimeMatchedListItemCopyWith<$Res> {
  factory _$TvTimeMatchedListItemCopyWith(_TvTimeMatchedListItem value, $Res Function(_TvTimeMatchedListItem) _then) = __$TvTimeMatchedListItemCopyWithImpl;
@override @useResult
$Res call({
 int tmdbId, String title, MediaType mediaType, String? posterPath
});




}
/// @nodoc
class __$TvTimeMatchedListItemCopyWithImpl<$Res>
    implements _$TvTimeMatchedListItemCopyWith<$Res> {
  __$TvTimeMatchedListItemCopyWithImpl(this._self, this._then);

  final _TvTimeMatchedListItem _self;
  final $Res Function(_TvTimeMatchedListItem) _then;

/// Create a copy of TvTimeMatchedListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tmdbId = null,Object? title = null,Object? mediaType = null,Object? posterPath = freezed,}) {
  return _then(_TvTimeMatchedListItem(
tmdbId: null == tmdbId ? _self.tmdbId : tmdbId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,posterPath: freezed == posterPath ? _self.posterPath : posterPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$TvTimeMatchedList {

 String get name; List<TvTimeMatchedListItem> get items;
/// Create a copy of TvTimeMatchedList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeMatchedListCopyWith<TvTimeMatchedList> get copyWith => _$TvTimeMatchedListCopyWithImpl<TvTimeMatchedList>(this as TvTimeMatchedList, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeMatchedList&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'TvTimeMatchedList(name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class $TvTimeMatchedListCopyWith<$Res>  {
  factory $TvTimeMatchedListCopyWith(TvTimeMatchedList value, $Res Function(TvTimeMatchedList) _then) = _$TvTimeMatchedListCopyWithImpl;
@useResult
$Res call({
 String name, List<TvTimeMatchedListItem> items
});




}
/// @nodoc
class _$TvTimeMatchedListCopyWithImpl<$Res>
    implements $TvTimeMatchedListCopyWith<$Res> {
  _$TvTimeMatchedListCopyWithImpl(this._self, this._then);

  final TvTimeMatchedList _self;
  final $Res Function(TvTimeMatchedList) _then;

/// Create a copy of TvTimeMatchedList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? items = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TvTimeMatchedListItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTimeMatchedList].
extension TvTimeMatchedListPatterns on TvTimeMatchedList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTimeMatchedList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTimeMatchedList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTimeMatchedList value)  $default,){
final _that = this;
switch (_that) {
case _TvTimeMatchedList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTimeMatchedList value)?  $default,){
final _that = this;
switch (_that) {
case _TvTimeMatchedList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<TvTimeMatchedListItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTimeMatchedList() when $default != null:
return $default(_that.name,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<TvTimeMatchedListItem> items)  $default,) {final _that = this;
switch (_that) {
case _TvTimeMatchedList():
return $default(_that.name,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<TvTimeMatchedListItem> items)?  $default,) {final _that = this;
switch (_that) {
case _TvTimeMatchedList() when $default != null:
return $default(_that.name,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _TvTimeMatchedList implements TvTimeMatchedList {
  const _TvTimeMatchedList({required this.name, required final  List<TvTimeMatchedListItem> items}): _items = items;
  

@override final  String name;
 final  List<TvTimeMatchedListItem> _items;
@override List<TvTimeMatchedListItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TvTimeMatchedList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTimeMatchedListCopyWith<_TvTimeMatchedList> get copyWith => __$TvTimeMatchedListCopyWithImpl<_TvTimeMatchedList>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTimeMatchedList&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TvTimeMatchedList(name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TvTimeMatchedListCopyWith<$Res> implements $TvTimeMatchedListCopyWith<$Res> {
  factory _$TvTimeMatchedListCopyWith(_TvTimeMatchedList value, $Res Function(_TvTimeMatchedList) _then) = __$TvTimeMatchedListCopyWithImpl;
@override @useResult
$Res call({
 String name, List<TvTimeMatchedListItem> items
});




}
/// @nodoc
class __$TvTimeMatchedListCopyWithImpl<$Res>
    implements _$TvTimeMatchedListCopyWith<$Res> {
  __$TvTimeMatchedListCopyWithImpl(this._self, this._then);

  final _TvTimeMatchedList _self;
  final $Res Function(_TvTimeMatchedList) _then;

/// Create a copy of TvTimeMatchedList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? items = null,}) {
  return _then(_TvTimeMatchedList(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TvTimeMatchedListItem>,
  ));
}


}

/// @nodoc
mixin _$UnmatchedTvTimeItem {

 String get type;// "movie" | "series"
 String get title; String get reason;
/// Create a copy of UnmatchedTvTimeItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnmatchedTvTimeItemCopyWith<UnmatchedTvTimeItem> get copyWith => _$UnmatchedTvTimeItemCopyWithImpl<UnmatchedTvTimeItem>(this as UnmatchedTvTimeItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnmatchedTvTimeItem&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,type,title,reason);

@override
String toString() {
  return 'UnmatchedTvTimeItem(type: $type, title: $title, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $UnmatchedTvTimeItemCopyWith<$Res>  {
  factory $UnmatchedTvTimeItemCopyWith(UnmatchedTvTimeItem value, $Res Function(UnmatchedTvTimeItem) _then) = _$UnmatchedTvTimeItemCopyWithImpl;
@useResult
$Res call({
 String type, String title, String reason
});




}
/// @nodoc
class _$UnmatchedTvTimeItemCopyWithImpl<$Res>
    implements $UnmatchedTvTimeItemCopyWith<$Res> {
  _$UnmatchedTvTimeItemCopyWithImpl(this._self, this._then);

  final UnmatchedTvTimeItem _self;
  final $Res Function(UnmatchedTvTimeItem) _then;

/// Create a copy of UnmatchedTvTimeItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? title = null,Object? reason = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UnmatchedTvTimeItem].
extension UnmatchedTvTimeItemPatterns on UnmatchedTvTimeItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnmatchedTvTimeItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnmatchedTvTimeItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnmatchedTvTimeItem value)  $default,){
final _that = this;
switch (_that) {
case _UnmatchedTvTimeItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnmatchedTvTimeItem value)?  $default,){
final _that = this;
switch (_that) {
case _UnmatchedTvTimeItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String title,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnmatchedTvTimeItem() when $default != null:
return $default(_that.type,_that.title,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String title,  String reason)  $default,) {final _that = this;
switch (_that) {
case _UnmatchedTvTimeItem():
return $default(_that.type,_that.title,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String title,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _UnmatchedTvTimeItem() when $default != null:
return $default(_that.type,_that.title,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _UnmatchedTvTimeItem implements UnmatchedTvTimeItem {
  const _UnmatchedTvTimeItem({required this.type, required this.title, required this.reason});
  

@override final  String type;
// "movie" | "series"
@override final  String title;
@override final  String reason;

/// Create a copy of UnmatchedTvTimeItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnmatchedTvTimeItemCopyWith<_UnmatchedTvTimeItem> get copyWith => __$UnmatchedTvTimeItemCopyWithImpl<_UnmatchedTvTimeItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnmatchedTvTimeItem&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,type,title,reason);

@override
String toString() {
  return 'UnmatchedTvTimeItem(type: $type, title: $title, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$UnmatchedTvTimeItemCopyWith<$Res> implements $UnmatchedTvTimeItemCopyWith<$Res> {
  factory _$UnmatchedTvTimeItemCopyWith(_UnmatchedTvTimeItem value, $Res Function(_UnmatchedTvTimeItem) _then) = __$UnmatchedTvTimeItemCopyWithImpl;
@override @useResult
$Res call({
 String type, String title, String reason
});




}
/// @nodoc
class __$UnmatchedTvTimeItemCopyWithImpl<$Res>
    implements _$UnmatchedTvTimeItemCopyWith<$Res> {
  __$UnmatchedTvTimeItemCopyWithImpl(this._self, this._then);

  final _UnmatchedTvTimeItem _self;
  final $Res Function(_UnmatchedTvTimeItem) _then;

/// Create a copy of UnmatchedTvTimeItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? title = null,Object? reason = null,}) {
  return _then(_UnmatchedTvTimeItem(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TvTimeMatchResult {

 List<TvTimeMatchedMovie> get movies; List<TvTimeMatchedEpisode> get episodes; List<TvTimeMatchedList> get lists; List<UnmatchedTvTimeItem> get unmatched;
/// Create a copy of TvTimeMatchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeMatchResultCopyWith<TvTimeMatchResult> get copyWith => _$TvTimeMatchResultCopyWithImpl<TvTimeMatchResult>(this as TvTimeMatchResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeMatchResult&&const DeepCollectionEquality().equals(other.movies, movies)&&const DeepCollectionEquality().equals(other.episodes, episodes)&&const DeepCollectionEquality().equals(other.lists, lists)&&const DeepCollectionEquality().equals(other.unmatched, unmatched));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(movies),const DeepCollectionEquality().hash(episodes),const DeepCollectionEquality().hash(lists),const DeepCollectionEquality().hash(unmatched));

@override
String toString() {
  return 'TvTimeMatchResult(movies: $movies, episodes: $episodes, lists: $lists, unmatched: $unmatched)';
}


}

/// @nodoc
abstract mixin class $TvTimeMatchResultCopyWith<$Res>  {
  factory $TvTimeMatchResultCopyWith(TvTimeMatchResult value, $Res Function(TvTimeMatchResult) _then) = _$TvTimeMatchResultCopyWithImpl;
@useResult
$Res call({
 List<TvTimeMatchedMovie> movies, List<TvTimeMatchedEpisode> episodes, List<TvTimeMatchedList> lists, List<UnmatchedTvTimeItem> unmatched
});




}
/// @nodoc
class _$TvTimeMatchResultCopyWithImpl<$Res>
    implements $TvTimeMatchResultCopyWith<$Res> {
  _$TvTimeMatchResultCopyWithImpl(this._self, this._then);

  final TvTimeMatchResult _self;
  final $Res Function(TvTimeMatchResult) _then;

/// Create a copy of TvTimeMatchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movies = null,Object? episodes = null,Object? lists = null,Object? unmatched = null,}) {
  return _then(_self.copyWith(
movies: null == movies ? _self.movies : movies // ignore: cast_nullable_to_non_nullable
as List<TvTimeMatchedMovie>,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<TvTimeMatchedEpisode>,lists: null == lists ? _self.lists : lists // ignore: cast_nullable_to_non_nullable
as List<TvTimeMatchedList>,unmatched: null == unmatched ? _self.unmatched : unmatched // ignore: cast_nullable_to_non_nullable
as List<UnmatchedTvTimeItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTimeMatchResult].
extension TvTimeMatchResultPatterns on TvTimeMatchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTimeMatchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTimeMatchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTimeMatchResult value)  $default,){
final _that = this;
switch (_that) {
case _TvTimeMatchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTimeMatchResult value)?  $default,){
final _that = this;
switch (_that) {
case _TvTimeMatchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TvTimeMatchedMovie> movies,  List<TvTimeMatchedEpisode> episodes,  List<TvTimeMatchedList> lists,  List<UnmatchedTvTimeItem> unmatched)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTimeMatchResult() when $default != null:
return $default(_that.movies,_that.episodes,_that.lists,_that.unmatched);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TvTimeMatchedMovie> movies,  List<TvTimeMatchedEpisode> episodes,  List<TvTimeMatchedList> lists,  List<UnmatchedTvTimeItem> unmatched)  $default,) {final _that = this;
switch (_that) {
case _TvTimeMatchResult():
return $default(_that.movies,_that.episodes,_that.lists,_that.unmatched);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TvTimeMatchedMovie> movies,  List<TvTimeMatchedEpisode> episodes,  List<TvTimeMatchedList> lists,  List<UnmatchedTvTimeItem> unmatched)?  $default,) {final _that = this;
switch (_that) {
case _TvTimeMatchResult() when $default != null:
return $default(_that.movies,_that.episodes,_that.lists,_that.unmatched);case _:
  return null;

}
}

}

/// @nodoc


class _TvTimeMatchResult implements TvTimeMatchResult {
  const _TvTimeMatchResult({required final  List<TvTimeMatchedMovie> movies, required final  List<TvTimeMatchedEpisode> episodes, required final  List<TvTimeMatchedList> lists, required final  List<UnmatchedTvTimeItem> unmatched}): _movies = movies,_episodes = episodes,_lists = lists,_unmatched = unmatched;
  

 final  List<TvTimeMatchedMovie> _movies;
@override List<TvTimeMatchedMovie> get movies {
  if (_movies is EqualUnmodifiableListView) return _movies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movies);
}

 final  List<TvTimeMatchedEpisode> _episodes;
@override List<TvTimeMatchedEpisode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}

 final  List<TvTimeMatchedList> _lists;
@override List<TvTimeMatchedList> get lists {
  if (_lists is EqualUnmodifiableListView) return _lists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lists);
}

 final  List<UnmatchedTvTimeItem> _unmatched;
@override List<UnmatchedTvTimeItem> get unmatched {
  if (_unmatched is EqualUnmodifiableListView) return _unmatched;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unmatched);
}


/// Create a copy of TvTimeMatchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTimeMatchResultCopyWith<_TvTimeMatchResult> get copyWith => __$TvTimeMatchResultCopyWithImpl<_TvTimeMatchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTimeMatchResult&&const DeepCollectionEquality().equals(other._movies, _movies)&&const DeepCollectionEquality().equals(other._episodes, _episodes)&&const DeepCollectionEquality().equals(other._lists, _lists)&&const DeepCollectionEquality().equals(other._unmatched, _unmatched));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_movies),const DeepCollectionEquality().hash(_episodes),const DeepCollectionEquality().hash(_lists),const DeepCollectionEquality().hash(_unmatched));

@override
String toString() {
  return 'TvTimeMatchResult(movies: $movies, episodes: $episodes, lists: $lists, unmatched: $unmatched)';
}


}

/// @nodoc
abstract mixin class _$TvTimeMatchResultCopyWith<$Res> implements $TvTimeMatchResultCopyWith<$Res> {
  factory _$TvTimeMatchResultCopyWith(_TvTimeMatchResult value, $Res Function(_TvTimeMatchResult) _then) = __$TvTimeMatchResultCopyWithImpl;
@override @useResult
$Res call({
 List<TvTimeMatchedMovie> movies, List<TvTimeMatchedEpisode> episodes, List<TvTimeMatchedList> lists, List<UnmatchedTvTimeItem> unmatched
});




}
/// @nodoc
class __$TvTimeMatchResultCopyWithImpl<$Res>
    implements _$TvTimeMatchResultCopyWith<$Res> {
  __$TvTimeMatchResultCopyWithImpl(this._self, this._then);

  final _TvTimeMatchResult _self;
  final $Res Function(_TvTimeMatchResult) _then;

/// Create a copy of TvTimeMatchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movies = null,Object? episodes = null,Object? lists = null,Object? unmatched = null,}) {
  return _then(_TvTimeMatchResult(
movies: null == movies ? _self._movies : movies // ignore: cast_nullable_to_non_nullable
as List<TvTimeMatchedMovie>,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<TvTimeMatchedEpisode>,lists: null == lists ? _self._lists : lists // ignore: cast_nullable_to_non_nullable
as List<TvTimeMatchedList>,unmatched: null == unmatched ? _self._unmatched : unmatched // ignore: cast_nullable_to_non_nullable
as List<UnmatchedTvTimeItem>,
  ));
}


}

// dart format on
