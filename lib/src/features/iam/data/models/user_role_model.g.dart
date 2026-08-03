// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRoleModel _$UserRoleModelFromJson(Map<String, dynamic> json) =>
    _UserRoleModel(
      id: json['id'] as String,
      userAccountId: json['userAccountId'] as String,
      roleId: json['roleId'] as String,
      roleCode: json['roleCode'] as String,
      scopeOrganizationId: json['scopeOrganizationId'] as String?,
      scopePathshalaId: json['scopePathshalaId'] as String?,
      effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
      effectiveTo: json['effectiveTo'] == null
          ? null
          : DateTime.parse(json['effectiveTo'] as String),
      grantedByUserId: json['grantedByUserId'] as String?,
      status: $enumDecode(_$UserRoleStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$UserRoleModelToJson(_UserRoleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userAccountId': instance.userAccountId,
      'roleId': instance.roleId,
      'roleCode': instance.roleCode,
      'scopeOrganizationId': instance.scopeOrganizationId,
      'scopePathshalaId': instance.scopePathshalaId,
      'effectiveFrom': instance.effectiveFrom.toIso8601String(),
      'effectiveTo': instance.effectiveTo?.toIso8601String(),
      'grantedByUserId': instance.grantedByUserId,
      'status': _$UserRoleStatusEnumMap[instance.status]!,
    };

const _$UserRoleStatusEnumMap = {
  UserRoleStatus.active: 'active',
  UserRoleStatus.revoked: 'revoked',
  UserRoleStatus.expired: 'expired',
};
