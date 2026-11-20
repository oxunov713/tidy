// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Address {

 String get id; String get line1; String get city; String get postcode; double get lat; double get lng; String get line2; String get accessNotes;
/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressCopyWith<Address> get copyWith => _$AddressCopyWithImpl<Address>(this as Address, _$identity);

  /// Serializes this Address to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Address;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Address&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.line1, _this.line1) || other.line1 == _this.line1)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.postcode, _this.postcode) || other.postcode == _this.postcode)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.line2, _this.line2) || other.line2 == _this.line2)&&(identical(other.accessNotes, _this.accessNotes) || other.accessNotes == _this.accessNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Address;
  return Object.hash(runtimeType,_this.id,_this.line1,_this.city,_this.postcode,_this.lat,_this.lng,_this.line2,_this.accessNotes);
}

@override
String toString() {
  final _this = this as Address;
  return 'Address(id: ${_this.id}, line1: ${_this.line1}, city: ${_this.city}, postcode: ${_this.postcode}, lat: ${_this.lat}, lng: ${_this.lng}, line2: ${_this.line2}, accessNotes: ${_this.accessNotes})';
}


}

/// @nodoc
abstract mixin class $AddressCopyWith<$Res>  {
  factory $AddressCopyWith(Address value, $Res Function(Address) _then) = _$AddressCopyWithImpl;
@useResult
$Res call({
 String id, String line1, String city, String postcode, double lat, double lng, String line2, String accessNotes
});




}
/// @nodoc
class _$AddressCopyWithImpl<$Res>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._self, this._then);

  final Address _self;
  final $Res Function(Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? line1 = null,Object? city = null,Object? postcode = null,Object? lat = null,Object? lng = null,Object? line2 = null,Object? accessNotes = null,}) {
  return _then(Address(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,postcode: null == postcode ? _self.postcode : postcode // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,line2: null == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String,accessNotes: null == accessNotes ? _self.accessNotes : accessNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Address].
extension AddressPatterns on Address {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Address value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Address value)  $default,){
final _that = this;
switch (_that) {
case _Address():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Address value)?  $default,){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String line1,  String city,  String postcode,  double lat,  double lng,  String line2,  String accessNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.id,_that.line1,_that.city,_that.postcode,_that.lat,_that.lng,_that.line2,_that.accessNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String line1,  String city,  String postcode,  double lat,  double lng,  String line2,  String accessNotes)  $default,) {final _that = this;
switch (_that) {
case _Address():
return $default(_that.id,_that.line1,_that.city,_that.postcode,_that.lat,_that.lng,_that.line2,_that.accessNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String line1,  String city,  String postcode,  double lat,  double lng,  String line2,  String accessNotes)?  $default,) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.id,_that.line1,_that.city,_that.postcode,_that.lat,_that.lng,_that.line2,_that.accessNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Address implements Address {
  const _Address({required this.id, required this.line1, required this.city, required this.postcode, required this.lat, required this.lng, required this.line2, required this.accessNotes});
  factory _Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

@override final  String id;
@override final  String line1;
@override final  String city;
@override final  String postcode;
@override final  double lat;
@override final  double lng;
@override final  String line2;
@override final  String accessNotes;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressCopyWith<_Address> get copyWith => __$AddressCopyWithImpl<_Address>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddressToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Address&&(identical(other.id, id) || other.id == id)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.city, city) || other.city == city)&&(identical(other.postcode, postcode) || other.postcode == postcode)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.accessNotes, accessNotes) || other.accessNotes == accessNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,line1,city,postcode,lat,lng,line2,accessNotes);
}

@override
String toString() {
    return 'Address(id: $id, line1: $line1, city: $city, postcode: $postcode, lat: $lat, lng: $lng, line2: $line2, accessNotes: $accessNotes)';
}


}

