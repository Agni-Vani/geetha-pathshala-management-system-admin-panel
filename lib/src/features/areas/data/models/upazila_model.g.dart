// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upazila_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpazilaModel _$UpazilaModelFromJson(Map<String, dynamic> json) =>
    _UpazilaModel(
      id: json['id'] as String,
      districtId: json['district_id'] as String,
      name: json['name'] as String,
      status: json['status'] as String? ?? 'active',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UpazilaModelToJson(_UpazilaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'district_id': instance.districtId,
      'name': instance.name,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
