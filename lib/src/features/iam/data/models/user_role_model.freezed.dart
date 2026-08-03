// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_role_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRoleModel {

 String get id; String get userAccountId; String get roleId; String get roleCode; String? get scopeOrganizationId; String? get scopePathshalaId; DateTime get effectiveFrom; DateTime? get effectiveTo; String? get grantedByUserId; UserRoleStatus get status;
/// Create a copy of UserRoleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRoleModelCopyWith<UserRoleModel> get copyWith => _$UserRoleModelCopyWithImpl<UserRoleModel>(this as UserRoleModel, _$identity);

  /// Serializes this UserRoleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRoleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userAccountId, userAccountId) || other.userAccountId == userAccountId)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.roleCode, roleCode) || other.roleCode == roleCode)&&(identical(other.scopeOrganizationId, scopeOrganizationId) || other.scopeOrganizationId == scopeOrganizationId)&&(identical(other.scopePathshalaId, scopePathshalaId) || other.scopePathshalaId == scopePathshalaId)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.grantedByUserId, grantedByUserId) || other.grantedByUserId == grantedByUserId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userAccountId,roleId,roleCode,scopeOrganizationId,scopePathshalaId,effectiveFrom,effectiveTo,grantedByUserId,status);

@override
String toString() {
  return 'UserRoleModel(id: $id, userAccountId: $userAccountId, roleId: $roleId, roleCode: $roleCode, scopeOrganizationId: $scopeOrganizationId, scopePathshalaId: $scopePathshalaId, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, grantedByUserId: $grantedByUserId, status: $status)';
}


}

