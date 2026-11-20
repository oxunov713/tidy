// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingEvent {

 BookingStatus get status; DateTime get at;/// Who did it; null when the system did (for example payment confirmed).
 String? get actorId;
/// Create a copy of BookingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingEventCopyWith<BookingEvent> get copyWith => _$BookingEventCopyWithImpl<BookingEvent>(this as BookingEvent, _$identity);

  /// Serializes this BookingEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingEvent&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.actorId, _this.actorId) || other.actorId == _this.actorId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingEvent;
  return Object.hash(runtimeType,_this.status,_this.at,_this.actorId);
}

@override
String toString() {
  final _this = this as BookingEvent;
  return 'BookingEvent(status: ${_this.status}, at: ${_this.at}, actorId: ${_this.actorId})';
}


}

/// @nodoc
abstract mixin class $BookingEventCopyWith<$Res>  {
  factory $BookingEventCopyWith(BookingEvent value, $Res Function(BookingEvent) _then) = _$BookingEventCopyWithImpl;
@useResult
$Res call({
 BookingStatus status, DateTime at, String? actorId
});




}
/// @nodoc
class _$BookingEventCopyWithImpl<$Res>
    implements $BookingEventCopyWith<$Res> {
  _$BookingEventCopyWithImpl(this._self, this._then);

  final BookingEvent _self;
  final $Res Function(BookingEvent) _then;

/// Create a copy of BookingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? at = null,Object? actorId = freezed,}) {
  return _then(BookingEvent(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,actorId: freezed == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingEvent].
extension BookingEventPatterns on BookingEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingEvent value)  $default,){
final _that = this;
switch (_that) {
case _BookingEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingEvent value)?  $default,){
final _that = this;
switch (_that) {
case _BookingEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BookingStatus status,  DateTime at,  String? actorId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingEvent() when $default != null:
return $default(_that.status,_that.at,_that.actorId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BookingStatus status,  DateTime at,  String? actorId)  $default,) {final _that = this;
switch (_that) {
case _BookingEvent():
return $default(_that.status,_that.at,_that.actorId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BookingStatus status,  DateTime at,  String? actorId)?  $default,) {final _that = this;
switch (_that) {
case _BookingEvent() when $default != null:
return $default(_that.status,_that.at,_that.actorId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingEvent implements BookingEvent {
  const _BookingEvent({required this.status, required this.at, this.actorId});
  factory _BookingEvent.fromJson(Map<String, dynamic> json) => _$BookingEventFromJson(json);

@override final  BookingStatus status;
@override final  DateTime at;
/// Who did it; null when the system did (for example payment confirmed).
@override final  String? actorId;

/// Create a copy of BookingEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingEventCopyWith<_BookingEvent> get copyWith => __$BookingEventCopyWithImpl<_BookingEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingEvent&&(identical(other.status, status) || other.status == status)&&(identical(other.at, at) || other.at == at)&&(identical(other.actorId, actorId) || other.actorId == actorId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,at,actorId);
}

@override
String toString() {
    return 'BookingEvent(status: $status, at: $at, actorId: $actorId)';
}


}

/// @nodoc
abstract mixin class _$BookingEventCopyWith<$Res> implements $BookingEventCopyWith<$Res> {
  factory _$BookingEventCopyWith(_BookingEvent value, $Res Function(_BookingEvent) _then) = __$BookingEventCopyWithImpl;
@override @useResult
$Res call({
 BookingStatus status, DateTime at, String? actorId
});




}
/// @nodoc
class __$BookingEventCopyWithImpl<$Res>
    implements _$BookingEventCopyWith<$Res> {
  __$BookingEventCopyWithImpl(this._self, this._then);

  final _BookingEvent _self;
  final $Res Function(_BookingEvent) _then;

/// Create a copy of BookingEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? at = null,Object? actorId = freezed,}) {
  return _then(_BookingEvent(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,actorId: freezed == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CleanerLocation {

 double get lat; double get lng; DateTime get at;
/// Create a copy of CleanerLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CleanerLocationCopyWith<CleanerLocation> get copyWith => _$CleanerLocationCopyWithImpl<CleanerLocation>(this as CleanerLocation, _$identity);

  /// Serializes this CleanerLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CleanerLocation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CleanerLocation&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.at, _this.at) || other.at == _this.at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CleanerLocation;
  return Object.hash(runtimeType,_this.lat,_this.lng,_this.at);
}

@override
String toString() {
  final _this = this as CleanerLocation;
  return 'CleanerLocation(lat: ${_this.lat}, lng: ${_this.lng}, at: ${_this.at})';
}


}

/// @nodoc
abstract mixin class $CleanerLocationCopyWith<$Res>  {
  factory $CleanerLocationCopyWith(CleanerLocation value, $Res Function(CleanerLocation) _then) = _$CleanerLocationCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, DateTime at
});




}
/// @nodoc
class _$CleanerLocationCopyWithImpl<$Res>
    implements $CleanerLocationCopyWith<$Res> {
  _$CleanerLocationCopyWithImpl(this._self, this._then);

  final CleanerLocation _self;
  final $Res Function(CleanerLocation) _then;

/// Create a copy of CleanerLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? at = null,}) {
  return _then(CleanerLocation(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CleanerLocation].
extension CleanerLocationPatterns on CleanerLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CleanerLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CleanerLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CleanerLocation value)  $default,){
final _that = this;
switch (_that) {
case _CleanerLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CleanerLocation value)?  $default,){
final _that = this;
switch (_that) {
case _CleanerLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CleanerLocation() when $default != null:
return $default(_that.lat,_that.lng,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _CleanerLocation():
return $default(_that.lat,_that.lng,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _CleanerLocation() when $default != null:
return $default(_that.lat,_that.lng,_that.at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CleanerLocation implements CleanerLocation {
  const _CleanerLocation({required this.lat, required this.lng, required this.at});
  factory _CleanerLocation.fromJson(Map<String, dynamic> json) => _$CleanerLocationFromJson(json);

@override final  double lat;
@override final  double lng;
@override final  DateTime at;

/// Create a copy of CleanerLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CleanerLocationCopyWith<_CleanerLocation> get copyWith => __$CleanerLocationCopyWithImpl<_CleanerLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CleanerLocationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CleanerLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,lat,lng,at);
}

@override
String toString() {
    return 'CleanerLocation(lat: $lat, lng: $lng, at: $at)';
}


}

/// @nodoc
abstract mixin class _$CleanerLocationCopyWith<$Res> implements $CleanerLocationCopyWith<$Res> {
  factory _$CleanerLocationCopyWith(_CleanerLocation value, $Res Function(_CleanerLocation) _then) = __$CleanerLocationCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, DateTime at
});




}
/// @nodoc
class __$CleanerLocationCopyWithImpl<$Res>
    implements _$CleanerLocationCopyWith<$Res> {
  __$CleanerLocationCopyWithImpl(this._self, this._then);

  final _CleanerLocation _self;
  final $Res Function(_CleanerLocation) _then;

/// Create a copy of CleanerLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? at = null,}) {
  return _then(_CleanerLocation(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$BookingExtra {

/// The id of the extra in the catalogue.
 String get id; String get title;/// Pence.
 int get price;
/// Create a copy of BookingExtra
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingExtraCopyWith<BookingExtra> get copyWith => _$BookingExtraCopyWithImpl<BookingExtra>(this as BookingExtra, _$identity);

  /// Serializes this BookingExtra to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingExtra;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingExtra&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.price, _this.price) || other.price == _this.price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingExtra;
  return Object.hash(runtimeType,_this.id,_this.title,_this.price);
}

@override
String toString() {
  final _this = this as BookingExtra;
  return 'BookingExtra(id: ${_this.id}, title: ${_this.title}, price: ${_this.price})';
}


}

/// @nodoc
abstract mixin class $BookingExtraCopyWith<$Res>  {
  factory $BookingExtraCopyWith(BookingExtra value, $Res Function(BookingExtra) _then) = _$BookingExtraCopyWithImpl;
@useResult
$Res call({
 String id, String title, int price
});




}
/// @nodoc
class _$BookingExtraCopyWithImpl<$Res>
    implements $BookingExtraCopyWith<$Res> {
  _$BookingExtraCopyWithImpl(this._self, this._then);

  final BookingExtra _self;
  final $Res Function(BookingExtra) _then;

/// Create a copy of BookingExtra
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? price = null,}) {
  return _then(BookingExtra(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingExtra].
extension BookingExtraPatterns on BookingExtra {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingExtra value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingExtra() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingExtra value)  $default,){
final _that = this;
switch (_that) {
case _BookingExtra():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingExtra value)?  $default,){
final _that = this;
switch (_that) {
case _BookingExtra() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  int price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingExtra() when $default != null:
return $default(_that.id,_that.title,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  int price)  $default,) {final _that = this;
switch (_that) {
case _BookingExtra():
return $default(_that.id,_that.title,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  int price)?  $default,) {final _that = this;
switch (_that) {
case _BookingExtra() when $default != null:
return $default(_that.id,_that.title,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingExtra implements BookingExtra {
  const _BookingExtra({required this.id, required this.title, required this.price});
  factory _BookingExtra.fromJson(Map<String, dynamic> json) => _$BookingExtraFromJson(json);

/// The id of the extra in the catalogue.
@override final  String id;
@override final  String title;
/// Pence.
@override final  int price;

/// Create a copy of BookingExtra
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingExtraCopyWith<_BookingExtra> get copyWith => __$BookingExtraCopyWithImpl<_BookingExtra>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingExtraToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingExtra&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,price);
}

@override
String toString() {
    return 'BookingExtra(id: $id, title: $title, price: $price)';
}


}

/// @nodoc
abstract mixin class _$BookingExtraCopyWith<$Res> implements $BookingExtraCopyWith<$Res> {
  factory _$BookingExtraCopyWith(_BookingExtra value, $Res Function(_BookingExtra) _then) = __$BookingExtraCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, int price
});




}
/// @nodoc
class __$BookingExtraCopyWithImpl<$Res>
    implements _$BookingExtraCopyWith<$Res> {
  __$BookingExtraCopyWithImpl(this._self, this._then);

  final _BookingExtra _self;
  final $Res Function(_BookingExtra) _then;

/// Create a copy of BookingExtra
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? price = null,}) {
  return _then(_BookingExtra(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Booking {

 String get id;/// Human friendly reference, e.g. `TD-1042`.
 String get code; String get clientId; String get serviceId; String get serviceTitle; String get addressId; int get bedrooms; int get bathrooms; Frequency get frequency; DateTime get start; DateTime get end; BookingStatus get status; int get subtotal; int get discount; int get total;/// What the cleaner earns, before tips.
 int get cleanerPayout; DateTime get createdAt; DateTime get updatedAt;/// Null until a cleaner accepts.
 String? get cleanerId;/// Set when the client picked a cleaner by name.
 String? get requestedCleanerId;/// Set for recurring bookings.
 String? get planId; List<BookingExtra> get extras;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Booking;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.clientId, _this.clientId) || other.clientId == _this.clientId)&&(identical(other.serviceId, _this.serviceId) || other.serviceId == _this.serviceId)&&(identical(other.serviceTitle, _this.serviceTitle) || other.serviceTitle == _this.serviceTitle)&&(identical(other.addressId, _this.addressId) || other.addressId == _this.addressId)&&(identical(other.bedrooms, _this.bedrooms) || other.bedrooms == _this.bedrooms)&&(identical(other.bathrooms, _this.bathrooms) || other.bathrooms == _this.bathrooms)&&(identical(other.frequency, _this.frequency) || other.frequency == _this.frequency)&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal)&&(identical(other.discount, _this.discount) || other.discount == _this.discount)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.cleanerPayout, _this.cleanerPayout) || other.cleanerPayout == _this.cleanerPayout)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.cleanerId, _this.cleanerId) || other.cleanerId == _this.cleanerId)&&(identical(other.requestedCleanerId, _this.requestedCleanerId) || other.requestedCleanerId == _this.requestedCleanerId)&&(identical(other.planId, _this.planId) || other.planId == _this.planId)&&const DeepCollectionEquality().equals(other.extras, _this.extras));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Booking;
  return Object.hashAll([runtimeType,_this.id,_this.code,_this.clientId,_this.serviceId,_this.serviceTitle,_this.addressId,_this.bedrooms,_this.bathrooms,_this.frequency,_this.start,_this.end,_this.status,_this.subtotal,_this.discount,_this.total,_this.cleanerPayout,_this.createdAt,_this.updatedAt,_this.cleanerId,_this.requestedCleanerId,_this.planId,const DeepCollectionEquality().hash(_this.extras)]);
}

@override
String toString() {
  final _this = this as Booking;
  return 'Booking(id: ${_this.id}, code: ${_this.code}, clientId: ${_this.clientId}, serviceId: ${_this.serviceId}, serviceTitle: ${_this.serviceTitle}, addressId: ${_this.addressId}, bedrooms: ${_this.bedrooms}, bathrooms: ${_this.bathrooms}, frequency: ${_this.frequency}, start: ${_this.start}, end: ${_this.end}, status: ${_this.status}, subtotal: ${_this.subtotal}, discount: ${_this.discount}, total: ${_this.total}, cleanerPayout: ${_this.cleanerPayout}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, cleanerId: ${_this.cleanerId}, requestedCleanerId: ${_this.requestedCleanerId}, planId: ${_this.planId}, extras: ${_this.extras})';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 String id, String code, String clientId, String serviceId, String serviceTitle, String addressId, int bedrooms, int bathrooms, Frequency frequency, DateTime start, DateTime end, BookingStatus status, int subtotal, int discount, int total, int cleanerPayout, DateTime createdAt, DateTime updatedAt, String? cleanerId, String? requestedCleanerId, String? planId, List<BookingExtra> extras
});




}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? clientId = null,Object? serviceId = null,Object? serviceTitle = null,Object? addressId = null,Object? bedrooms = null,Object? bathrooms = null,Object? frequency = null,Object? start = null,Object? end = null,Object? status = null,Object? subtotal = null,Object? discount = null,Object? total = null,Object? cleanerPayout = null,Object? createdAt = null,Object? updatedAt = null,Object? cleanerId = freezed,Object? requestedCleanerId = freezed,Object? planId = freezed,Object? extras = null,}) {
  return _then(Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,serviceTitle: null == serviceTitle ? _self.serviceTitle : serviceTitle // ignore: cast_nullable_to_non_nullable
as String,addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,bedrooms: null == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int,bathrooms: null == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,cleanerPayout: null == cleanerPayout ? _self.cleanerPayout : cleanerPayout // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,cleanerId: freezed == cleanerId ? _self.cleanerId : cleanerId // ignore: cast_nullable_to_non_nullable
as String?,requestedCleanerId: freezed == requestedCleanerId ? _self.requestedCleanerId : requestedCleanerId // ignore: cast_nullable_to_non_nullable
as String?,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String?,extras: null == extras ? _self.extras : extras // ignore: cast_nullable_to_non_nullable
as List<BookingExtra>,
  ));
}

}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String clientId,  String serviceId,  String serviceTitle,  String addressId,  int bedrooms,  int bathrooms,  Frequency frequency,  DateTime start,  DateTime end,  BookingStatus status,  int subtotal,  int discount,  int total,  int cleanerPayout,  DateTime createdAt,  DateTime updatedAt,  String? cleanerId,  String? requestedCleanerId,  String? planId,  List<BookingExtra> extras)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.code,_that.clientId,_that.serviceId,_that.serviceTitle,_that.addressId,_that.bedrooms,_that.bathrooms,_that.frequency,_that.start,_that.end,_that.status,_that.subtotal,_that.discount,_that.total,_that.cleanerPayout,_that.createdAt,_that.updatedAt,_that.cleanerId,_that.requestedCleanerId,_that.planId,_that.extras);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String clientId,  String serviceId,  String serviceTitle,  String addressId,  int bedrooms,  int bathrooms,  Frequency frequency,  DateTime start,  DateTime end,  BookingStatus status,  int subtotal,  int discount,  int total,  int cleanerPayout,  DateTime createdAt,  DateTime updatedAt,  String? cleanerId,  String? requestedCleanerId,  String? planId,  List<BookingExtra> extras)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.code,_that.clientId,_that.serviceId,_that.serviceTitle,_that.addressId,_that.bedrooms,_that.bathrooms,_that.frequency,_that.start,_that.end,_that.status,_that.subtotal,_that.discount,_that.total,_that.cleanerPayout,_that.createdAt,_that.updatedAt,_that.cleanerId,_that.requestedCleanerId,_that.planId,_that.extras);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String clientId,  String serviceId,  String serviceTitle,  String addressId,  int bedrooms,  int bathrooms,  Frequency frequency,  DateTime start,  DateTime end,  BookingStatus status,  int subtotal,  int discount,  int total,  int cleanerPayout,  DateTime createdAt,  DateTime updatedAt,  String? cleanerId,  String? requestedCleanerId,  String? planId,  List<BookingExtra> extras)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.code,_that.clientId,_that.serviceId,_that.serviceTitle,_that.addressId,_that.bedrooms,_that.bathrooms,_that.frequency,_that.start,_that.end,_that.status,_that.subtotal,_that.discount,_that.total,_that.cleanerPayout,_that.createdAt,_that.updatedAt,_that.cleanerId,_that.requestedCleanerId,_that.planId,_that.extras);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Booking implements Booking {
  const _Booking({required this.id, required this.code, required this.clientId, required this.serviceId, required this.serviceTitle, required this.addressId, required this.bedrooms, required this.bathrooms, required this.frequency, required this.start, required this.end, required this.status, required this.subtotal, required this.discount, required this.total, required this.cleanerPayout, required this.createdAt, required this.updatedAt, this.cleanerId, this.requestedCleanerId, this.planId,  List<BookingExtra> extras = const <BookingExtra>[]}): _extras = extras;
  factory _Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

@override final  String id;
/// Human friendly reference, e.g. `TD-1042`.
@override final  String code;
@override final  String clientId;
@override final  String serviceId;
@override final  String serviceTitle;
@override final  String addressId;
@override final  int bedrooms;
@override final  int bathrooms;
@override final  Frequency frequency;
@override final  DateTime start;
@override final  DateTime end;
@override final  BookingStatus status;
@override final  int subtotal;
@override final  int discount;
@override final  int total;
/// What the cleaner earns, before tips.
@override final  int cleanerPayout;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Null until a cleaner accepts.
@override final  String? cleanerId;
/// Set when the client picked a cleaner by name.
@override final  String? requestedCleanerId;
/// Set for recurring bookings.
@override final  String? planId;
 final  List<BookingExtra> _extras;
@override@JsonKey() List<BookingExtra> get extras {
  if (_extras is EqualUnmodifiableListView) return _extras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extras);
}


