// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tvtime_raw_export.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TvTimeRawMovieRow {

 String get uuid; String get imdbId; String get tvdbId; String get title; bool get isWatched; String? get watchedAt; String? get createdAt;
/// Create a copy of TvTimeRawMovieRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeRawMovieRowCopyWith<TvTimeRawMovieRow> get copyWith => _$TvTimeRawMovieRowCopyWithImpl<TvTimeRawMovieRow>(this as TvTimeRawMovieRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeRawMovieRow&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.imdbId, imdbId) || other.imdbId == imdbId)&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.isWatched, isWatched) || other.isWatched == isWatched)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,uuid,imdbId,tvdbId,title,isWatched,watchedAt,createdAt);

@override
String toString() {
  return 'TvTimeRawMovieRow(uuid: $uuid, imdbId: $imdbId, tvdbId: $tvdbId, title: $title, isWatched: $isWatched, watchedAt: $watchedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TvTimeRawMovieRowCopyWith<$Res>  {
  factory $TvTimeRawMovieRowCopyWith(TvTimeRawMovieRow value, $Res Function(TvTimeRawMovieRow) _then) = _$TvTimeRawMovieRowCopyWithImpl;
@useResult
$Res call({
 String uuid, String imdbId, String tvdbId, String title, bool isWatched, String? watchedAt, String? createdAt
});




}
/// @nodoc
class _$TvTimeRawMovieRowCopyWithImpl<$Res>
    implements $TvTimeRawMovieRowCopyWith<$Res> {
  _$TvTimeRawMovieRowCopyWithImpl(this._self, this._then);

  final TvTimeRawMovieRow _self;
  final $Res Function(TvTimeRawMovieRow) _then;

/// Create a copy of TvTimeRawMovieRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? imdbId = null,Object? tvdbId = null,Object? title = null,Object? isWatched = null,Object? watchedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,imdbId: null == imdbId ? _self.imdbId : imdbId // ignore: cast_nullable_to_non_nullable
as String,tvdbId: null == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isWatched: null == isWatched ? _self.isWatched : isWatched // ignore: cast_nullable_to_non_nullable
as bool,watchedAt: freezed == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTimeRawMovieRow].
extension TvTimeRawMovieRowPatterns on TvTimeRawMovieRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTimeRawMovieRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTimeRawMovieRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTimeRawMovieRow value)  $default,){
final _that = this;
switch (_that) {
case _TvTimeRawMovieRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTimeRawMovieRow value)?  $default,){
final _that = this;
switch (_that) {
case _TvTimeRawMovieRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uuid,  String imdbId,  String tvdbId,  String title,  bool isWatched,  String? watchedAt,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTimeRawMovieRow() when $default != null:
return $default(_that.uuid,_that.imdbId,_that.tvdbId,_that.title,_that.isWatched,_that.watchedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uuid,  String imdbId,  String tvdbId,  String title,  bool isWatched,  String? watchedAt,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TvTimeRawMovieRow():
return $default(_that.uuid,_that.imdbId,_that.tvdbId,_that.title,_that.isWatched,_that.watchedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uuid,  String imdbId,  String tvdbId,  String title,  bool isWatched,  String? watchedAt,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TvTimeRawMovieRow() when $default != null:
return $default(_that.uuid,_that.imdbId,_that.tvdbId,_that.title,_that.isWatched,_that.watchedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _TvTimeRawMovieRow implements TvTimeRawMovieRow {
  const _TvTimeRawMovieRow({required this.uuid, required this.imdbId, required this.tvdbId, required this.title, required this.isWatched, this.watchedAt, this.createdAt});
  

@override final  String uuid;
@override final  String imdbId;
@override final  String tvdbId;
@override final  String title;
@override final  bool isWatched;
@override final  String? watchedAt;
@override final  String? createdAt;

/// Create a copy of TvTimeRawMovieRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTimeRawMovieRowCopyWith<_TvTimeRawMovieRow> get copyWith => __$TvTimeRawMovieRowCopyWithImpl<_TvTimeRawMovieRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTimeRawMovieRow&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.imdbId, imdbId) || other.imdbId == imdbId)&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.title, title) || other.title == title)&&(identical(other.isWatched, isWatched) || other.isWatched == isWatched)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,uuid,imdbId,tvdbId,title,isWatched,watchedAt,createdAt);

@override
String toString() {
  return 'TvTimeRawMovieRow(uuid: $uuid, imdbId: $imdbId, tvdbId: $tvdbId, title: $title, isWatched: $isWatched, watchedAt: $watchedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TvTimeRawMovieRowCopyWith<$Res> implements $TvTimeRawMovieRowCopyWith<$Res> {
  factory _$TvTimeRawMovieRowCopyWith(_TvTimeRawMovieRow value, $Res Function(_TvTimeRawMovieRow) _then) = __$TvTimeRawMovieRowCopyWithImpl;
@override @useResult
$Res call({
 String uuid, String imdbId, String tvdbId, String title, bool isWatched, String? watchedAt, String? createdAt
});




}
/// @nodoc
class __$TvTimeRawMovieRowCopyWithImpl<$Res>
    implements _$TvTimeRawMovieRowCopyWith<$Res> {
  __$TvTimeRawMovieRowCopyWithImpl(this._self, this._then);

  final _TvTimeRawMovieRow _self;
  final $Res Function(_TvTimeRawMovieRow) _then;

/// Create a copy of TvTimeRawMovieRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? imdbId = null,Object? tvdbId = null,Object? title = null,Object? isWatched = null,Object? watchedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_TvTimeRawMovieRow(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,imdbId: null == imdbId ? _self.imdbId : imdbId // ignore: cast_nullable_to_non_nullable
as String,tvdbId: null == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isWatched: null == isWatched ? _self.isWatched : isWatched // ignore: cast_nullable_to_non_nullable
as bool,watchedAt: freezed == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$TvTimeRawEpisodeRow {

 String get seriesTvdbId; String get seriesTitleHint; int get season; int get episode; bool get isWatched;// `special=true` indica che questa riga è una entry TVDB "special"
// (recap/OVA/extra) che collide sullo stesso (season, episode) di un
// episodio regolare nello stesso export. Vedi TvTimeArchiveParser per
// il dedup che usa questo campo.
 bool get special; String? get watchedAt;
/// Create a copy of TvTimeRawEpisodeRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeRawEpisodeRowCopyWith<TvTimeRawEpisodeRow> get copyWith => _$TvTimeRawEpisodeRowCopyWithImpl<TvTimeRawEpisodeRow>(this as TvTimeRawEpisodeRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeRawEpisodeRow&&(identical(other.seriesTvdbId, seriesTvdbId) || other.seriesTvdbId == seriesTvdbId)&&(identical(other.seriesTitleHint, seriesTitleHint) || other.seriesTitleHint == seriesTitleHint)&&(identical(other.season, season) || other.season == season)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.isWatched, isWatched) || other.isWatched == isWatched)&&(identical(other.special, special) || other.special == special)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt));
}


@override
int get hashCode => Object.hash(runtimeType,seriesTvdbId,seriesTitleHint,season,episode,isWatched,special,watchedAt);

@override
String toString() {
  return 'TvTimeRawEpisodeRow(seriesTvdbId: $seriesTvdbId, seriesTitleHint: $seriesTitleHint, season: $season, episode: $episode, isWatched: $isWatched, special: $special, watchedAt: $watchedAt)';
}


}

/// @nodoc
abstract mixin class $TvTimeRawEpisodeRowCopyWith<$Res>  {
  factory $TvTimeRawEpisodeRowCopyWith(TvTimeRawEpisodeRow value, $Res Function(TvTimeRawEpisodeRow) _then) = _$TvTimeRawEpisodeRowCopyWithImpl;
@useResult
$Res call({
 String seriesTvdbId, String seriesTitleHint, int season, int episode, bool isWatched, bool special, String? watchedAt
});




}
/// @nodoc
class _$TvTimeRawEpisodeRowCopyWithImpl<$Res>
    implements $TvTimeRawEpisodeRowCopyWith<$Res> {
  _$TvTimeRawEpisodeRowCopyWithImpl(this._self, this._then);

  final TvTimeRawEpisodeRow _self;
  final $Res Function(TvTimeRawEpisodeRow) _then;

/// Create a copy of TvTimeRawEpisodeRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seriesTvdbId = null,Object? seriesTitleHint = null,Object? season = null,Object? episode = null,Object? isWatched = null,Object? special = null,Object? watchedAt = freezed,}) {
  return _then(_self.copyWith(
seriesTvdbId: null == seriesTvdbId ? _self.seriesTvdbId : seriesTvdbId // ignore: cast_nullable_to_non_nullable
as String,seriesTitleHint: null == seriesTitleHint ? _self.seriesTitleHint : seriesTitleHint // ignore: cast_nullable_to_non_nullable
as String,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,episode: null == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as int,isWatched: null == isWatched ? _self.isWatched : isWatched // ignore: cast_nullable_to_non_nullable
as bool,special: null == special ? _self.special : special // ignore: cast_nullable_to_non_nullable
as bool,watchedAt: freezed == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTimeRawEpisodeRow].
extension TvTimeRawEpisodeRowPatterns on TvTimeRawEpisodeRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTimeRawEpisodeRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTimeRawEpisodeRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTimeRawEpisodeRow value)  $default,){
final _that = this;
switch (_that) {
case _TvTimeRawEpisodeRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTimeRawEpisodeRow value)?  $default,){
final _that = this;
switch (_that) {
case _TvTimeRawEpisodeRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String seriesTvdbId,  String seriesTitleHint,  int season,  int episode,  bool isWatched,  bool special,  String? watchedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTimeRawEpisodeRow() when $default != null:
return $default(_that.seriesTvdbId,_that.seriesTitleHint,_that.season,_that.episode,_that.isWatched,_that.special,_that.watchedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String seriesTvdbId,  String seriesTitleHint,  int season,  int episode,  bool isWatched,  bool special,  String? watchedAt)  $default,) {final _that = this;
switch (_that) {
case _TvTimeRawEpisodeRow():
return $default(_that.seriesTvdbId,_that.seriesTitleHint,_that.season,_that.episode,_that.isWatched,_that.special,_that.watchedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String seriesTvdbId,  String seriesTitleHint,  int season,  int episode,  bool isWatched,  bool special,  String? watchedAt)?  $default,) {final _that = this;
switch (_that) {
case _TvTimeRawEpisodeRow() when $default != null:
return $default(_that.seriesTvdbId,_that.seriesTitleHint,_that.season,_that.episode,_that.isWatched,_that.special,_that.watchedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TvTimeRawEpisodeRow implements TvTimeRawEpisodeRow {
  const _TvTimeRawEpisodeRow({required this.seriesTvdbId, required this.seriesTitleHint, required this.season, required this.episode, required this.isWatched, required this.special, this.watchedAt});
  

@override final  String seriesTvdbId;
@override final  String seriesTitleHint;
@override final  int season;
@override final  int episode;
@override final  bool isWatched;
// `special=true` indica che questa riga è una entry TVDB "special"
// (recap/OVA/extra) che collide sullo stesso (season, episode) di un
// episodio regolare nello stesso export. Vedi TvTimeArchiveParser per
// il dedup che usa questo campo.
@override final  bool special;
@override final  String? watchedAt;

/// Create a copy of TvTimeRawEpisodeRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTimeRawEpisodeRowCopyWith<_TvTimeRawEpisodeRow> get copyWith => __$TvTimeRawEpisodeRowCopyWithImpl<_TvTimeRawEpisodeRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTimeRawEpisodeRow&&(identical(other.seriesTvdbId, seriesTvdbId) || other.seriesTvdbId == seriesTvdbId)&&(identical(other.seriesTitleHint, seriesTitleHint) || other.seriesTitleHint == seriesTitleHint)&&(identical(other.season, season) || other.season == season)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.isWatched, isWatched) || other.isWatched == isWatched)&&(identical(other.special, special) || other.special == special)&&(identical(other.watchedAt, watchedAt) || other.watchedAt == watchedAt));
}


@override
int get hashCode => Object.hash(runtimeType,seriesTvdbId,seriesTitleHint,season,episode,isWatched,special,watchedAt);

@override
String toString() {
  return 'TvTimeRawEpisodeRow(seriesTvdbId: $seriesTvdbId, seriesTitleHint: $seriesTitleHint, season: $season, episode: $episode, isWatched: $isWatched, special: $special, watchedAt: $watchedAt)';
}


}

/// @nodoc
abstract mixin class _$TvTimeRawEpisodeRowCopyWith<$Res> implements $TvTimeRawEpisodeRowCopyWith<$Res> {
  factory _$TvTimeRawEpisodeRowCopyWith(_TvTimeRawEpisodeRow value, $Res Function(_TvTimeRawEpisodeRow) _then) = __$TvTimeRawEpisodeRowCopyWithImpl;
@override @useResult
$Res call({
 String seriesTvdbId, String seriesTitleHint, int season, int episode, bool isWatched, bool special, String? watchedAt
});




}
/// @nodoc
class __$TvTimeRawEpisodeRowCopyWithImpl<$Res>
    implements _$TvTimeRawEpisodeRowCopyWith<$Res> {
  __$TvTimeRawEpisodeRowCopyWithImpl(this._self, this._then);

  final _TvTimeRawEpisodeRow _self;
  final $Res Function(_TvTimeRawEpisodeRow) _then;

/// Create a copy of TvTimeRawEpisodeRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seriesTvdbId = null,Object? seriesTitleHint = null,Object? season = null,Object? episode = null,Object? isWatched = null,Object? special = null,Object? watchedAt = freezed,}) {
  return _then(_TvTimeRawEpisodeRow(
seriesTvdbId: null == seriesTvdbId ? _self.seriesTvdbId : seriesTvdbId // ignore: cast_nullable_to_non_nullable
as String,seriesTitleHint: null == seriesTitleHint ? _self.seriesTitleHint : seriesTitleHint // ignore: cast_nullable_to_non_nullable
as String,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,episode: null == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as int,isWatched: null == isWatched ? _self.isWatched : isWatched // ignore: cast_nullable_to_non_nullable
as bool,special: null == special ? _self.special : special // ignore: cast_nullable_to_non_nullable
as bool,watchedAt: freezed == watchedAt ? _self.watchedAt : watchedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$TvTimeRawListRow {

 String get listName; String get itemType;// "movie" | "series"
 String get uuid; String get tvdbId; String get nameHint;
/// Create a copy of TvTimeRawListRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeRawListRowCopyWith<TvTimeRawListRow> get copyWith => _$TvTimeRawListRowCopyWithImpl<TvTimeRawListRow>(this as TvTimeRawListRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeRawListRow&&(identical(other.listName, listName) || other.listName == listName)&&(identical(other.itemType, itemType) || other.itemType == itemType)&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.nameHint, nameHint) || other.nameHint == nameHint));
}


@override
int get hashCode => Object.hash(runtimeType,listName,itemType,uuid,tvdbId,nameHint);

@override
String toString() {
  return 'TvTimeRawListRow(listName: $listName, itemType: $itemType, uuid: $uuid, tvdbId: $tvdbId, nameHint: $nameHint)';
}


}

/// @nodoc
abstract mixin class $TvTimeRawListRowCopyWith<$Res>  {
  factory $TvTimeRawListRowCopyWith(TvTimeRawListRow value, $Res Function(TvTimeRawListRow) _then) = _$TvTimeRawListRowCopyWithImpl;
@useResult
$Res call({
 String listName, String itemType, String uuid, String tvdbId, String nameHint
});




}
/// @nodoc
class _$TvTimeRawListRowCopyWithImpl<$Res>
    implements $TvTimeRawListRowCopyWith<$Res> {
  _$TvTimeRawListRowCopyWithImpl(this._self, this._then);

  final TvTimeRawListRow _self;
  final $Res Function(TvTimeRawListRow) _then;

/// Create a copy of TvTimeRawListRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? listName = null,Object? itemType = null,Object? uuid = null,Object? tvdbId = null,Object? nameHint = null,}) {
  return _then(_self.copyWith(
listName: null == listName ? _self.listName : listName // ignore: cast_nullable_to_non_nullable
as String,itemType: null == itemType ? _self.itemType : itemType // ignore: cast_nullable_to_non_nullable
as String,uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,tvdbId: null == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as String,nameHint: null == nameHint ? _self.nameHint : nameHint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTimeRawListRow].
extension TvTimeRawListRowPatterns on TvTimeRawListRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTimeRawListRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTimeRawListRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTimeRawListRow value)  $default,){
final _that = this;
switch (_that) {
case _TvTimeRawListRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTimeRawListRow value)?  $default,){
final _that = this;
switch (_that) {
case _TvTimeRawListRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String listName,  String itemType,  String uuid,  String tvdbId,  String nameHint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTimeRawListRow() when $default != null:
return $default(_that.listName,_that.itemType,_that.uuid,_that.tvdbId,_that.nameHint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String listName,  String itemType,  String uuid,  String tvdbId,  String nameHint)  $default,) {final _that = this;
switch (_that) {
case _TvTimeRawListRow():
return $default(_that.listName,_that.itemType,_that.uuid,_that.tvdbId,_that.nameHint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String listName,  String itemType,  String uuid,  String tvdbId,  String nameHint)?  $default,) {final _that = this;
switch (_that) {
case _TvTimeRawListRow() when $default != null:
return $default(_that.listName,_that.itemType,_that.uuid,_that.tvdbId,_that.nameHint);case _:
  return null;

}
}

}

/// @nodoc


class _TvTimeRawListRow implements TvTimeRawListRow {
  const _TvTimeRawListRow({required this.listName, required this.itemType, required this.uuid, required this.tvdbId, required this.nameHint});
  

@override final  String listName;
@override final  String itemType;
// "movie" | "series"
@override final  String uuid;
@override final  String tvdbId;
@override final  String nameHint;

/// Create a copy of TvTimeRawListRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTimeRawListRowCopyWith<_TvTimeRawListRow> get copyWith => __$TvTimeRawListRowCopyWithImpl<_TvTimeRawListRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTimeRawListRow&&(identical(other.listName, listName) || other.listName == listName)&&(identical(other.itemType, itemType) || other.itemType == itemType)&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.nameHint, nameHint) || other.nameHint == nameHint));
}


@override
int get hashCode => Object.hash(runtimeType,listName,itemType,uuid,tvdbId,nameHint);

@override
String toString() {
  return 'TvTimeRawListRow(listName: $listName, itemType: $itemType, uuid: $uuid, tvdbId: $tvdbId, nameHint: $nameHint)';
}


}

/// @nodoc
abstract mixin class _$TvTimeRawListRowCopyWith<$Res> implements $TvTimeRawListRowCopyWith<$Res> {
  factory _$TvTimeRawListRowCopyWith(_TvTimeRawListRow value, $Res Function(_TvTimeRawListRow) _then) = __$TvTimeRawListRowCopyWithImpl;
@override @useResult
$Res call({
 String listName, String itemType, String uuid, String tvdbId, String nameHint
});




}
/// @nodoc
class __$TvTimeRawListRowCopyWithImpl<$Res>
    implements _$TvTimeRawListRowCopyWith<$Res> {
  __$TvTimeRawListRowCopyWithImpl(this._self, this._then);

  final _TvTimeRawListRow _self;
  final $Res Function(_TvTimeRawListRow) _then;

/// Create a copy of TvTimeRawListRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? listName = null,Object? itemType = null,Object? uuid = null,Object? tvdbId = null,Object? nameHint = null,}) {
  return _then(_TvTimeRawListRow(
listName: null == listName ? _self.listName : listName // ignore: cast_nullable_to_non_nullable
as String,itemType: null == itemType ? _self.itemType : itemType // ignore: cast_nullable_to_non_nullable
as String,uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,tvdbId: null == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as String,nameHint: null == nameHint ? _self.nameHint : nameHint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TvTimeRawSeriesRow {

 String get tvdbId; String get status;
/// Create a copy of TvTimeRawSeriesRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeRawSeriesRowCopyWith<TvTimeRawSeriesRow> get copyWith => _$TvTimeRawSeriesRowCopyWithImpl<TvTimeRawSeriesRow>(this as TvTimeRawSeriesRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeRawSeriesRow&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,tvdbId,status);

@override
String toString() {
  return 'TvTimeRawSeriesRow(tvdbId: $tvdbId, status: $status)';
}


}

/// @nodoc
abstract mixin class $TvTimeRawSeriesRowCopyWith<$Res>  {
  factory $TvTimeRawSeriesRowCopyWith(TvTimeRawSeriesRow value, $Res Function(TvTimeRawSeriesRow) _then) = _$TvTimeRawSeriesRowCopyWithImpl;
@useResult
$Res call({
 String tvdbId, String status
});




}
/// @nodoc
class _$TvTimeRawSeriesRowCopyWithImpl<$Res>
    implements $TvTimeRawSeriesRowCopyWith<$Res> {
  _$TvTimeRawSeriesRowCopyWithImpl(this._self, this._then);

  final TvTimeRawSeriesRow _self;
  final $Res Function(TvTimeRawSeriesRow) _then;

/// Create a copy of TvTimeRawSeriesRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tvdbId = null,Object? status = null,}) {
  return _then(_self.copyWith(
tvdbId: null == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTimeRawSeriesRow].
extension TvTimeRawSeriesRowPatterns on TvTimeRawSeriesRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTimeRawSeriesRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTimeRawSeriesRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTimeRawSeriesRow value)  $default,){
final _that = this;
switch (_that) {
case _TvTimeRawSeriesRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTimeRawSeriesRow value)?  $default,){
final _that = this;
switch (_that) {
case _TvTimeRawSeriesRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tvdbId,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTimeRawSeriesRow() when $default != null:
return $default(_that.tvdbId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tvdbId,  String status)  $default,) {final _that = this;
switch (_that) {
case _TvTimeRawSeriesRow():
return $default(_that.tvdbId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tvdbId,  String status)?  $default,) {final _that = this;
switch (_that) {
case _TvTimeRawSeriesRow() when $default != null:
return $default(_that.tvdbId,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _TvTimeRawSeriesRow implements TvTimeRawSeriesRow {
  const _TvTimeRawSeriesRow({required this.tvdbId, required this.status});
  

@override final  String tvdbId;
@override final  String status;

/// Create a copy of TvTimeRawSeriesRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTimeRawSeriesRowCopyWith<_TvTimeRawSeriesRow> get copyWith => __$TvTimeRawSeriesRowCopyWithImpl<_TvTimeRawSeriesRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTimeRawSeriesRow&&(identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,tvdbId,status);

@override
String toString() {
  return 'TvTimeRawSeriesRow(tvdbId: $tvdbId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$TvTimeRawSeriesRowCopyWith<$Res> implements $TvTimeRawSeriesRowCopyWith<$Res> {
  factory _$TvTimeRawSeriesRowCopyWith(_TvTimeRawSeriesRow value, $Res Function(_TvTimeRawSeriesRow) _then) = __$TvTimeRawSeriesRowCopyWithImpl;
@override @useResult
$Res call({
 String tvdbId, String status
});




}
/// @nodoc
class __$TvTimeRawSeriesRowCopyWithImpl<$Res>
    implements _$TvTimeRawSeriesRowCopyWith<$Res> {
  __$TvTimeRawSeriesRowCopyWithImpl(this._self, this._then);

  final _TvTimeRawSeriesRow _self;
  final $Res Function(_TvTimeRawSeriesRow) _then;

/// Create a copy of TvTimeRawSeriesRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tvdbId = null,Object? status = null,}) {
  return _then(_TvTimeRawSeriesRow(
tvdbId: null == tvdbId ? _self.tvdbId : tvdbId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TvTimeRawExport {

 List<TvTimeRawMovieRow> get movies; List<TvTimeRawEpisodeRow> get episodes; List<TvTimeRawListRow> get lists; List<TvTimeRawSeriesRow> get series;
/// Create a copy of TvTimeRawExport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TvTimeRawExportCopyWith<TvTimeRawExport> get copyWith => _$TvTimeRawExportCopyWithImpl<TvTimeRawExport>(this as TvTimeRawExport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TvTimeRawExport&&const DeepCollectionEquality().equals(other.movies, movies)&&const DeepCollectionEquality().equals(other.episodes, episodes)&&const DeepCollectionEquality().equals(other.lists, lists)&&const DeepCollectionEquality().equals(other.series, series));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(movies),const DeepCollectionEquality().hash(episodes),const DeepCollectionEquality().hash(lists),const DeepCollectionEquality().hash(series));

@override
String toString() {
  return 'TvTimeRawExport(movies: $movies, episodes: $episodes, lists: $lists, series: $series)';
}


}

/// @nodoc
abstract mixin class $TvTimeRawExportCopyWith<$Res>  {
  factory $TvTimeRawExportCopyWith(TvTimeRawExport value, $Res Function(TvTimeRawExport) _then) = _$TvTimeRawExportCopyWithImpl;
@useResult
$Res call({
 List<TvTimeRawMovieRow> movies, List<TvTimeRawEpisodeRow> episodes, List<TvTimeRawListRow> lists, List<TvTimeRawSeriesRow> series
});




}
/// @nodoc
class _$TvTimeRawExportCopyWithImpl<$Res>
    implements $TvTimeRawExportCopyWith<$Res> {
  _$TvTimeRawExportCopyWithImpl(this._self, this._then);

  final TvTimeRawExport _self;
  final $Res Function(TvTimeRawExport) _then;

/// Create a copy of TvTimeRawExport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? movies = null,Object? episodes = null,Object? lists = null,Object? series = null,}) {
  return _then(_self.copyWith(
movies: null == movies ? _self.movies : movies // ignore: cast_nullable_to_non_nullable
as List<TvTimeRawMovieRow>,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<TvTimeRawEpisodeRow>,lists: null == lists ? _self.lists : lists // ignore: cast_nullable_to_non_nullable
as List<TvTimeRawListRow>,series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as List<TvTimeRawSeriesRow>,
  ));
}

}


/// Adds pattern-matching-related methods to [TvTimeRawExport].
extension TvTimeRawExportPatterns on TvTimeRawExport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TvTimeRawExport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TvTimeRawExport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TvTimeRawExport value)  $default,){
final _that = this;
switch (_that) {
case _TvTimeRawExport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TvTimeRawExport value)?  $default,){
final _that = this;
switch (_that) {
case _TvTimeRawExport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TvTimeRawMovieRow> movies,  List<TvTimeRawEpisodeRow> episodes,  List<TvTimeRawListRow> lists,  List<TvTimeRawSeriesRow> series)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TvTimeRawExport() when $default != null:
return $default(_that.movies,_that.episodes,_that.lists,_that.series);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TvTimeRawMovieRow> movies,  List<TvTimeRawEpisodeRow> episodes,  List<TvTimeRawListRow> lists,  List<TvTimeRawSeriesRow> series)  $default,) {final _that = this;
switch (_that) {
case _TvTimeRawExport():
return $default(_that.movies,_that.episodes,_that.lists,_that.series);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TvTimeRawMovieRow> movies,  List<TvTimeRawEpisodeRow> episodes,  List<TvTimeRawListRow> lists,  List<TvTimeRawSeriesRow> series)?  $default,) {final _that = this;
switch (_that) {
case _TvTimeRawExport() when $default != null:
return $default(_that.movies,_that.episodes,_that.lists,_that.series);case _:
  return null;

}
}

}

/// @nodoc


class _TvTimeRawExport implements TvTimeRawExport {
  const _TvTimeRawExport({required final  List<TvTimeRawMovieRow> movies, required final  List<TvTimeRawEpisodeRow> episodes, required final  List<TvTimeRawListRow> lists, final  List<TvTimeRawSeriesRow> series = const []}): _movies = movies,_episodes = episodes,_lists = lists,_series = series;
  

 final  List<TvTimeRawMovieRow> _movies;
@override List<TvTimeRawMovieRow> get movies {
  if (_movies is EqualUnmodifiableListView) return _movies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_movies);
}

 final  List<TvTimeRawEpisodeRow> _episodes;
@override List<TvTimeRawEpisodeRow> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}

 final  List<TvTimeRawListRow> _lists;
@override List<TvTimeRawListRow> get lists {
  if (_lists is EqualUnmodifiableListView) return _lists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lists);
}

 final  List<TvTimeRawSeriesRow> _series;
@override@JsonKey() List<TvTimeRawSeriesRow> get series {
  if (_series is EqualUnmodifiableListView) return _series;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_series);
}


/// Create a copy of TvTimeRawExport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TvTimeRawExportCopyWith<_TvTimeRawExport> get copyWith => __$TvTimeRawExportCopyWithImpl<_TvTimeRawExport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TvTimeRawExport&&const DeepCollectionEquality().equals(other._movies, _movies)&&const DeepCollectionEquality().equals(other._episodes, _episodes)&&const DeepCollectionEquality().equals(other._lists, _lists)&&const DeepCollectionEquality().equals(other._series, _series));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_movies),const DeepCollectionEquality().hash(_episodes),const DeepCollectionEquality().hash(_lists),const DeepCollectionEquality().hash(_series));

@override
String toString() {
  return 'TvTimeRawExport(movies: $movies, episodes: $episodes, lists: $lists, series: $series)';
}


}

/// @nodoc
abstract mixin class _$TvTimeRawExportCopyWith<$Res> implements $TvTimeRawExportCopyWith<$Res> {
  factory _$TvTimeRawExportCopyWith(_TvTimeRawExport value, $Res Function(_TvTimeRawExport) _then) = __$TvTimeRawExportCopyWithImpl;
@override @useResult
$Res call({
 List<TvTimeRawMovieRow> movies, List<TvTimeRawEpisodeRow> episodes, List<TvTimeRawListRow> lists, List<TvTimeRawSeriesRow> series
});




}
/// @nodoc
class __$TvTimeRawExportCopyWithImpl<$Res>
    implements _$TvTimeRawExportCopyWith<$Res> {
  __$TvTimeRawExportCopyWithImpl(this._self, this._then);

  final _TvTimeRawExport _self;
  final $Res Function(_TvTimeRawExport) _then;

/// Create a copy of TvTimeRawExport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? movies = null,Object? episodes = null,Object? lists = null,Object? series = null,}) {
  return _then(_TvTimeRawExport(
movies: null == movies ? _self._movies : movies // ignore: cast_nullable_to_non_nullable
as List<TvTimeRawMovieRow>,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<TvTimeRawEpisodeRow>,lists: null == lists ? _self._lists : lists // ignore: cast_nullable_to_non_nullable
as List<TvTimeRawListRow>,series: null == series ? _self._series : series // ignore: cast_nullable_to_non_nullable
as List<TvTimeRawSeriesRow>,
  ));
}


}

// dart format on