/// @nodoc
abstract mixin class $UserRoleModelCopyWith<$Res>  {
  factory $UserRoleModelCopyWith(UserRoleModel value, $Res Function(UserRoleModel) _then) = _$UserRoleModelCopyWithImpl;
@useResult
$Res call({
 String id, String userAccountId, String roleId, String roleCode, String? scopeOrganizationId, String? scopePathshalaId, DateTime effectiveFrom, DateTime? effectiveTo, String? grantedByUserId, UserRoleStatus status
});




}
/// @nodoc
class _$UserRoleModelCopyWithImpl<$Res>
    implements $UserRoleModelCopyWith<$Res> {
  _$UserRoleModelCopyWithImpl(this._self, this._then);

  final UserRoleModel _self;
  final $Res Function(UserRoleModel) _then;

/// Create a copy of UserRoleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userAccountId = null,Object? roleId = null,Object? roleCode = null,Object? scopeOrganizationId = freezed,Object? scopePathshalaId = freezed,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? grantedByUserId = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userAccountId: null == userAccountId ? _self.userAccountId : userAccountId // ignore: cast_nullable_to_non_nullable
as String,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String,roleCode: null == roleCode ? _self.roleCode : roleCode // ignore: cast_nullable_to_non_nullable
as String,scopeOrganizationId: freezed == scopeOrganizationId ? _self.scopeOrganizationId : scopeOrganizationId // ignore: cast_nullable_to_non_nullable
as String?,scopePathshalaId: freezed == scopePathshalaId ? _self.scopePathshalaId : scopePathshalaId // ignore: cast_nullable_to_non_nullable
as String?,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,grantedByUserId: freezed == grantedByUserId ? _self.grantedByUserId : grantedByUserId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserRoleStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [UserRoleModel].
extension UserRoleModelPatterns on UserRoleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRoleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRoleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRoleModel value)  $default,){
final _that = this;
switch (_that) {
case _UserRoleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRoleModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserRoleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userAccountId,  String roleId,  String roleCode,  String? scopeOrganizationId,  String? scopePathshalaId,  DateTime effectiveFrom,  DateTime? effectiveTo,  String? grantedByUserId,  UserRoleStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRoleModel() when $default != null:
return $default(_that.id,_that.userAccountId,_that.roleId,_that.roleCode,_that.scopeOrganizationId,_that.scopePathshalaId,_that.effectiveFrom,_that.effectiveTo,_that.grantedByUserId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userAccountId,  String roleId,  String roleCode,  String? scopeOrganizationId,  String? scopePathshalaId,  DateTime effectiveFrom,  DateTime? effectiveTo,  String? grantedByUserId,  UserRoleStatus status)  $default,) {final _that = this;
switch (_that) {
case _UserRoleModel():
return $default(_that.id,_that.userAccountId,_that.roleId,_that.roleCode,_that.scopeOrganizationId,_that.scopePathshalaId,_that.effectiveFrom,_that.effectiveTo,_that.grantedByUserId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userAccountId,  String roleId,  String roleCode,  String? scopeOrganizationId,  String? scopePathshalaId,  DateTime effectiveFrom,  DateTime? effectiveTo,  String? grantedByUserId,  UserRoleStatus status)?  $default,) {final _that = this;
switch (_that) {
case _UserRoleModel() when $default != null:
return $default(_that.id,_that.userAccountId,_that.roleId,_that.roleCode,_that.scopeOrganizationId,_that.scopePathshalaId,_that.effectiveFrom,_that.effectiveTo,_that.grantedByUserId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserRoleModel extends UserRoleModel {
  const _UserRoleModel({required this.id, required this.userAccountId, required this.roleId, required this.roleCode, required this.scopeOrganizationId, required this.scopePathshalaId, required this.effectiveFrom, required this.effectiveTo, required this.grantedByUserId, required this.status}): super._();
  factory _UserRoleModel.fromJson(Map<String, dynamic> json) => _$UserRoleModelFromJson(json);

@override final  String id;
@override final  String userAccountId;
@override final  String roleId;
@override final  String roleCode;
@override final  String? scopeOrganizationId;
@override final  String? scopePathshalaId;
@override final  DateTime effectiveFrom;
@override final  DateTime? effectiveTo;
@override final  String? grantedByUserId;
@override final  UserRoleStatus status;

/// Create a copy of UserRoleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRoleModelCopyWith<_UserRoleModel> get copyWith => __$UserRoleModelCopyWithImpl<_UserRoleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRoleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRoleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userAccountId, userAccountId) || other.userAccountId == userAccountId)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.roleCode, roleCode) || other.roleCode == roleCode)&&(identical(other.scopeOrganizationId, scopeOrganizationId) || other.scopeOrganizationId == scopeOrganizationId)&&(identical(other.scopePathshalaId, scopePathshalaId) || other.scopePathshalaId == scopePathshalaId)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.grantedByUserId, grantedByUserId) || other.grantedByUserId == grantedByUserId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userAccountId,roleId,roleCode,scopeOrganizationId,scopePathshalaId,effectiveFrom,effectiveTo,grantedByUserId,status);

@override
String toString() {
  return 'UserRoleModel(id: $id, userAccountId: $userAccountId, roleId: $roleId, roleCode: $roleCode, scopeOrganizationId: $scopeOrganizationId, scopePathshalaId: $scopePathshalaId, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, grantedByUserId: $grantedByUserId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UserRoleModelCopyWith<$Res> implements $UserRoleModelCopyWith<$Res> {
  factory _$UserRoleModelCopyWith(_UserRoleModel value, $Res Function(_UserRoleModel) _then) = __$UserRoleModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userAccountId, String roleId, String roleCode, String? scopeOrganizationId, String? scopePathshalaId, DateTime effectiveFrom, DateTime? effectiveTo, String? grantedByUserId, UserRoleStatus status
});




}
/// @nodoc
class __$UserRoleModelCopyWithImpl<$Res>
    implements _$UserRoleModelCopyWith<$Res> {
  __$UserRoleModelCopyWithImpl(this._self, this._then);

  final _UserRoleModel _self;
  final $Res Function(_UserRoleModel) _then;

/// Create a copy of UserRoleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userAccountId = null,Object? roleId = null,Object? roleCode = null,Object? scopeOrganizationId = freezed,Object? scopePathshalaId = freezed,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? grantedByUserId = freezed,Object? status = null,}) {
  return _then(_UserRoleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userAccountId: null == userAccountId ? _self.userAccountId : userAccountId // ignore: cast_nullable_to_non_nullable
as String,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String,roleCode: null == roleCode ? _self.roleCode : roleCode // ignore: cast_nullable_to_non_nullable
as String,scopeOrganizationId: freezed == scopeOrganizationId ? _self.scopeOrganizationId : scopeOrganizationId // ignore: cast_nullable_to_non_nullable
as String?,scopePathshalaId: freezed == scopePathshalaId ? _self.scopePathshalaId : scopePathshalaId // ignore: cast_nullable_to_non_nullable
as String?,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,grantedByUserId: freezed == grantedByUserId ? _self.grantedByUserId : grantedByUserId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserRoleStatus,
  ));
}


}

// dart format on
