import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'person_datasource.dart';

final class SupabasePersonDatasource implements PersonDatasource {
  final SupabaseClient client;

  SupabasePersonDatasource([SupabaseClient? client])
      : client = client ?? Supabase.instance.client;

  Future<dynamic> _invoke(String action, [Map<String, dynamic>? payload]) async {
    final response = await client.functions.invoke(
      'registry-api',
      body: {'action': action, ...?payload},
    );
    if (response.status != 200) {
      throw StateError('Edge function error ($action): ${response.data}');
    }
    return response.data;
  }

  Map<String, dynamic> _normalizePerson(Map<String, dynamic> json) {
    return {
      'id': (json['id'] ?? '').toString(),
      'organizationId': (json['organizationId'] ?? json['organization_id'] ?? '00000000-0000-0000-0000-000000000001').toString(),
      'legalName': (json['legalName'] ?? json['legal_name'] ?? '').toString(),
      'preferredName': json['preferredName'] ?? json['preferred_name'],
      'dateOfBirth': json['dateOfBirth'] ?? json['date_of_birth'],
      'gender': json['gender'],
      'primaryPhone': json['primaryPhone'] ?? json['primary_phone'],
      'primaryEmail': json['primaryEmail'] ?? json['primary_email'],
      'status': (json['status'] ?? 'active').toString().toLowerCase(),
      'createdByUserId': json['createdByUserId'] ?? json['created_by_user_id'],
      'createdAt': (json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()).toString(),
      'updatedAt': (json['updatedAt'] ?? json['updated_at'] ?? DateTime.now().toIso8601String()).toString(),
    };
  }

  Map<String, dynamic> _normalizeContact(Map<String, dynamic> json) {
    return {
      'id': (json['id'] ?? '').toString(),
      'personId': (json['personId'] ?? json['person_id'] ?? '').toString(),
      'type': (json['type'] ?? 'other').toString().toLowerCase(),
      'label': (json['label'] ?? '').toString(),
      'value': (json['value'] ?? '').toString(),
      'isPrimary': json['isPrimary'] ?? json['is_primary'] ?? false,
      'verifiedAt': json['verifiedAt'] ?? json['verified_at'],
    };
  }

  Map<String, dynamic> _normalizeRelationship(Map<String, dynamic> json) {
    return {
      'id': (json['id'] ?? '').toString(),
      'personId': (json['personId'] ?? json['person_id'] ?? '').toString(),
      'relatedPersonId': (json['relatedPersonId'] ?? json['related_person_id'] ?? '').toString(),
      'type': (json['type'] ?? 'other').toString().toLowerCase(),
      'isPrimaryGuardian': json['isPrimaryGuardian'] ?? json['is_primary_guardian'] ?? false,
      'effectiveFrom': (json['effectiveFrom'] ?? json['effective_from'] ?? DateTime.now().toIso8601String()).toString(),
      'effectiveTo': json['effectiveTo'] ?? json['effective_to'],
    };
  }

  @override
  Future<List<PersonModel>> searchPeople(SearchPeopleParams params) async {
    final data = await _invoke('searchPeople', {
      'organizationId': params.organizationId,
      'query': params.query,
      'dateOfBirth': params.dateOfBirth?.toIso8601String(),
      'phone': params.phone,
      'email': params.email,
    });
    final list = (data is Map && data['data'] is List)
        ? data['data'] as List
        : (data is List ? data : <dynamic>[]);
    return list
        .map((json) => PersonModel.fromJson(_normalizePerson(json as Map<String, dynamic>)))
        .toList();
  }

  @override
  Future<PersonModel> getPersonById(String personId) async {
    final data = await _invoke('getPersonById', {'personId': personId});
    return PersonModel.fromJson(_normalizePerson(data as Map<String, dynamic>));
  }

  @override
  Future<PersonModel> createPerson(CreatePersonParams params) async {
    final payload = <String, dynamic>{
      'organizationId': params.organizationId,
      'legalName': params.legalName,
      'preferredName': params.preferredName,
      'dateOfBirth': params.dateOfBirth?.toIso8601String(),
      'gender': params.gender,
      'primaryPhone': params.primaryPhone,
      'primaryEmail': params.primaryEmail,
    };

    if (params.educations.isNotEmpty) {
      payload['educations'] = params.educations.map((e) => {
        'academicLevel': e.academicLevel,
        'disciplineOrGroup': e.disciplineOrGroup,
        'institutionName': e.institutionName,
        'governingBoard': e.governingBoard,
        'startYear': e.startYear,
        'passingYear': e.passingYear,
        'isOngoing': e.isOngoing,
        'resultOrScore': e.resultOrScore,
        'remarks': e.remarks,
        'createdByUserId': e.createdByUserId,
        'createdByRoleAtTime': e.createdByRoleAtTime,
        'createdByNameSnapshot': e.createdByNameSnapshot,
      }).toList();
    }

    if (params.workExperiences.isNotEmpty) {
      payload['workExperiences'] = params.workExperiences.map((w) => {
        'organizationName': w.organizationName,
        'roleOrDesignation': w.roleOrDesignation,
        'departmentOrUnit': w.departmentOrUnit,
        'engagementType': w.engagementType,
        'location': w.location,
        'startDate': w.startDate.toIso8601String().split('T').first,
        'endDate': w.endDate?.toIso8601String().split('T').first,
        'isOngoing': w.isOngoing,
        'responsibilities': w.responsibilities,
        'createdByUserId': w.createdByUserId,
        'createdByRoleAtTime': w.createdByRoleAtTime,
        'createdByNameSnapshot': w.createdByNameSnapshot,
      }).toList();
    }

    final data = await _invoke('createPerson', payload);
    return PersonModel.fromJson(_normalizePerson(data as Map<String, dynamic>));
  }

