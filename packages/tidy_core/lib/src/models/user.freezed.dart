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

 String get id; UserRole get role; String get phone; String get fullName; String? get email; String? get avatarUrl;/// Present for cleaners on `GET /me`.
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.cleaner, _this.cleaner) || other.cleaner == _this.cleaner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as User;
  return Object.hash(runtimeType,_this.id,_this.role,_this.phone,_this.fullName,_this.email,_this.avatarUrl,_this.cleaner);
}

@override
String toString() {
  final _this = this as User;
  return 'User(id: ${_this.id}, role: ${_this.role}, phone: ${_this.phone}, fullName: ${_this.fullName}, email: ${_this.email}, avatarUrl: ${_this.avatarUrl}, cleaner: ${_this.cleaner})';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, UserRole role, String phone, String fullName, String? email, String? avatarUrl, Cleaner? cleaner
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? phone = null,Object? fullName = null,Object? email = freezed,Object? avatarUrl = freezed,Object? cleaner = freezed,}) {
  return _then(User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  UserRole role,  String phone,  String fullName,  String? email,  String? avatarUrl,  Cleaner? cleaner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.role,_that.phone,_that.fullName,_that.email,_that.avatarUrl,_that.cleaner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  UserRole role,  String phone,  String fullName,  String? email,  String? avatarUrl,  Cleaner? cleaner)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.role,_that.phone,_that.fullName,_that.email,_that.avatarUrl,_that.cleaner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  UserRole role,  String phone,  String fullName,  String? email,  String? avatarUrl,  Cleaner? cleaner)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.role,_that.phone,_that.fullName,_that.email,_that.avatarUrl,_that.cleaner);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.id, required this.role, this.phone = '', this.fullName = '', this.email, this.avatarUrl, this.cleaner});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String id;
@override final  UserRole role;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String fullName;
@override final  String? email;
@override final  String? avatarUrl;
/// Present for cleaners on `GET /me`.
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.cleaner, cleaner) || other.cleaner == cleaner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,role,phone,fullName,email,avatarUrl,cleaner);
}

@override
String toString() {
    return 'User(id: $id, role: $role, phone: $phone, fullName: $fullName, email: $email, avatarUrl: $avatarUrl, cleaner: $cleaner)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, UserRole role, String phone, String fullName, String? email, String? avatarUrl, Cleaner? cleaner
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? phone = null,Object? fullName = null,Object? email = freezed,Object? avatarUrl = freezed,Object? cleaner = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
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

 String get id; String get fullName; String? get phone; String? get avatarUrl; CleanerStatus get status; String get bio; double get rating; int get ratingCount; bool get online;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cleaner&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.ratingCount, _this.ratingCount) || other.ratingCount == _this.ratingCount)&&(identical(other.online, _this.online) || other.online == _this.online));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Cleaner;
  return Object.hash(runtimeType,_this.id,_this.fullName,_this.phone,_this.avatarUrl,_this.status,_this.bio,_this.rating,_this.ratingCount,_this.online);
}

@override
String toString() {
  final _this = this as Cleaner;
  return 'Cleaner(id: ${_this.id}, fullName: ${_this.fullName}, phone: ${_this.phone}, avatarUrl: ${_this.avatarUrl}, status: ${_this.status}, bio: ${_this.bio}, rating: ${_this.rating}, ratingCount: ${_this.ratingCount}, online: ${_this.online})';
}


}

/// @nodoc
abstract mixin class $CleanerCopyWith<$Res>  {
  factory $CleanerCopyWith(Cleaner value, $Res Function(Cleaner) _then) = _$CleanerCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? phone, String? avatarUrl, CleanerStatus status, String bio, double rating, int ratingCount, bool online
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? phone = freezed,Object? avatarUrl = freezed,Object? status = null,Object? bio = null,Object? rating = null,Object? ratingCount = null,Object? online = null,}) {
  return _then(Cleaner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CleanerStatus,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String? phone,  String? avatarUrl,  CleanerStatus status,  String bio,  double rating,  int ratingCount,  bool online)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cleaner() when $default != null:
return $default(_that.id,_that.fullName,_that.phone,_that.avatarUrl,_that.status,_that.bio,_that.rating,_that.ratingCount,_that.online);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String? phone,  String? avatarUrl,  CleanerStatus status,  String bio,  double rating,  int ratingCount,  bool online)  $default,) {final _that = this;
switch (_that) {
case _Cleaner():
return $default(_that.id,_that.fullName,_that.phone,_that.avatarUrl,_that.status,_that.bio,_that.rating,_that.ratingCount,_that.online);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String? phone,  String? avatarUrl,  CleanerStatus status,  String bio,  double rating,  int ratingCount,  bool online)?  $default,) {final _that = this;
switch (_that) {
case _Cleaner() when $default != null:
return $default(_that.id,_that.fullName,_that.phone,_that.avatarUrl,_that.status,_that.bio,_that.rating,_that.ratingCount,_that.online);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cleaner implements Cleaner {
  const _Cleaner({required this.id, this.fullName = '', this.phone, this.avatarUrl, this.status = CleanerStatus.approved, this.bio = '', this.rating = 0.0, this.ratingCount = 0, this.online = false});
  factory _Cleaner.fromJson(Map<String, dynamic> json) => _$CleanerFromJson(json);

@override final  String id;
@override@JsonKey() final  String fullName;
@override final  String? phone;
@override final  String? avatarUrl;
@override@JsonKey() final  CleanerStatus status;
@override@JsonKey() final  String bio;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int ratingCount;
@override@JsonKey() final  bool online;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cleaner&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.online, online) || other.online == online));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,phone,avatarUrl,status,bio,rating,ratingCount,online);
}

