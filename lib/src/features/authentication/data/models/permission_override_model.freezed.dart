// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission_override_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PermissionOverrideModel {

 String get id; String get userAccountId; String get permissionId; String get permissionCode; bool get isGranted; String? get scopeOrganizationId; String? get scopePathshalaId; DateTime get effectiveFrom; DateTime? get effectiveTo; String get reason;
/// Create a copy of PermissionOverrideModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionOverrideModelCopyWith<PermissionOverrideModel> get copyWith => _$PermissionOverrideModelCopyWithImpl<PermissionOverrideModel>(this as PermissionOverrideModel, _$identity);

  /// Serializes this PermissionOverrideModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionOverrideModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userAccountId, userAccountId) || other.userAccountId == userAccountId)&&(identical(other.permissionId, permissionId) || other.permissionId == permissionId)&&(identical(other.permissionCode, permissionCode) || other.permissionCode == permissionCode)&&(identical(other.isGranted, isGranted) || other.isGranted == isGranted)&&(identical(other.scopeOrganizationId, scopeOrganizationId) || other.scopeOrganizationId == scopeOrganizationId)&&(identical(other.scopePathshalaId, scopePathshalaId) || other.scopePathshalaId == scopePathshalaId)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userAccountId,permissionId,permissionCode,isGranted,scopeOrganizationId,scopePathshalaId,effectiveFrom,effectiveTo,reason);