/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.serviceTitle, serviceTitle) || other.serviceTitle == serviceTitle)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.bedrooms, bedrooms) || other.bedrooms == bedrooms)&&(identical(other.bathrooms, bathrooms) || other.bathrooms == bathrooms)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.total, total) || other.total == total)&&(identical(other.cleanerPayout, cleanerPayout) || other.cleanerPayout == cleanerPayout)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.cleanerId, cleanerId) || other.cleanerId == cleanerId)&&(identical(other.requestedCleanerId, requestedCleanerId) || other.requestedCleanerId == requestedCleanerId)&&(identical(other.planId, planId) || other.planId == planId)&&const DeepCollectionEquality().equals(other.extras, _extras));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,code,clientId,serviceId,serviceTitle,addressId,bedrooms,bathrooms,frequency,start,end,status,subtotal,discount,total,cleanerPayout,createdAt,updatedAt,cleanerId,requestedCleanerId,planId,const DeepCollectionEquality().hash(_extras)]);
}

@override
String toString() {
    return 'Booking(id: $id, code: $code, clientId: $clientId, serviceId: $serviceId, serviceTitle: $serviceTitle, addressId: $addressId, bedrooms: $bedrooms, bathrooms: $bathrooms, frequency: $frequency, start: $start, end: $end, status: $status, subtotal: $subtotal, discount: $discount, total: $total, cleanerPayout: $cleanerPayout, createdAt: $createdAt, updatedAt: $updatedAt, cleanerId: $cleanerId, requestedCleanerId: $requestedCleanerId, planId: $planId, extras: $extras)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String clientId, String serviceId, String serviceTitle, String addressId, int bedrooms, int bathrooms, Frequency frequency, DateTime start, DateTime end, BookingStatus status, int subtotal, int discount, int total, int cleanerPayout, DateTime createdAt, DateTime updatedAt, String? cleanerId, String? requestedCleanerId, String? planId, List<BookingExtra> extras
});




}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? clientId = null,Object? serviceId = null,Object? serviceTitle = null,Object? addressId = null,Object? bedrooms = null,Object? bathrooms = null,Object? frequency = null,Object? start = null,Object? end = null,Object? status = null,Object? subtotal = null,Object? discount = null,Object? total = null,Object? cleanerPayout = null,Object? createdAt = null,Object? updatedAt = null,Object? cleanerId = freezed,Object? requestedCleanerId = freezed,Object? planId = freezed,Object? extras = null,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,serviceTitle: null == serviceTitle ? _self.serviceTitle : serviceTitle // ignore: cast_nullable_to_non_nullable
as String,addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,bedrooms: null == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int,bathrooms: null == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,cleanerPayout: null == cleanerPayout ? _self.cleanerPayout : cleanerPayout // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,cleanerId: freezed == cleanerId ? _self.cleanerId : cleanerId // ignore: cast_nullable_to_non_nullable
as String?,requestedCleanerId: freezed == requestedCleanerId ? _self.requestedCleanerId : requestedCleanerId // ignore: cast_nullable_to_non_nullable
as String?,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String?,extras: null == extras ? _self._extras : extras // ignore: cast_nullable_to_non_nullable
as List<BookingExtra>,
  ));
}


}


