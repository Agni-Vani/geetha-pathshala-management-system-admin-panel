import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'registry_datasource.dart';

final class SupabaseRegistryDatasource implements RegistryDatasource {
  final SupabaseClient client;

  SupabaseRegistryDatasource({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;


  @override
  Future<OrganizationModel> getOrganization(String organizationId) async {
    final response = await client
        .schema('registry')
        .from('organizations')
        .select()
        .eq('id', organizationId)
        .single();
    return OrganizationModel.fromJson(response);
  }

  @override
  Future<List<PersonModel>> searchPeople(SearchPeopleParams params) async {
    var query = client
        .schema('registry')
        .from('people')
        .select()
        .eq('organization_id', params.organizationId);

    if (params.query.isNotEmpty) {
      query = query.or(
        'legal_name.ilike.%${params.query}%,preferred_name.ilike.%${params.query}%',
      );
    }
    final response = await query;
    return (response as List)
        .map((json) => PersonModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PersonModel> getPersonById(String personId) async {
    final response = await client
        .schema('registry')
        .from('people')
        .select()
        .eq('id', personId)
        .single();
    return PersonModel.fromJson(response);
  }

  @override
  Future<PersonModel> createPerson(CreatePersonParams params) async {
    final response = await client
        .schema('registry')
        .from('people')
        .insert({
          'organization_id': params.organizationId,
          'legal_name': params.legalName,
          'preferred_name': params.preferredName,
          'date_of_birth': params.dateOfBirth?.toIso8601String(),
          'gender': params.gender,
          'primary_phone': params.primaryPhone,
          'primary_email': params.primaryEmail,
        })
        .select()
        .single();
    return PersonModel.fromJson(response);
  }

  @override
  Future<List<PersonContactModel>> getPersonContacts(String personId) async {
    final response = await client
        .schema('registry')
        .from('person_contacts')
        .select()
        .eq('person_id', personId);
    return (response as List)
        .map((json) => PersonContactModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PersonRelationshipModel>> getPersonRelationships(
    String personId,
  ) async {
    final response = await client
        .schema('registry')
        .from('person_relationships')
        .select()
        .eq('person_id', personId);
    return (response as List)
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
    var query = client
        .schema('registry')
        .from('pathshalas')
        .select()
        .eq('organization_id', params.organizationId);

    if (params.status != null) {
      query = query.eq('status', params.status!.name);
    }
    if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
      query = query.ilike('name', '%${params.searchQuery}%');
    }
    final response = await query;
    return (response as List)
        .map((json) => PathshalaModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PathshalaModel> getPathshalaById(String pathshalaId) async {
    final response = await client
        .schema('registry')
        .from('pathshalas')
        .select()
        .eq('id', pathshalaId)
        .single();
    return PathshalaModel.fromJson(response);
  }

  @override
  Future<PathshalaModel> createPathshala(CreatePathshalaParams params) async {
    final response = await client
        .schema('registry')
        .from('pathshalas')
        .insert({
          'organization_id': params.organizationId,
          'code': params.code,
          'name': params.name,
          'status': 'active',
          'address_line1': params.address.addressLine1,
          'address_line2': params.address.addressLine2,
          'city': params.address.city,
          'region': params.address.region,
          'country': params.address.country,
          'postal_code': params.address.postalCode,
          'latitude': params.coordinate?.latitude,
          'longitude': params.coordinate?.longitude,
          'started_on': params.startedOn?.toIso8601String() ??
              DateTime.now().toIso8601String(),
        })
        .select()
        .single();
    return PathshalaModel.fromJson(response);
  }

  @override
  Future<List<CommitteeModel>> listCommittees(
    ListCommitteesParams params,
  ) async {
    var query = client
        .schema('registry')
        .from('committees')
        .select()
        .eq('organization_id', params.organizationId);

    if (params.pathshalaId != null) {
      query = query.eq('pathshala_id', params.pathshalaId!);
    }
    final response = await query;
    return (response as List)
        .map((json) => CommitteeModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CommitteeModel> getCommitteeById(String committeeId) async {
    final response = await client
        .schema('registry')
        .from('committees')
        .select()
        .eq('id', committeeId)
        .single();
    return CommitteeModel.fromJson(response);
  }

  @override
  Future<List<CommitteeMembershipModel>> listCommitteeMemberships(
    ListCommitteeMembershipsParams params,
  ) async {
    final response = await client
        .schema('registry')
        .from('committee_memberships')
        .select()
        .eq('committee_id', params.committeeId);
    return (response as List)
        .map(
          (json) =>
              CommitteeMembershipModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
