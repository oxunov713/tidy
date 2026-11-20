// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_wizard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingWizardState {

 Service? get service; int get bedrooms; int get bathrooms; Set<String> get extraIds; Frequency get frequency;/// Latest price from the server. Kept while a newer one is loading so the
/// total does not jump to nothing.
 Quote? get quote; bool get quoteLoading; Object? get quoteError;/// The day picked in the Schedule step (local, time of day ignored).
 DateTime? get date; List<Slot> get slots; bool get slotsLoading; Object? get slotsError;/// Chosen start time.
 DateTime? get slot;/// A specific cleaner ("your last cleaner"), or null for anyone.
 String? get cleanerId; Address? get address; String get accessNotes; bool get submitting;
/// Create a copy of BookingWizardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingWizardStateCopyWith<BookingWizardState> get copyWith => _$BookingWizardStateCopyWithImpl<BookingWizardState>(this as BookingWizardState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookingWizardState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingWizardState&&(identical(other.service, _this.service) || other.service == _this.service)&&(identical(other.bedrooms, _this.bedrooms) || other.bedrooms == _this.bedrooms)&&(identical(other.bathrooms, _this.bathrooms) || other.bathrooms == _this.bathrooms)&&const DeepCollectionEquality().equals(other.extraIds, _this.extraIds)&&(identical(other.frequency, _this.frequency) || other.frequency == _this.frequency)&&(identical(other.quote, _this.quote) || other.quote == _this.quote)&&(identical(other.quoteLoading, _this.quoteLoading) || other.quoteLoading == _this.quoteLoading)&&const DeepCollectionEquality().equals(other.quoteError, _this.quoteError)&&(identical(other.date, _this.date) || other.date == _this.date)&&const DeepCollectionEquality().equals(other.slots, _this.slots)&&(identical(other.slotsLoading, _this.slotsLoading) || other.slotsLoading == _this.slotsLoading)&&const DeepCollectionEquality().equals(other.slotsError, _this.slotsError)&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&(identical(other.cleanerId, _this.cleanerId) || other.cleanerId == _this.cleanerId)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.accessNotes, _this.accessNotes) || other.accessNotes == _this.accessNotes)&&(identical(other.submitting, _this.submitting) || other.submitting == _this.submitting));
}


@override
int get hashCode {
  final _this = this as BookingWizardState;
  return Object.hash(runtimeType,_this.service,_this.bedrooms,_this.bathrooms,const DeepCollectionEquality().hash(_this.extraIds),_this.frequency,_this.quote,_this.quoteLoading,const DeepCollectionEquality().hash(_this.quoteError),_this.date,const DeepCollectionEquality().hash(_this.slots),_this.slotsLoading,const DeepCollectionEquality().hash(_this.slotsError),_this.slot,_this.cleanerId,_this.address,_this.accessNotes,_this.submitting);
}

@override
String toString() {
  final _this = this as BookingWizardState;
  return 'BookingWizardState(service: ${_this.service}, bedrooms: ${_this.bedrooms}, bathrooms: ${_this.bathrooms}, extraIds: ${_this.extraIds}, frequency: ${_this.frequency}, quote: ${_this.quote}, quoteLoading: ${_this.quoteLoading}, quoteError: ${_this.quoteError}, date: ${_this.date}, slots: ${_this.slots}, slotsLoading: ${_this.slotsLoading}, slotsError: ${_this.slotsError}, slot: ${_this.slot}, cleanerId: ${_this.cleanerId}, address: ${_this.address}, accessNotes: ${_this.accessNotes}, submitting: ${_this.submitting})';
}


}

