// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookings_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PagedBookings {

 List<Booking> get items;/// Empty on the last page.
 String get nextCursor; bool get loadingMore;/// Set when fetching the next page failed; the loaded items stay.
 Object? get loadMoreError;
/// Create a copy of PagedBookings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PagedBookingsCopyWith<PagedBookings> get copyWith => _$PagedBookingsCopyWithImpl<PagedBookings>(this as PagedBookings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PagedBookings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PagedBookings&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor)&&(identical(other.loadingMore, _this.loadingMore) || other.loadingMore == _this.loadingMore)&&const DeepCollectionEquality().equals(other.loadMoreError, _this.loadMoreError));
}


@override
int get hashCode {
  final _this = this as PagedBookings;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor,_this.loadingMore,const DeepCollectionEquality().hash(_this.loadMoreError));
}

@override
String toString() {
  final _this = this as PagedBookings;
  return 'PagedBookings(items: ${_this.items}, nextCursor: ${_this.nextCursor}, loadingMore: ${_this.loadingMore}, loadMoreError: ${_this.loadMoreError})';
}


}

/// @nodoc
abstract mixin class $PagedBookingsCopyWith<$Res>  {
  factory $PagedBookingsCopyWith(PagedBookings value, $Res Function(PagedBookings) _then) = _$PagedBookingsCopyWithImpl;
@useResult
$Res call({
 List<Booking> items, String nextCursor, bool loadingMore, Object? loadMoreError
});




}
/// @nodoc
class _$PagedBookingsCopyWithImpl<$Res>
    implements $PagedBookingsCopyWith<$Res> {
  _$PagedBookingsCopyWithImpl(this._self, this._then);

  final PagedBookings _self;
  final $Res Function(PagedBookings) _then;

/// Create a copy of PagedBookings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = null,Object? loadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(PagedBookings(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Booking>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError ,
  ));
}

}


/// Adds pattern-matching-related methods to [PagedBookings].
extension PagedBookingsPatterns on PagedBookings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PagedBookings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PagedBookings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PagedBookings value)  $default,){
final _that = this;
switch (_that) {
case _PagedBookings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PagedBookings value)?  $default,){
final _that = this;
switch (_that) {
case _PagedBookings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Booking> items,  String nextCursor,  bool loadingMore,  Object? loadMoreError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PagedBookings() when $default != null:
return $default(_that.items,_that.nextCursor,_that.loadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Booking> items,  String nextCursor,  bool loadingMore,  Object? loadMoreError)  $default,) {final _that = this;
switch (_that) {
case _PagedBookings():
return $default(_that.items,_that.nextCursor,_that.loadingMore,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Booking> items,  String nextCursor,  bool loadingMore,  Object? loadMoreError)?  $default,) {final _that = this;
switch (_that) {
case _PagedBookings() when $default != null:
return $default(_that.items,_that.nextCursor,_that.loadingMore,_that.loadMoreError);case _:
  return null;

}
}

}

/// @nodoc


class _PagedBookings extends PagedBookings {
  const _PagedBookings({ List<Booking> items = const <Booking>[], this.nextCursor = '', this.loadingMore = false, this.loadMoreError}): _items = items,super._();
  

 final  List<Booking> _items;
@override@JsonKey() List<Booking> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Empty on the last page.
@override@JsonKey() final  String nextCursor;
@override@JsonKey() final  bool loadingMore;
/// Set when fetching the next page failed; the loaded items stay.
@override final  Object? loadMoreError;

/// Create a copy of PagedBookings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PagedBookingsCopyWith<_PagedBookings> get copyWith => __$PagedBookingsCopyWithImpl<_PagedBookings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PagedBookings&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&const DeepCollectionEquality().equals(other.loadMoreError, loadMoreError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor,loadingMore,const DeepCollectionEquality().hash(loadMoreError));
}

@override
String toString() {
    return 'PagedBookings(items: $items, nextCursor: $nextCursor, loadingMore: $loadingMore, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class _$PagedBookingsCopyWith<$Res> implements $PagedBookingsCopyWith<$Res> {
  factory _$PagedBookingsCopyWith(_PagedBookings value, $Res Function(_PagedBookings) _then) = __$PagedBookingsCopyWithImpl;
@override @useResult
$Res call({
 List<Booking> items, String nextCursor, bool loadingMore, Object? loadMoreError
});




}
/// @nodoc
class __$PagedBookingsCopyWithImpl<$Res>
    implements _$PagedBookingsCopyWith<$Res> {
  __$PagedBookingsCopyWithImpl(this._self, this._then);

  final _PagedBookings _self;
  final $Res Function(_PagedBookings) _then;

/// Create a copy of PagedBookings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = null,Object? loadingMore = null,Object? loadMoreError = freezed,}) {
  return _then(_PagedBookings(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Booking>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError ,
  ));
}


}

// dart format on
