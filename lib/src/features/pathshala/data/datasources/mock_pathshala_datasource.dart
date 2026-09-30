import '../../domain/pathshala_domain.dart';
import '../models/models.dart';
import 'pathshala_datasource.dart';

/// In-memory mock data-source for development and offline mode.
final class MockPathshalaDatasource implements PathshalaDatasource {
  static const Duration defaultDelay = Duration(milliseconds: 150);
  final Duration processingDelay;

  final List<OrganizationModel> _organizations;
  final List<PathshalaModel> _pathshalas;
  final List<CommitteeModel> _committees;
  final List<CommitteeMembershipModel> _memberships;

  MockPathshalaDatasource({this.processingDelay = defaultDelay})
      : _organizations = _seedOrganizations(),
        _pathshalas = _seedPathshalas(),
        _committees = _seedCommittees(),
        _memberships = _seedMemberships();

  @override
  Future<OrganizationModel> getOrganization(String organizationId) async {
    await _simulateProcessing();
    return _organizations.firstWhere(
      (org) => org.id == organizationId,
      orElse: () => throw StateError('Organization not found.'),
    );
  }

  @override
  Future<List<PathshalaModel>> listPathshalas(
    ListPathshalasParams params,
  ) async {
    await _simulateProcessing();
    final searchQuery = params.searchQuery?.trim().toLowerCase();

    final results = _pathshalas.where((pathshala) {
      if (pathshala.organizationId != params.organizationId) return false;
      if (params.status != null && pathshala.status != params.status) {
        return false;
      }
      if (searchQuery == null || searchQuery.isEmpty) return true;

      return pathshala.name.toLowerCase().contains(searchQuery) ||
          pathshala.code.toLowerCase().contains(searchQuery) ||
          pathshala.address.city.toLowerCase().contains(searchQuery);
    }).toList();

    results.sort((a, b) => a.name.compareTo(b.name));
    return results;
  }

  @override
  Future<PathshalaModel> getPathshalaById(String pathshalaId) async {
    await _simulateProcessing();
    return _pathshalas.firstWhere(
      (pathshala) => pathshala.id == pathshalaId,
      orElse: () => throw StateError('Pathshala not found.'),
    );
  }

  @override
  Future<PathshalaModel> createPathshala(CreatePathshalaParams params) async {
    await _simulateProcessing();
    final now = DateTime.now();
    final addressModel = PathshalaAddressModel(
      addressLine1: params.addressLine1,
      addressLine2: params.addressLine2,
      detailedAddress: params.detailedAddress ?? params.addressLine1,
      city: params.city,
      region: params.district,
      country: params.country,
      postalCode: params.postalCode,
    );
    final coordModel = params.latitude != null && params.longitude != null
        ? GeoCoordinateModel(
            latitude: params.latitude!,
            longitude: params.longitude!,
          )
        : null;

    final pathshala = PathshalaModel(
      id: 'pathshala-${DateTime.now().millisecondsSinceEpoch}',
      organizationId: params.organizationId,
      code: params.code,
      name: params.name,
      status: PathshalaStatus.active,
      districtId: params.districtId,
      upazilaId: params.upazilaId,
      address: addressModel,
      coordinate: coordModel,
      startedOn: params.startedOn ?? now,
      closedOn: null,
      createdAt: now,
      updatedAt: now,
    );
    _pathshalas.add(pathshala);
    return pathshala;
  }

  @override
  Future<PathshalaModel> updatePathshala(UpdatePathshalaParams params) async {
    await _simulateProcessing();
    final index = _pathshalas.indexWhere(
      (pathshala) => pathshala.id == params.pathshalaId,
    );
    if (index == -1) throw StateError('Pathshala not found.');

    final existing = _pathshalas[index];
    final coordModel = params.latitude != null && params.longitude != null
        ? GeoCoordinateModel(
            latitude: params.latitude!,
            longitude: params.longitude!,
          )
        : existing.coordinate;

    final updated = existing.copyWith(
      name: params.name,
      districtId: params.districtId ?? existing.districtId,
      upazilaId: params.upazilaId ?? existing.upazilaId,
      address: existing.address.copyWith(
        addressLine1: params.addressLine1,
        addressLine2: params.addressLine2,
        detailedAddress:
            params.detailedAddress ?? existing.address.detailedAddress,
        city: params.city,
        region: params.district,
        country: params.country,
        postalCode: params.postalCode,
      ),
      coordinate: coordModel,
      startedOn: params.startedOn ?? existing.startedOn,
      updatedAt: DateTime.now(),
    );

    _pathshalas[index] = updated;
    return updated;
  }

  @override
  Future<List<CommitteeModel>> listCommittees(
    ListCommitteesParams params,
  ) async {
    await _simulateProcessing();
    final results = _committees.where((committee) {
      if (committee.organizationId != params.organizationId) {
        return false;
      }
      if (params.pathshalaId != null &&
          committee.pathshalaId != params.pathshalaId) {
        return false;
      }
      if (params.type != null && committee.type != params.type) {
        return false;
      }
      if (params.status != null && committee.status != params.status) {
        return false;
      }
      return true;
    }).toList();

    results.sort((a, b) => a.name.compareTo(b.name));
    return results;
  }

  @override
  Future<CommitteeModel> getCommitteeById(String committeeId) async {
    await _simulateProcessing();
    return _committees.firstWhere(
      (committee) => committee.id == committeeId,
      orElse: () => throw StateError('Committee not found.'),
    );
  }

