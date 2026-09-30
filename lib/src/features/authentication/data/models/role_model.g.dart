// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoleModel _$RoleModelFromJson(Map<String, dynamic> json) => _RoleModel(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  scopeType: $enumDecode(_$RoleScopeTypeEnumMap, json['scopeType']),
  description: json['description'] as String?,
  permissionCodes: (json['permissionCodes'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$RoleModelToJson(_RoleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'scopeType': _$RoleScopeTypeEnumMap[instance.scopeType]!,
      'description': instance.description,
      'permissionCodes': instance.permissionCodes,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$RoleScopeTypeEnumMap = {
  RoleScopeType.global: 'global',
  RoleScopeType.organization: 'organization',
  RoleScopeType.pathshala: 'pathshala',
};
