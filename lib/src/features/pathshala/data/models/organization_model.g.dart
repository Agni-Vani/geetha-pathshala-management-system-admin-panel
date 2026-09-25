// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrganizationModel _$OrganizationModelFromJson(Map<String, dynamic> json) =>
    _OrganizationModel(
      id: json['id'] as String,
      officialName: json['officialName'] as String,
      displayName: json['displayName'] as String,
      status: $enumDecode(_$OrganizationStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$OrganizationModelToJson(_OrganizationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'officialName': instance.officialName,
      'displayName': instance.displayName,
      'status': _$OrganizationStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$OrganizationStatusEnumMap = {
  OrganizationStatus.active: 'active',
  OrganizationStatus.inactive: 'inactive',
  OrganizationStatus.archived: 'archived',
};
