// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_year_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AcademicYearModel _$AcademicYearModelFromJson(Map<String, dynamic> json) =>
    _AcademicYearModel(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      status: $enumDecode(_$AcademicYearStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AcademicYearModelToJson(_AcademicYearModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'status': _$AcademicYearStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$AcademicYearStatusEnumMap = {
  AcademicYearStatus.upcoming: 'upcoming',
  AcademicYearStatus.active: 'active',
  AcademicYearStatus.completed: 'completed',
  AcademicYearStatus.archived: 'archived',
};