/// @nodoc
abstract mixin class $BookingWizardStateCopyWith<$Res>  {
  factory $BookingWizardStateCopyWith(BookingWizardState value, $Res Function(BookingWizardState) _then) = _$BookingWizardStateCopyWithImpl;
@useResult
$Res call({
 Service? service, int bedrooms, int bathrooms, Set<String> extraIds, Frequency frequency, Quote? quote, bool quoteLoading, Object? quoteError, DateTime? date, List<Slot> slots, bool slotsLoading, Object? slotsError, DateTime? slot, String? cleanerId, Address? address, String accessNotes, bool submitting
});


$ServiceCopyWith<$Res>? get service;$QuoteCopyWith<$Res>? get quote;$AddressCopyWith<$Res>? get address;

}
/// @nodoc
class _$BookingWizardStateCopyWithImpl<$Res>
    implements $BookingWizardStateCopyWith<$Res> {
  _$BookingWizardStateCopyWithImpl(this._self, this._then);

  final BookingWizardState _self;
  final $Res Function(BookingWizardState) _then;

/// Create a copy of BookingWizardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? service = freezed,Object? bedrooms = null,Object? bathrooms = null,Object? extraIds = null,Object? frequency = null,Object? quote = freezed,Object? quoteLoading = null,Object? quoteError = freezed,Object? date = freezed,Object? slots = null,Object? slotsLoading = null,Object? slotsError = freezed,Object? slot = freezed,Object? cleanerId = freezed,Object? address = freezed,Object? accessNotes = null,Object? submitting = null,}) {
  return _then(BookingWizardState(
service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as Service?,bedrooms: null == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int,bathrooms: null == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int,extraIds: null == extraIds ? _self.extraIds : extraIds // ignore: cast_nullable_to_non_nullable
as Set<String>,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,quote: freezed == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as Quote?,quoteLoading: null == quoteLoading ? _self.quoteLoading : quoteLoading // ignore: cast_nullable_to_non_nullable
as bool,quoteError: freezed == quoteError ? _self.quoteError : quoteError ,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<Slot>,slotsLoading: null == slotsLoading ? _self.slotsLoading : slotsLoading // ignore: cast_nullable_to_non_nullable
as bool,slotsError: freezed == slotsError ? _self.slotsError : slotsError ,slot: freezed == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as DateTime?,cleanerId: freezed == cleanerId ? _self.cleanerId : cleanerId // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address?,accessNotes: null == accessNotes ? _self.accessNotes : accessNotes // ignore: cast_nullable_to_non_nullable
as String,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of BookingWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceCopyWith<$Res>? get service {
    if (_self.service == null) {
    return null;
  }

  return $ServiceCopyWith<$Res>(_self.service!, (value) {
    return _then(_self.copyWith(service: value));
  });
}/// Create a copy of BookingWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteCopyWith<$Res>? get quote {
    if (_self.quote == null) {
    return null;
  }

  return $QuoteCopyWith<$Res>(_self.quote!, (value) {
    return _then(_self.copyWith(quote: value));
  });
}/// Create a copy of BookingWizardState
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
}
}


