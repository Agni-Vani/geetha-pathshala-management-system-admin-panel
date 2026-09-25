// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonModel _$PersonModelFromJson(Map<String, dynamic> json) => _PersonModel(
  id: json['id'] as String,
  organizationId: json['organizationId'] as String,
  legalName: json['legalName'] as String,
  preferredName: json['preferredName'] as String?,
  dateOfBirth: json['dateOfBirth'] == null
      ? null
      : DateTime.parse(json['dateOfBirth'] as String),
  gender: json['gender'] as String?,
  primaryPhone: json['primaryPhone'] as String?,
  primaryEmail: json['primaryEmail'] as String?,
  status: $enumDecode(_$PersonStatusEnumMap, json['status']),
  createdByUserId: json['createdByUserId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PersonModelToJson(_PersonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'legalName': instance.legalName,
      'preferredName': instance.preferredName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'primaryPhone': instance.primaryPhone,
      'primaryEmail': instance.primaryEmail,
      'status': _$PersonStatusEnumMap[instance.status]!,
      'createdByUserId': instance.createdByUserId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PersonStatusEnumMap = {
  PersonStatus.active: 'active',
  PersonStatus.inactive: 'inactive',
  PersonStatus.merged: 'merged',
  PersonStatus.deceased: 'deceased',
  PersonStatus.archived: 'archived',
};

_PersonContactModel _$PersonContactModelFromJson(Map<String, dynamic> json) =>
    _PersonContactModel(
      id: json['id'] as String,
      personId: json['personId'] as String,
      type: $enumDecode(_$ContactTypeEnumMap, json['type']),
      label: json['label'] as String,
      value: json['value'] as String,
      isPrimary: json['isPrimary'] as bool,
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
    );

Map<String, dynamic> _$PersonContactModelToJson(_PersonContactModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personId': instance.personId,
      'type': _$ContactTypeEnumMap[instance.type]!,
      'label': instance.label,
      'value': instance.value,
      'isPrimary': instance.isPrimary,
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
    };

const _$ContactTypeEnumMap = {
  ContactType.phone: 'phone',
  ContactType.email: 'email',
  ContactType.address: 'address',
  ContactType.emergency: 'emergency',
  ContactType.other: 'other',
};

_PersonRelationshipModel _$PersonRelationshipModelFromJson(
  Map<String, dynamic> json,
) => _PersonRelationshipModel(
  id: json['id'] as String,
  personId: json['personId'] as String,
  relatedPersonId: json['relatedPersonId'] as String,
  type: $enumDecode(_$PersonRelationshipTypeEnumMap, json['type']),
  isPrimaryGuardian: json['isPrimaryGuardian'] as bool,
  effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
  effectiveTo: json['effectiveTo'] == null
      ? null
      : DateTime.parse(json['effectiveTo'] as String),
);

Map<String, dynamic> _$PersonRelationshipModelToJson(
  _PersonRelationshipModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'personId': instance.personId,
  'relatedPersonId': instance.relatedPersonId,
  'type': _$PersonRelationshipTypeEnumMap[instance.type]!,
  'isPrimaryGuardian': instance.isPrimaryGuardian,
  'effectiveFrom': instance.effectiveFrom.toIso8601String(),
  'effectiveTo': instance.effectiveTo?.toIso8601String(),
};

const _$PersonRelationshipTypeEnumMap = {
  PersonRelationshipType.parent: 'parent',
  PersonRelationshipType.guardian: 'guardian',
  PersonRelationshipType.sibling: 'sibling',
  PersonRelationshipType.spouse: 'spouse',
  PersonRelationshipType.other: 'other',
};
