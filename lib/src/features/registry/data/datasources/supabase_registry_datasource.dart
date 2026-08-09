import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'registry_datasource.dart';

final class SupabaseRegistryDatasource implements RegistryDatasource {
  final SupabaseClient client;

  SupabaseRegistryDatasource({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  Future<dynamic> _invoke(String action, Map<String, dynamic> body) async {
    final response = await client.functions.invoke(
      'registry-api',
      body: {'action': action, ...body},
    );
    if (response.status != 200) {
      throw StateError('Edge Function error: ${response.data}');
    }
    return response.data;
  }

  @override
  Future<OrganizationModel> getOrganization(String organizationId) async {
    final data = await _invoke('getOrganization', {
      'organizationId': organizationId,
    });
    return OrganizationModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<PersonModel>> searchPeople(SearchPeopleParams params) async {
    final data = await _invoke('searchPeople', {
      'organizationId': params.organizationId,
      'query': params.query,
      'dateOfBirth': params.dateOfBirth?.toIso8601String(),
      'phone': params.phone,
      'email': params.email,
      'page': params.page,
      'pageSize': params.pageSize,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
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
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
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
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map(
          (json) =>
              PersonRelationshipModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<PathshalaModel>> listPathshalas(
    ListPathshalasParams params,
  ) async {
    final data = await _invoke('listPathshalas', {
      'organizationId': params.organizationId,
      'status': params.status?.name,
      'searchQuery': params.searchQuery,
      'page': params.page,
      'pageSize': params.pageSize,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map((json) => PathshalaModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PathshalaModel> getPathshalaById(String pathshalaId) async {
    final data = await _invoke('getPathshalaById', {
      'pathshalaId': pathshalaId,
    });
    return PathshalaModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<PathshalaModel> createPathshala(CreatePathshalaParams params) async {
    final data = await _invoke('createPathshala', {
      'organizationId': params.organizationId,
      'code': params.code,
      'name': params.name,
      'addressLine1': params.addressLine1,
      'addressLine2': params.addressLine2,
      'city': params.city,
      'region': params.district,
      'country': params.country,
      'postalCode': params.postalCode,
      'latitude': params.latitude,
      'longitude': params.longitude,
      'startedOn': params.startedOn?.toIso8601String(),
    });
    return PathshalaModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<CommitteeModel>> listCommittees(
    ListCommitteesParams params,
  ) async {
    final data = await _invoke('listCommittees', {
      'organizationId': params.organizationId,
      'pathshalaId': params.pathshalaId,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map((json) => CommitteeModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CommitteeModel> getCommitteeById(String committeeId) async {
    final data = await _invoke('getCommitteeById', {
      'committeeId': committeeId,
    });
    return CommitteeModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<CommitteeMembershipModel>> listCommitteeMemberships(
    ListCommitteeMembershipsParams params,
  ) async {
    final data = await _invoke('listCommitteeMemberships', {
      'committeeId': params.committeeId,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map(
          (json) =>
              CommitteeMembershipModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
