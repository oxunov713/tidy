// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 String get id; String get phone; String get fullName; UserRole get role; DateTime get createdAt; String? get email; String? get avatarUrl;/// The cleaner profile. Sent by `GET /me` for cleaners and in the admin
/// cleaner list; absent for clients and admins and in `/auth/verify`.
 Cleaner? get cleaner;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as User;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.cleaner, _this.cleaner) || other.cleaner == _this.cleaner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as User;
  return Object.hash(runtimeType,_this.id,_this.phone,_this.fullName,_this.role,_this.createdAt,_this.email,_this.avatarUrl,_this.cleaner);
}

@override
String toString() {
  final _this = this as User;
  return 'User(id: ${_this.id}, phone: ${_this.phone}, fullName: ${_this.fullName}, role: ${_this.role}, createdAt: ${_this.createdAt}, email: ${_this.email}, avatarUrl: ${_this.avatarUrl}, cleaner: ${_this.cleaner})';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String phone, String fullName, UserRole role, DateTime createdAt, String? email, String? avatarUrl, Cleaner? cleaner
});


$CleanerCopyWith<$Res>? get cleaner;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? phone = null,Object? fullName = null,Object? role = null,Object? createdAt = null,Object? email = freezed,Object? avatarUrl = freezed,Object? cleaner = freezed,}) {
  return _then(User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,cleaner: freezed == cleaner ? _self.cleaner : cleaner // ignore: cast_nullable_to_non_nullable
as Cleaner?,
  ));
}
/// Create a copy of User
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
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String phone,  String fullName,  UserRole role,  DateTime createdAt,  String? email,  String? avatarUrl,  Cleaner? cleaner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.phone,_that.fullName,_that.role,_that.createdAt,_that.email,_that.avatarUrl,_that.cleaner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String phone,  String fullName,  UserRole role,  DateTime createdAt,  String? email,  String? avatarUrl,  Cleaner? cleaner)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.phone,_that.fullName,_that.role,_that.createdAt,_that.email,_that.avatarUrl,_that.cleaner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String phone,  String fullName,  UserRole role,  DateTime createdAt,  String? email,  String? avatarUrl,  Cleaner? cleaner)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.phone,_that.fullName,_that.role,_that.createdAt,_that.email,_that.avatarUrl,_that.cleaner);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.id, required this.phone, required this.fullName, required this.role, required this.createdAt, this.email, this.avatarUrl, this.cleaner});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String id;
@override final  String phone;
@override final  String fullName;
@override final  UserRole role;
@override final  DateTime createdAt;
@override final  String? email;
@override final  String? avatarUrl;
/// The cleaner profile. Sent by `GET /me` for cleaners and in the admin
/// cleaner list; absent for clients and admins and in `/auth/verify`.
@override final  Cleaner? cleaner;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.cleaner, cleaner) || other.cleaner == cleaner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,phone,fullName,role,createdAt,email,avatarUrl,cleaner);
}

@override
String toString() {
    return 'User(id: $id, phone: $phone, fullName: $fullName, role: $role, createdAt: $createdAt, email: $email, avatarUrl: $avatarUrl, cleaner: $cleaner)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String phone, String fullName, UserRole role, DateTime createdAt, String? email, String? avatarUrl, Cleaner? cleaner
});


@override $CleanerCopyWith<$Res>? get cleaner;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? phone = null,Object? fullName = null,Object? role = null,Object? createdAt = null,Object? email = freezed,Object? avatarUrl = freezed,Object? cleaner = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,cleaner: freezed == cleaner ? _self.cleaner : cleaner // ignore: cast_nullable_to_non_nullable
as Cleaner?,
  ));
}

/// Create a copy of User
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
}
}


/// @nodoc
mixin _$Cleaner {

/// Same as the id of the [User] it belongs to.
 String get userId; CleanerStatus get status; String get bio; double get rating; int get ratingCount; bool get isOnline; double? get lastLat; double? get lastLng; DateTime? get lastSeenAt;
/// Create a copy of Cleaner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CleanerCopyWith<Cleaner> get copyWith => _$CleanerCopyWithImpl<Cleaner>(this as Cleaner, _$identity);

  /// Serializes this Cleaner to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Cleaner;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cleaner&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.ratingCount, _this.ratingCount) || other.ratingCount == _this.ratingCount)&&(identical(other.isOnline, _this.isOnline) || other.isOnline == _this.isOnline)&&(identical(other.lastLat, _this.lastLat) || other.lastLat == _this.lastLat)&&(identical(other.lastLng, _this.lastLng) || other.lastLng == _this.lastLng)&&(identical(other.lastSeenAt, _this.lastSeenAt) || other.lastSeenAt == _this.lastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Cleaner;
  return Object.hash(runtimeType,_this.userId,_this.status,_this.bio,_this.rating,_this.ratingCount,_this.isOnline,_this.lastLat,_this.lastLng,_this.lastSeenAt);
}

@override
String toString() {
  final _this = this as Cleaner;
  return 'Cleaner(userId: ${_this.userId}, status: ${_this.status}, bio: ${_this.bio}, rating: ${_this.rating}, ratingCount: ${_this.ratingCount}, isOnline: ${_this.isOnline}, lastLat: ${_this.lastLat}, lastLng: ${_this.lastLng}, lastSeenAt: ${_this.lastSeenAt})';
}


}

