// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Service {

 String get id; String get slug; String get title;/// Starting price in pence.
 int get fromPrice;/// Visit length in minutes for one bedroom and one bathroom, extras not
/// included.
 int get minutes;
/// Create a copy of Service
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceCopyWith<Service> get copyWith => _$ServiceCopyWithImpl<Service>(this as Service, _$identity);

  /// Serializes this Service to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Service;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Service&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.fromPrice, _this.fromPrice) || other.fromPrice == _this.fromPrice)&&(identical(other.minutes, _this.minutes) || other.minutes == _this.minutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Service;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.title,_this.fromPrice,_this.minutes);
}

@override
String toString() {
  final _this = this as Service;
  return 'Service(id: ${_this.id}, slug: ${_this.slug}, title: ${_this.title}, fromPrice: ${_this.fromPrice}, minutes: ${_this.minutes})';
}


}

/// @nodoc
abstract mixin class $ServiceCopyWith<$Res>  {
  factory $ServiceCopyWith(Service value, $Res Function(Service) _then) = _$ServiceCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String title, int fromPrice, int minutes
});




}
/// @nodoc
class _$ServiceCopyWithImpl<$Res>
    implements $ServiceCopyWith<$Res> {
  _$ServiceCopyWithImpl(this._self, this._then);

  final Service _self;
  final $Res Function(Service) _then;

/// Create a copy of Service
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? fromPrice = null,Object? minutes = null,}) {
  return _then(Service(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fromPrice: null == fromPrice ? _self.fromPrice : fromPrice // ignore: cast_nullable_to_non_nullable
as int,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Service].
extension ServicePatterns on Service {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Service value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Service() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Service value)  $default,){
final _that = this;
switch (_that) {
case _Service():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Service value)?  $default,){
final _that = this;
switch (_that) {
case _Service() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  int fromPrice,  int minutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Service() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.fromPrice,_that.minutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  int fromPrice,  int minutes)  $default,) {final _that = this;
switch (_that) {
case _Service():
return $default(_that.id,_that.slug,_that.title,_that.fromPrice,_that.minutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String title,  int fromPrice,  int minutes)?  $default,) {final _that = this;
switch (_that) {
case _Service() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.fromPrice,_that.minutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Service implements Service {
  const _Service({required this.id, required this.slug, required this.title, required this.fromPrice, required this.minutes});
  factory _Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String title;
/// Starting price in pence.
@override final  int fromPrice;
/// Visit length in minutes for one bedroom and one bathroom, extras not
/// included.
@override final  int minutes;

/// Create a copy of Service
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceCopyWith<_Service> get copyWith => __$ServiceCopyWithImpl<_Service>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Service&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.fromPrice, fromPrice) || other.fromPrice == fromPrice)&&(identical(other.minutes, minutes) || other.minutes == minutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,title,fromPrice,minutes);
}

@override
String toString() {
    return 'Service(id: $id, slug: $slug, title: $title, fromPrice: $fromPrice, minutes: $minutes)';
}


}

/// @nodoc
abstract mixin class _$ServiceCopyWith<$Res> implements $ServiceCopyWith<$Res> {
  factory _$ServiceCopyWith(_Service value, $Res Function(_Service) _then) = __$ServiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String title, int fromPrice, int minutes
});




}
/// @nodoc
class __$ServiceCopyWithImpl<$Res>
    implements _$ServiceCopyWith<$Res> {
  __$ServiceCopyWithImpl(this._self, this._then);

  final _Service _self;
  final $Res Function(_Service) _then;

/// Create a copy of Service
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? fromPrice = null,Object? minutes = null,}) {
  return _then(_Service(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fromPrice: null == fromPrice ? _self.fromPrice : fromPrice // ignore: cast_nullable_to_non_nullable
as int,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Extra {

 String get id; String get slug; String get title;/// Price in pence.
 int get price;
/// Create a copy of Extra
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtraCopyWith<Extra> get copyWith => _$ExtraCopyWithImpl<Extra>(this as Extra, _$identity);

  /// Serializes this Extra to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Extra;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Extra&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.price, _this.price) || other.price == _this.price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Extra;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.title,_this.price);
}

@override
String toString() {
  final _this = this as Extra;
  return 'Extra(id: ${_this.id}, slug: ${_this.slug}, title: ${_this.title}, price: ${_this.price})';
}


}

/// @nodoc
abstract mixin class $ExtraCopyWith<$Res>  {
  factory $ExtraCopyWith(Extra value, $Res Function(Extra) _then) = _$ExtraCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String title, int price
});




}
/// @nodoc
class _$ExtraCopyWithImpl<$Res>
    implements $ExtraCopyWith<$Res> {
  _$ExtraCopyWithImpl(this._self, this._then);

  final Extra _self;
  final $Res Function(Extra) _then;

/// Create a copy of Extra
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? price = null,}) {
  return _then(Extra(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Extra].
extension ExtraPatterns on Extra {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Extra value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Extra() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Extra value)  $default,){
final _that = this;
switch (_that) {
case _Extra():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Extra value)?  $default,){
final _that = this;
switch (_that) {
case _Extra() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  int price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Extra() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  int price)  $default,) {final _that = this;
switch (_that) {
case _Extra():
return $default(_that.id,_that.slug,_that.title,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String title,  int price)?  $default,) {final _that = this;
switch (_that) {
case _Extra() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Extra implements Extra {
  const _Extra({required this.id, required this.slug, required this.title, required this.price});
  factory _Extra.fromJson(Map<String, dynamic> json) => _$ExtraFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String title;
/// Price in pence.
@override final  int price;

/// Create a copy of Extra
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtraCopyWith<_Extra> get copyWith => __$ExtraCopyWithImpl<_Extra>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtraToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Extra&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,title,price);
}

@override
String toString() {
    return 'Extra(id: $id, slug: $slug, title: $title, price: $price)';
}


}

/// @nodoc
abstract mixin class _$ExtraCopyWith<$Res> implements $ExtraCopyWith<$Res> {
  factory _$ExtraCopyWith(_Extra value, $Res Function(_Extra) _then) = __$ExtraCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String title, int price
});




}
/// @nodoc
class __$ExtraCopyWithImpl<$Res>
    implements _$ExtraCopyWith<$Res> {
  __$ExtraCopyWithImpl(this._self, this._then);

  final _Extra _self;
  final $Res Function(_Extra) _then;

/// Create a copy of Extra
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? price = null,}) {
  return _then(_Extra(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AdminService {

 String get id; String get slug; String get title;/// Price in pence for one bedroom and one bathroom.
 int get basePrice; int get perBedroom; int get perBathroom;/// Minutes for one bedroom and one bathroom.
 int get baseMinutes; int get minutesPerRoom; bool get isActive; int get sortOrder;
/// Create a copy of AdminService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminServiceCopyWith<AdminService> get copyWith => _$AdminServiceCopyWithImpl<AdminService>(this as AdminService, _$identity);

  /// Serializes this AdminService to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminService;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminService&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.basePrice, _this.basePrice) || other.basePrice == _this.basePrice)&&(identical(other.perBedroom, _this.perBedroom) || other.perBedroom == _this.perBedroom)&&(identical(other.perBathroom, _this.perBathroom) || other.perBathroom == _this.perBathroom)&&(identical(other.baseMinutes, _this.baseMinutes) || other.baseMinutes == _this.baseMinutes)&&(identical(other.minutesPerRoom, _this.minutesPerRoom) || other.minutesPerRoom == _this.minutesPerRoom)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminService;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.title,_this.basePrice,_this.perBedroom,_this.perBathroom,_this.baseMinutes,_this.minutesPerRoom,_this.isActive,_this.sortOrder);
}

@override
String toString() {
  final _this = this as AdminService;
  return 'AdminService(id: ${_this.id}, slug: ${_this.slug}, title: ${_this.title}, basePrice: ${_this.basePrice}, perBedroom: ${_this.perBedroom}, perBathroom: ${_this.perBathroom}, baseMinutes: ${_this.baseMinutes}, minutesPerRoom: ${_this.minutesPerRoom}, isActive: ${_this.isActive}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $AdminServiceCopyWith<$Res>  {
  factory $AdminServiceCopyWith(AdminService value, $Res Function(AdminService) _then) = _$AdminServiceCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String title, int basePrice, int perBedroom, int perBathroom, int baseMinutes, int minutesPerRoom, bool isActive, int sortOrder
});




}
/// @nodoc
class _$AdminServiceCopyWithImpl<$Res>
    implements $AdminServiceCopyWith<$Res> {
  _$AdminServiceCopyWithImpl(this._self, this._then);

  final AdminService _self;
  final $Res Function(AdminService) _then;

/// Create a copy of AdminService
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? basePrice = null,Object? perBedroom = null,Object? perBathroom = null,Object? baseMinutes = null,Object? minutesPerRoom = null,Object? isActive = null,Object? sortOrder = null,}) {
  return _then(AdminService(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as int,perBedroom: null == perBedroom ? _self.perBedroom : perBedroom // ignore: cast_nullable_to_non_nullable
as int,perBathroom: null == perBathroom ? _self.perBathroom : perBathroom // ignore: cast_nullable_to_non_nullable
as int,baseMinutes: null == baseMinutes ? _self.baseMinutes : baseMinutes // ignore: cast_nullable_to_non_nullable
as int,minutesPerRoom: null == minutesPerRoom ? _self.minutesPerRoom : minutesPerRoom // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminService].
extension AdminServicePatterns on AdminService {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminService() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminService value)  $default,){
final _that = this;
switch (_that) {
case _AdminService():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminService value)?  $default,){
final _that = this;
switch (_that) {
case _AdminService() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  int basePrice,  int perBedroom,  int perBathroom,  int baseMinutes,  int minutesPerRoom,  bool isActive,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminService() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.basePrice,_that.perBedroom,_that.perBathroom,_that.baseMinutes,_that.minutesPerRoom,_that.isActive,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  int basePrice,  int perBedroom,  int perBathroom,  int baseMinutes,  int minutesPerRoom,  bool isActive,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _AdminService():
return $default(_that.id,_that.slug,_that.title,_that.basePrice,_that.perBedroom,_that.perBathroom,_that.baseMinutes,_that.minutesPerRoom,_that.isActive,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String title,  int basePrice,  int perBedroom,  int perBathroom,  int baseMinutes,  int minutesPerRoom,  bool isActive,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _AdminService() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.basePrice,_that.perBedroom,_that.perBathroom,_that.baseMinutes,_that.minutesPerRoom,_that.isActive,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminService implements AdminService {
  const _AdminService({required this.id, required this.slug, required this.title, required this.basePrice, required this.perBedroom, required this.perBathroom, required this.baseMinutes, required this.minutesPerRoom, required this.isActive, required this.sortOrder});
  factory _AdminService.fromJson(Map<String, dynamic> json) => _$AdminServiceFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String title;
/// Price in pence for one bedroom and one bathroom.
@override final  int basePrice;
@override final  int perBedroom;
@override final  int perBathroom;
/// Minutes for one bedroom and one bathroom.
@override final  int baseMinutes;
@override final  int minutesPerRoom;
@override final  bool isActive;
@override final  int sortOrder;

/// Create a copy of AdminService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminServiceCopyWith<_AdminService> get copyWith => __$AdminServiceCopyWithImpl<_AdminService>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminServiceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminService&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.perBedroom, perBedroom) || other.perBedroom == perBedroom)&&(identical(other.perBathroom, perBathroom) || other.perBathroom == perBathroom)&&(identical(other.baseMinutes, baseMinutes) || other.baseMinutes == baseMinutes)&&(identical(other.minutesPerRoom, minutesPerRoom) || other.minutesPerRoom == minutesPerRoom)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,title,basePrice,perBedroom,perBathroom,baseMinutes,minutesPerRoom,isActive,sortOrder);
}

@override
String toString() {
    return 'AdminService(id: $id, slug: $slug, title: $title, basePrice: $basePrice, perBedroom: $perBedroom, perBathroom: $perBathroom, baseMinutes: $baseMinutes, minutesPerRoom: $minutesPerRoom, isActive: $isActive, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$AdminServiceCopyWith<$Res> implements $AdminServiceCopyWith<$Res> {
  factory _$AdminServiceCopyWith(_AdminService value, $Res Function(_AdminService) _then) = __$AdminServiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String title, int basePrice, int perBedroom, int perBathroom, int baseMinutes, int minutesPerRoom, bool isActive, int sortOrder
});




}
/// @nodoc
class __$AdminServiceCopyWithImpl<$Res>
    implements _$AdminServiceCopyWith<$Res> {
  __$AdminServiceCopyWithImpl(this._self, this._then);

  final _AdminService _self;
  final $Res Function(_AdminService) _then;

/// Create a copy of AdminService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? basePrice = null,Object? perBedroom = null,Object? perBathroom = null,Object? baseMinutes = null,Object? minutesPerRoom = null,Object? isActive = null,Object? sortOrder = null,}) {
  return _then(_AdminService(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as int,perBedroom: null == perBedroom ? _self.perBedroom : perBedroom // ignore: cast_nullable_to_non_nullable
as int,perBathroom: null == perBathroom ? _self.perBathroom : perBathroom // ignore: cast_nullable_to_non_nullable
as int,baseMinutes: null == baseMinutes ? _self.baseMinutes : baseMinutes // ignore: cast_nullable_to_non_nullable
as int,minutesPerRoom: null == minutesPerRoom ? _self.minutesPerRoom : minutesPerRoom // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ServiceUpdate {

 String get title; int get basePrice; int get perBedroom; int get perBathroom; int get baseMinutes; int get minutesPerRoom; bool get isActive;
/// Create a copy of ServiceUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceUpdateCopyWith<ServiceUpdate> get copyWith => _$ServiceUpdateCopyWithImpl<ServiceUpdate>(this as ServiceUpdate, _$identity);

  /// Serializes this ServiceUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServiceUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceUpdate&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.basePrice, _this.basePrice) || other.basePrice == _this.basePrice)&&(identical(other.perBedroom, _this.perBedroom) || other.perBedroom == _this.perBedroom)&&(identical(other.perBathroom, _this.perBathroom) || other.perBathroom == _this.perBathroom)&&(identical(other.baseMinutes, _this.baseMinutes) || other.baseMinutes == _this.baseMinutes)&&(identical(other.minutesPerRoom, _this.minutesPerRoom) || other.minutesPerRoom == _this.minutesPerRoom)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServiceUpdate;
  return Object.hash(runtimeType,_this.title,_this.basePrice,_this.perBedroom,_this.perBathroom,_this.baseMinutes,_this.minutesPerRoom,_this.isActive);
}

@override
String toString() {
  final _this = this as ServiceUpdate;
  return 'ServiceUpdate(title: ${_this.title}, basePrice: ${_this.basePrice}, perBedroom: ${_this.perBedroom}, perBathroom: ${_this.perBathroom}, baseMinutes: ${_this.baseMinutes}, minutesPerRoom: ${_this.minutesPerRoom}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $ServiceUpdateCopyWith<$Res>  {
  factory $ServiceUpdateCopyWith(ServiceUpdate value, $Res Function(ServiceUpdate) _then) = _$ServiceUpdateCopyWithImpl;
@useResult
$Res call({
 String title, int basePrice, int perBedroom, int perBathroom, int baseMinutes, int minutesPerRoom, bool isActive
});




}
/// @nodoc
class _$ServiceUpdateCopyWithImpl<$Res>
    implements $ServiceUpdateCopyWith<$Res> {
  _$ServiceUpdateCopyWithImpl(this._self, this._then);

  final ServiceUpdate _self;
  final $Res Function(ServiceUpdate) _then;

/// Create a copy of ServiceUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? basePrice = null,Object? perBedroom = null,Object? perBathroom = null,Object? baseMinutes = null,Object? minutesPerRoom = null,Object? isActive = null,}) {
  return _then(ServiceUpdate(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as int,perBedroom: null == perBedroom ? _self.perBedroom : perBedroom // ignore: cast_nullable_to_non_nullable
as int,perBathroom: null == perBathroom ? _self.perBathroom : perBathroom // ignore: cast_nullable_to_non_nullable
as int,baseMinutes: null == baseMinutes ? _self.baseMinutes : baseMinutes // ignore: cast_nullable_to_non_nullable
as int,minutesPerRoom: null == minutesPerRoom ? _self.minutesPerRoom : minutesPerRoom // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceUpdate].
extension ServiceUpdatePatterns on ServiceUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceUpdate value)  $default,){
final _that = this;
switch (_that) {
case _ServiceUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  int basePrice,  int perBedroom,  int perBathroom,  int baseMinutes,  int minutesPerRoom,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceUpdate() when $default != null:
return $default(_that.title,_that.basePrice,_that.perBedroom,_that.perBathroom,_that.baseMinutes,_that.minutesPerRoom,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  int basePrice,  int perBedroom,  int perBathroom,  int baseMinutes,  int minutesPerRoom,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ServiceUpdate():
return $default(_that.title,_that.basePrice,_that.perBedroom,_that.perBathroom,_that.baseMinutes,_that.minutesPerRoom,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  int basePrice,  int perBedroom,  int perBathroom,  int baseMinutes,  int minutesPerRoom,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ServiceUpdate() when $default != null:
return $default(_that.title,_that.basePrice,_that.perBedroom,_that.perBathroom,_that.baseMinutes,_that.minutesPerRoom,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceUpdate implements ServiceUpdate {
  const _ServiceUpdate({required this.title, required this.basePrice, required this.perBedroom, required this.perBathroom, required this.baseMinutes, required this.minutesPerRoom, this.isActive = true});
  factory _ServiceUpdate.fromJson(Map<String, dynamic> json) => _$ServiceUpdateFromJson(json);

@override final  String title;
@override final  int basePrice;
@override final  int perBedroom;
@override final  int perBathroom;
@override final  int baseMinutes;
@override final  int minutesPerRoom;
@override@JsonKey() final  bool isActive;

/// Create a copy of ServiceUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceUpdateCopyWith<_ServiceUpdate> get copyWith => __$ServiceUpdateCopyWithImpl<_ServiceUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceUpdate&&(identical(other.title, title) || other.title == title)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.perBedroom, perBedroom) || other.perBedroom == perBedroom)&&(identical(other.perBathroom, perBathroom) || other.perBathroom == perBathroom)&&(identical(other.baseMinutes, baseMinutes) || other.baseMinutes == baseMinutes)&&(identical(other.minutesPerRoom, minutesPerRoom) || other.minutesPerRoom == minutesPerRoom)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,basePrice,perBedroom,perBathroom,baseMinutes,minutesPerRoom,isActive);
}

@override
String toString() {
    return 'ServiceUpdate(title: $title, basePrice: $basePrice, perBedroom: $perBedroom, perBathroom: $perBathroom, baseMinutes: $baseMinutes, minutesPerRoom: $minutesPerRoom, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ServiceUpdateCopyWith<$Res> implements $ServiceUpdateCopyWith<$Res> {
  factory _$ServiceUpdateCopyWith(_ServiceUpdate value, $Res Function(_ServiceUpdate) _then) = __$ServiceUpdateCopyWithImpl;
@override @useResult
$Res call({
 String title, int basePrice, int perBedroom, int perBathroom, int baseMinutes, int minutesPerRoom, bool isActive
});




}
/// @nodoc
class __$ServiceUpdateCopyWithImpl<$Res>
    implements _$ServiceUpdateCopyWith<$Res> {
  __$ServiceUpdateCopyWithImpl(this._self, this._then);

  final _ServiceUpdate _self;
  final $Res Function(_ServiceUpdate) _then;

/// Create a copy of ServiceUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? basePrice = null,Object? perBedroom = null,Object? perBathroom = null,Object? baseMinutes = null,Object? minutesPerRoom = null,Object? isActive = null,}) {
  return _then(_ServiceUpdate(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as int,perBedroom: null == perBedroom ? _self.perBedroom : perBedroom // ignore: cast_nullable_to_non_nullable
as int,perBathroom: null == perBathroom ? _self.perBathroom : perBathroom // ignore: cast_nullable_to_non_nullable
as int,baseMinutes: null == baseMinutes ? _self.baseMinutes : baseMinutes // ignore: cast_nullable_to_non_nullable
as int,minutesPerRoom: null == minutesPerRoom ? _self.minutesPerRoom : minutesPerRoom // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
