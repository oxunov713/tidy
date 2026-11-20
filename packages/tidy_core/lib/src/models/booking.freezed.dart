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

 BookingStatus get status; DateTime get at;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingEvent&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.at, _this.at) || other.at == _this.at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BookingEvent;
  return Object.hash(runtimeType,_this.status,_this.at);
}

@override
String toString() {
  final _this = this as BookingEvent;
  return 'BookingEvent(status: ${_this.status}, at: ${_this.at})';
}


}

/// @nodoc
abstract mixin class $BookingEventCopyWith<$Res>  {
  factory $BookingEventCopyWith(BookingEvent value, $Res Function(BookingEvent) _then) = _$BookingEventCopyWithImpl;
@useResult
$Res call({
 BookingStatus status, DateTime at
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
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? at = null,}) {
  return _then(BookingEvent(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BookingStatus status,  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingEvent() when $default != null:
return $default(_that.status,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BookingStatus status,  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _BookingEvent():
return $default(_that.status,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BookingStatus status,  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _BookingEvent() when $default != null:
return $default(_that.status,_that.at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingEvent implements BookingEvent {
  const _BookingEvent({required this.status, required this.at});
  factory _BookingEvent.fromJson(Map<String, dynamic> json) => _$BookingEventFromJson(json);

@override final  BookingStatus status;
@override final  DateTime at;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingEvent&&(identical(other.status, status) || other.status == status)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,at);
}

@override
String toString() {
    return 'BookingEvent(status: $status, at: $at)';
}


}

/// @nodoc
abstract mixin class _$BookingEventCopyWith<$Res> implements $BookingEventCopyWith<$Res> {
  factory _$BookingEventCopyWith(_BookingEvent value, $Res Function(_BookingEvent) _then) = __$BookingEventCopyWithImpl;
@override @useResult
$Res call({
 BookingStatus status, DateTime at
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
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? at = null,}) {
  return _then(_BookingEvent(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CleanerLocation {

 double get lat; double get lng; int? get etaMinutes; DateTime? get at;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CleanerLocation&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.etaMinutes, _this.etaMinutes) || other.etaMinutes == _this.etaMinutes)&&(identical(other.at, _this.at) || other.at == _this.at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CleanerLocation;
  return Object.hash(runtimeType,_this.lat,_this.lng,_this.etaMinutes,_this.at);
}

@override
String toString() {
  final _this = this as CleanerLocation;
  return 'CleanerLocation(lat: ${_this.lat}, lng: ${_this.lng}, etaMinutes: ${_this.etaMinutes}, at: ${_this.at})';
}


}

/// @nodoc
abstract mixin class $CleanerLocationCopyWith<$Res>  {
  factory $CleanerLocationCopyWith(CleanerLocation value, $Res Function(CleanerLocation) _then) = _$CleanerLocationCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, int? etaMinutes, DateTime? at
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
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? etaMinutes = freezed,Object? at = freezed,}) {
  return _then(CleanerLocation(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,etaMinutes: freezed == etaMinutes ? _self.etaMinutes : etaMinutes // ignore: cast_nullable_to_non_nullable
as int?,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  int? etaMinutes,  DateTime? at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CleanerLocation() when $default != null:
return $default(_that.lat,_that.lng,_that.etaMinutes,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  int? etaMinutes,  DateTime? at)  $default,) {final _that = this;
switch (_that) {
case _CleanerLocation():
return $default(_that.lat,_that.lng,_that.etaMinutes,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  int? etaMinutes,  DateTime? at)?  $default,) {final _that = this;
switch (_that) {
case _CleanerLocation() when $default != null:
return $default(_that.lat,_that.lng,_that.etaMinutes,_that.at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CleanerLocation implements CleanerLocation {
  const _CleanerLocation({required this.lat, required this.lng, this.etaMinutes, this.at});
  factory _CleanerLocation.fromJson(Map<String, dynamic> json) => _$CleanerLocationFromJson(json);

@override final  double lat;
@override final  double lng;
@override final  int? etaMinutes;
@override final  DateTime? at;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CleanerLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.etaMinutes, etaMinutes) || other.etaMinutes == etaMinutes)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,lat,lng,etaMinutes,at);
}

@override
String toString() {
    return 'CleanerLocation(lat: $lat, lng: $lng, etaMinutes: $etaMinutes, at: $at)';
}


}

/// @nodoc
abstract mixin class _$CleanerLocationCopyWith<$Res> implements $CleanerLocationCopyWith<$Res> {
  factory _$CleanerLocationCopyWith(_CleanerLocation value, $Res Function(_CleanerLocation) _then) = __$CleanerLocationCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, int? etaMinutes, DateTime? at
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
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? etaMinutes = freezed,Object? at = freezed,}) {
  return _then(_CleanerLocation(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,etaMinutes: freezed == etaMinutes ? _self.etaMinutes : etaMinutes // ignore: cast_nullable_to_non_nullable
as int?,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Booking {

 String get id; BookingStatus get status; DateTime get start;/// Human friendly reference, e.g. `TD-1042`.
 String get code; String get serviceId; String get serviceTitle; int get bedrooms; int get bathrooms; Frequency get frequency; DateTime? get end; int get minutes; int get subtotal; int get discount; int get total; List<Extra> get extras; Address? get address; Cleaner? get cleaner; ClientSummary? get client; CleanerLocation? get cleanerLocation; List<BookingEvent> get events;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.serviceId, _this.serviceId) || other.serviceId == _this.serviceId)&&(identical(other.serviceTitle, _this.serviceTitle) || other.serviceTitle == _this.serviceTitle)&&(identical(other.bedrooms, _this.bedrooms) || other.bedrooms == _this.bedrooms)&&(identical(other.bathrooms, _this.bathrooms) || other.bathrooms == _this.bathrooms)&&(identical(other.frequency, _this.frequency) || other.frequency == _this.frequency)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.minutes, _this.minutes) || other.minutes == _this.minutes)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal)&&(identical(other.discount, _this.discount) || other.discount == _this.discount)&&(identical(other.total, _this.total) || other.total == _this.total)&&const DeepCollectionEquality().equals(other.extras, _this.extras)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.cleaner, _this.cleaner) || other.cleaner == _this.cleaner)&&(identical(other.client, _this.client) || other.client == _this.client)&&(identical(other.cleanerLocation, _this.cleanerLocation) || other.cleanerLocation == _this.cleanerLocation)&&const DeepCollectionEquality().equals(other.events, _this.events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Booking;
  return Object.hashAll([runtimeType,_this.id,_this.status,_this.start,_this.code,_this.serviceId,_this.serviceTitle,_this.bedrooms,_this.bathrooms,_this.frequency,_this.end,_this.minutes,_this.subtotal,_this.discount,_this.total,const DeepCollectionEquality().hash(_this.extras),_this.address,_this.cleaner,_this.client,_this.cleanerLocation,const DeepCollectionEquality().hash(_this.events)]);
}

@override
String toString() {
  final _this = this as Booking;
  return 'Booking(id: ${_this.id}, status: ${_this.status}, start: ${_this.start}, code: ${_this.code}, serviceId: ${_this.serviceId}, serviceTitle: ${_this.serviceTitle}, bedrooms: ${_this.bedrooms}, bathrooms: ${_this.bathrooms}, frequency: ${_this.frequency}, end: ${_this.end}, minutes: ${_this.minutes}, subtotal: ${_this.subtotal}, discount: ${_this.discount}, total: ${_this.total}, extras: ${_this.extras}, address: ${_this.address}, cleaner: ${_this.cleaner}, client: ${_this.client}, cleanerLocation: ${_this.cleanerLocation}, events: ${_this.events})';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 String id, BookingStatus status, DateTime start, String code, String serviceId, String serviceTitle, int bedrooms, int bathrooms, Frequency frequency, DateTime? end, int minutes, int subtotal, int discount, int total, List<Extra> extras, Address? address, Cleaner? cleaner, ClientSummary? client, CleanerLocation? cleanerLocation, List<BookingEvent> events
});


$AddressCopyWith<$Res>? get address;$CleanerCopyWith<$Res>? get cleaner;$ClientSummaryCopyWith<$Res>? get client;$CleanerLocationCopyWith<$Res>? get cleanerLocation;

}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? start = null,Object? code = null,Object? serviceId = null,Object? serviceTitle = null,Object? bedrooms = null,Object? bathrooms = null,Object? frequency = null,Object? end = freezed,Object? minutes = null,Object? subtotal = null,Object? discount = null,Object? total = null,Object? extras = null,Object? address = freezed,Object? cleaner = freezed,Object? client = freezed,Object? cleanerLocation = freezed,Object? events = null,}) {
  return _then(Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,serviceTitle: null == serviceTitle ? _self.serviceTitle : serviceTitle // ignore: cast_nullable_to_non_nullable
as String,bedrooms: null == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int,bathrooms: null == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime?,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,extras: null == extras ? _self.extras : extras // ignore: cast_nullable_to_non_nullable
as List<Extra>,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address?,cleaner: freezed == cleaner ? _self.cleaner : cleaner // ignore: cast_nullable_to_non_nullable
as Cleaner?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as ClientSummary?,cleanerLocation: freezed == cleanerLocation ? _self.cleanerLocation : cleanerLocation // ignore: cast_nullable_to_non_nullable
as CleanerLocation?,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<BookingEvent>,
  ));
}
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $AddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CleanerCopyWith<$Res>? get cleaner {
    if (_self.cleaner == null) {
    return null;
  }

  return $CleanerCopyWith<$Res>(_self.cleaner!, (value) {
    return _then(_self.copyWith(cleaner: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientSummaryCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $ClientSummaryCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CleanerLocationCopyWith<$Res>? get cleanerLocation {
    if (_self.cleanerLocation == null) {
    return null;
  }

  return $CleanerLocationCopyWith<$Res>(_self.cleanerLocation!, (value) {
    return _then(_self.copyWith(cleanerLocation: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  BookingStatus status,  DateTime start,  String code,  String serviceId,  String serviceTitle,  int bedrooms,  int bathrooms,  Frequency frequency,  DateTime? end,  int minutes,  int subtotal,  int discount,  int total,  List<Extra> extras,  Address? address,  Cleaner? cleaner,  ClientSummary? client,  CleanerLocation? cleanerLocation,  List<BookingEvent> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.status,_that.start,_that.code,_that.serviceId,_that.serviceTitle,_that.bedrooms,_that.bathrooms,_that.frequency,_that.end,_that.minutes,_that.subtotal,_that.discount,_that.total,_that.extras,_that.address,_that.cleaner,_that.client,_that.cleanerLocation,_that.events);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  BookingStatus status,  DateTime start,  String code,  String serviceId,  String serviceTitle,  int bedrooms,  int bathrooms,  Frequency frequency,  DateTime? end,  int minutes,  int subtotal,  int discount,  int total,  List<Extra> extras,  Address? address,  Cleaner? cleaner,  ClientSummary? client,  CleanerLocation? cleanerLocation,  List<BookingEvent> events)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.status,_that.start,_that.code,_that.serviceId,_that.serviceTitle,_that.bedrooms,_that.bathrooms,_that.frequency,_that.end,_that.minutes,_that.subtotal,_that.discount,_that.total,_that.extras,_that.address,_that.cleaner,_that.client,_that.cleanerLocation,_that.events);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  BookingStatus status,  DateTime start,  String code,  String serviceId,  String serviceTitle,  int bedrooms,  int bathrooms,  Frequency frequency,  DateTime? end,  int minutes,  int subtotal,  int discount,  int total,  List<Extra> extras,  Address? address,  Cleaner? cleaner,  ClientSummary? client,  CleanerLocation? cleanerLocation,  List<BookingEvent> events)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.status,_that.start,_that.code,_that.serviceId,_that.serviceTitle,_that.bedrooms,_that.bathrooms,_that.frequency,_that.end,_that.minutes,_that.subtotal,_that.discount,_that.total,_that.extras,_that.address,_that.cleaner,_that.client,_that.cleanerLocation,_that.events);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Booking implements Booking {
  const _Booking({required this.id, required this.status, required this.start, this.code = '', this.serviceId = '', this.serviceTitle = '', this.bedrooms = 1, this.bathrooms = 1, this.frequency = Frequency.once, this.end, this.minutes = 0, this.subtotal = 0, this.discount = 0, this.total = 0,  List<Extra> extras = const <Extra>[], this.address, this.cleaner, this.client, this.cleanerLocation,  List<BookingEvent> events = const <BookingEvent>[]}): _extras = extras,_events = events;
  factory _Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

@override final  String id;
@override final  BookingStatus status;
@override final  DateTime start;
/// Human friendly reference, e.g. `TD-1042`.
@override@JsonKey() final  String code;
@override@JsonKey() final  String serviceId;
@override@JsonKey() final  String serviceTitle;
@override@JsonKey() final  int bedrooms;
@override@JsonKey() final  int bathrooms;
@override@JsonKey() final  Frequency frequency;
@override final  DateTime? end;
@override@JsonKey() final  int minutes;
@override@JsonKey() final  int subtotal;
@override@JsonKey() final  int discount;
@override@JsonKey() final  int total;
 final  List<Extra> _extras;
@override@JsonKey() List<Extra> get extras {
  if (_extras is EqualUnmodifiableListView) return _extras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extras);
}

@override final  Address? address;
@override final  Cleaner? cleaner;
@override final  ClientSummary? client;
@override final  CleanerLocation? cleanerLocation;
 final  List<BookingEvent> _events;
@override@JsonKey() List<BookingEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.start, start) || other.start == start)&&(identical(other.code, code) || other.code == code)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.serviceTitle, serviceTitle) || other.serviceTitle == serviceTitle)&&(identical(other.bedrooms, bedrooms) || other.bedrooms == bedrooms)&&(identical(other.bathrooms, bathrooms) || other.bathrooms == bathrooms)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.end, end) || other.end == end)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.extras, _extras)&&(identical(other.address, address) || other.address == address)&&(identical(other.cleaner, cleaner) || other.cleaner == cleaner)&&(identical(other.client, client) || other.client == client)&&(identical(other.cleanerLocation, cleanerLocation) || other.cleanerLocation == cleanerLocation)&&const DeepCollectionEquality().equals(other.events, _events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,status,start,code,serviceId,serviceTitle,bedrooms,bathrooms,frequency,end,minutes,subtotal,discount,total,const DeepCollectionEquality().hash(_extras),address,cleaner,client,cleanerLocation,const DeepCollectionEquality().hash(_events)]);
}