/// @nodoc
mixin _$CleanerCard {

 String get id; String get fullName; double get rating; int get ratingCount; String? get avatarUrl;
/// Create a copy of CleanerCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CleanerCardCopyWith<CleanerCard> get copyWith => _$CleanerCardCopyWithImpl<CleanerCard>(this as CleanerCard, _$identity);

  /// Serializes this CleanerCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CleanerCard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CleanerCard&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.ratingCount, _this.ratingCount) || other.ratingCount == _this.ratingCount)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CleanerCard;
  return Object.hash(runtimeType,_this.id,_this.fullName,_this.rating,_this.ratingCount,_this.avatarUrl);
}

@override
String toString() {
  final _this = this as CleanerCard;
  return 'CleanerCard(id: ${_this.id}, fullName: ${_this.fullName}, rating: ${_this.rating}, ratingCount: ${_this.ratingCount}, avatarUrl: ${_this.avatarUrl})';
}


}

/// @nodoc
abstract mixin class $CleanerCardCopyWith<$Res>  {
  factory $CleanerCardCopyWith(CleanerCard value, $Res Function(CleanerCard) _then) = _$CleanerCardCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, double rating, int ratingCount, String? avatarUrl
});




}
/// @nodoc
class _$CleanerCardCopyWithImpl<$Res>
    implements $CleanerCardCopyWith<$Res> {
  _$CleanerCardCopyWithImpl(this._self, this._then);

  final CleanerCard _self;
  final $Res Function(CleanerCard) _then;

/// Create a copy of CleanerCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? rating = null,Object? ratingCount = null,Object? avatarUrl = freezed,}) {
  return _then(CleanerCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CleanerCard].
extension CleanerCardPatterns on CleanerCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CleanerCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CleanerCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CleanerCard value)  $default,){
final _that = this;
switch (_that) {
case _CleanerCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CleanerCard value)?  $default,){
final _that = this;
switch (_that) {
case _CleanerCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  double rating,  int ratingCount,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CleanerCard() when $default != null:
return $default(_that.id,_that.fullName,_that.rating,_that.ratingCount,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  double rating,  int ratingCount,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _CleanerCard():
return $default(_that.id,_that.fullName,_that.rating,_that.ratingCount,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  double rating,  int ratingCount,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _CleanerCard() when $default != null:
return $default(_that.id,_that.fullName,_that.rating,_that.ratingCount,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CleanerCard implements CleanerCard {
  const _CleanerCard({required this.id, required this.fullName, required this.rating, required this.ratingCount, this.avatarUrl});
  factory _CleanerCard.fromJson(Map<String, dynamic> json) => _$CleanerCardFromJson(json);

@override final  String id;
@override final  String fullName;
@override final  double rating;
@override final  int ratingCount;
@override final  String? avatarUrl;

/// Create a copy of CleanerCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CleanerCardCopyWith<_CleanerCard> get copyWith => __$CleanerCardCopyWithImpl<_CleanerCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CleanerCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CleanerCard&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,rating,ratingCount,avatarUrl);
}

@override
String toString() {
    return 'CleanerCard(id: $id, fullName: $fullName, rating: $rating, ratingCount: $ratingCount, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$CleanerCardCopyWith<$Res> implements $CleanerCardCopyWith<$Res> {
  factory _$CleanerCardCopyWith(_CleanerCard value, $Res Function(_CleanerCard) _then) = __$CleanerCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, double rating, int ratingCount, String? avatarUrl
});




}
/// @nodoc
class __$CleanerCardCopyWithImpl<$Res>
    implements _$CleanerCardCopyWith<$Res> {
  __$CleanerCardCopyWithImpl(this._self, this._then);

  final _CleanerCard _self;
  final $Res Function(_CleanerCard) _then;

/// Create a copy of CleanerCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? rating = null,Object? ratingCount = null,Object? avatarUrl = freezed,}) {
  return _then(_CleanerCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Review {

 String get bookingId; String get cleanerId; int get rating; String get comment;/// Pence.
 int get tip; DateTime get createdAt; List<String> get tags;
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCopyWith<Review> get copyWith => _$ReviewCopyWithImpl<Review>(this as Review, _$identity);

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Review;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Review&&(identical(other.bookingId, _this.bookingId) || other.bookingId == _this.bookingId)&&(identical(other.cleanerId, _this.cleanerId) || other.cleanerId == _this.cleanerId)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.comment, _this.comment) || other.comment == _this.comment)&&(identical(other.tip, _this.tip) || other.tip == _this.tip)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.tags, _this.tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Review;
  return Object.hash(runtimeType,_this.bookingId,_this.cleanerId,_this.rating,_this.comment,_this.tip,_this.createdAt,const DeepCollectionEquality().hash(_this.tags));
}

@override
String toString() {
  final _this = this as Review;
  return 'Review(bookingId: ${_this.bookingId}, cleanerId: ${_this.cleanerId}, rating: ${_this.rating}, comment: ${_this.comment}, tip: ${_this.tip}, createdAt: ${_this.createdAt}, tags: ${_this.tags})';
}


}

/// @nodoc
abstract mixin class $ReviewCopyWith<$Res>  {
  factory $ReviewCopyWith(Review value, $Res Function(Review) _then) = _$ReviewCopyWithImpl;
@useResult
$Res call({
 String bookingId, String cleanerId, int rating, String comment, int tip, DateTime createdAt, List<String> tags
});




}
/// @nodoc
class _$ReviewCopyWithImpl<$Res>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._self, this._then);

  final Review _self;
  final $Res Function(Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookingId = null,Object? cleanerId = null,Object? rating = null,Object? comment = null,Object? tip = null,Object? createdAt = null,Object? tags = null,}) {
  return _then(Review(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,cleanerId: null == cleanerId ? _self.cleanerId : cleanerId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,tip: null == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Review].
extension ReviewPatterns on Review {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Review value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Review value)  $default,){
final _that = this;
switch (_that) {
case _Review():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Review value)?  $default,){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bookingId,  String cleanerId,  int rating,  String comment,  int tip,  DateTime createdAt,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.bookingId,_that.cleanerId,_that.rating,_that.comment,_that.tip,_that.createdAt,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bookingId,  String cleanerId,  int rating,  String comment,  int tip,  DateTime createdAt,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _Review():
return $default(_that.bookingId,_that.cleanerId,_that.rating,_that.comment,_that.tip,_that.createdAt,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bookingId,  String cleanerId,  int rating,  String comment,  int tip,  DateTime createdAt,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.bookingId,_that.cleanerId,_that.rating,_that.comment,_that.tip,_that.createdAt,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Review implements Review {
  const _Review({required this.bookingId, required this.cleanerId, required this.rating, required this.comment, required this.tip, required this.createdAt,  List<String> tags = const <String>[]}): _tags = tags;
  factory _Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

@override final  String bookingId;
@override final  String cleanerId;
@override final  int rating;
@override final  String comment;
/// Pence.
@override final  int tip;
@override final  DateTime createdAt;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCopyWith<_Review> get copyWith => __$ReviewCopyWithImpl<_Review>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Review&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.cleanerId, cleanerId) || other.cleanerId == cleanerId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.tip, tip) || other.tip == tip)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,bookingId,cleanerId,rating,comment,tip,createdAt,const DeepCollectionEquality().hash(_tags));
}

@override
String toString() {
    return 'Review(bookingId: $bookingId, cleanerId: $cleanerId, rating: $rating, comment: $comment, tip: $tip, createdAt: $createdAt, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$ReviewCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$ReviewCopyWith(_Review value, $Res Function(_Review) _then) = __$ReviewCopyWithImpl;
@override @useResult
$Res call({
 String bookingId, String cleanerId, int rating, String comment, int tip, DateTime createdAt, List<String> tags
});




}
/// @nodoc
class __$ReviewCopyWithImpl<$Res>
    implements _$ReviewCopyWith<$Res> {
  __$ReviewCopyWithImpl(this._self, this._then);

  final _Review _self;
  final $Res Function(_Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookingId = null,Object? cleanerId = null,Object? rating = null,Object? comment = null,Object? tip = null,Object? createdAt = null,Object? tags = null,}) {
  return _then(_Review(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,cleanerId: null == cleanerId ? _self.cleanerId : cleanerId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,tip: null == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$BookingDetails {

 Booking get booking; Address get address; CleanerCard? get cleaner; CleanerLocation? get lastLocation; List<BookingEvent> get events; Review? get review;
/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingDetailsCopyWith<BookingDetails> get copyWith => _$BookingDetailsCopyWithImpl<BookingDetails>(this as BookingDetails, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookingDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingDetails&&(identical(other.booking, _this.booking) || other.booking == _this.booking)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.cleaner, _this.cleaner) || other.cleaner == _this.cleaner)&&(identical(other.lastLocation, _this.lastLocation) || other.lastLocation == _this.lastLocation)&&const DeepCollectionEquality().equals(other.events, _this.events)&&(identical(other.review, _this.review) || other.review == _this.review));
}


@override
int get hashCode {
  final _this = this as BookingDetails;
  return Object.hash(runtimeType,_this.booking,_this.address,_this.cleaner,_this.lastLocation,const DeepCollectionEquality().hash(_this.events),_this.review);
}

@override
String toString() {
  final _this = this as BookingDetails;
  return 'BookingDetails(booking: ${_this.booking}, address: ${_this.address}, cleaner: ${_this.cleaner}, lastLocation: ${_this.lastLocation}, events: ${_this.events}, review: ${_this.review})';
}


}

