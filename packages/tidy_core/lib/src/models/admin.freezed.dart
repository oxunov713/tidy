// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminStats {

 int get bookings;/// Pence.
 int get revenue; int get cleanersOnline; int get pendingApprovals;
/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminStatsCopyWith<AdminStats> get copyWith => _$AdminStatsCopyWithImpl<AdminStats>(this as AdminStats, _$identity);

  /// Serializes this AdminStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminStats&&(identical(other.bookings, _this.bookings) || other.bookings == _this.bookings)&&(identical(other.revenue, _this.revenue) || other.revenue == _this.revenue)&&(identical(other.cleanersOnline, _this.cleanersOnline) || other.cleanersOnline == _this.cleanersOnline)&&(identical(other.pendingApprovals, _this.pendingApprovals) || other.pendingApprovals == _this.pendingApprovals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminStats;
  return Object.hash(runtimeType,_this.bookings,_this.revenue,_this.cleanersOnline,_this.pendingApprovals);
}

@override
String toString() {
  final _this = this as AdminStats;
  return 'AdminStats(bookings: ${_this.bookings}, revenue: ${_this.revenue}, cleanersOnline: ${_this.cleanersOnline}, pendingApprovals: ${_this.pendingApprovals})';
}


}

/// @nodoc
abstract mixin class $AdminStatsCopyWith<$Res>  {
  factory $AdminStatsCopyWith(AdminStats value, $Res Function(AdminStats) _then) = _$AdminStatsCopyWithImpl;
@useResult
$Res call({
 int bookings, int revenue, int cleanersOnline, int pendingApprovals
});




}
/// @nodoc
class _$AdminStatsCopyWithImpl<$Res>
    implements $AdminStatsCopyWith<$Res> {
  _$AdminStatsCopyWithImpl(this._self, this._then);

  final AdminStats _self;
  final $Res Function(AdminStats) _then;

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookings = null,Object? revenue = null,Object? cleanersOnline = null,Object? pendingApprovals = null,}) {
  return _then(AdminStats(
bookings: null == bookings ? _self.bookings : bookings // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,cleanersOnline: null == cleanersOnline ? _self.cleanersOnline : cleanersOnline // ignore: cast_nullable_to_non_nullable
as int,pendingApprovals: null == pendingApprovals ? _self.pendingApprovals : pendingApprovals // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminStats].
extension AdminStatsPatterns on AdminStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminStats value)  $default,){
final _that = this;
switch (_that) {
case _AdminStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminStats value)?  $default,){
final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int bookings,  int revenue,  int cleanersOnline,  int pendingApprovals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
return $default(_that.bookings,_that.revenue,_that.cleanersOnline,_that.pendingApprovals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int bookings,  int revenue,  int cleanersOnline,  int pendingApprovals)  $default,) {final _that = this;
switch (_that) {
case _AdminStats():
return $default(_that.bookings,_that.revenue,_that.cleanersOnline,_that.pendingApprovals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int bookings,  int revenue,  int cleanersOnline,  int pendingApprovals)?  $default,) {final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
return $default(_that.bookings,_that.revenue,_that.cleanersOnline,_that.pendingApprovals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminStats implements AdminStats {
  const _AdminStats({required this.bookings, required this.revenue, required this.cleanersOnline, required this.pendingApprovals});
  factory _AdminStats.fromJson(Map<String, dynamic> json) => _$AdminStatsFromJson(json);

@override final  int bookings;
/// Pence.
@override final  int revenue;
@override final  int cleanersOnline;
@override final  int pendingApprovals;

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminStatsCopyWith<_AdminStats> get copyWith => __$AdminStatsCopyWithImpl<_AdminStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminStats&&(identical(other.bookings, bookings) || other.bookings == bookings)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.cleanersOnline, cleanersOnline) || other.cleanersOnline == cleanersOnline)&&(identical(other.pendingApprovals, pendingApprovals) || other.pendingApprovals == pendingApprovals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,bookings,revenue,cleanersOnline,pendingApprovals);
}

@override
String toString() {
    return 'AdminStats(bookings: $bookings, revenue: $revenue, cleanersOnline: $cleanersOnline, pendingApprovals: $pendingApprovals)';
}


}

/// @nodoc
abstract mixin class _$AdminStatsCopyWith<$Res> implements $AdminStatsCopyWith<$Res> {
  factory _$AdminStatsCopyWith(_AdminStats value, $Res Function(_AdminStats) _then) = __$AdminStatsCopyWithImpl;
@override @useResult
$Res call({
 int bookings, int revenue, int cleanersOnline, int pendingApprovals
});




}
/// @nodoc
class __$AdminStatsCopyWithImpl<$Res>
    implements _$AdminStatsCopyWith<$Res> {
  __$AdminStatsCopyWithImpl(this._self, this._then);

  final _AdminStats _self;
  final $Res Function(_AdminStats) _then;

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookings = null,Object? revenue = null,Object? cleanersOnline = null,Object? pendingApprovals = null,}) {
  return _then(_AdminStats(
bookings: null == bookings ? _self.bookings : bookings // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,cleanersOnline: null == cleanersOnline ? _self.cleanersOnline : cleanersOnline // ignore: cast_nullable_to_non_nullable
as int,pendingApprovals: null == pendingApprovals ? _self.pendingApprovals : pendingApprovals // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
