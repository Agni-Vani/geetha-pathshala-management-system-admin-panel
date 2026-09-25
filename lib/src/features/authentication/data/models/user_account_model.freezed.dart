// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_account_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserAccountModel {

 String get id; String get personId; String? get authUserId; String get email; AccountStatus get status; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of UserAccountModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAccountModelCopyWith<UserAccountModel> get copyWith => _$UserAccountModelCopyWithImpl<UserAccountModel>(this as UserAccountModel, _$identity);

  /// Serializes this UserAccountModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.authUserId, authUserId) || other.authUserId == authUserId)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,personId,authUserId,email,status,createdAt,updatedAt);

@override
String toString() {
  return 'UserAccountModel(id: $id, personId: $personId, authUserId: $authUserId, email: $email, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserAccountModelCopyWith<$Res>  {
  factory $UserAccountModelCopyWith(UserAccountModel value, $Res Function(UserAccountModel) _then) = _$UserAccountModelCopyWithImpl;
@useResult
$Res call({
 String id, String personId, String? authUserId, String email, AccountStatus status, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$UserAccountModelCopyWithImpl<$Res>
    implements $UserAccountModelCopyWith<$Res> {
  _$UserAccountModelCopyWithImpl(this._self, this._then);

  final UserAccountModel _self;
  final $Res Function(UserAccountModel) _then;

/// Create a copy of UserAccountModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? personId = null,Object? authUserId = freezed,Object? email = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,authUserId: freezed == authUserId ? _self.authUserId : authUserId // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserAccountModel].
extension UserAccountModelPatterns on UserAccountModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserAccountModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserAccountModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserAccountModel value)  $default,){
final _that = this;
switch (_that) {
case _UserAccountModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserAccountModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserAccountModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String personId,  String? authUserId,  String email,  AccountStatus status,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserAccountModel() when $default != null:
return $default(_that.id,_that.personId,_that.authUserId,_that.email,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String personId,  String? authUserId,  String email,  AccountStatus status,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserAccountModel():
return $default(_that.id,_that.personId,_that.authUserId,_that.email,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String personId,  String? authUserId,  String email,  AccountStatus status,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserAccountModel() when $default != null:
return $default(_that.id,_that.personId,_that.authUserId,_that.email,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserAccountModel extends UserAccountModel {
  const _UserAccountModel({required this.id, required this.personId, required this.authUserId, required this.email, required this.status, required this.createdAt, required this.updatedAt}): super._();
  factory _UserAccountModel.fromJson(Map<String, dynamic> json) => _$UserAccountModelFromJson(json);

@override final  String id;
@override final  String personId;
@override final  String? authUserId;
@override final  String email;
@override final  AccountStatus status;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of UserAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserAccountModelCopyWith<_UserAccountModel> get copyWith => __$UserAccountModelCopyWithImpl<_UserAccountModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserAccountModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserAccountModel&&(identical(other.id, id) || other.id == id)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.authUserId, authUserId) || other.authUserId == authUserId)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,personId,authUserId,email,status,createdAt,updatedAt);

@override
String toString() {
  return 'UserAccountModel(id: $id, personId: $personId, authUserId: $authUserId, email: $email, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserAccountModelCopyWith<$Res> implements $UserAccountModelCopyWith<$Res> {
  factory _$UserAccountModelCopyWith(_UserAccountModel value, $Res Function(_UserAccountModel) _then) = __$UserAccountModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String personId, String? authUserId, String email, AccountStatus status, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$UserAccountModelCopyWithImpl<$Res>
    implements _$UserAccountModelCopyWith<$Res> {
  __$UserAccountModelCopyWithImpl(this._self, this._then);

  final _UserAccountModel _self;
  final $Res Function(_UserAccountModel) _then;

/// Create a copy of UserAccountModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? personId = null,Object? authUserId = freezed,Object? email = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_UserAccountModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,authUserId: freezed == authUserId ? _self.authUserId : authUserId // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
