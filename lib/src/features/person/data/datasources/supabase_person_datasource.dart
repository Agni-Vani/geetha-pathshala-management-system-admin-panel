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
        .map((json) => PersonModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PersonModel> getPersonById(String personId) async {
    final data = await _invoke('getPersonById', {'personId': personId});
    return PersonModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<PersonModel> createPerson(CreatePersonParams params) async {
    final data = await _invoke('createPerson', {
      'organizationId': params.organizationId,
      'legalName': params.legalName,
      'preferredName': params.preferredName,
      'dateOfBirth': params.dateOfBirth?.toIso8601String(),
      'gender': params.gender,
      'primaryPhone': params.primaryPhone,
      'primaryEmail': params.primaryEmail,
    });
    return PersonModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<PersonContactModel>> getPersonContacts(String personId) async {
    final data = await _invoke('getPersonContacts', {'personId': personId});
    final list = data is List ? data : <dynamic>[];
    return list
        .map(
          (json) => PersonContactModel.fromJson(json as Map<String, dynamic>),
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
              PersonRelationshipModel.fromJson(json as Map<String, dynamic>),
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