/// @nodoc
abstract mixin class $BookingDetailsCopyWith<$Res>  {
  factory $BookingDetailsCopyWith(BookingDetails value, $Res Function(BookingDetails) _then) = _$BookingDetailsCopyWithImpl;
@useResult
$Res call({
 Booking booking, Address address, CleanerCard? cleaner, CleanerLocation? lastLocation, List<BookingEvent> events, Review? review
});


$BookingCopyWith<$Res> get booking;$AddressCopyWith<$Res> get address;$CleanerCardCopyWith<$Res>? get cleaner;$CleanerLocationCopyWith<$Res>? get lastLocation;$ReviewCopyWith<$Res>? get review;

}
/// @nodoc
class _$BookingDetailsCopyWithImpl<$Res>
    implements $BookingDetailsCopyWith<$Res> {
  _$BookingDetailsCopyWithImpl(this._self, this._then);

  final BookingDetails _self;
  final $Res Function(BookingDetails) _then;

/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? booking = null,Object? address = null,Object? cleaner = freezed,Object? lastLocation = freezed,Object? events = null,Object? review = freezed,}) {
  return _then(BookingDetails(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address,cleaner: freezed == cleaner ? _self.cleaner : cleaner // ignore: cast_nullable_to_non_nullable
as CleanerCard?,lastLocation: freezed == lastLocation ? _self.lastLocation : lastLocation // ignore: cast_nullable_to_non_nullable
as CleanerLocation?,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<BookingEvent>,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as Review?,
  ));
}
/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get address {
  
  return $AddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CleanerCardCopyWith<$Res>? get cleaner {
    if (_self.cleaner == null) {
    return null;
  }

  return $CleanerCardCopyWith<$Res>(_self.cleaner!, (value) {
    return _then(_self.copyWith(cleaner: value));
  });
}/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CleanerLocationCopyWith<$Res>? get lastLocation {
    if (_self.lastLocation == null) {
    return null;
  }

  return $CleanerLocationCopyWith<$Res>(_self.lastLocation!, (value) {
    return _then(_self.copyWith(lastLocation: value));
  });
}/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewCopyWith<$Res>? get review {
    if (_self.review == null) {
    return null;
  }

  return $ReviewCopyWith<$Res>(_self.review!, (value) {
    return _then(_self.copyWith(review: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingDetails].
extension BookingDetailsPatterns on BookingDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingDetails value)  $default,){
final _that = this;
switch (_that) {
case _BookingDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingDetails value)?  $default,){
final _that = this;
switch (_that) {
case _BookingDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Booking booking,  Address address,  CleanerCard? cleaner,  CleanerLocation? lastLocation,  List<BookingEvent> events,  Review? review)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingDetails() when $default != null:
return $default(_that.booking,_that.address,_that.cleaner,_that.lastLocation,_that.events,_that.review);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Booking booking,  Address address,  CleanerCard? cleaner,  CleanerLocation? lastLocation,  List<BookingEvent> events,  Review? review)  $default,) {final _that = this;
switch (_that) {
case _BookingDetails():
return $default(_that.booking,_that.address,_that.cleaner,_that.lastLocation,_that.events,_that.review);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Booking booking,  Address address,  CleanerCard? cleaner,  CleanerLocation? lastLocation,  List<BookingEvent> events,  Review? review)?  $default,) {final _that = this;
switch (_that) {
case _BookingDetails() when $default != null:
return $default(_that.booking,_that.address,_that.cleaner,_that.lastLocation,_that.events,_that.review);case _:
  return null;

}
}

}

/// @nodoc


class _BookingDetails extends BookingDetails {
  const _BookingDetails({required this.booking, required this.address, this.cleaner, this.lastLocation,  List<BookingEvent> events = const <BookingEvent>[], this.review}): _events = events,super._();
  

@override final  Booking booking;
@override final  Address address;
@override final  CleanerCard? cleaner;
@override final  CleanerLocation? lastLocation;
 final  List<BookingEvent> _events;
@override@JsonKey() List<BookingEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override final  Review? review;

/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingDetailsCopyWith<_BookingDetails> get copyWith => __$BookingDetailsCopyWithImpl<_BookingDetails>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingDetails&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.address, address) || other.address == address)&&(identical(other.cleaner, cleaner) || other.cleaner == cleaner)&&(identical(other.lastLocation, lastLocation) || other.lastLocation == lastLocation)&&const DeepCollectionEquality().equals(other.events, _events)&&(identical(other.review, review) || other.review == review));
}


@override
int get hashCode {
    return Object.hash(runtimeType,booking,address,cleaner,lastLocation,const DeepCollectionEquality().hash(_events),review);
}

@override
String toString() {
    return 'BookingDetails(booking: $booking, address: $address, cleaner: $cleaner, lastLocation: $lastLocation, events: $events, review: $review)';
}


}

/// @nodoc
abstract mixin class _$BookingDetailsCopyWith<$Res> implements $BookingDetailsCopyWith<$Res> {
  factory _$BookingDetailsCopyWith(_BookingDetails value, $Res Function(_BookingDetails) _then) = __$BookingDetailsCopyWithImpl;
@override @useResult
$Res call({
 Booking booking, Address address, CleanerCard? cleaner, CleanerLocation? lastLocation, List<BookingEvent> events, Review? review
});


@override $BookingCopyWith<$Res> get booking;@override $AddressCopyWith<$Res> get address;@override $CleanerCardCopyWith<$Res>? get cleaner;@override $CleanerLocationCopyWith<$Res>? get lastLocation;@override $ReviewCopyWith<$Res>? get review;

}
/// @nodoc
class __$BookingDetailsCopyWithImpl<$Res>
    implements _$BookingDetailsCopyWith<$Res> {
  __$BookingDetailsCopyWithImpl(this._self, this._then);

  final _BookingDetails _self;
  final $Res Function(_BookingDetails) _then;

/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? booking = null,Object? address = null,Object? cleaner = freezed,Object? lastLocation = freezed,Object? events = null,Object? review = freezed,}) {
  return _then(_BookingDetails(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address,cleaner: freezed == cleaner ? _self.cleaner : cleaner // ignore: cast_nullable_to_non_nullable
as CleanerCard?,lastLocation: freezed == lastLocation ? _self.lastLocation : lastLocation // ignore: cast_nullable_to_non_nullable
as CleanerLocation?,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<BookingEvent>,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as Review?,
  ));
}

/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get address {
  
  return $AddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CleanerCardCopyWith<$Res>? get cleaner {
    if (_self.cleaner == null) {
    return null;
  }

  return $CleanerCardCopyWith<$Res>(_self.cleaner!, (value) {
    return _then(_self.copyWith(cleaner: value));
  });
}/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CleanerLocationCopyWith<$Res>? get lastLocation {
    if (_self.lastLocation == null) {
    return null;
  }

  return $CleanerLocationCopyWith<$Res>(_self.lastLocation!, (value) {
    return _then(_self.copyWith(lastLocation: value));
  });
}/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewCopyWith<$Res>? get review {
    if (_self.review == null) {
    return null;
  }

  return $ReviewCopyWith<$Res>(_self.review!, (value) {
    return _then(_self.copyWith(review: value));
  });
}
}

/// @nodoc
mixin _$Job {

 Booking get booking; Address get address; String get clientName;
/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobCopyWith<Job> get copyWith => _$JobCopyWithImpl<Job>(this as Job, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Job;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Job&&(identical(other.booking, _this.booking) || other.booking == _this.booking)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.clientName, _this.clientName) || other.clientName == _this.clientName));
}


@override
int get hashCode {
  final _this = this as Job;
  return Object.hash(runtimeType,_this.booking,_this.address,_this.clientName);
}

@override
String toString() {
  final _this = this as Job;
  return 'Job(booking: ${_this.booking}, address: ${_this.address}, clientName: ${_this.clientName})';
}


}

/// @nodoc
abstract mixin class $JobCopyWith<$Res>  {
  factory $JobCopyWith(Job value, $Res Function(Job) _then) = _$JobCopyWithImpl;
@useResult
$Res call({
 Booking booking, Address address, String clientName
});


$BookingCopyWith<$Res> get booking;$AddressCopyWith<$Res> get address;

}
/// @nodoc
class _$JobCopyWithImpl<$Res>
    implements $JobCopyWith<$Res> {
  _$JobCopyWithImpl(this._self, this._then);

  final Job _self;
  final $Res Function(Job) _then;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? booking = null,Object? address = null,Object? clientName = null,}) {
  return _then(Job(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get address {
  
  return $AddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}


/// Adds pattern-matching-related methods to [Job].
extension JobPatterns on Job {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Job value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Job() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Job value)  $default,){
final _that = this;
switch (_that) {
case _Job():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Job value)?  $default,){
final _that = this;
switch (_that) {
case _Job() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Booking booking,  Address address,  String clientName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that.booking,_that.address,_that.clientName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Booking booking,  Address address,  String clientName)  $default,) {final _that = this;
switch (_that) {
case _Job():
return $default(_that.booking,_that.address,_that.clientName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Booking booking,  Address address,  String clientName)?  $default,) {final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that.booking,_that.address,_that.clientName);case _:
  return null;

}
}

}

/// @nodoc


class _Job extends Job {
  const _Job({required this.booking, required this.address, required this.clientName}): super._();
  

@override final  Booking booking;
@override final  Address address;
@override final  String clientName;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobCopyWith<_Job> get copyWith => __$JobCopyWithImpl<_Job>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Job&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.address, address) || other.address == address)&&(identical(other.clientName, clientName) || other.clientName == clientName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,booking,address,clientName);
}

