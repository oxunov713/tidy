// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuoteRequest {

 String get serviceId; int get bedrooms; int get bathrooms; List<String> get extraIds; Frequency get frequency;
/// Create a copy of QuoteRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteRequestCopyWith<QuoteRequest> get copyWith => _$QuoteRequestCopyWithImpl<QuoteRequest>(this as QuoteRequest, _$identity);

  /// Serializes this QuoteRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuoteRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteRequest&&(identical(other.serviceId, _this.serviceId) || other.serviceId == _this.serviceId)&&(identical(other.bedrooms, _this.bedrooms) || other.bedrooms == _this.bedrooms)&&(identical(other.bathrooms, _this.bathrooms) || other.bathrooms == _this.bathrooms)&&const DeepCollectionEquality().equals(other.extraIds, _this.extraIds)&&(identical(other.frequency, _this.frequency) || other.frequency == _this.frequency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuoteRequest;
  return Object.hash(runtimeType,_this.serviceId,_this.bedrooms,_this.bathrooms,const DeepCollectionEquality().hash(_this.extraIds),_this.frequency);
}

@override
String toString() {
  final _this = this as QuoteRequest;
  return 'QuoteRequest(serviceId: ${_this.serviceId}, bedrooms: ${_this.bedrooms}, bathrooms: ${_this.bathrooms}, extraIds: ${_this.extraIds}, frequency: ${_this.frequency})';
}


}

/// @nodoc
abstract mixin class $QuoteRequestCopyWith<$Res>  {
  factory $QuoteRequestCopyWith(QuoteRequest value, $Res Function(QuoteRequest) _then) = _$QuoteRequestCopyWithImpl;
@useResult
$Res call({
 String serviceId, int bedrooms, int bathrooms, List<String> extraIds, Frequency frequency
});




}
/// @nodoc
class _$QuoteRequestCopyWithImpl<$Res>
    implements $QuoteRequestCopyWith<$Res> {
  _$QuoteRequestCopyWithImpl(this._self, this._then);

  final QuoteRequest _self;
  final $Res Function(QuoteRequest) _then;

/// Create a copy of QuoteRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceId = null,Object? bedrooms = null,Object? bathrooms = null,Object? extraIds = null,Object? frequency = null,}) {
  return _then(QuoteRequest(
serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,bedrooms: null == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int,bathrooms: null == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int,extraIds: null == extraIds ? _self.extraIds : extraIds // ignore: cast_nullable_to_non_nullable
as List<String>,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,
  ));
}

}


