// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DistrictModel _$DistrictModelFromJson(Map<String, dynamic> json) =>
    _DistrictModel(
      id: json['id'] as String,
      name: json['name'] as String,
      division: json['division'] as String,
      status: json['status'] as String? ?? 'active',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DistrictModelToJson(_DistrictModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'division': instance.division,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