/// Adds pattern-matching-related methods to [BookingWizardState].
extension BookingWizardStatePatterns on BookingWizardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingWizardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingWizardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingWizardState value)  $default,){
final _that = this;
switch (_that) {
case _BookingWizardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingWizardState value)?  $default,){
final _that = this;
switch (_that) {
case _BookingWizardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Service? service,  int bedrooms,  int bathrooms,  Set<String> extraIds,  Frequency frequency,  Quote? quote,  bool quoteLoading,  Object? quoteError,  DateTime? date,  List<Slot> slots,  bool slotsLoading,  Object? slotsError,  DateTime? slot,  String? cleanerId,  Address? address,  String accessNotes,  bool submitting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingWizardState() when $default != null:
return $default(_that.service,_that.bedrooms,_that.bathrooms,_that.extraIds,_that.frequency,_that.quote,_that.quoteLoading,_that.quoteError,_that.date,_that.slots,_that.slotsLoading,_that.slotsError,_that.slot,_that.cleanerId,_that.address,_that.accessNotes,_that.submitting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Service? service,  int bedrooms,  int bathrooms,  Set<String> extraIds,  Frequency frequency,  Quote? quote,  bool quoteLoading,  Object? quoteError,  DateTime? date,  List<Slot> slots,  bool slotsLoading,  Object? slotsError,  DateTime? slot,  String? cleanerId,  Address? address,  String accessNotes,  bool submitting)  $default,) {final _that = this;
switch (_that) {
case _BookingWizardState():
return $default(_that.service,_that.bedrooms,_that.bathrooms,_that.extraIds,_that.frequency,_that.quote,_that.quoteLoading,_that.quoteError,_that.date,_that.slots,_that.slotsLoading,_that.slotsError,_that.slot,_that.cleanerId,_that.address,_that.accessNotes,_that.submitting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Service? service,  int bedrooms,  int bathrooms,  Set<String> extraIds,  Frequency frequency,  Quote? quote,  bool quoteLoading,  Object? quoteError,  DateTime? date,  List<Slot> slots,  bool slotsLoading,  Object? slotsError,  DateTime? slot,  String? cleanerId,  Address? address,  String accessNotes,  bool submitting)?  $default,) {final _that = this;
switch (_that) {
case _BookingWizardState() when $default != null:
return $default(_that.service,_that.bedrooms,_that.bathrooms,_that.extraIds,_that.frequency,_that.quote,_that.quoteLoading,_that.quoteError,_that.date,_that.slots,_that.slotsLoading,_that.slotsError,_that.slot,_that.cleanerId,_that.address,_that.accessNotes,_that.submitting);case _:
  return null;

}
}

}

/// @nodoc


class _BookingWizardState extends BookingWizardState {
  const _BookingWizardState({this.service, this.bedrooms = 2, this.bathrooms = 1,  Set<String> extraIds = const <String>{}, this.frequency = Frequency.once, this.quote, this.quoteLoading = false, this.quoteError, this.date,  List<Slot> slots = const <Slot>[], this.slotsLoading = false, this.slotsError, this.slot, this.cleanerId, this.address, this.accessNotes = '', this.submitting = false}): _extraIds = extraIds,_slots = slots,super._();
  

@override final  Service? service;
@override@JsonKey() final  int bedrooms;
@override@JsonKey() final  int bathrooms;
 final  Set<String> _extraIds;
@override@JsonKey() Set<String> get extraIds {
  if (_extraIds is EqualUnmodifiableSetView) return _extraIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_extraIds);
}

@override@JsonKey() final  Frequency frequency;
/// Latest price from the server. Kept while a newer one is loading so the
/// total does not jump to nothing.
@override final  Quote? quote;
@override@JsonKey() final  bool quoteLoading;
@override final  Object? quoteError;
/// The day picked in the Schedule step (local, time of day ignored).
@override final  DateTime? date;
 final  List<Slot> _slots;
@override@JsonKey() List<Slot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}

@override@JsonKey() final  bool slotsLoading;
@override final  Object? slotsError;
/// Chosen start time.
@override final  DateTime? slot;
/// A specific cleaner ("your last cleaner"), or null for anyone.
@override final  String? cleanerId;
@override final  Address? address;
@override@JsonKey() final  String accessNotes;
@override@JsonKey() final  bool submitting;

/// Create a copy of BookingWizardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingWizardStateCopyWith<_BookingWizardState> get copyWith => __$BookingWizardStateCopyWithImpl<_BookingWizardState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingWizardState&&(identical(other.service, service) || other.service == service)&&(identical(other.bedrooms, bedrooms) || other.bedrooms == bedrooms)&&(identical(other.bathrooms, bathrooms) || other.bathrooms == bathrooms)&&const DeepCollectionEquality().equals(other.extraIds, _extraIds)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.quoteLoading, quoteLoading) || other.quoteLoading == quoteLoading)&&const DeepCollectionEquality().equals(other.quoteError, quoteError)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.slots, _slots)&&(identical(other.slotsLoading, slotsLoading) || other.slotsLoading == slotsLoading)&&const DeepCollectionEquality().equals(other.slotsError, slotsError)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.cleanerId, cleanerId) || other.cleanerId == cleanerId)&&(identical(other.address, address) || other.address == address)&&(identical(other.accessNotes, accessNotes) || other.accessNotes == accessNotes)&&(identical(other.submitting, submitting) || other.submitting == submitting));
}