  @override
  Future<PersonModel> updatePerson(UpdatePersonParams params) async {
    final payload = <String, dynamic>{
      'personId': params.personId,
      if (params.legalName != null) 'legalName': params.legalName,
      if (params.preferredName != null) 'preferredName': params.preferredName,
      if (params.dateOfBirth != null) 'dateOfBirth': params.dateOfBirth!.toIso8601String(),
      if (params.gender != null) 'gender': params.gender,
      if (params.primaryPhone != null) 'primaryPhone': params.primaryPhone,
      if (params.primaryEmail != null) 'primaryEmail': params.primaryEmail,
      if (params.status != null) 'status': params.status!.name,
    };
    final data = await _invoke('updatePerson', payload);
    return PersonModel.fromJson(_normalizePerson(data as Map<String, dynamic>));
  }

  @override
  Future<List<PersonContactModel>> getPersonContacts(String personId) async {
    final data = await _invoke('getPersonContacts', {'personId': personId});
    final list = data is List ? data : <dynamic>[];
    return list
        .map(
          (json) => PersonContactModel.fromJson(_normalizeContact(json as Map<String, dynamic>)),
        )
        .toList();
  }

  @override
  Future<List<PersonRelationshipModel>> getPersonRelationships(
    String personId,
  ) async {
    final data = await _invoke('getPersonRelationships', {
      'personId': personId,
    });
    final list = data is List ? data : <dynamic>[];
    return list
        .map(
          (json) =>
              PersonRelationshipModel.fromJson(_normalizeRelationship(json as Map<String, dynamic>)),
        )
        .toList();
  }

  @override
  Future<List<PersonEducationModel>> getPersonEducations(String personId) async {
    final data = await _invoke('getPersonEducations', {'personId': personId});
    final list = data is List ? data : <dynamic>[];
    return list
        .map(
          (json) => PersonEducationModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<PersonEducationModel> createPersonEducation(
    CreatePersonEducationParams params,
  ) async {
    final data = await _invoke('createPersonEducation', {
      'personId': params.personId,
      'academicLevel': params.academicLevel,
      'disciplineOrGroup': params.disciplineOrGroup,
      'institutionName': params.institutionName,
      'governingBoard': params.governingBoard,
      'startYear': params.startYear,
      'passingYear': params.passingYear,
      'isOngoing': params.isOngoing,
      'resultOrScore': params.resultOrScore,
      'remarks': params.remarks,
      'createdByUserId': params.createdByUserId,
      'createdByRoleAtTime': params.createdByRoleAtTime,
      'createdByNameSnapshot': params.createdByNameSnapshot,
    });
    return PersonEducationModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<PersonWorkExperienceModel>> getPersonWorkExperiences(
    String personId,
  ) async {
    final data = await _invoke('getPersonWorkExperiences', {
      'personId': personId,
    });
    final list = data is List ? data : <dynamic>[];
    return list
        .map(
          (json) =>
              PersonWorkExperienceModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<PersonWorkExperienceModel> createPersonWorkExperience(
    CreatePersonWorkExperienceParams params,
  ) async {
    final data = await _invoke('createPersonWorkExperience', {
      'personId': params.personId,
      'organizationName': params.organizationName,
      'roleOrDesignation': params.roleOrDesignation,
      'departmentOrUnit': params.departmentOrUnit,
      'engagementType': params.engagementType,
      'location': params.location,
      'startDate': params.startDate.toIso8601String().split('T').first,
      'endDate': params.endDate?.toIso8601String().split('T').first,
      'isOngoing': params.isOngoing,
      'responsibilities': params.responsibilities,
      'createdByUserId': params.createdByUserId,
      'createdByRoleAtTime': params.createdByRoleAtTime,
      'createdByNameSnapshot': params.createdByNameSnapshot,
    });
    return PersonWorkExperienceModel.fromJson(data as Map<String, dynamic>);
  }
}
