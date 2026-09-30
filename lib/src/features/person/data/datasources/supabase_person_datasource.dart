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
}
