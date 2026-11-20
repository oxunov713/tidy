// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Slot {

/// Start time, UTC.
 DateTime get start; bool get available;
/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotCopyWith<Slot> get copyWith => _$SlotCopyWithImpl<Slot>(this as Slot, _$identity);

  /// Serializes this Slot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Slot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Slot&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.available, _this.available) || other.available == _this.available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Slot;
  return Object.hash(runtimeType,_this.start,_this.available);
}

@override
String toString() {
  final _this = this as Slot;
  return 'Slot(start: ${_this.start}, available: ${_this.available})';
}


}

/// @nodoc
abstract mixin class $SlotCopyWith<$Res>  {
  factory $SlotCopyWith(Slot value, $Res Function(Slot) _then) = _$SlotCopyWithImpl;
@useResult
$Res call({
 DateTime start, bool available
});




}
/// @nodoc
class _$SlotCopyWithImpl<$Res>
    implements $SlotCopyWith<$Res> {
  _$SlotCopyWithImpl(this._self, this._then);

  final Slot _self;
  final $Res Function(Slot) _then;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? available = null,}) {
  return _then(Slot(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Slot].
extension SlotPatterns on Slot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Slot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Slot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Slot value)  $default,){
final _that = this;
switch (_that) {
case _Slot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Slot value)?  $default,){
final _that = this;
switch (_that) {
case _Slot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime start,  bool available)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that.start,_that.available);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime start,  bool available)  $default,) {final _that = this;
switch (_that) {
case _Slot():
return $default(_that.start,_that.available);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime start,  bool available)?  $default,) {final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that.start,_that.available);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Slot implements Slot {
  const _Slot({required this.start, required this.available});
  factory _Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);

/// Start time, UTC.
@override final  DateTime start;
@override final  bool available;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotCopyWith<_Slot> get copyWith => __$SlotCopyWithImpl<_Slot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Slot&&(identical(other.start, start) || other.start == start)&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,start,available);
}

@override
String toString() {
    return 'Slot(start: $start, available: $available)';
}


}

/// @nodoc
abstract mixin class _$SlotCopyWith<$Res> implements $SlotCopyWith<$Res> {
  factory _$SlotCopyWith(_Slot value, $Res Function(_Slot) _then) = __$SlotCopyWithImpl;
@override @useResult
$Res call({
 DateTime start, bool available
});




}
/// @nodoc
class __$SlotCopyWithImpl<$Res>
    implements _$SlotCopyWith<$Res> {
  __$SlotCopyWithImpl(this._self, this._then);

  final _Slot _self;
  final $Res Function(_Slot) _then;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? available = null,}) {
  return _then(_Slot(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SlotsResponse {

/// Day in `yyyy-MM-dd` form, as sent.
 String get date; List<Slot> get slots;
/// Create a copy of SlotsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotsResponseCopyWith<SlotsResponse> get copyWith => _$SlotsResponseCopyWithImpl<SlotsResponse>(this as SlotsResponse, _$identity);

  /// Serializes this SlotsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SlotsResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotsResponse&&(identical(other.date, _this.date) || other.date == _this.date)&&const DeepCollectionEquality().equals(other.slots, _this.slots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SlotsResponse;
  return Object.hash(runtimeType,_this.date,const DeepCollectionEquality().hash(_this.slots));
}

@override
String toString() {
  final _this = this as SlotsResponse;
  return 'SlotsResponse(date: ${_this.date}, slots: ${_this.slots})';
}


}

/// @nodoc
abstract mixin class $SlotsResponseCopyWith<$Res>  {
  factory $SlotsResponseCopyWith(SlotsResponse value, $Res Function(SlotsResponse) _then) = _$SlotsResponseCopyWithImpl;
@useResult
$Res call({
 String date, List<Slot> slots
});




}
/// @nodoc
class _$SlotsResponseCopyWithImpl<$Res>
    implements $SlotsResponseCopyWith<$Res> {
  _$SlotsResponseCopyWithImpl(this._self, this._then);

  final SlotsResponse _self;
  final $Res Function(SlotsResponse) _then;

/// Create a copy of SlotsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? slots = null,}) {
  return _then(SlotsResponse(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<Slot>,
  ));
}

}


/// Adds pattern-matching-related methods to [SlotsResponse].
extension SlotsResponsePatterns on SlotsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlotsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlotsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlotsResponse value)  $default,){
final _that = this;
switch (_that) {
case _SlotsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlotsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SlotsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  List<Slot> slots)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlotsResponse() when $default != null:
return $default(_that.date,_that.slots);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  List<Slot> slots)  $default,) {final _that = this;
switch (_that) {
case _SlotsResponse():
return $default(_that.date,_that.slots);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  List<Slot> slots)?  $default,) {final _that = this;
switch (_that) {
case _SlotsResponse() when $default != null:
return $default(_that.date,_that.slots);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlotsResponse implements SlotsResponse {
  const _SlotsResponse({required this.date,  List<Slot> slots = const <Slot>[]}): _slots = slots;
  factory _SlotsResponse.fromJson(Map<String, dynamic> json) => _$SlotsResponseFromJson(json);

/// Day in `yyyy-MM-dd` form, as sent.
@override final  String date;
 final  List<Slot> _slots;
@override@JsonKey() List<Slot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}


/// Create a copy of SlotsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotsResponseCopyWith<_SlotsResponse> get copyWith => __$SlotsResponseCopyWithImpl<_SlotsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlotsResponse&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.slots, _slots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_slots));
}

@override
String toString() {
    return 'SlotsResponse(date: $date, slots: $slots)';
}


}

/// @nodoc
abstract mixin class _$SlotsResponseCopyWith<$Res> implements $SlotsResponseCopyWith<$Res> {
  factory _$SlotsResponseCopyWith(_SlotsResponse value, $Res Function(_SlotsResponse) _then) = __$SlotsResponseCopyWithImpl;
@override @useResult
$Res call({
 String date, List<Slot> slots
});




}
/// @nodoc
class __$SlotsResponseCopyWithImpl<$Res>
    implements _$SlotsResponseCopyWith<$Res> {
  __$SlotsResponseCopyWithImpl(this._self, this._then);

  final _SlotsResponse _self;
  final $Res Function(_SlotsResponse) _then;

/// Create a copy of SlotsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? slots = null,}) {
  return _then(_SlotsResponse(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<Slot>,
  ));
}


}

// dart format on