@override
String toString() {
    return 'Job(booking: $booking, address: $address, clientName: $clientName)';
}


}

/// @nodoc
abstract mixin class _$JobCopyWith<$Res> implements $JobCopyWith<$Res> {
  factory _$JobCopyWith(_Job value, $Res Function(_Job) _then) = __$JobCopyWithImpl;
@override @useResult
$Res call({
 Booking booking, Address address, String clientName
});


@override $BookingCopyWith<$Res> get booking;@override $AddressCopyWith<$Res> get address;

}
/// @nodoc
class __$JobCopyWithImpl<$Res>
    implements _$JobCopyWith<$Res> {
  __$JobCopyWithImpl(this._self, this._then);

  final _Job _self;
  final $Res Function(_Job) _then;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? booking = null,Object? address = null,Object? clientName = null,}) {
  return _then(_Job(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get address {
  
  return $AddressCopyWith<$Res>(_self.address, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}

/// @nodoc
mixin _$AdminBooking {

 Booking get booking; String get clientName; String get clientPhone; String get cleanerName;
/// Create a copy of AdminBooking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminBookingCopyWith<AdminBooking> get copyWith => _$AdminBookingCopyWithImpl<AdminBooking>(this as AdminBooking, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdminBooking;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminBooking&&(identical(other.booking, _this.booking) || other.booking == _this.booking)&&(identical(other.clientName, _this.clientName) || other.clientName == _this.clientName)&&(identical(other.clientPhone, _this.clientPhone) || other.clientPhone == _this.clientPhone)&&(identical(other.cleanerName, _this.cleanerName) || other.cleanerName == _this.cleanerName));
}


@override
int get hashCode {
  final _this = this as AdminBooking;
  return Object.hash(runtimeType,_this.booking,_this.clientName,_this.clientPhone,_this.cleanerName);
}

@override
String toString() {
  final _this = this as AdminBooking;
  return 'AdminBooking(booking: ${_this.booking}, clientName: ${_this.clientName}, clientPhone: ${_this.clientPhone}, cleanerName: ${_this.cleanerName})';
}


}

/// @nodoc
abstract mixin class $AdminBookingCopyWith<$Res>  {
  factory $AdminBookingCopyWith(AdminBooking value, $Res Function(AdminBooking) _then) = _$AdminBookingCopyWithImpl;
@useResult
$Res call({
 Booking booking, String clientName, String clientPhone, String cleanerName
});


$BookingCopyWith<$Res> get booking;

}
/// @nodoc
class _$AdminBookingCopyWithImpl<$Res>
    implements $AdminBookingCopyWith<$Res> {
  _$AdminBookingCopyWithImpl(this._self, this._then);

  final AdminBooking _self;
  final $Res Function(AdminBooking) _then;

/// Create a copy of AdminBooking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? booking = null,Object? clientName = null,Object? clientPhone = null,Object? cleanerName = null,}) {
  return _then(AdminBooking(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,clientPhone: null == clientPhone ? _self.clientPhone : clientPhone // ignore: cast_nullable_to_non_nullable
as String,cleanerName: null == cleanerName ? _self.cleanerName : cleanerName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of AdminBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminBooking].
extension AdminBookingPatterns on AdminBooking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminBooking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminBooking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminBooking value)  $default,){
final _that = this;
switch (_that) {
case _AdminBooking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminBooking value)?  $default,){
final _that = this;
switch (_that) {
case _AdminBooking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Booking booking,  String clientName,  String clientPhone,  String cleanerName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminBooking() when $default != null:
return $default(_that.booking,_that.clientName,_that.clientPhone,_that.cleanerName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Booking booking,  String clientName,  String clientPhone,  String cleanerName)  $default,) {final _that = this;
switch (_that) {
case _AdminBooking():
return $default(_that.booking,_that.clientName,_that.clientPhone,_that.cleanerName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Booking booking,  String clientName,  String clientPhone,  String cleanerName)?  $default,) {final _that = this;
switch (_that) {
case _AdminBooking() when $default != null:
return $default(_that.booking,_that.clientName,_that.clientPhone,_that.cleanerName);case _:
  return null;

}
}

}

/// @nodoc


class _AdminBooking extends AdminBooking {
  const _AdminBooking({required this.booking, required this.clientName, required this.clientPhone, required this.cleanerName}): super._();
  

@override final  Booking booking;
@override final  String clientName;
@override final  String clientPhone;
@override final  String cleanerName;

/// Create a copy of AdminBooking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminBookingCopyWith<_AdminBooking> get copyWith => __$AdminBookingCopyWithImpl<_AdminBooking>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminBooking&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientPhone, clientPhone) || other.clientPhone == clientPhone)&&(identical(other.cleanerName, cleanerName) || other.cleanerName == cleanerName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,booking,clientName,clientPhone,cleanerName);
}

@override
String toString() {
    return 'AdminBooking(booking: $booking, clientName: $clientName, clientPhone: $clientPhone, cleanerName: $cleanerName)';
}


}

/// @nodoc
abstract mixin class _$AdminBookingCopyWith<$Res> implements $AdminBookingCopyWith<$Res> {
  factory _$AdminBookingCopyWith(_AdminBooking value, $Res Function(_AdminBooking) _then) = __$AdminBookingCopyWithImpl;
@override @useResult
$Res call({
 Booking booking, String clientName, String clientPhone, String cleanerName
});


@override $BookingCopyWith<$Res> get booking;

}
/// @nodoc
class __$AdminBookingCopyWithImpl<$Res>
    implements _$AdminBookingCopyWith<$Res> {
  __$AdminBookingCopyWithImpl(this._self, this._then);

  final _AdminBooking _self;
  final $Res Function(_AdminBooking) _then;

/// Create a copy of AdminBooking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? booking = null,Object? clientName = null,Object? clientPhone = null,Object? cleanerName = null,}) {
  return _then(_AdminBooking(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,clientPhone: null == clientPhone ? _self.clientPhone : clientPhone // ignore: cast_nullable_to_non_nullable
as String,cleanerName: null == cleanerName ? _self.cleanerName : cleanerName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AdminBooking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}


/// @nodoc
mixin _$BookingPage {

 List<Booking> get items;/// Empty on the last page.
 String get nextCursor;
/// Create a copy of BookingPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingPageCopyWith<BookingPage> get copyWith => _$BookingPageCopyWithImpl<BookingPage>(this as BookingPage, _$identity);

  /// Serializes this BookingPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingPage&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as BookingPage;
  return 'BookingPage(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $BookingPageCopyWith<$Res>  {
  factory $BookingPageCopyWith(BookingPage value, $Res Function(BookingPage) _then) = _$BookingPageCopyWithImpl;
@useResult
$Res call({
 List<Booking> items, String nextCursor
});




}
/// @nodoc
class _$BookingPageCopyWithImpl<$Res>
    implements $BookingPageCopyWith<$Res> {
  _$BookingPageCopyWithImpl(this._self, this._then);

  final BookingPage _self;
  final $Res Function(BookingPage) _then;

/// Create a copy of BookingPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = null,}) {
  return _then(BookingPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Booking>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingPage].
extension BookingPagePatterns on BookingPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingPage value)  $default,){
final _that = this;
switch (_that) {
case _BookingPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingPage value)?  $default,){
final _that = this;
switch (_that) {
case _BookingPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Booking> items,  String nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Booking> items,  String nextCursor)  $default,) {final _that = this;
switch (_that) {
case _BookingPage():
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Booking> items,  String nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _BookingPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingPage extends BookingPage {
  const _BookingPage({ List<Booking> items = const <Booking>[], this.nextCursor = ''}): _items = items,super._();
  factory _BookingPage.fromJson(Map<String, dynamic> json) => _$BookingPageFromJson(json);

 final  List<Booking> _items;
@override@JsonKey() List<Booking> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Empty on the last page.
@override@JsonKey() final  String nextCursor;

/// Create a copy of BookingPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingPageCopyWith<_BookingPage> get copyWith => __$BookingPageCopyWithImpl<_BookingPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingPage&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'BookingPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$BookingPageCopyWith<$Res> implements $BookingPageCopyWith<$Res> {
  factory _$BookingPageCopyWith(_BookingPage value, $Res Function(_BookingPage) _then) = __$BookingPageCopyWithImpl;
@override @useResult
$Res call({
 List<Booking> items, String nextCursor
});




}
/// @nodoc
class __$BookingPageCopyWithImpl<$Res>
    implements _$BookingPageCopyWith<$Res> {
  __$BookingPageCopyWithImpl(this._self, this._then);

  final _BookingPage _self;
  final $Res Function(_BookingPage) _then;

/// Create a copy of BookingPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = null,}) {
  return _then(_BookingPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Booking>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AdminBookingPage {

 List<AdminBooking> get items;/// Empty on the last page.
 String get nextCursor;
/// Create a copy of AdminBookingPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminBookingPageCopyWith<AdminBookingPage> get copyWith => _$AdminBookingPageCopyWithImpl<AdminBookingPage>(this as AdminBookingPage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdminBookingPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminBookingPage&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}


@override
int get hashCode {
  final _this = this as AdminBookingPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.nextCursor);
}

@override
String toString() {
  final _this = this as AdminBookingPage;
  return 'AdminBookingPage(items: ${_this.items}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $AdminBookingPageCopyWith<$Res>  {
  factory $AdminBookingPageCopyWith(AdminBookingPage value, $Res Function(AdminBookingPage) _then) = _$AdminBookingPageCopyWithImpl;
@useResult
$Res call({
 List<AdminBooking> items, String nextCursor
});




}
/// @nodoc
class _$AdminBookingPageCopyWithImpl<$Res>
    implements $AdminBookingPageCopyWith<$Res> {
  _$AdminBookingPageCopyWithImpl(this._self, this._then);

  final AdminBookingPage _self;
  final $Res Function(AdminBookingPage) _then;

/// Create a copy of AdminBookingPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = null,}) {
  return _then(AdminBookingPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AdminBooking>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminBookingPage].
extension AdminBookingPagePatterns on AdminBookingPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminBookingPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminBookingPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminBookingPage value)  $default,){
final _that = this;
switch (_that) {
case _AdminBookingPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminBookingPage value)?  $default,){
final _that = this;
switch (_that) {
case _AdminBookingPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AdminBooking> items,  String nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminBookingPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AdminBooking> items,  String nextCursor)  $default,) {final _that = this;
switch (_that) {
case _AdminBookingPage():
return $default(_that.items,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AdminBooking> items,  String nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _AdminBookingPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc


class _AdminBookingPage extends AdminBookingPage {
  const _AdminBookingPage({ List<AdminBooking> items = const <AdminBooking>[], this.nextCursor = ''}): _items = items,super._();
  

 final  List<AdminBooking> _items;
@override@JsonKey() List<AdminBooking> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Empty on the last page.
@override@JsonKey() final  String nextCursor;

/// Create a copy of AdminBookingPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminBookingPageCopyWith<_AdminBookingPage> get copyWith => __$AdminBookingPageCopyWithImpl<_AdminBookingPage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminBookingPage&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);
}

@override
String toString() {
    return 'AdminBookingPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$AdminBookingPageCopyWith<$Res> implements $AdminBookingPageCopyWith<$Res> {
  factory _$AdminBookingPageCopyWith(_AdminBookingPage value, $Res Function(_AdminBookingPage) _then) = __$AdminBookingPageCopyWithImpl;
@override @useResult
$Res call({
 List<AdminBooking> items, String nextCursor
});




}
/// @nodoc
class __$AdminBookingPageCopyWithImpl<$Res>
    implements _$AdminBookingPageCopyWith<$Res> {
  __$AdminBookingPageCopyWithImpl(this._self, this._then);

  final _AdminBookingPage _self;
  final $Res Function(_AdminBookingPage) _then;

/// Create a copy of AdminBookingPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = null,}) {
  return _then(_AdminBookingPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AdminBooking>,nextCursor: null == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CreateBookingRequest {

 String get serviceId; int get bedrooms; int get bathrooms; String get addressId;/// Sent as UTC.
@JsonKey(toJson: _utc) DateTime get start; List<String> get extraIds; Frequency get frequency;/// Ask for one cleaner ("book Sarah again").
 String? get cleanerId;
/// Create a copy of CreateBookingRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateBookingRequestCopyWith<CreateBookingRequest> get copyWith => _$CreateBookingRequestCopyWithImpl<CreateBookingRequest>(this as CreateBookingRequest, _$identity);

  /// Serializes this CreateBookingRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateBookingRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateBookingRequest&&(identical(other.serviceId, _this.serviceId) || other.serviceId == _this.serviceId)&&(identical(other.bedrooms, _this.bedrooms) || other.bedrooms == _this.bedrooms)&&(identical(other.bathrooms, _this.bathrooms) || other.bathrooms == _this.bathrooms)&&(identical(other.addressId, _this.addressId) || other.addressId == _this.addressId)&&(identical(other.start, _this.start) || other.start == _this.start)&&const DeepCollectionEquality().equals(other.extraIds, _this.extraIds)&&(identical(other.frequency, _this.frequency) || other.frequency == _this.frequency)&&(identical(other.cleanerId, _this.cleanerId) || other.cleanerId == _this.cleanerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateBookingRequest;
  return Object.hash(runtimeType,_this.serviceId,_this.bedrooms,_this.bathrooms,_this.addressId,_this.start,const DeepCollectionEquality().hash(_this.extraIds),_this.frequency,_this.cleanerId);
}

@override
String toString() {
  final _this = this as CreateBookingRequest;
  return 'CreateBookingRequest(serviceId: ${_this.serviceId}, bedrooms: ${_this.bedrooms}, bathrooms: ${_this.bathrooms}, addressId: ${_this.addressId}, start: ${_this.start}, extraIds: ${_this.extraIds}, frequency: ${_this.frequency}, cleanerId: ${_this.cleanerId})';
}


}

/// @nodoc
abstract mixin class $CreateBookingRequestCopyWith<$Res>  {
  factory $CreateBookingRequestCopyWith(CreateBookingRequest value, $Res Function(CreateBookingRequest) _then) = _$CreateBookingRequestCopyWithImpl;
@useResult
$Res call({
 String serviceId, int bedrooms, int bathrooms, String addressId,@JsonKey(toJson: _utc) DateTime start, List<String> extraIds, Frequency frequency, String? cleanerId
});




}
/// @nodoc
class _$CreateBookingRequestCopyWithImpl<$Res>
    implements $CreateBookingRequestCopyWith<$Res> {
  _$CreateBookingRequestCopyWithImpl(this._self, this._then);

  final CreateBookingRequest _self;
  final $Res Function(CreateBookingRequest) _then;

/// Create a copy of CreateBookingRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceId = null,Object? bedrooms = null,Object? bathrooms = null,Object? addressId = null,Object? start = null,Object? extraIds = null,Object? frequency = null,Object? cleanerId = freezed,}) {
  return _then(CreateBookingRequest(
serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,bedrooms: null == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int,bathrooms: null == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int,addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,extraIds: null == extraIds ? _self.extraIds : extraIds // ignore: cast_nullable_to_non_nullable
as List<String>,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,cleanerId: freezed == cleanerId ? _self.cleanerId : cleanerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateBookingRequest].
extension CreateBookingRequestPatterns on CreateBookingRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateBookingRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateBookingRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateBookingRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateBookingRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateBookingRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateBookingRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serviceId,  int bedrooms,  int bathrooms,  String addressId, @JsonKey(toJson: _utc)  DateTime start,  List<String> extraIds,  Frequency frequency,  String? cleanerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateBookingRequest() when $default != null:
return $default(_that.serviceId,_that.bedrooms,_that.bathrooms,_that.addressId,_that.start,_that.extraIds,_that.frequency,_that.cleanerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serviceId,  int bedrooms,  int bathrooms,  String addressId, @JsonKey(toJson: _utc)  DateTime start,  List<String> extraIds,  Frequency frequency,  String? cleanerId)  $default,) {final _that = this;
switch (_that) {
case _CreateBookingRequest():
return $default(_that.serviceId,_that.bedrooms,_that.bathrooms,_that.addressId,_that.start,_that.extraIds,_that.frequency,_that.cleanerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serviceId,  int bedrooms,  int bathrooms,  String addressId, @JsonKey(toJson: _utc)  DateTime start,  List<String> extraIds,  Frequency frequency,  String? cleanerId)?  $default,) {final _that = this;
switch (_that) {
case _CreateBookingRequest() when $default != null:
return $default(_that.serviceId,_that.bedrooms,_that.bathrooms,_that.addressId,_that.start,_that.extraIds,_that.frequency,_that.cleanerId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _CreateBookingRequest implements CreateBookingRequest {
  const _CreateBookingRequest({required this.serviceId, required this.bedrooms, required this.bathrooms, required this.addressId, @JsonKey(toJson: _utc) required this.start,  List<String> extraIds = const <String>[], this.frequency = Frequency.once, this.cleanerId}): _extraIds = extraIds;
  factory _CreateBookingRequest.fromJson(Map<String, dynamic> json) => _$CreateBookingRequestFromJson(json);

@override final  String serviceId;
@override final  int bedrooms;
@override final  int bathrooms;
@override final  String addressId;
/// Sent as UTC.
@override@JsonKey(toJson: _utc) final  DateTime start;
 final  List<String> _extraIds;
@override@JsonKey() List<String> get extraIds {
  if (_extraIds is EqualUnmodifiableListView) return _extraIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extraIds);
}

@override@JsonKey() final  Frequency frequency;
/// Ask for one cleaner ("book Sarah again").
@override final  String? cleanerId;

/// Create a copy of CreateBookingRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateBookingRequestCopyWith<_CreateBookingRequest> get copyWith => __$CreateBookingRequestCopyWithImpl<_CreateBookingRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateBookingRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateBookingRequest&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.bedrooms, bedrooms) || other.bedrooms == bedrooms)&&(identical(other.bathrooms, bathrooms) || other.bathrooms == bathrooms)&&(identical(other.addressId, addressId) || other.addressId == addressId)&&(identical(other.start, start) || other.start == start)&&const DeepCollectionEquality().equals(other.extraIds, _extraIds)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.cleanerId, cleanerId) || other.cleanerId == cleanerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,serviceId,bedrooms,bathrooms,addressId,start,const DeepCollectionEquality().hash(_extraIds),frequency,cleanerId);
}

@override
String toString() {
    return 'CreateBookingRequest(serviceId: $serviceId, bedrooms: $bedrooms, bathrooms: $bathrooms, addressId: $addressId, start: $start, extraIds: $extraIds, frequency: $frequency, cleanerId: $cleanerId)';
}


}

/// @nodoc
abstract mixin class _$CreateBookingRequestCopyWith<$Res> implements $CreateBookingRequestCopyWith<$Res> {
  factory _$CreateBookingRequestCopyWith(_CreateBookingRequest value, $Res Function(_CreateBookingRequest) _then) = __$CreateBookingRequestCopyWithImpl;
@override @useResult
$Res call({
 String serviceId, int bedrooms, int bathrooms, String addressId,@JsonKey(toJson: _utc) DateTime start, List<String> extraIds, Frequency frequency, String? cleanerId
});




}
/// @nodoc
class __$CreateBookingRequestCopyWithImpl<$Res>
    implements _$CreateBookingRequestCopyWith<$Res> {
  __$CreateBookingRequestCopyWithImpl(this._self, this._then);

  final _CreateBookingRequest _self;
  final $Res Function(_CreateBookingRequest) _then;

/// Create a copy of CreateBookingRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceId = null,Object? bedrooms = null,Object? bathrooms = null,Object? addressId = null,Object? start = null,Object? extraIds = null,Object? frequency = null,Object? cleanerId = freezed,}) {
  return _then(_CreateBookingRequest(
serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,bedrooms: null == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int,bathrooms: null == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int,addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,extraIds: null == extraIds ? _self._extraIds : extraIds // ignore: cast_nullable_to_non_nullable
as List<String>,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,cleanerId: freezed == cleanerId ? _self.cleanerId : cleanerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PaymentIntentInfo {

/// Stripe client secret; the mock provider returns a placeholder.
 String get clientSecret;
/// Create a copy of PaymentIntentInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentIntentInfoCopyWith<PaymentIntentInfo> get copyWith => _$PaymentIntentInfoCopyWithImpl<PaymentIntentInfo>(this as PaymentIntentInfo, _$identity);

  /// Serializes this PaymentIntentInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentIntentInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentIntentInfo&&(identical(other.clientSecret, _this.clientSecret) || other.clientSecret == _this.clientSecret));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentIntentInfo;
  return Object.hash(runtimeType,_this.clientSecret);
}

@override
String toString() {
  final _this = this as PaymentIntentInfo;
  return 'PaymentIntentInfo(clientSecret: ${_this.clientSecret})';
}


}

/// @nodoc
abstract mixin class $PaymentIntentInfoCopyWith<$Res>  {
  factory $PaymentIntentInfoCopyWith(PaymentIntentInfo value, $Res Function(PaymentIntentInfo) _then) = _$PaymentIntentInfoCopyWithImpl;
@useResult
$Res call({
 String clientSecret
});




}
/// @nodoc
class _$PaymentIntentInfoCopyWithImpl<$Res>
    implements $PaymentIntentInfoCopyWith<$Res> {
  _$PaymentIntentInfoCopyWithImpl(this._self, this._then);

  final PaymentIntentInfo _self;
  final $Res Function(PaymentIntentInfo) _then;

/// Create a copy of PaymentIntentInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientSecret = null,}) {
  return _then(PaymentIntentInfo(
clientSecret: null == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentIntentInfo].
extension PaymentIntentInfoPatterns on PaymentIntentInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentIntentInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentIntentInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentIntentInfo value)  $default,){
final _that = this;
switch (_that) {
case _PaymentIntentInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentIntentInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentIntentInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientSecret)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentIntentInfo() when $default != null:
return $default(_that.clientSecret);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientSecret)  $default,) {final _that = this;
switch (_that) {
case _PaymentIntentInfo():
return $default(_that.clientSecret);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientSecret)?  $default,) {final _that = this;
switch (_that) {
case _PaymentIntentInfo() when $default != null:
return $default(_that.clientSecret);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentIntentInfo implements PaymentIntentInfo {
  const _PaymentIntentInfo({required this.clientSecret});
  factory _PaymentIntentInfo.fromJson(Map<String, dynamic> json) => _$PaymentIntentInfoFromJson(json);

/// Stripe client secret; the mock provider returns a placeholder.
@override final  String clientSecret;

/// Create a copy of PaymentIntentInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentIntentInfoCopyWith<_PaymentIntentInfo> get copyWith => __$PaymentIntentInfoCopyWithImpl<_PaymentIntentInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentIntentInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentIntentInfo&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,clientSecret);
}

@override
String toString() {
    return 'PaymentIntentInfo(clientSecret: $clientSecret)';
}


}

/// @nodoc
abstract mixin class _$PaymentIntentInfoCopyWith<$Res> implements $PaymentIntentInfoCopyWith<$Res> {
  factory _$PaymentIntentInfoCopyWith(_PaymentIntentInfo value, $Res Function(_PaymentIntentInfo) _then) = __$PaymentIntentInfoCopyWithImpl;
@override @useResult
$Res call({
 String clientSecret
});




}
/// @nodoc
class __$PaymentIntentInfoCopyWithImpl<$Res>
    implements _$PaymentIntentInfoCopyWith<$Res> {
  __$PaymentIntentInfoCopyWithImpl(this._self, this._then);

  final _PaymentIntentInfo _self;
  final $Res Function(_PaymentIntentInfo) _then;

/// Create a copy of PaymentIntentInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientSecret = null,}) {
  return _then(_PaymentIntentInfo(
clientSecret: null == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BookingCreated {

 Booking get booking; PaymentIntentInfo get payment;
/// Create a copy of BookingCreated
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCreatedCopyWith<BookingCreated> get copyWith => _$BookingCreatedCopyWithImpl<BookingCreated>(this as BookingCreated, _$identity);

  /// Serializes this BookingCreated to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BookingCreated;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingCreated&&(identical(other.booking, _this.booking) || other.booking == _this.booking)&&(identical(other.payment, _this.payment) || other.payment == _this.payment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingCreated;
  return Object.hash(runtimeType,_this.booking,_this.payment);
}

@override
String toString() {
  final _this = this as BookingCreated;
  return 'BookingCreated(booking: ${_this.booking}, payment: ${_this.payment})';
}


}

/// @nodoc
abstract mixin class $BookingCreatedCopyWith<$Res>  {
  factory $BookingCreatedCopyWith(BookingCreated value, $Res Function(BookingCreated) _then) = _$BookingCreatedCopyWithImpl;
@useResult
$Res call({
 Booking booking, PaymentIntentInfo payment
});


$BookingCopyWith<$Res> get booking;$PaymentIntentInfoCopyWith<$Res> get payment;

}
/// @nodoc
class _$BookingCreatedCopyWithImpl<$Res>
    implements $BookingCreatedCopyWith<$Res> {
  _$BookingCreatedCopyWithImpl(this._self, this._then);

  final BookingCreated _self;
  final $Res Function(BookingCreated) _then;

/// Create a copy of BookingCreated
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? booking = null,Object? payment = null,}) {
  return _then(BookingCreated(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as PaymentIntentInfo,
  ));
}
/// Create a copy of BookingCreated
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}/// Create a copy of BookingCreated
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentIntentInfoCopyWith<$Res> get payment {
  
  return $PaymentIntentInfoCopyWith<$Res>(_self.payment, (value) {
    return _then(_self.copyWith(payment: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingCreated].
extension BookingCreatedPatterns on BookingCreated {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingCreated value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingCreated() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingCreated value)  $default,){
final _that = this;
switch (_that) {
case _BookingCreated():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingCreated value)?  $default,){
final _that = this;
switch (_that) {
case _BookingCreated() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Booking booking,  PaymentIntentInfo payment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingCreated() when $default != null:
return $default(_that.booking,_that.payment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Booking booking,  PaymentIntentInfo payment)  $default,) {final _that = this;
switch (_that) {
case _BookingCreated():
return $default(_that.booking,_that.payment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Booking booking,  PaymentIntentInfo payment)?  $default,) {final _that = this;
switch (_that) {
case _BookingCreated() when $default != null:
return $default(_that.booking,_that.payment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingCreated implements BookingCreated {
  const _BookingCreated({required this.booking, required this.payment});
  factory _BookingCreated.fromJson(Map<String, dynamic> json) => _$BookingCreatedFromJson(json);

@override final  Booking booking;
@override final  PaymentIntentInfo payment;

/// Create a copy of BookingCreated
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCreatedCopyWith<_BookingCreated> get copyWith => __$BookingCreatedCopyWithImpl<_BookingCreated>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingCreatedToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingCreated&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.payment, payment) || other.payment == payment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,booking,payment);
}

@override
String toString() {
    return 'BookingCreated(booking: $booking, payment: $payment)';
}


}

/// @nodoc
abstract mixin class _$BookingCreatedCopyWith<$Res> implements $BookingCreatedCopyWith<$Res> {
  factory _$BookingCreatedCopyWith(_BookingCreated value, $Res Function(_BookingCreated) _then) = __$BookingCreatedCopyWithImpl;
@override @useResult
$Res call({
 Booking booking, PaymentIntentInfo payment
});


@override $BookingCopyWith<$Res> get booking;@override $PaymentIntentInfoCopyWith<$Res> get payment;

}
/// @nodoc
class __$BookingCreatedCopyWithImpl<$Res>
    implements _$BookingCreatedCopyWith<$Res> {
  __$BookingCreatedCopyWithImpl(this._self, this._then);

  final _BookingCreated _self;
  final $Res Function(_BookingCreated) _then;

/// Create a copy of BookingCreated
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? booking = null,Object? payment = null,}) {
  return _then(_BookingCreated(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as PaymentIntentInfo,
  ));
}

/// Create a copy of BookingCreated
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}/// Create a copy of BookingCreated
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentIntentInfoCopyWith<$Res> get payment {
  
  return $PaymentIntentInfoCopyWith<$Res>(_self.payment, (value) {
    return _then(_self.copyWith(payment: value));
  });
}
}


/// @nodoc
mixin _$Cancellation {

 Booking get booking;/// False when the cancellation came too late and the price is charged.
 bool get refunded;
/// Create a copy of Cancellation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CancellationCopyWith<Cancellation> get copyWith => _$CancellationCopyWithImpl<Cancellation>(this as Cancellation, _$identity);

  /// Serializes this Cancellation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Cancellation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cancellation&&(identical(other.booking, _this.booking) || other.booking == _this.booking)&&(identical(other.refunded, _this.refunded) || other.refunded == _this.refunded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Cancellation;
  return Object.hash(runtimeType,_this.booking,_this.refunded);
}

@override
String toString() {
  final _this = this as Cancellation;
  return 'Cancellation(booking: ${_this.booking}, refunded: ${_this.refunded})';
}


}

/// @nodoc
abstract mixin class $CancellationCopyWith<$Res>  {
  factory $CancellationCopyWith(Cancellation value, $Res Function(Cancellation) _then) = _$CancellationCopyWithImpl;
@useResult
$Res call({
 Booking booking, bool refunded
});


$BookingCopyWith<$Res> get booking;

}
/// @nodoc
class _$CancellationCopyWithImpl<$Res>
    implements $CancellationCopyWith<$Res> {
  _$CancellationCopyWithImpl(this._self, this._then);

  final Cancellation _self;
  final $Res Function(Cancellation) _then;

/// Create a copy of Cancellation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? booking = null,Object? refunded = null,}) {
  return _then(Cancellation(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,refunded: null == refunded ? _self.refunded : refunded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Cancellation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}


/// Adds pattern-matching-related methods to [Cancellation].
extension CancellationPatterns on Cancellation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cancellation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cancellation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cancellation value)  $default,){
final _that = this;
switch (_that) {
case _Cancellation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cancellation value)?  $default,){
final _that = this;
switch (_that) {
case _Cancellation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Booking booking,  bool refunded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cancellation() when $default != null:
return $default(_that.booking,_that.refunded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Booking booking,  bool refunded)  $default,) {final _that = this;
switch (_that) {
case _Cancellation():
return $default(_that.booking,_that.refunded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Booking booking,  bool refunded)?  $default,) {final _that = this;
switch (_that) {
case _Cancellation() when $default != null:
return $default(_that.booking,_that.refunded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cancellation implements Cancellation {
  const _Cancellation({required this.booking, required this.refunded});
  factory _Cancellation.fromJson(Map<String, dynamic> json) => _$CancellationFromJson(json);

@override final  Booking booking;
/// False when the cancellation came too late and the price is charged.
@override final  bool refunded;

/// Create a copy of Cancellation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CancellationCopyWith<_Cancellation> get copyWith => __$CancellationCopyWithImpl<_Cancellation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CancellationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cancellation&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.refunded, refunded) || other.refunded == refunded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,booking,refunded);
}

@override
String toString() {
    return 'Cancellation(booking: $booking, refunded: $refunded)';
}


}

/// @nodoc
abstract mixin class _$CancellationCopyWith<$Res> implements $CancellationCopyWith<$Res> {
  factory _$CancellationCopyWith(_Cancellation value, $Res Function(_Cancellation) _then) = __$CancellationCopyWithImpl;
@override @useResult
$Res call({
 Booking booking, bool refunded
});


@override $BookingCopyWith<$Res> get booking;

}
/// @nodoc
class __$CancellationCopyWithImpl<$Res>
    implements _$CancellationCopyWith<$Res> {
  __$CancellationCopyWithImpl(this._self, this._then);

  final _Cancellation _self;
  final $Res Function(_Cancellation) _then;

/// Create a copy of Cancellation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? booking = null,Object? refunded = null,}) {
  return _then(_Cancellation(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,refunded: null == refunded ? _self.refunded : refunded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Cancellation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}


/// @nodoc
mixin _$ReviewRequest {

/// 1 to 5.
 int get rating; List<String> get tags; String get comment;/// Tip in pence, 0 to 10000.
 int get tip;
/// Create a copy of ReviewRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewRequestCopyWith<ReviewRequest> get copyWith => _$ReviewRequestCopyWithImpl<ReviewRequest>(this as ReviewRequest, _$identity);

  /// Serializes this ReviewRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReviewRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewRequest&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&(identical(other.comment, _this.comment) || other.comment == _this.comment)&&(identical(other.tip, _this.tip) || other.tip == _this.tip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReviewRequest;
  return Object.hash(runtimeType,_this.rating,const DeepCollectionEquality().hash(_this.tags),_this.comment,_this.tip);
}

@override
String toString() {
  final _this = this as ReviewRequest;
  return 'ReviewRequest(rating: ${_this.rating}, tags: ${_this.tags}, comment: ${_this.comment}, tip: ${_this.tip})';
}


}

/// @nodoc
abstract mixin class $ReviewRequestCopyWith<$Res>  {
  factory $ReviewRequestCopyWith(ReviewRequest value, $Res Function(ReviewRequest) _then) = _$ReviewRequestCopyWithImpl;
@useResult
$Res call({
 int rating, List<String> tags, String comment, int tip
});




}
/// @nodoc
class _$ReviewRequestCopyWithImpl<$Res>
    implements $ReviewRequestCopyWith<$Res> {
  _$ReviewRequestCopyWithImpl(this._self, this._then);

  final ReviewRequest _self;
  final $Res Function(ReviewRequest) _then;

/// Create a copy of ReviewRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rating = null,Object? tags = null,Object? comment = null,Object? tip = null,}) {
  return _then(ReviewRequest(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,tip: null == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewRequest].
extension ReviewRequestPatterns on ReviewRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewRequest value)  $default,){
final _that = this;
switch (_that) {
case _ReviewRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rating,  List<String> tags,  String comment,  int tip)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewRequest() when $default != null:
return $default(_that.rating,_that.tags,_that.comment,_that.tip);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rating,  List<String> tags,  String comment,  int tip)  $default,) {final _that = this;
switch (_that) {
case _ReviewRequest():
return $default(_that.rating,_that.tags,_that.comment,_that.tip);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rating,  List<String> tags,  String comment,  int tip)?  $default,) {final _that = this;
switch (_that) {
case _ReviewRequest() when $default != null:
return $default(_that.rating,_that.tags,_that.comment,_that.tip);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewRequest implements ReviewRequest {
  const _ReviewRequest({required this.rating,  List<String> tags = const <String>[], this.comment = '', this.tip = 0}): _tags = tags;
  factory _ReviewRequest.fromJson(Map<String, dynamic> json) => _$ReviewRequestFromJson(json);

/// 1 to 5.
@override final  int rating;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  String comment;
/// Tip in pence, 0 to 10000.
@override@JsonKey() final  int tip;

/// Create a copy of ReviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewRequestCopyWith<_ReviewRequest> get copyWith => __$ReviewRequestCopyWithImpl<_ReviewRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewRequest&&(identical(other.rating, rating) || other.rating == rating)&&const DeepCollectionEquality().equals(other.tags, _tags)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.tip, tip) || other.tip == tip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rating,const DeepCollectionEquality().hash(_tags),comment,tip);
}

@override
String toString() {
    return 'ReviewRequest(rating: $rating, tags: $tags, comment: $comment, tip: $tip)';
}


}

/// @nodoc
abstract mixin class _$ReviewRequestCopyWith<$Res> implements $ReviewRequestCopyWith<$Res> {
  factory _$ReviewRequestCopyWith(_ReviewRequest value, $Res Function(_ReviewRequest) _then) = __$ReviewRequestCopyWithImpl;
@override @useResult
$Res call({
 int rating, List<String> tags, String comment, int tip
});




}
/// @nodoc
class __$ReviewRequestCopyWithImpl<$Res>
    implements _$ReviewRequestCopyWith<$Res> {
  __$ReviewRequestCopyWithImpl(this._self, this._then);

  final _ReviewRequest _self;
  final $Res Function(_ReviewRequest) _then;

/// Create a copy of ReviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rating = null,Object? tags = null,Object? comment = null,Object? tip = null,}) {
  return _then(_ReviewRequest(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,tip: null == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AdminBookingPatch {

 String? get cleanerId; BookingStatus? get status;
/// Create a copy of AdminBookingPatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminBookingPatchCopyWith<AdminBookingPatch> get copyWith => _$AdminBookingPatchCopyWithImpl<AdminBookingPatch>(this as AdminBookingPatch, _$identity);

  /// Serializes this AdminBookingPatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminBookingPatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminBookingPatch&&(identical(other.cleanerId, _this.cleanerId) || other.cleanerId == _this.cleanerId)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminBookingPatch;
  return Object.hash(runtimeType,_this.cleanerId,_this.status);
}

@override
String toString() {
  final _this = this as AdminBookingPatch;
  return 'AdminBookingPatch(cleanerId: ${_this.cleanerId}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $AdminBookingPatchCopyWith<$Res>  {
  factory $AdminBookingPatchCopyWith(AdminBookingPatch value, $Res Function(AdminBookingPatch) _then) = _$AdminBookingPatchCopyWithImpl;
@useResult
$Res call({
 String? cleanerId, BookingStatus? status
});




}
/// @nodoc
class _$AdminBookingPatchCopyWithImpl<$Res>
    implements $AdminBookingPatchCopyWith<$Res> {
  _$AdminBookingPatchCopyWithImpl(this._self, this._then);

  final AdminBookingPatch _self;
  final $Res Function(AdminBookingPatch) _then;

/// Create a copy of AdminBookingPatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cleanerId = freezed,Object? status = freezed,}) {
  return _then(AdminBookingPatch(
cleanerId: freezed == cleanerId ? _self.cleanerId : cleanerId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminBookingPatch].
extension AdminBookingPatchPatterns on AdminBookingPatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminBookingPatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminBookingPatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminBookingPatch value)  $default,){
final _that = this;
switch (_that) {
case _AdminBookingPatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminBookingPatch value)?  $default,){
final _that = this;
switch (_that) {
case _AdminBookingPatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? cleanerId,  BookingStatus? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminBookingPatch() when $default != null:
return $default(_that.cleanerId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? cleanerId,  BookingStatus? status)  $default,) {final _that = this;
switch (_that) {
case _AdminBookingPatch():
return $default(_that.cleanerId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? cleanerId,  BookingStatus? status)?  $default,) {final _that = this;
switch (_that) {
case _AdminBookingPatch() when $default != null:
return $default(_that.cleanerId,_that.status);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _AdminBookingPatch implements AdminBookingPatch {
  const _AdminBookingPatch({this.cleanerId, this.status});
  factory _AdminBookingPatch.fromJson(Map<String, dynamic> json) => _$AdminBookingPatchFromJson(json);

@override final  String? cleanerId;
@override final  BookingStatus? status;

/// Create a copy of AdminBookingPatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminBookingPatchCopyWith<_AdminBookingPatch> get copyWith => __$AdminBookingPatchCopyWithImpl<_AdminBookingPatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminBookingPatchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminBookingPatch&&(identical(other.cleanerId, cleanerId) || other.cleanerId == cleanerId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,cleanerId,status);
}

@override
String toString() {
    return 'AdminBookingPatch(cleanerId: $cleanerId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AdminBookingPatchCopyWith<$Res> implements $AdminBookingPatchCopyWith<$Res> {
  factory _$AdminBookingPatchCopyWith(_AdminBookingPatch value, $Res Function(_AdminBookingPatch) _then) = __$AdminBookingPatchCopyWithImpl;
@override @useResult
$Res call({
 String? cleanerId, BookingStatus? status
});




}
/// @nodoc
class __$AdminBookingPatchCopyWithImpl<$Res>
    implements _$AdminBookingPatchCopyWith<$Res> {
  __$AdminBookingPatchCopyWithImpl(this._self, this._then);

  final _AdminBookingPatch _self;
  final $Res Function(_AdminBookingPatch) _then;

/// Create a copy of AdminBookingPatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cleanerId = freezed,Object? status = freezed,}) {
  return _then(_AdminBookingPatch(
cleanerId: freezed == cleanerId ? _self.cleanerId : cleanerId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus?,
  ));
}


}

// dart format on