/// @nodoc
abstract mixin class _$AddressCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$AddressCopyWith(_Address value, $Res Function(_Address) _then) = __$AddressCopyWithImpl;
@override @useResult
$Res call({
 String id, String line1, String city, String postcode, double lat, double lng, String line2, String accessNotes
});




}
/// @nodoc
class __$AddressCopyWithImpl<$Res>
    implements _$AddressCopyWith<$Res> {
  __$AddressCopyWithImpl(this._self, this._then);

  final _Address _self;
  final $Res Function(_Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? line1 = null,Object? city = null,Object? postcode = null,Object? lat = null,Object? lng = null,Object? line2 = null,Object? accessNotes = null,}) {
  return _then(_Address(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,postcode: null == postcode ? _self.postcode : postcode // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,line2: null == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String,accessNotes: null == accessNotes ? _self.accessNotes : accessNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AddressInput {

 String get line1; String get city; String get postcode; double get lat; double get lng; String get line2; String get accessNotes;
/// Create a copy of AddressInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressInputCopyWith<AddressInput> get copyWith => _$AddressInputCopyWithImpl<AddressInput>(this as AddressInput, _$identity);

  /// Serializes this AddressInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AddressInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressInput&&(identical(other.line1, _this.line1) || other.line1 == _this.line1)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.postcode, _this.postcode) || other.postcode == _this.postcode)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.line2, _this.line2) || other.line2 == _this.line2)&&(identical(other.accessNotes, _this.accessNotes) || other.accessNotes == _this.accessNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AddressInput;
  return Object.hash(runtimeType,_this.line1,_this.city,_this.postcode,_this.lat,_this.lng,_this.line2,_this.accessNotes);
}

@override
String toString() {
  final _this = this as AddressInput;
  return 'AddressInput(line1: ${_this.line1}, city: ${_this.city}, postcode: ${_this.postcode}, lat: ${_this.lat}, lng: ${_this.lng}, line2: ${_this.line2}, accessNotes: ${_this.accessNotes})';
}


}

/// @nodoc
abstract mixin class $AddressInputCopyWith<$Res>  {
  factory $AddressInputCopyWith(AddressInput value, $Res Function(AddressInput) _then) = _$AddressInputCopyWithImpl;
@useResult
$Res call({
 String line1, String city, String postcode, double lat, double lng, String line2, String accessNotes
});




}
/// @nodoc
class _$AddressInputCopyWithImpl<$Res>
    implements $AddressInputCopyWith<$Res> {
  _$AddressInputCopyWithImpl(this._self, this._then);

  final AddressInput _self;
  final $Res Function(AddressInput) _then;

/// Create a copy of AddressInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? line1 = null,Object? city = null,Object? postcode = null,Object? lat = null,Object? lng = null,Object? line2 = null,Object? accessNotes = null,}) {
  return _then(AddressInput(
line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,postcode: null == postcode ? _self.postcode : postcode // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,line2: null == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String,accessNotes: null == accessNotes ? _self.accessNotes : accessNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AddressInput].
extension AddressInputPatterns on AddressInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressInput value)  $default,){
final _that = this;
switch (_that) {
case _AddressInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressInput value)?  $default,){
final _that = this;
switch (_that) {
case _AddressInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String line1,  String city,  String postcode,  double lat,  double lng,  String line2,  String accessNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressInput() when $default != null:
return $default(_that.line1,_that.city,_that.postcode,_that.lat,_that.lng,_that.line2,_that.accessNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String line1,  String city,  String postcode,  double lat,  double lng,  String line2,  String accessNotes)  $default,) {final _that = this;
switch (_that) {
case _AddressInput():
return $default(_that.line1,_that.city,_that.postcode,_that.lat,_that.lng,_that.line2,_that.accessNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String line1,  String city,  String postcode,  double lat,  double lng,  String line2,  String accessNotes)?  $default,) {final _that = this;
switch (_that) {
case _AddressInput() when $default != null:
return $default(_that.line1,_that.city,_that.postcode,_that.lat,_that.lng,_that.line2,_that.accessNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddressInput implements AddressInput {
  const _AddressInput({required this.line1, required this.city, required this.postcode, required this.lat, required this.lng, this.line2 = '', this.accessNotes = ''});
  factory _AddressInput.fromJson(Map<String, dynamic> json) => _$AddressInputFromJson(json);

@override final  String line1;
@override final  String city;
@override final  String postcode;
@override final  double lat;
@override final  double lng;
@override@JsonKey() final  String line2;
@override@JsonKey() final  String accessNotes;

/// Create a copy of AddressInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressInputCopyWith<_AddressInput> get copyWith => __$AddressInputCopyWithImpl<_AddressInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddressInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressInput&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.city, city) || other.city == city)&&(identical(other.postcode, postcode) || other.postcode == postcode)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.accessNotes, accessNotes) || other.accessNotes == accessNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,line1,city,postcode,lat,lng,line2,accessNotes);
}

@override
String toString() {
    return 'AddressInput(line1: $line1, city: $city, postcode: $postcode, lat: $lat, lng: $lng, line2: $line2, accessNotes: $accessNotes)';
}


}

/// @nodoc
abstract mixin class _$AddressInputCopyWith<$Res> implements $AddressInputCopyWith<$Res> {
  factory _$AddressInputCopyWith(_AddressInput value, $Res Function(_AddressInput) _then) = __$AddressInputCopyWithImpl;
@override @useResult
$Res call({
 String line1, String city, String postcode, double lat, double lng, String line2, String accessNotes
});




}
/// @nodoc
class __$AddressInputCopyWithImpl<$Res>
    implements _$AddressInputCopyWith<$Res> {
  __$AddressInputCopyWithImpl(this._self, this._then);

  final _AddressInput _self;
  final $Res Function(_AddressInput) _then;

/// Create a copy of AddressInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? line1 = null,Object? city = null,Object? postcode = null,Object? lat = null,Object? lng = null,Object? line2 = null,Object? accessNotes = null,}) {
  return _then(_AddressInput(
line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,postcode: null == postcode ? _self.postcode : postcode // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,line2: null == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String,accessNotes: null == accessNotes ? _self.accessNotes : accessNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