/// @nodoc
abstract mixin class $CleanerCopyWith<$Res>  {
  factory $CleanerCopyWith(Cleaner value, $Res Function(Cleaner) _then) = _$CleanerCopyWithImpl;
@useResult
$Res call({
 String userId, CleanerStatus status, String bio, double rating, int ratingCount, bool isOnline, double? lastLat, double? lastLng, DateTime? lastSeenAt
});




}
/// @nodoc
class _$CleanerCopyWithImpl<$Res>
    implements $CleanerCopyWith<$Res> {
  _$CleanerCopyWithImpl(this._self, this._then);

  final Cleaner _self;
  final $Res Function(Cleaner) _then;

/// Create a copy of Cleaner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? status = null,Object? bio = null,Object? rating = null,Object? ratingCount = null,Object? isOnline = null,Object? lastLat = freezed,Object? lastLng = freezed,Object? lastSeenAt = freezed,}) {
  return _then(Cleaner(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CleanerStatus,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,lastLat: freezed == lastLat ? _self.lastLat : lastLat // ignore: cast_nullable_to_non_nullable
as double?,lastLng: freezed == lastLng ? _self.lastLng : lastLng // ignore: cast_nullable_to_non_nullable
as double?,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Cleaner].
extension CleanerPatterns on Cleaner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cleaner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cleaner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cleaner value)  $default,){
final _that = this;
switch (_that) {
case _Cleaner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cleaner value)?  $default,){
final _that = this;
switch (_that) {
case _Cleaner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  CleanerStatus status,  String bio,  double rating,  int ratingCount,  bool isOnline,  double? lastLat,  double? lastLng,  DateTime? lastSeenAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cleaner() when $default != null:
return $default(_that.userId,_that.status,_that.bio,_that.rating,_that.ratingCount,_that.isOnline,_that.lastLat,_that.lastLng,_that.lastSeenAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  CleanerStatus status,  String bio,  double rating,  int ratingCount,  bool isOnline,  double? lastLat,  double? lastLng,  DateTime? lastSeenAt)  $default,) {final _that = this;
switch (_that) {
case _Cleaner():
return $default(_that.userId,_that.status,_that.bio,_that.rating,_that.ratingCount,_that.isOnline,_that.lastLat,_that.lastLng,_that.lastSeenAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  CleanerStatus status,  String bio,  double rating,  int ratingCount,  bool isOnline,  double? lastLat,  double? lastLng,  DateTime? lastSeenAt)?  $default,) {final _that = this;
switch (_that) {
case _Cleaner() when $default != null:
return $default(_that.userId,_that.status,_that.bio,_that.rating,_that.ratingCount,_that.isOnline,_that.lastLat,_that.lastLng,_that.lastSeenAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cleaner implements Cleaner {
  const _Cleaner({required this.userId, required this.status, required this.bio, required this.rating, required this.ratingCount, required this.isOnline, this.lastLat, this.lastLng, this.lastSeenAt});
  factory _Cleaner.fromJson(Map<String, dynamic> json) => _$CleanerFromJson(json);

/// Same as the id of the [User] it belongs to.
@override final  String userId;
@override final  CleanerStatus status;
@override final  String bio;
@override final  double rating;
@override final  int ratingCount;
@override final  bool isOnline;
@override final  double? lastLat;
@override final  double? lastLng;
@override final  DateTime? lastSeenAt;

/// Create a copy of Cleaner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CleanerCopyWith<_Cleaner> get copyWith => __$CleanerCopyWithImpl<_Cleaner>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CleanerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cleaner&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.lastLat, lastLat) || other.lastLat == lastLat)&&(identical(other.lastLng, lastLng) || other.lastLng == lastLng)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,status,bio,rating,ratingCount,isOnline,lastLat,lastLng,lastSeenAt);
}

@override
String toString() {
    return 'Cleaner(userId: $userId, status: $status, bio: $bio, rating: $rating, ratingCount: $ratingCount, isOnline: $isOnline, lastLat: $lastLat, lastLng: $lastLng, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class _$CleanerCopyWith<$Res> implements $CleanerCopyWith<$Res> {
  factory _$CleanerCopyWith(_Cleaner value, $Res Function(_Cleaner) _then) = __$CleanerCopyWithImpl;
@override @useResult
$Res call({
 String userId, CleanerStatus status, String bio, double rating, int ratingCount, bool isOnline, double? lastLat, double? lastLng, DateTime? lastSeenAt
});




}
/// @nodoc
class __$CleanerCopyWithImpl<$Res>
    implements _$CleanerCopyWith<$Res> {
  __$CleanerCopyWithImpl(this._self, this._then);

  final _Cleaner _self;
  final $Res Function(_Cleaner) _then;

/// Create a copy of Cleaner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? status = null,Object? bio = null,Object? rating = null,Object? ratingCount = null,Object? isOnline = null,Object? lastLat = freezed,Object? lastLng = freezed,Object? lastSeenAt = freezed,}) {
  return _then(_Cleaner(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CleanerStatus,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,lastLat: freezed == lastLat ? _self.lastLat : lastLat // ignore: cast_nullable_to_non_nullable
as double?,lastLng: freezed == lastLng ? _self.lastLng : lastLng // ignore: cast_nullable_to_non_nullable
as double?,lastSeenAt: freezed == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
