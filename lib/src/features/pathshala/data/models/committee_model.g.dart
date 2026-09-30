// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'committee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommitteeModel _$CommitteeModelFromJson(Map<String, dynamic> json) =>
    _CommitteeModel(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      pathshalaId: json['pathshalaId'] as String?,
      name: json['name'] as String,
      type: $enumDecode(_$CommitteeTypeEnumMap, json['type']),
      status: $enumDecode(_$CommitteeStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$CommitteeModelToJson(_CommitteeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'pathshalaId': instance.pathshalaId,
      'name': instance.name,
      'type': _$CommitteeTypeEnumMap[instance.type]!,
      'status': _$CommitteeStatusEnumMap[instance.status]!,
    };

const _$CommitteeTypeEnumMap = {
  CommitteeType.central: 'central',
  CommitteeType.pathshala: 'pathshala',
  CommitteeType.advisory: 'advisory',
  CommitteeType.other: 'other',
};

const _$CommitteeStatusEnumMap = {
  CommitteeStatus.active: 'active',
  CommitteeStatus.inactive: 'inactive',
  CommitteeStatus.archived: 'archived',
};

_CommitteeMembershipModel _$CommitteeMembershipModelFromJson(
  Map<String, dynamic> json,
) => _CommitteeMembershipModel(
  id: json['id'] as String,
  committeeId: json['committeeId'] as String,
  personId: json['personId'] as String,
  title: json['title'] as String,
  effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
  effectiveTo: json['effectiveTo'] == null
      ? null
      : DateTime.parse(json['effectiveTo'] as String),
  status: $enumDecode(_$CommitteeMembershipStatusEnumMap, json['status']),
);

Map<String, dynamic> _$CommitteeMembershipModelToJson(
  _CommitteeMembershipModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'committeeId': instance.committeeId,
  'personId': instance.personId,
  'title': instance.title,
  'effectiveFrom': instance.effectiveFrom.toIso8601String(),
  'effectiveTo': instance.effectiveTo?.toIso8601String(),
  'status': _$CommitteeMembershipStatusEnumMap[instance.status]!,
};

const _$CommitteeMembershipStatusEnumMap = {
  CommitteeMembershipStatus.active: 'active',
  CommitteeMembershipStatus.ended: 'ended',
};