@override
String toString() {
    return 'Booking(id: $id, status: $status, start: $start, code: $code, serviceId: $serviceId, serviceTitle: $serviceTitle, bedrooms: $bedrooms, bathrooms: $bathrooms, frequency: $frequency, end: $end, minutes: $minutes, subtotal: $subtotal, discount: $discount, total: $total, extras: $extras, address: $address, cleaner: $cleaner, client: $client, cleanerLocation: $cleanerLocation, events: $events)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 String id, BookingStatus status, DateTime start, String code, String serviceId, String serviceTitle, int bedrooms, int bathrooms, Frequency frequency, DateTime? end, int minutes, int subtotal, int discount, int total, List<Extra> extras, Address? address, Cleaner? cleaner, ClientSummary? client, CleanerLocation? cleanerLocation, List<BookingEvent> events
});


@override $AddressCopyWith<$Res>? get address;@override $CleanerCopyWith<$Res>? get cleaner;@override $ClientSummaryCopyWith<$Res>? get client;@override $CleanerLocationCopyWith<$Res>? get cleanerLocation;

}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? start = null,Object? code = null,Object? serviceId = null,Object? serviceTitle = null,Object? bedrooms = null,Object? bathrooms = null,Object? frequency = null,Object? end = freezed,Object? minutes = null,Object? subtotal = null,Object? discount = null,Object? total = null,Object? extras = null,Object? address = freezed,Object? cleaner = freezed,Object? client = freezed,Object? cleanerLocation = freezed,Object? events = null,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,serviceTitle: null == serviceTitle ? _self.serviceTitle : serviceTitle // ignore: cast_nullable_to_non_nullable
as String,bedrooms: null == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int,bathrooms: null == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime?,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,extras: null == extras ? _self._extras : extras // ignore: cast_nullable_to_non_nullable
as List<Extra>,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address?,cleaner: freezed == cleaner ? _self.cleaner : cleaner // ignore: cast_nullable_to_non_nullable
as Cleaner?,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as ClientSummary?,cleanerLocation: freezed == cleanerLocation ? _self.cleanerLocation : cleanerLocation // ignore: cast_nullable_to_non_nullable
as CleanerLocation?,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<BookingEvent>,
  ));
}

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $AddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CleanerCopyWith<$Res>? get cleaner {
    if (_self.cleaner == null) {
    return null;
  }

  return $CleanerCopyWith<$Res>(_self.cleaner!, (value) {
    return _then(_self.copyWith(cleaner: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientSummaryCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $ClientSummaryCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CleanerLocationCopyWith<$Res>? get cleanerLocation {
    if (_self.cleanerLocation == null) {
    return null;
  }

  return $CleanerLocationCopyWith<$Res>(_self.cleanerLocation!, (value) {
    return _then(_self.copyWith(cleanerLocation: value));
  });
}
}


/// @nodoc
mixin _$BookingPage {

 List<Booking> get items;/// Null on the last page.
 String? get nextCursor;
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
 List<Booking> items, String? nextCursor
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
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(BookingPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Booking>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Booking> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Booking> items,  String? nextCursor)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Booking> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _BookingPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingPage implements BookingPage {
  const _BookingPage({ List<Booking> items = const <Booking>[], this.nextCursor}): _items = items;
  factory _BookingPage.fromJson(Map<String, dynamic> json) => _$BookingPageFromJson(json);

 final  List<Booking> _items;
@override@JsonKey() List<Booking> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Null on the last page.
@override final  String? nextCursor;

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
 List<Booking> items, String? nextCursor
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
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_BookingPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Booking>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateBookingRequest {

 String get serviceId; int get bedrooms; int get bathrooms; String get addressId; DateTime get start; List<String> get extraIds; Frequency get frequency; String? get cleanerId;
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
 String serviceId, int bedrooms, int bathrooms, String addressId, DateTime start, List<String> extraIds, Frequency frequency, String? cleanerId
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serviceId,  int bedrooms,  int bathrooms,  String addressId,  DateTime start,  List<String> extraIds,  Frequency frequency,  String? cleanerId)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serviceId,  int bedrooms,  int bathrooms,  String addressId,  DateTime start,  List<String> extraIds,  Frequency frequency,  String? cleanerId)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serviceId,  int bedrooms,  int bathrooms,  String addressId,  DateTime start,  List<String> extraIds,  Frequency frequency,  String? cleanerId)?  $default,) {final _that = this;
switch (_that) {
case _CreateBookingRequest() when $default != null:
return $default(_that.serviceId,_that.bedrooms,_that.bathrooms,_that.addressId,_that.start,_that.extraIds,_that.frequency,_that.cleanerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateBookingRequest implements CreateBookingRequest {
  const _CreateBookingRequest({required this.serviceId, required this.bedrooms, required this.bathrooms, required this.addressId, required this.start,  List<String> extraIds = const <String>[], this.frequency = Frequency.once, this.cleanerId}): _extraIds = extraIds;
  factory _CreateBookingRequest.fromJson(Map<String, dynamic> json) => _$CreateBookingRequestFromJson(json);

@override final  String serviceId;
@override final  int bedrooms;
@override final  int bathrooms;
@override final  String addressId;
@override final  DateTime start;
 final  List<String> _extraIds;
@override@JsonKey() List<String> get extraIds {
  if (_extraIds is EqualUnmodifiableListView) return _extraIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extraIds);
}

@override@JsonKey() final  Frequency frequency;
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
 String serviceId, int bedrooms, int bathrooms, String addressId, DateTime start, List<String> extraIds, Frequency frequency, String? cleanerId
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
mixin _$ReviewRequest {

/// 1 to 5.
 int get rating; List<String> get tags; String get comment;/// Tip in pence.
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
/// Tip in pence.
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
@JsonSerializable()

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
