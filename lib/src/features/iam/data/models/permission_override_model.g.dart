// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_override_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PermissionOverrideModel _$PermissionOverrideModelFromJson(
  Map<String, dynamic> json,
) => _PermissionOverrideModel(
  id: json['id'] as String,
  userAccountId: json['userAccountId'] as String,
  permissionId: json['permissionId'] as String,
  permissionCode: json['permissionCode'] as String,
  isGranted: json['isGranted'] as bool,
  scopeOrganizationId: json['scopeOrganizationId'] as String?,
  scopePathshalaId: json['scopePathshalaId'] as String?,
  effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
  effectiveTo: json['effectiveTo'] == null
      ? null
      : DateTime.parse(json['effectiveTo'] as String),
  reason: json['reason'] as String,
);

Map<String, dynamic> _$PermissionOverrideModelToJson(
  _PermissionOverrideModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userAccountId': instance.userAccountId,
  'permissionId': instance.permissionId,
  'permissionCode': instance.permissionCode,
  'isGranted': instance.isGranted,
  'scopeOrganizationId': instance.scopeOrganizationId,
  'scopePathshalaId': instance.scopePathshalaId,
  'effectiveFrom': instance.effectiveFrom.toIso8601String(),
  'effectiveTo': instance.effectiveTo?.toIso8601String(),
  'reason': instance.reason,
};
