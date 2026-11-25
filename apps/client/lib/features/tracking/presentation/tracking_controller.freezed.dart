// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackingState {

 BookingDetails get details;/// Latest status, which may be newer than [details].
 BookingStatus get status; GeoPoint? get cleanerPosition; int? get etaMinutes;/// The server removed us from the booking's room (cancelled or
/// reassigned): no more live updates will come.
 bool get accessRevoked;
/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingStateCopyWith<TrackingState> get copyWith => _$TrackingStateCopyWithImpl<TrackingState>(this as TrackingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TrackingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingState&&(identical(other.details, _this.details) || other.details == _this.details)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.cleanerPosition, _this.cleanerPosition) || other.cleanerPosition == _this.cleanerPosition)&&(identical(other.etaMinutes, _this.etaMinutes) || other.etaMinutes == _this.etaMinutes)&&(identical(other.accessRevoked, _this.accessRevoked) || other.accessRevoked == _this.accessRevoked));
}


@override
int get hashCode {
  final _this = this as TrackingState;
  return Object.hash(runtimeType,_this.details,_this.status,_this.cleanerPosition,_this.etaMinutes,_this.accessRevoked);
}

@override
String toString() {
  final _this = this as TrackingState;
  return 'TrackingState(details: ${_this.details}, status: ${_this.status}, cleanerPosition: ${_this.cleanerPosition}, etaMinutes: ${_this.etaMinutes}, accessRevoked: ${_this.accessRevoked})';
}


}

/// @nodoc
abstract mixin class $TrackingStateCopyWith<$Res>  {
  factory $TrackingStateCopyWith(TrackingState value, $Res Function(TrackingState) _then) = _$TrackingStateCopyWithImpl;
@useResult
$Res call({
 BookingDetails details, BookingStatus status, GeoPoint? cleanerPosition, int? etaMinutes, bool accessRevoked
});


$BookingDetailsCopyWith<$Res> get details;$GeoPointCopyWith<$Res>? get cleanerPosition;

}
/// @nodoc
class _$TrackingStateCopyWithImpl<$Res>
    implements $TrackingStateCopyWith<$Res> {
  _$TrackingStateCopyWithImpl(this._self, this._then);

  final TrackingState _self;
  final $Res Function(TrackingState) _then;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? details = null,Object? status = null,Object? cleanerPosition = freezed,Object? etaMinutes = freezed,Object? accessRevoked = null,}) {
  return _then(TrackingState(
details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as BookingDetails,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,cleanerPosition: freezed == cleanerPosition ? _self.cleanerPosition : cleanerPosition // ignore: cast_nullable_to_non_nullable
as GeoPoint?,etaMinutes: freezed == etaMinutes ? _self.etaMinutes : etaMinutes // ignore: cast_nullable_to_non_nullable
as int?,accessRevoked: null == accessRevoked ? _self.accessRevoked : accessRevoked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingDetailsCopyWith<$Res> get details {
  
  return $BookingDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get cleanerPosition {
    if (_self.cleanerPosition == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.cleanerPosition!, (value) {
    return _then(_self.copyWith(cleanerPosition: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrackingState].
extension TrackingStatePatterns on TrackingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackingState value)  $default,){
final _that = this;
switch (_that) {
case _TrackingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackingState value)?  $default,){
final _that = this;
switch (_that) {
case _TrackingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BookingDetails details,  BookingStatus status,  GeoPoint? cleanerPosition,  int? etaMinutes,  bool accessRevoked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackingState() when $default != null:
return $default(_that.details,_that.status,_that.cleanerPosition,_that.etaMinutes,_that.accessRevoked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BookingDetails details,  BookingStatus status,  GeoPoint? cleanerPosition,  int? etaMinutes,  bool accessRevoked)  $default,) {final _that = this;
switch (_that) {
case _TrackingState():
return $default(_that.details,_that.status,_that.cleanerPosition,_that.etaMinutes,_that.accessRevoked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BookingDetails details,  BookingStatus status,  GeoPoint? cleanerPosition,  int? etaMinutes,  bool accessRevoked)?  $default,) {final _that = this;
switch (_that) {
case _TrackingState() when $default != null:
return $default(_that.details,_that.status,_that.cleanerPosition,_that.etaMinutes,_that.accessRevoked);case _:
  return null;

}
}

}

/// @nodoc


class _TrackingState extends TrackingState {
  const _TrackingState({required this.details, required this.status, this.cleanerPosition, this.etaMinutes, this.accessRevoked = false}): super._();
  

@override final  BookingDetails details;
/// Latest status, which may be newer than [details].
@override final  BookingStatus status;
@override final  GeoPoint? cleanerPosition;
@override final  int? etaMinutes;
/// The server removed us from the booking's room (cancelled or
/// reassigned): no more live updates will come.
@override@JsonKey() final  bool accessRevoked;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackingStateCopyWith<_TrackingState> get copyWith => __$TrackingStateCopyWithImpl<_TrackingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackingState&&(identical(other.details, details) || other.details == details)&&(identical(other.status, status) || other.status == status)&&(identical(other.cleanerPosition, cleanerPosition) || other.cleanerPosition == cleanerPosition)&&(identical(other.etaMinutes, etaMinutes) || other.etaMinutes == etaMinutes)&&(identical(other.accessRevoked, accessRevoked) || other.accessRevoked == accessRevoked));
}


@override
int get hashCode {
    return Object.hash(runtimeType,details,status,cleanerPosition,etaMinutes,accessRevoked);
}

@override
String toString() {
    return 'TrackingState(details: $details, status: $status, cleanerPosition: $cleanerPosition, etaMinutes: $etaMinutes, accessRevoked: $accessRevoked)';
}


}

/// @nodoc
abstract mixin class _$TrackingStateCopyWith<$Res> implements $TrackingStateCopyWith<$Res> {
  factory _$TrackingStateCopyWith(_TrackingState value, $Res Function(_TrackingState) _then) = __$TrackingStateCopyWithImpl;
@override @useResult
$Res call({
 BookingDetails details, BookingStatus status, GeoPoint? cleanerPosition, int? etaMinutes, bool accessRevoked
});


@override $BookingDetailsCopyWith<$Res> get details;@override $GeoPointCopyWith<$Res>? get cleanerPosition;

}
/// @nodoc
class __$TrackingStateCopyWithImpl<$Res>
    implements _$TrackingStateCopyWith<$Res> {
  __$TrackingStateCopyWithImpl(this._self, this._then);

  final _TrackingState _self;
  final $Res Function(_TrackingState) _then;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? details = null,Object? status = null,Object? cleanerPosition = freezed,Object? etaMinutes = freezed,Object? accessRevoked = null,}) {
  return _then(_TrackingState(
details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as BookingDetails,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,cleanerPosition: freezed == cleanerPosition ? _self.cleanerPosition : cleanerPosition // ignore: cast_nullable_to_non_nullable
as GeoPoint?,etaMinutes: freezed == etaMinutes ? _self.etaMinutes : etaMinutes // ignore: cast_nullable_to_non_nullable
as int?,accessRevoked: null == accessRevoked ? _self.accessRevoked : accessRevoked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingDetailsCopyWith<$Res> get details {
  
  return $BookingDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res>? get cleanerPosition {
    if (_self.cleanerPosition == null) {
    return null;
  }

  return $GeoPointCopyWith<$Res>(_self.cleanerPosition!, (value) {
    return _then(_self.copyWith(cleanerPosition: value));
  });
}
}

// dart format on
