import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'pathshala_datasource.dart';

final class SupabasePathshalaDatasource implements PathshalaDatasource {
  final SupabaseClient client;

  SupabasePathshalaDatasource({SupabaseClient? client})
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
      'districtId': params.districtId,
      'upazilaId': params.upazilaId,
      'detailedAddress': params.detailedAddress,
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
  Future<PathshalaModel> updatePathshala(UpdatePathshalaParams params) async {
    final data = await _invoke('updatePathshala', {
      'pathshalaId': params.pathshalaId,
      'name': params.name,
      'districtId': params.districtId,
      'upazilaId': params.upazilaId,
      'detailedAddress': params.detailedAddress,
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
