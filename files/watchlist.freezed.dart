// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watchlist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Watchlist {

 String get id; String get userId; String get name; DateTime get createdAt; List<WatchlistItem> get items;
/// Create a copy of Watchlist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchlistCopyWith<Watchlist> get copyWith => _$WatchlistCopyWithImpl<Watchlist>(this as Watchlist, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Watchlist&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,name,createdAt,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'Watchlist(id: $id, userId: $userId, name: $name, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class $WatchlistCopyWith<$Res>  {
  factory $WatchlistCopyWith(Watchlist value, $Res Function(Watchlist) _then) = _$WatchlistCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, DateTime createdAt, List<WatchlistItem> items
});




}
/// @nodoc
class _$WatchlistCopyWithImpl<$Res>
    implements $WatchlistCopyWith<$Res> {
  _$WatchlistCopyWithImpl(this._self, this._then);

  final Watchlist _self;
  final $Res Function(Watchlist) _then;

/// Create a copy of Watchlist
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? createdAt = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WatchlistItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [Watchlist].
extension WatchlistPatterns on Watchlist {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Watchlist value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Watchlist() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Watchlist value)  $default,){
final _that = this;
switch (_that) {
case _Watchlist():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Watchlist value)?  $default,){
final _that = this;
switch (_that) {
case _Watchlist() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  DateTime createdAt,  List<WatchlistItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Watchlist() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  DateTime createdAt,  List<WatchlistItem> items)  $default,) {final _that = this;
switch (_that) {
case _Watchlist():
return $default(_that.id,_that.userId,_that.name,_that.createdAt,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  DateTime createdAt,  List<WatchlistItem> items)?  $default,) {final _that = this;
switch (_that) {
case _Watchlist() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.createdAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _Watchlist extends Watchlist {
  const _Watchlist({required this.id, required this.userId, required this.name, required this.createdAt, final  List<WatchlistItem> items = const []}): _items = items,super._();
  

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  DateTime createdAt;
 final  List<WatchlistItem> _items;
@override@JsonKey() List<WatchlistItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Watchlist
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchlistCopyWith<_Watchlist> get copyWith => __$WatchlistCopyWithImpl<_Watchlist>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Watchlist&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,name,createdAt,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'Watchlist(id: $id, userId: $userId, name: $name, createdAt: $createdAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$WatchlistCopyWith<$Res> implements $WatchlistCopyWith<$Res> {
  factory _$WatchlistCopyWith(_Watchlist value, $Res Function(_Watchlist) _then) = __$WatchlistCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, DateTime createdAt, List<WatchlistItem> items
});




}
/// @nodoc
class __$WatchlistCopyWithImpl<$Res>
    implements _$WatchlistCopyWith<$Res> {
  __$WatchlistCopyWithImpl(this._self, this._then);

  final _Watchlist _self;
  final $Res Function(_Watchlist) _then;

/// Create a copy of Watchlist
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? createdAt = null,Object? items = null,}) {
  return _then(_Watchlist(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<WatchlistItem>,
  ));
}


}

// dart format on