@override
String toString() {
  return 'PermissionOverrideModel(id: $id, userAccountId: $userAccountId, permissionId: $permissionId, permissionCode: $permissionCode, isGranted: $isGranted, scopeOrganizationId: $scopeOrganizationId, scopePathshalaId: $scopePathshalaId, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $PermissionOverrideModelCopyWith<$Res>  {
  factory $PermissionOverrideModelCopyWith(PermissionOverrideModel value, $Res Function(PermissionOverrideModel) _then) = _$PermissionOverrideModelCopyWithImpl;
@useResult
$Res call({
 String id, String userAccountId, String permissionId, String permissionCode, bool isGranted, String? scopeOrganizationId, String? scopePathshalaId, DateTime effectiveFrom, DateTime? effectiveTo, String reason
});




}
/// @nodoc
class _$PermissionOverrideModelCopyWithImpl<$Res>
    implements $PermissionOverrideModelCopyWith<$Res> {
  _$PermissionOverrideModelCopyWithImpl(this._self, this._then);

  final PermissionOverrideModel _self;
  final $Res Function(PermissionOverrideModel) _then;

/// Create a copy of PermissionOverrideModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userAccountId = null,Object? permissionId = null,Object? permissionCode = null,Object? isGranted = null,Object? scopeOrganizationId = freezed,Object? scopePathshalaId = freezed,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? reason = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userAccountId: null == userAccountId ? _self.userAccountId : userAccountId // ignore: cast_nullable_to_non_nullable
as String,permissionId: null == permissionId ? _self.permissionId : permissionId // ignore: cast_nullable_to_non_nullable
as String,permissionCode: null == permissionCode ? _self.permissionCode : permissionCode // ignore: cast_nullable_to_non_nullable
as String,isGranted: null == isGranted ? _self.isGranted : isGranted // ignore: cast_nullable_to_non_nullable
as bool,scopeOrganizationId: freezed == scopeOrganizationId ? _self.scopeOrganizationId : scopeOrganizationId // ignore: cast_nullable_to_non_nullable
as String?,scopePathshalaId: freezed == scopePathshalaId ? _self.scopePathshalaId : scopePathshalaId // ignore: cast_nullable_to_non_nullable
as String?,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PermissionOverrideModel].
extension PermissionOverrideModelPatterns on PermissionOverrideModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermissionOverrideModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermissionOverrideModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermissionOverrideModel value)  $default,){
final _that = this;
switch (_that) {
case _PermissionOverrideModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermissionOverrideModel value)?  $default,){
final _that = this;
switch (_that) {
case _PermissionOverrideModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userAccountId,  String permissionId,  String permissionCode,  bool isGranted,  String? scopeOrganizationId,  String? scopePathshalaId,  DateTime effectiveFrom,  DateTime? effectiveTo,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermissionOverrideModel() when $default != null:
return $default(_that.id,_that.userAccountId,_that.permissionId,_that.permissionCode,_that.isGranted,_that.scopeOrganizationId,_that.scopePathshalaId,_that.effectiveFrom,_that.effectiveTo,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userAccountId,  String permissionId,  String permissionCode,  bool isGranted,  String? scopeOrganizationId,  String? scopePathshalaId,  DateTime effectiveFrom,  DateTime? effectiveTo,  String reason)  $default,) {final _that = this;
switch (_that) {
case _PermissionOverrideModel():
return $default(_that.id,_that.userAccountId,_that.permissionId,_that.permissionCode,_that.isGranted,_that.scopeOrganizationId,_that.scopePathshalaId,_that.effectiveFrom,_that.effectiveTo,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userAccountId,  String permissionId,  String permissionCode,  bool isGranted,  String? scopeOrganizationId,  String? scopePathshalaId,  DateTime effectiveFrom,  DateTime? effectiveTo,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _PermissionOverrideModel() when $default != null:
return $default(_that.id,_that.userAccountId,_that.permissionId,_that.permissionCode,_that.isGranted,_that.scopeOrganizationId,_that.scopePathshalaId,_that.effectiveFrom,_that.effectiveTo,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PermissionOverrideModel extends PermissionOverrideModel {
  const _PermissionOverrideModel({required this.id, required this.userAccountId, required this.permissionId, required this.permissionCode, required this.isGranted, required this.scopeOrganizationId, required this.scopePathshalaId, required this.effectiveFrom, required this.effectiveTo, required this.reason}): super._();
  factory _PermissionOverrideModel.fromJson(Map<String, dynamic> json) => _$PermissionOverrideModelFromJson(json);

@override final  String id;
@override final  String userAccountId;
@override final  String permissionId;
@override final  String permissionCode;
@override final  bool isGranted;
@override final  String? scopeOrganizationId;
@override final  String? scopePathshalaId;
@override final  DateTime effectiveFrom;
@override final  DateTime? effectiveTo;
@override final  String reason;

/// Create a copy of PermissionOverrideModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionOverrideModelCopyWith<_PermissionOverrideModel> get copyWith => __$PermissionOverrideModelCopyWithImpl<_PermissionOverrideModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PermissionOverrideModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionOverrideModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userAccountId, userAccountId) || other.userAccountId == userAccountId)&&(identical(other.permissionId, permissionId) || other.permissionId == permissionId)&&(identical(other.permissionCode, permissionCode) || other.permissionCode == permissionCode)&&(identical(other.isGranted, isGranted) || other.isGranted == isGranted)&&(identical(other.scopeOrganizationId, scopeOrganizationId) || other.scopeOrganizationId == scopeOrganizationId)&&(identical(other.scopePathshalaId, scopePathshalaId) || other.scopePathshalaId == scopePathshalaId)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userAccountId,permissionId,permissionCode,isGranted,scopeOrganizationId,scopePathshalaId,effectiveFrom,effectiveTo,reason);

@override
String toString() {
  return 'PermissionOverrideModel(id: $id, userAccountId: $userAccountId, permissionId: $permissionId, permissionCode: $permissionCode, isGranted: $isGranted, scopeOrganizationId: $scopeOrganizationId, scopePathshalaId: $scopePathshalaId, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$PermissionOverrideModelCopyWith<$Res> implements $PermissionOverrideModelCopyWith<$Res> {
  factory _$PermissionOverrideModelCopyWith(_PermissionOverrideModel value, $Res Function(_PermissionOverrideModel) _then) = __$PermissionOverrideModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userAccountId, String permissionId, String permissionCode, bool isGranted, String? scopeOrganizationId, String? scopePathshalaId, DateTime effectiveFrom, DateTime? effectiveTo, String reason
});




}
/// @nodoc
class __$PermissionOverrideModelCopyWithImpl<$Res>
    implements _$PermissionOverrideModelCopyWith<$Res> {
  __$PermissionOverrideModelCopyWithImpl(this._self, this._then);

  final _PermissionOverrideModel _self;
  final $Res Function(_PermissionOverrideModel) _then;

/// Create a copy of PermissionOverrideModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userAccountId = null,Object? permissionId = null,Object? permissionCode = null,Object? isGranted = null,Object? scopeOrganizationId = freezed,Object? scopePathshalaId = freezed,Object? effectiveFrom = null,Object? effectiveTo = freezed,Object? reason = null,}) {
  return _then(_PermissionOverrideModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userAccountId: null == userAccountId ? _self.userAccountId : userAccountId // ignore: cast_nullable_to_non_nullable
as String,permissionId: null == permissionId ? _self.permissionId : permissionId // ignore: cast_nullable_to_non_nullable
as String,permissionCode: null == permissionCode ? _self.permissionCode : permissionCode // ignore: cast_nullable_to_non_nullable
as String,isGranted: null == isGranted ? _self.isGranted : isGranted // ignore: cast_nullable_to_non_nullable
as bool,scopeOrganizationId: freezed == scopeOrganizationId ? _self.scopeOrganizationId : scopeOrganizationId // ignore: cast_nullable_to_non_nullable
as String?,scopePathshalaId: freezed == scopePathshalaId ? _self.scopePathshalaId : scopePathshalaId // ignore: cast_nullable_to_non_nullable
as String?,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