  @override
  Future<List<CommitteeMembershipModel>> listCommitteeMemberships(
    ListCommitteeMembershipsParams params,
  ) async {
    await _simulateProcessing();
    await getCommitteeById(params.committeeId);
    return _memberships
        .where((membership) {
          if (membership.committeeId != params.committeeId) return false;
          if (params.status != null && membership.status != params.status) {
            return false;
          }
          return true;
        })
        .toList(growable: false);
  }

  Future<void> _simulateProcessing() => Future.delayed(processingDelay);
}

List<OrganizationModel> _seedOrganizations() {
  final now = DateTime(2026, 7, 1, 9);
  return [
    OrganizationModel(
      id: 'org-gp-central',
      officialName: 'Gita Pathshala Central Governing Organization',
      displayName: 'Gita Pathshala',
      status: OrganizationStatus.active,
      createdAt: now,
      updatedAt: now,
    ),
  ];
}

List<PathshalaModel> _seedPathshalas() {
  final createdAt = DateTime(2026, 7, 2, 9);
  return [
    PathshalaModel(
      id: 'pathshala-dhaka-central',
      organizationId: 'org-gp-central',
      code: 'DHK-001',
      name: 'Dhaka Central Gita Pathshala',
      status: PathshalaStatus.active,
      districtId: 'dist-dhaka',
      upazilaId: 'upz-dhanmondi',
      address: const PathshalaAddressModel(
        addressLine1: 'House 12, Road 4',
        addressLine2: 'Dhanmondi',
        detailedAddress: 'House 12, Road 4, Dhanmondi, Dhaka',
        city: 'Dhaka',
        region: 'Dhaka',
        country: 'Bangladesh',
        postalCode: '1205',
      ),
      coordinate: const GeoCoordinateModel(
        latitude: 23.7465,
        longitude: 90.3760,
      ),
      startedOn: DateTime(2019, 1, 12),
      closedOn: null,
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
    PathshalaModel(
      id: 'pathshala-chattogram-north',
      organizationId: 'org-gp-central',
      code: 'CTG-002',
      name: 'Chattogram North Gita Pathshala',
      status: PathshalaStatus.active,
      districtId: 'dist-chattogram',
      upazilaId: 'upz-panchlaish',
      address: const PathshalaAddressModel(
        addressLine1: 'Temple Complex Road',
        addressLine2: null,
        detailedAddress: 'Temple Complex Road, Panchlaish, Chattogram',
        city: 'Chattogram',
        region: 'Chattogram',
        country: 'Bangladesh',
        postalCode: '4000',
      ),
      coordinate: const GeoCoordinateModel(
        latitude: 22.3569,
        longitude: 91.7832,
      ),
      startedOn: DateTime(2021, 4, 3),
      closedOn: null,
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
    PathshalaModel(
      id: 'pathshala-sylhet-east',
      organizationId: 'org-gp-central',
      code: 'SYL-003',
      name: 'Sylhet East Gita Pathshala',
      status: PathshalaStatus.paused,
      districtId: 'dist-sylhet',
      upazilaId: 'upz-sylhet-sadar',
      address: const PathshalaAddressModel(
        addressLine1: 'Community Hall 2',
        addressLine2: 'Zindabazar',
        detailedAddress: 'Community Hall 2, Zindabazar, Sylhet',
        city: 'Sylhet',
        region: 'Sylhet',
        country: 'Bangladesh',
        postalCode: '3100',
      ),
      coordinate: const GeoCoordinateModel(
        latitude: 24.8949,
        longitude: 91.8687,
      ),
      startedOn: DateTime(2022, 2, 19),
      closedOn: null,
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
  ];
}

List<CommitteeModel> _seedCommittees() {
  return const [
    CommitteeModel(
      id: 'committee-central-operations',
      organizationId: 'org-gp-central',
      pathshalaId: null,
      name: 'Central Operations Committee',
      type: CommitteeType.central,
      status: CommitteeStatus.active,
    ),
    CommitteeModel(
      id: 'committee-dhaka-local',
      organizationId: 'org-gp-central',
      pathshalaId: 'pathshala-dhaka-central',
      name: 'Dhaka Central Local Committee',
      type: CommitteeType.pathshala,
      status: CommitteeStatus.active,
    ),
    CommitteeModel(
      id: 'committee-chattogram-local',
      organizationId: 'org-gp-central',
      pathshalaId: 'pathshala-chattogram-north',
      name: 'Chattogram North Local Committee',
      type: CommitteeType.pathshala,
      status: CommitteeStatus.active,
    ),
  ];
}

List<CommitteeMembershipModel> _seedMemberships() {
  return [
    CommitteeMembershipModel(
      id: 'membership-anirban-central',
      committeeId: 'committee-central-operations',
      personId: 'person-anirban-sen',
      title: 'Operations Lead',
      effectiveFrom: DateTime(2026, 7, 1),
      effectiveTo: null,
      status: CommitteeMembershipStatus.active,
    ),
    CommitteeMembershipModel(
      id: 'membership-madhuri-dhaka',
      committeeId: 'committee-dhaka-local',
      personId: 'person-madhuri-das',
      title: 'Secretary',
      effectiveFrom: DateTime(2026, 7, 1),
      effectiveTo: null,
      status: CommitteeMembershipStatus.active,
    ),
  ];
}