@override
int get hashCode {
    return Object.hash(runtimeType,service,bedrooms,bathrooms,const DeepCollectionEquality().hash(_extraIds),frequency,quote,quoteLoading,const DeepCollectionEquality().hash(quoteError),date,const DeepCollectionEquality().hash(_slots),slotsLoading,const DeepCollectionEquality().hash(slotsError),slot,cleanerId,address,accessNotes,submitting);
}

@override
String toString() {
    return 'BookingWizardState(service: $service, bedrooms: $bedrooms, bathrooms: $bathrooms, extraIds: $extraIds, frequency: $frequency, quote: $quote, quoteLoading: $quoteLoading, quoteError: $quoteError, date: $date, slots: $slots, slotsLoading: $slotsLoading, slotsError: $slotsError, slot: $slot, cleanerId: $cleanerId, address: $address, accessNotes: $accessNotes, submitting: $submitting)';
}


}

/// @nodoc
abstract mixin class _$BookingWizardStateCopyWith<$Res> implements $BookingWizardStateCopyWith<$Res> {
  factory _$BookingWizardStateCopyWith(_BookingWizardState value, $Res Function(_BookingWizardState) _then) = __$BookingWizardStateCopyWithImpl;
@override @useResult
$Res call({
 Service? service, int bedrooms, int bathrooms, Set<String> extraIds, Frequency frequency, Quote? quote, bool quoteLoading, Object? quoteError, DateTime? date, List<Slot> slots, bool slotsLoading, Object? slotsError, DateTime? slot, String? cleanerId, Address? address, String accessNotes, bool submitting
});


@override $ServiceCopyWith<$Res>? get service;@override $QuoteCopyWith<$Res>? get quote;@override $AddressCopyWith<$Res>? get address;

}
/// @nodoc
class __$BookingWizardStateCopyWithImpl<$Res>
    implements _$BookingWizardStateCopyWith<$Res> {
  __$BookingWizardStateCopyWithImpl(this._self, this._then);

  final _BookingWizardState _self;
  final $Res Function(_BookingWizardState) _then;

/// Create a copy of BookingWizardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? service = freezed,Object? bedrooms = null,Object? bathrooms = null,Object? extraIds = null,Object? frequency = null,Object? quote = freezed,Object? quoteLoading = null,Object? quoteError = freezed,Object? date = freezed,Object? slots = null,Object? slotsLoading = null,Object? slotsError = freezed,Object? slot = freezed,Object? cleanerId = freezed,Object? address = freezed,Object? accessNotes = null,Object? submitting = null,}) {
  return _then(_BookingWizardState(
service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as Service?,bedrooms: null == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int,bathrooms: null == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int,extraIds: null == extraIds ? _self._extraIds : extraIds // ignore: cast_nullable_to_non_nullable
as Set<String>,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,quote: freezed == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as Quote?,quoteLoading: null == quoteLoading ? _self.quoteLoading : quoteLoading // ignore: cast_nullable_to_non_nullable
as bool,quoteError: freezed == quoteError ? _self.quoteError : quoteError ,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<Slot>,slotsLoading: null == slotsLoading ? _self.slotsLoading : slotsLoading // ignore: cast_nullable_to_non_nullable
as bool,slotsError: freezed == slotsError ? _self.slotsError : slotsError ,slot: freezed == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as DateTime?,cleanerId: freezed == cleanerId ? _self.cleanerId : cleanerId // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address?,accessNotes: null == accessNotes ? _self.accessNotes : accessNotes // ignore: cast_nullable_to_non_nullable
as String,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of BookingWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceCopyWith<$Res>? get service {
    if (_self.service == null) {
    return null;
  }

  return $ServiceCopyWith<$Res>(_self.service!, (value) {
    return _then(_self.copyWith(service: value));
  });
}/// Create a copy of BookingWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteCopyWith<$Res>? get quote {
    if (_self.quote == null) {
    return null;
  }

  return $QuoteCopyWith<$Res>(_self.quote!, (value) {
    return _then(_self.copyWith(quote: value));
  });
}/// Create a copy of BookingWizardState
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
}
}

// dart format on