/// Adds pattern-matching-related methods to [QuoteRequest].
extension QuoteRequestPatterns on QuoteRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuoteRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuoteRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuoteRequest value)  $default,){
final _that = this;
switch (_that) {
case _QuoteRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuoteRequest value)?  $default,){
final _that = this;
switch (_that) {
case _QuoteRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serviceId,  int bedrooms,  int bathrooms,  List<String> extraIds,  Frequency frequency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuoteRequest() when $default != null:
return $default(_that.serviceId,_that.bedrooms,_that.bathrooms,_that.extraIds,_that.frequency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serviceId,  int bedrooms,  int bathrooms,  List<String> extraIds,  Frequency frequency)  $default,) {final _that = this;
switch (_that) {
case _QuoteRequest():
return $default(_that.serviceId,_that.bedrooms,_that.bathrooms,_that.extraIds,_that.frequency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serviceId,  int bedrooms,  int bathrooms,  List<String> extraIds,  Frequency frequency)?  $default,) {final _that = this;
switch (_that) {
case _QuoteRequest() when $default != null:
return $default(_that.serviceId,_that.bedrooms,_that.bathrooms,_that.extraIds,_that.frequency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuoteRequest implements QuoteRequest {
  const _QuoteRequest({required this.serviceId, required this.bedrooms, required this.bathrooms,  List<String> extraIds = const <String>[], this.frequency = Frequency.once}): _extraIds = extraIds;
  factory _QuoteRequest.fromJson(Map<String, dynamic> json) => _$QuoteRequestFromJson(json);

@override final  String serviceId;
@override final  int bedrooms;
@override final  int bathrooms;
 final  List<String> _extraIds;
@override@JsonKey() List<String> get extraIds {
  if (_extraIds is EqualUnmodifiableListView) return _extraIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extraIds);
}

@override@JsonKey() final  Frequency frequency;

/// Create a copy of QuoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteRequestCopyWith<_QuoteRequest> get copyWith => __$QuoteRequestCopyWithImpl<_QuoteRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuoteRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuoteRequest&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.bedrooms, bedrooms) || other.bedrooms == bedrooms)&&(identical(other.bathrooms, bathrooms) || other.bathrooms == bathrooms)&&const DeepCollectionEquality().equals(other.extraIds, _extraIds)&&(identical(other.frequency, frequency) || other.frequency == frequency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,serviceId,bedrooms,bathrooms,const DeepCollectionEquality().hash(_extraIds),frequency);
}

@override
String toString() {
    return 'QuoteRequest(serviceId: $serviceId, bedrooms: $bedrooms, bathrooms: $bathrooms, extraIds: $extraIds, frequency: $frequency)';
}


}

/// @nodoc
abstract mixin class _$QuoteRequestCopyWith<$Res> implements $QuoteRequestCopyWith<$Res> {
  factory _$QuoteRequestCopyWith(_QuoteRequest value, $Res Function(_QuoteRequest) _then) = __$QuoteRequestCopyWithImpl;
@override @useResult
$Res call({
 String serviceId, int bedrooms, int bathrooms, List<String> extraIds, Frequency frequency
});




}
/// @nodoc
class __$QuoteRequestCopyWithImpl<$Res>
    implements _$QuoteRequestCopyWith<$Res> {
  __$QuoteRequestCopyWithImpl(this._self, this._then);

  final _QuoteRequest _self;
  final $Res Function(_QuoteRequest) _then;

/// Create a copy of QuoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceId = null,Object? bedrooms = null,Object? bathrooms = null,Object? extraIds = null,Object? frequency = null,}) {
  return _then(_QuoteRequest(
serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,bedrooms: null == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int,bathrooms: null == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int,extraIds: null == extraIds ? _self._extraIds : extraIds // ignore: cast_nullable_to_non_nullable
as List<String>,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,
  ));
}


}


/// @nodoc
mixin _$QuoteLine {

 String get label;/// Pence; negative for discounts.
 int get amount;
/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteLineCopyWith<QuoteLine> get copyWith => _$QuoteLineCopyWithImpl<QuoteLine>(this as QuoteLine, _$identity);

  /// Serializes this QuoteLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuoteLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteLine&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.amount, _this.amount) || other.amount == _this.amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuoteLine;
  return Object.hash(runtimeType,_this.label,_this.amount);
}

@override
String toString() {
  final _this = this as QuoteLine;
  return 'QuoteLine(label: ${_this.label}, amount: ${_this.amount})';
}


}

/// @nodoc
abstract mixin class $QuoteLineCopyWith<$Res>  {
  factory $QuoteLineCopyWith(QuoteLine value, $Res Function(QuoteLine) _then) = _$QuoteLineCopyWithImpl;
@useResult
$Res call({
 String label, int amount
});




}
/// @nodoc
class _$QuoteLineCopyWithImpl<$Res>
    implements $QuoteLineCopyWith<$Res> {
  _$QuoteLineCopyWithImpl(this._self, this._then);

  final QuoteLine _self;
  final $Res Function(QuoteLine) _then;

/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? amount = null,}) {
  return _then(QuoteLine(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuoteLine].
extension QuoteLinePatterns on QuoteLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuoteLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuoteLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuoteLine value)  $default,){
final _that = this;
switch (_that) {
case _QuoteLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuoteLine value)?  $default,){
final _that = this;
switch (_that) {
case _QuoteLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  int amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuoteLine() when $default != null:
return $default(_that.label,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  int amount)  $default,) {final _that = this;
switch (_that) {
case _QuoteLine():
return $default(_that.label,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  int amount)?  $default,) {final _that = this;
switch (_that) {
case _QuoteLine() when $default != null:
return $default(_that.label,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuoteLine implements QuoteLine {
  const _QuoteLine({required this.label, required this.amount});
  factory _QuoteLine.fromJson(Map<String, dynamic> json) => _$QuoteLineFromJson(json);

@override final  String label;
/// Pence; negative for discounts.
@override final  int amount;

/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteLineCopyWith<_QuoteLine> get copyWith => __$QuoteLineCopyWithImpl<_QuoteLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuoteLineToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuoteLine&&(identical(other.label, label) || other.label == label)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,label,amount);
}

@override
String toString() {
    return 'QuoteLine(label: $label, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$QuoteLineCopyWith<$Res> implements $QuoteLineCopyWith<$Res> {
  factory _$QuoteLineCopyWith(_QuoteLine value, $Res Function(_QuoteLine) _then) = __$QuoteLineCopyWithImpl;
@override @useResult
$Res call({
 String label, int amount
});




}
/// @nodoc
class __$QuoteLineCopyWithImpl<$Res>
    implements _$QuoteLineCopyWith<$Res> {
  __$QuoteLineCopyWithImpl(this._self, this._then);

  final _QuoteLine _self;
  final $Res Function(_QuoteLine) _then;

/// Create a copy of QuoteLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? amount = null,}) {
  return _then(_QuoteLine(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Quote {

 int get subtotal; int get discount; int get total;/// Visit length, extras included.
 int get minutes; List<QuoteLine> get lines;
/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteCopyWith<Quote> get copyWith => _$QuoteCopyWithImpl<Quote>(this as Quote, _$identity);

  /// Serializes this Quote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Quote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quote&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal)&&(identical(other.discount, _this.discount) || other.discount == _this.discount)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.minutes, _this.minutes) || other.minutes == _this.minutes)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Quote;
  return Object.hash(runtimeType,_this.subtotal,_this.discount,_this.total,_this.minutes,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as Quote;
  return 'Quote(subtotal: ${_this.subtotal}, discount: ${_this.discount}, total: ${_this.total}, minutes: ${_this.minutes}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $QuoteCopyWith<$Res>  {
  factory $QuoteCopyWith(Quote value, $Res Function(Quote) _then) = _$QuoteCopyWithImpl;
@useResult
$Res call({
 int subtotal, int discount, int total, int minutes, List<QuoteLine> lines
});




}
/// @nodoc
class _$QuoteCopyWithImpl<$Res>
    implements $QuoteCopyWith<$Res> {
  _$QuoteCopyWithImpl(this._self, this._then);

  final Quote _self;
  final $Res Function(Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subtotal = null,Object? discount = null,Object? total = null,Object? minutes = null,Object? lines = null,}) {
  return _then(Quote(
subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<QuoteLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [Quote].
extension QuotePatterns on Quote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Quote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Quote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Quote value)  $default,){
final _that = this;
switch (_that) {
case _Quote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Quote value)?  $default,){
final _that = this;
switch (_that) {
case _Quote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int subtotal,  int discount,  int total,  int minutes,  List<QuoteLine> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that.subtotal,_that.discount,_that.total,_that.minutes,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int subtotal,  int discount,  int total,  int minutes,  List<QuoteLine> lines)  $default,) {final _that = this;
switch (_that) {
case _Quote():
return $default(_that.subtotal,_that.discount,_that.total,_that.minutes,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int subtotal,  int discount,  int total,  int minutes,  List<QuoteLine> lines)?  $default,) {final _that = this;
switch (_that) {
case _Quote() when $default != null:
return $default(_that.subtotal,_that.discount,_that.total,_that.minutes,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Quote implements Quote {
  const _Quote({required this.subtotal, required this.discount, required this.total, required this.minutes,  List<QuoteLine> lines = const <QuoteLine>[]}): _lines = lines;
  factory _Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

@override final  int subtotal;
@override final  int discount;
@override final  int total;
/// Visit length, extras included.
@override final  int minutes;
 final  List<QuoteLine> _lines;
@override@JsonKey() List<QuoteLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteCopyWith<_Quote> get copyWith => __$QuoteCopyWithImpl<_Quote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quote&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.total, total) || other.total == total)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&const DeepCollectionEquality().equals(other.lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,subtotal,discount,total,minutes,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'Quote(subtotal: $subtotal, discount: $discount, total: $total, minutes: $minutes, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$QuoteCopyWith<$Res> implements $QuoteCopyWith<$Res> {
  factory _$QuoteCopyWith(_Quote value, $Res Function(_Quote) _then) = __$QuoteCopyWithImpl;
@override @useResult
$Res call({
 int subtotal, int discount, int total, int minutes, List<QuoteLine> lines
});




}
/// @nodoc
class __$QuoteCopyWithImpl<$Res>
    implements _$QuoteCopyWith<$Res> {
  __$QuoteCopyWithImpl(this._self, this._then);

  final _Quote _self;
  final $Res Function(_Quote) _then;

/// Create a copy of Quote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subtotal = null,Object? discount = null,Object? total = null,Object? minutes = null,Object? lines = null,}) {
  return _then(_Quote(
subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<QuoteLine>,
  ));
}


}

// dart format on
