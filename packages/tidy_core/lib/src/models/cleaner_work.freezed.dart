// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cleaner_work.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Offer {

 Booking get booking; DateTime get expiresAt;
/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferCopyWith<Offer> get copyWith => _$OfferCopyWithImpl<Offer>(this as Offer, _$identity);

  /// Serializes this Offer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Offer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Offer&&(identical(other.booking, _this.booking) || other.booking == _this.booking)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Offer;
  return Object.hash(runtimeType,_this.booking,_this.expiresAt);
}

@override
String toString() {
  final _this = this as Offer;
  return 'Offer(booking: ${_this.booking}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $OfferCopyWith<$Res>  {
  factory $OfferCopyWith(Offer value, $Res Function(Offer) _then) = _$OfferCopyWithImpl;
@useResult
$Res call({
 Booking booking, DateTime expiresAt
});


$BookingCopyWith<$Res> get booking;

}
/// @nodoc
class _$OfferCopyWithImpl<$Res>
    implements $OfferCopyWith<$Res> {
  _$OfferCopyWithImpl(this._self, this._then);

  final Offer _self;
  final $Res Function(Offer) _then;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? booking = null,Object? expiresAt = null,}) {
  return _then(Offer(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}


/// Adds pattern-matching-related methods to [Offer].
extension OfferPatterns on Offer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Offer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Offer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Offer value)  $default,){
final _that = this;
switch (_that) {
case _Offer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Offer value)?  $default,){
final _that = this;
switch (_that) {
case _Offer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Booking booking,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that.booking,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Booking booking,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _Offer():
return $default(_that.booking,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Booking booking,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that.booking,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Offer implements Offer {
  const _Offer({required this.booking, required this.expiresAt});
  factory _Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

@override final  Booking booking;
@override final  DateTime expiresAt;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferCopyWith<_Offer> get copyWith => __$OfferCopyWithImpl<_Offer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Offer&&(identical(other.booking, booking) || other.booking == booking)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,booking,expiresAt);
}

@override
String toString() {
    return 'Offer(booking: $booking, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$OfferCopyWith<$Res> implements $OfferCopyWith<$Res> {
  factory _$OfferCopyWith(_Offer value, $Res Function(_Offer) _then) = __$OfferCopyWithImpl;
@override @useResult
$Res call({
 Booking booking, DateTime expiresAt
});


@override $BookingCopyWith<$Res> get booking;

}
/// @nodoc
class __$OfferCopyWithImpl<$Res>
    implements _$OfferCopyWith<$Res> {
  __$OfferCopyWithImpl(this._self, this._then);

  final _Offer _self;
  final $Res Function(_Offer) _then;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? booking = null,Object? expiresAt = null,}) {
  return _then(_Offer(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Offer
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
mixin _$AvailabilityWindow {

/// 0 = Monday.
 int get weekday;/// `HH:mm`.
 String get startTime; String get endTime;
/// Create a copy of AvailabilityWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilityWindowCopyWith<AvailabilityWindow> get copyWith => _$AvailabilityWindowCopyWithImpl<AvailabilityWindow>(this as AvailabilityWindow, _$identity);

  /// Serializes this AvailabilityWindow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AvailabilityWindow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailabilityWindow&&(identical(other.weekday, _this.weekday) || other.weekday == _this.weekday)&&(identical(other.startTime, _this.startTime) || other.startTime == _this.startTime)&&(identical(other.endTime, _this.endTime) || other.endTime == _this.endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AvailabilityWindow;
  return Object.hash(runtimeType,_this.weekday,_this.startTime,_this.endTime);
}

@override
String toString() {
  final _this = this as AvailabilityWindow;
  return 'AvailabilityWindow(weekday: ${_this.weekday}, startTime: ${_this.startTime}, endTime: ${_this.endTime})';
}


}

/// @nodoc
abstract mixin class $AvailabilityWindowCopyWith<$Res>  {
  factory $AvailabilityWindowCopyWith(AvailabilityWindow value, $Res Function(AvailabilityWindow) _then) = _$AvailabilityWindowCopyWithImpl;
@useResult
$Res call({
 int weekday, String startTime, String endTime
});




}
/// @nodoc
class _$AvailabilityWindowCopyWithImpl<$Res>
    implements $AvailabilityWindowCopyWith<$Res> {
  _$AvailabilityWindowCopyWithImpl(this._self, this._then);

  final AvailabilityWindow _self;
  final $Res Function(AvailabilityWindow) _then;

/// Create a copy of AvailabilityWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekday = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(AvailabilityWindow(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailabilityWindow].
extension AvailabilityWindowPatterns on AvailabilityWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailabilityWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailabilityWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailabilityWindow value)  $default,){
final _that = this;
switch (_that) {
case _AvailabilityWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailabilityWindow value)?  $default,){
final _that = this;
switch (_that) {
case _AvailabilityWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int weekday,  String startTime,  String endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailabilityWindow() when $default != null:
return $default(_that.weekday,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int weekday,  String startTime,  String endTime)  $default,) {final _that = this;
switch (_that) {
case _AvailabilityWindow():
return $default(_that.weekday,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int weekday,  String startTime,  String endTime)?  $default,) {final _that = this;
switch (_that) {
case _AvailabilityWindow() when $default != null:
return $default(_that.weekday,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvailabilityWindow implements AvailabilityWindow {
  const _AvailabilityWindow({required this.weekday, required this.startTime, required this.endTime});
  factory _AvailabilityWindow.fromJson(Map<String, dynamic> json) => _$AvailabilityWindowFromJson(json);

/// 0 = Monday.
@override final  int weekday;
/// `HH:mm`.
@override final  String startTime;
@override final  String endTime;

/// Create a copy of AvailabilityWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilityWindowCopyWith<_AvailabilityWindow> get copyWith => __$AvailabilityWindowCopyWithImpl<_AvailabilityWindow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailabilityWindowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailabilityWindow&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,weekday,startTime,endTime);
}

@override
String toString() {
    return 'AvailabilityWindow(weekday: $weekday, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$AvailabilityWindowCopyWith<$Res> implements $AvailabilityWindowCopyWith<$Res> {
  factory _$AvailabilityWindowCopyWith(_AvailabilityWindow value, $Res Function(_AvailabilityWindow) _then) = __$AvailabilityWindowCopyWithImpl;
@override @useResult
$Res call({
 int weekday, String startTime, String endTime
});




}
/// @nodoc
class __$AvailabilityWindowCopyWithImpl<$Res>
    implements _$AvailabilityWindowCopyWith<$Res> {
  __$AvailabilityWindowCopyWithImpl(this._self, this._then);

  final _AvailabilityWindow _self;
  final $Res Function(_AvailabilityWindow) _then;

/// Create a copy of AvailabilityWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekday = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_AvailabilityWindow(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$EarningsDay {

/// `yyyy-MM-dd`.
 String get date;/// Pence.
 int get amount;
/// Create a copy of EarningsDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarningsDayCopyWith<EarningsDay> get copyWith => _$EarningsDayCopyWithImpl<EarningsDay>(this as EarningsDay, _$identity);

  /// Serializes this EarningsDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EarningsDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarningsDay&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.amount, _this.amount) || other.amount == _this.amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EarningsDay;
  return Object.hash(runtimeType,_this.date,_this.amount);
}

@override
String toString() {
  final _this = this as EarningsDay;
  return 'EarningsDay(date: ${_this.date}, amount: ${_this.amount})';
}


}

/// @nodoc
abstract mixin class $EarningsDayCopyWith<$Res>  {
  factory $EarningsDayCopyWith(EarningsDay value, $Res Function(EarningsDay) _then) = _$EarningsDayCopyWithImpl;
@useResult
$Res call({
 String date, int amount
});




}
/// @nodoc
class _$EarningsDayCopyWithImpl<$Res>
    implements $EarningsDayCopyWith<$Res> {
  _$EarningsDayCopyWithImpl(this._self, this._then);

  final EarningsDay _self;
  final $Res Function(EarningsDay) _then;

/// Create a copy of EarningsDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? amount = null,}) {
  return _then(EarningsDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EarningsDay].
extension EarningsDayPatterns on EarningsDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarningsDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarningsDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarningsDay value)  $default,){
final _that = this;
switch (_that) {
case _EarningsDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarningsDay value)?  $default,){
final _that = this;
switch (_that) {
case _EarningsDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  int amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarningsDay() when $default != null:
return $default(_that.date,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  int amount)  $default,) {final _that = this;
switch (_that) {
case _EarningsDay():
return $default(_that.date,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  int amount)?  $default,) {final _that = this;
switch (_that) {
case _EarningsDay() when $default != null:
return $default(_that.date,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EarningsDay implements EarningsDay {
  const _EarningsDay({required this.date, required this.amount});
  factory _EarningsDay.fromJson(Map<String, dynamic> json) => _$EarningsDayFromJson(json);

/// `yyyy-MM-dd`.
@override final  String date;
/// Pence.
@override final  int amount;

/// Create a copy of EarningsDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarningsDayCopyWith<_EarningsDay> get copyWith => __$EarningsDayCopyWithImpl<_EarningsDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarningsDayToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarningsDay&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,amount);
}

@override
String toString() {
    return 'EarningsDay(date: $date, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$EarningsDayCopyWith<$Res> implements $EarningsDayCopyWith<$Res> {
  factory _$EarningsDayCopyWith(_EarningsDay value, $Res Function(_EarningsDay) _then) = __$EarningsDayCopyWithImpl;
@override @useResult
$Res call({
 String date, int amount
});




}
/// @nodoc
class __$EarningsDayCopyWithImpl<$Res>
    implements _$EarningsDayCopyWith<$Res> {
  __$EarningsDayCopyWithImpl(this._self, this._then);

  final _EarningsDay _self;
  final $Res Function(_EarningsDay) _then;

/// Create a copy of EarningsDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? amount = null,}) {
  return _then(_EarningsDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$EarningsJob {

 String get bookingId; int get amount; String get code; String get serviceTitle; DateTime? get completedAt;
/// Create a copy of EarningsJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarningsJobCopyWith<EarningsJob> get copyWith => _$EarningsJobCopyWithImpl<EarningsJob>(this as EarningsJob, _$identity);

  /// Serializes this EarningsJob to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EarningsJob;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarningsJob&&(identical(other.bookingId, _this.bookingId) || other.bookingId == _this.bookingId)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.serviceTitle, _this.serviceTitle) || other.serviceTitle == _this.serviceTitle)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EarningsJob;
  return Object.hash(runtimeType,_this.bookingId,_this.amount,_this.code,_this.serviceTitle,_this.completedAt);
}

@override
String toString() {
  final _this = this as EarningsJob;
  return 'EarningsJob(bookingId: ${_this.bookingId}, amount: ${_this.amount}, code: ${_this.code}, serviceTitle: ${_this.serviceTitle}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $EarningsJobCopyWith<$Res>  {
  factory $EarningsJobCopyWith(EarningsJob value, $Res Function(EarningsJob) _then) = _$EarningsJobCopyWithImpl;
@useResult
$Res call({
 String bookingId, int amount, String code, String serviceTitle, DateTime? completedAt
});




}
/// @nodoc
class _$EarningsJobCopyWithImpl<$Res>
    implements $EarningsJobCopyWith<$Res> {
  _$EarningsJobCopyWithImpl(this._self, this._then);

  final EarningsJob _self;
  final $Res Function(EarningsJob) _then;

/// Create a copy of EarningsJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookingId = null,Object? amount = null,Object? code = null,Object? serviceTitle = null,Object? completedAt = freezed,}) {
  return _then(EarningsJob(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,serviceTitle: null == serviceTitle ? _self.serviceTitle : serviceTitle // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EarningsJob].
extension EarningsJobPatterns on EarningsJob {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarningsJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarningsJob() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarningsJob value)  $default,){
final _that = this;
switch (_that) {
case _EarningsJob():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarningsJob value)?  $default,){
final _that = this;
switch (_that) {
case _EarningsJob() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bookingId,  int amount,  String code,  String serviceTitle,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarningsJob() when $default != null:
return $default(_that.bookingId,_that.amount,_that.code,_that.serviceTitle,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bookingId,  int amount,  String code,  String serviceTitle,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _EarningsJob():
return $default(_that.bookingId,_that.amount,_that.code,_that.serviceTitle,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bookingId,  int amount,  String code,  String serviceTitle,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _EarningsJob() when $default != null:
return $default(_that.bookingId,_that.amount,_that.code,_that.serviceTitle,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EarningsJob implements EarningsJob {
  const _EarningsJob({required this.bookingId, required this.amount, this.code = '', this.serviceTitle = '', this.completedAt});
  factory _EarningsJob.fromJson(Map<String, dynamic> json) => _$EarningsJobFromJson(json);

@override final  String bookingId;
@override final  int amount;
@override@JsonKey() final  String code;
@override@JsonKey() final  String serviceTitle;
@override final  DateTime? completedAt;

/// Create a copy of EarningsJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarningsJobCopyWith<_EarningsJob> get copyWith => __$EarningsJobCopyWithImpl<_EarningsJob>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarningsJobToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarningsJob&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.code, code) || other.code == code)&&(identical(other.serviceTitle, serviceTitle) || other.serviceTitle == serviceTitle)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,bookingId,amount,code,serviceTitle,completedAt);
}

@override
String toString() {
    return 'EarningsJob(bookingId: $bookingId, amount: $amount, code: $code, serviceTitle: $serviceTitle, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$EarningsJobCopyWith<$Res> implements $EarningsJobCopyWith<$Res> {
  factory _$EarningsJobCopyWith(_EarningsJob value, $Res Function(_EarningsJob) _then) = __$EarningsJobCopyWithImpl;
@override @useResult
$Res call({
 String bookingId, int amount, String code, String serviceTitle, DateTime? completedAt
});




}
/// @nodoc
class __$EarningsJobCopyWithImpl<$Res>
    implements _$EarningsJobCopyWith<$Res> {
  __$EarningsJobCopyWithImpl(this._self, this._then);

  final _EarningsJob _self;
  final $Res Function(_EarningsJob) _then;

/// Create a copy of EarningsJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookingId = null,Object? amount = null,Object? code = null,Object? serviceTitle = null,Object? completedAt = freezed,}) {
  return _then(_EarningsJob(
bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,serviceTitle: null == serviceTitle ? _self.serviceTitle : serviceTitle // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Earnings {

 int get total; int get jobs; int get tips; List<EarningsDay> get days; List<EarningsJob> get recent;
/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarningsCopyWith<Earnings> get copyWith => _$EarningsCopyWithImpl<Earnings>(this as Earnings, _$identity);

  /// Serializes this Earnings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Earnings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Earnings&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.jobs, _this.jobs) || other.jobs == _this.jobs)&&(identical(other.tips, _this.tips) || other.tips == _this.tips)&&const DeepCollectionEquality().equals(other.days, _this.days)&&const DeepCollectionEquality().equals(other.recent, _this.recent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Earnings;
  return Object.hash(runtimeType,_this.total,_this.jobs,_this.tips,const DeepCollectionEquality().hash(_this.days),const DeepCollectionEquality().hash(_this.recent));
}

@override
String toString() {
  final _this = this as Earnings;
  return 'Earnings(total: ${_this.total}, jobs: ${_this.jobs}, tips: ${_this.tips}, days: ${_this.days}, recent: ${_this.recent})';
}


}

/// @nodoc
abstract mixin class $EarningsCopyWith<$Res>  {
  factory $EarningsCopyWith(Earnings value, $Res Function(Earnings) _then) = _$EarningsCopyWithImpl;
@useResult
$Res call({
 int total, int jobs, int tips, List<EarningsDay> days, List<EarningsJob> recent
});




}
/// @nodoc
class _$EarningsCopyWithImpl<$Res>
    implements $EarningsCopyWith<$Res> {
  _$EarningsCopyWithImpl(this._self, this._then);

  final Earnings _self;
  final $Res Function(Earnings) _then;

/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? jobs = null,Object? tips = null,Object? days = null,Object? recent = null,}) {
  return _then(Earnings(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,jobs: null == jobs ? _self.jobs : jobs // ignore: cast_nullable_to_non_nullable
as int,tips: null == tips ? _self.tips : tips // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<EarningsDay>,recent: null == recent ? _self.recent : recent // ignore: cast_nullable_to_non_nullable
as List<EarningsJob>,
  ));
}

}


/// Adds pattern-matching-related methods to [Earnings].
extension EarningsPatterns on Earnings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Earnings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Earnings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Earnings value)  $default,){
final _that = this;
switch (_that) {
case _Earnings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Earnings value)?  $default,){
final _that = this;
switch (_that) {
case _Earnings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int jobs,  int tips,  List<EarningsDay> days,  List<EarningsJob> recent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Earnings() when $default != null:
return $default(_that.total,_that.jobs,_that.tips,_that.days,_that.recent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int jobs,  int tips,  List<EarningsDay> days,  List<EarningsJob> recent)  $default,) {final _that = this;
switch (_that) {
case _Earnings():
return $default(_that.total,_that.jobs,_that.tips,_that.days,_that.recent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int jobs,  int tips,  List<EarningsDay> days,  List<EarningsJob> recent)?  $default,) {final _that = this;
switch (_that) {
case _Earnings() when $default != null:
return $default(_that.total,_that.jobs,_that.tips,_that.days,_that.recent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Earnings implements Earnings {
  const _Earnings({required this.total, this.jobs = 0, this.tips = 0,  List<EarningsDay> days = const <EarningsDay>[],  List<EarningsJob> recent = const <EarningsJob>[]}): _days = days,_recent = recent;
  factory _Earnings.fromJson(Map<String, dynamic> json) => _$EarningsFromJson(json);

@override final  int total;
@override@JsonKey() final  int jobs;
@override@JsonKey() final  int tips;
 final  List<EarningsDay> _days;
@override@JsonKey() List<EarningsDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

 final  List<EarningsJob> _recent;
@override@JsonKey() List<EarningsJob> get recent {
  if (_recent is EqualUnmodifiableListView) return _recent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recent);
}


/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarningsCopyWith<_Earnings> get copyWith => __$EarningsCopyWithImpl<_Earnings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarningsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Earnings&&(identical(other.total, total) || other.total == total)&&(identical(other.jobs, jobs) || other.jobs == jobs)&&(identical(other.tips, tips) || other.tips == tips)&&const DeepCollectionEquality().equals(other.days, _days)&&const DeepCollectionEquality().equals(other.recent, _recent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,jobs,tips,const DeepCollectionEquality().hash(_days),const DeepCollectionEquality().hash(_recent));
}

@override
String toString() {
    return 'Earnings(total: $total, jobs: $jobs, tips: $tips, days: $days, recent: $recent)';
}


}

/// @nodoc
abstract mixin class _$EarningsCopyWith<$Res> implements $EarningsCopyWith<$Res> {
  factory _$EarningsCopyWith(_Earnings value, $Res Function(_Earnings) _then) = __$EarningsCopyWithImpl;
@override @useResult
$Res call({
 int total, int jobs, int tips, List<EarningsDay> days, List<EarningsJob> recent
});




}
/// @nodoc
class __$EarningsCopyWithImpl<$Res>
    implements _$EarningsCopyWith<$Res> {
  __$EarningsCopyWithImpl(this._self, this._then);

  final _Earnings _self;
  final $Res Function(_Earnings) _then;

/// Create a copy of Earnings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? jobs = null,Object? tips = null,Object? days = null,Object? recent = null,}) {
  return _then(_Earnings(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,jobs: null == jobs ? _self.jobs : jobs // ignore: cast_nullable_to_non_nullable
as int,tips: null == tips ? _self.tips : tips // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<EarningsDay>,recent: null == recent ? _self._recent : recent // ignore: cast_nullable_to_non_nullable
as List<EarningsJob>,
  ));
}


}

// dart format on