@override
String toString() {
    return 'Cleaner(id: $id, fullName: $fullName, phone: $phone, avatarUrl: $avatarUrl, status: $status, bio: $bio, rating: $rating, ratingCount: $ratingCount, online: $online)';
}


}

/// @nodoc
abstract mixin class _$CleanerCopyWith<$Res> implements $CleanerCopyWith<$Res> {
  factory _$CleanerCopyWith(_Cleaner value, $Res Function(_Cleaner) _then) = __$CleanerCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? phone, String? avatarUrl, CleanerStatus status, String bio, double rating, int ratingCount, bool online
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? phone = freezed,Object? avatarUrl = freezed,Object? status = null,Object? bio = null,Object? rating = null,Object? ratingCount = null,Object? online = null,}) {
  return _then(_Cleaner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CleanerStatus,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ClientSummary {

 String get id; String get fullName; String? get phone; String? get avatarUrl;
/// Create a copy of ClientSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientSummaryCopyWith<ClientSummary> get copyWith => _$ClientSummaryCopyWithImpl<ClientSummary>(this as ClientSummary, _$identity);

  /// Serializes this ClientSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ClientSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ClientSummary;
  return Object.hash(runtimeType,_this.id,_this.fullName,_this.phone,_this.avatarUrl);
}

@override
String toString() {
  final _this = this as ClientSummary;
  return 'ClientSummary(id: ${_this.id}, fullName: ${_this.fullName}, phone: ${_this.phone}, avatarUrl: ${_this.avatarUrl})';
}


}

/// @nodoc
abstract mixin class $ClientSummaryCopyWith<$Res>  {
  factory $ClientSummaryCopyWith(ClientSummary value, $Res Function(ClientSummary) _then) = _$ClientSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? phone, String? avatarUrl
});




}
/// @nodoc
class _$ClientSummaryCopyWithImpl<$Res>
    implements $ClientSummaryCopyWith<$Res> {
  _$ClientSummaryCopyWithImpl(this._self, this._then);

  final ClientSummary _self;
  final $Res Function(ClientSummary) _then;

/// Create a copy of ClientSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? phone = freezed,Object? avatarUrl = freezed,}) {
  return _then(ClientSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientSummary].
extension ClientSummaryPatterns on ClientSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientSummary value)  $default,){
final _that = this;
switch (_that) {
case _ClientSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ClientSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String? phone,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientSummary() when $default != null:
return $default(_that.id,_that.fullName,_that.phone,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String? phone,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _ClientSummary():
return $default(_that.id,_that.fullName,_that.phone,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String? phone,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _ClientSummary() when $default != null:
return $default(_that.id,_that.fullName,_that.phone,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientSummary implements ClientSummary {
  const _ClientSummary({required this.id, this.fullName = '', this.phone, this.avatarUrl});
  factory _ClientSummary.fromJson(Map<String, dynamic> json) => _$ClientSummaryFromJson(json);

@override final  String id;
@override@JsonKey() final  String fullName;
@override final  String? phone;
@override final  String? avatarUrl;

/// Create a copy of ClientSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientSummaryCopyWith<_ClientSummary> get copyWith => __$ClientSummaryCopyWithImpl<_ClientSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,phone,avatarUrl);
}

@override
String toString() {
    return 'ClientSummary(id: $id, fullName: $fullName, phone: $phone, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ClientSummaryCopyWith<$Res> implements $ClientSummaryCopyWith<$Res> {
  factory _$ClientSummaryCopyWith(_ClientSummary value, $Res Function(_ClientSummary) _then) = __$ClientSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? phone, String? avatarUrl
});




}
/// @nodoc
class __$ClientSummaryCopyWithImpl<$Res>
    implements _$ClientSummaryCopyWith<$Res> {
  __$ClientSummaryCopyWithImpl(this._self, this._then);

  final _ClientSummary _self;
  final $Res Function(_ClientSummary) _then;

/// Create a copy of ClientSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? phone = freezed,Object? avatarUrl = freezed,}) {
  return _then(_ClientSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
