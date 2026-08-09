import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'registry_datasource.dart';

/// In-memory registry datasource used until Supabase integration is added.
final class MockRegistryDatasource implements RegistryDatasource {
  final Duration processingDelay;
  final List<OrganizationModel> _organizations;
  final List<PersonModel> _people;
  final List<PersonContactModel> _contacts;
  final List<PersonRelationshipModel> _relationships;
  final List<PathshalaModel> _pathshalas;
  final List<CommitteeModel> _committees;
  final List<CommitteeMembershipModel> _memberships;

  MockRegistryDatasource({
    this.processingDelay = const Duration(milliseconds: 650),
  }) : _organizations = _seedOrganizations(),
       _people = _seedPeople(),
       _contacts = _seedContacts(),
       _relationships = _seedRelationships(),
       _pathshalas = _seedPathshalas(),
       _committees = _seedCommittees(),
       _memberships = _seedMemberships();

  @override
  Future<OrganizationModel> getOrganization(String organizationId) async {
    await _simulateProcessing();
    return _organizations.firstWhere(
      (organization) => organization.id == organizationId,
      orElse: () => throw StateError('Organization not found.'),
    );
  }

  @override
  Future<List<PersonModel>> searchPeople(SearchPeopleParams params) async {
    await _simulateProcessing();
    final query = params.query?.trim().toLowerCase();
    final phone = params.phone?.trim().toLowerCase();
    final email = params.email?.trim().toLowerCase();

    final results = _people.where((person) {
      if (person.organizationId != params.organizationId) return false;

      final nameMatches =
          query == null ||
          query.isEmpty ||
          person.legalName.toLowerCase().contains(query) ||
          (person.preferredName?.toLowerCase().contains(query) ?? false);
      final phoneMatches =
          phone == null ||
          phone.isEmpty ||
          (person.primaryPhone?.toLowerCase().contains(phone) ?? false);
      final emailMatches =
          email == null ||
          email.isEmpty ||
          (person.primaryEmail?.toLowerCase().contains(email) ?? false);
      final dobMatches =
          params.dateOfBirth == null ||
          person.dateOfBirth == params.dateOfBirth;

      return nameMatches && phoneMatches && emailMatches && dobMatches;
    }).toList();

    results.sort((a, b) => a.legalName.compareTo(b.legalName));
    return results.take(params.pageSize).toList(growable: false);
  }

  @override
  Future<PersonModel> getPersonById(String personId) async {
    await _simulateProcessing();
    return _people.firstWhere(
      (person) => person.id == personId,
      orElse: () => throw StateError('Person not found.'),
    );
  }

  @override
  Future<PersonModel> createPerson(CreatePersonParams params) async {
    await _simulateProcessing();
    final now = DateTime.now();
    final person = PersonModel(
      id: 'person-${now.microsecondsSinceEpoch}',
      organizationId: params.organizationId,
      legalName: params.legalName,
      preferredName: params.preferredName,
      dateOfBirth: params.dateOfBirth,
      gender: params.gender,
      primaryPhone: params.primaryPhone,
      primaryEmail: params.primaryEmail,
      status: PersonStatus.active,
      createdByUserId: null,
      createdAt: now,
      updatedAt: now,
    );

    _people.add(person);
    _contacts.addAll(
      params.contacts.map((contact) {
        return PersonContactModel(
          id: 'contact-${now.microsecondsSinceEpoch}-${_contacts.length + 1}',
          personId: person.id,
          type: contact.type,
          label: contact.label,
          value: contact.value,
          isPrimary: contact.isPrimary,
          verifiedAt: null,
        );
      }),
    );
    _relationships.addAll(
      params.relationships.map((relationship) {
        return PersonRelationshipModel(
          id: 'relationship-${now.microsecondsSinceEpoch}-${_relationships.length + 1}',
          personId: person.id,
          relatedPersonId: relationship.relatedPersonId,
          type: relationship.type,
          isPrimaryGuardian: relationship.isPrimaryGuardian,
          effectiveFrom: relationship.effectiveFrom,
          effectiveTo: relationship.effectiveTo,
        );
      }),
    );

    return person;
  }

  @override
  Future<List<PersonContactModel>> getPersonContacts(String personId) async {
    await _simulateProcessing();
    await getPersonById(personId);
    return _contacts
        .where((contact) => contact.personId == personId)
        .toList(growable: false);
  }

  @override
  Future<List<PersonRelationshipModel>> getPersonRelationships(
    String personId,
  ) async {
    await _simulateProcessing();
    await getPersonById(personId);
    return _relationships
        .where((relationship) => relationship.personId == personId)
        .toList(growable: false);
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

List<PersonModel> _seedPeople() {
  final createdAt = DateTime(2026, 7, 5, 10);
  return [
    PersonModel(
      id: 'person-anirban-sen',
      organizationId: 'org-gp-central',
      legalName: 'Anirban Sen',
      preferredName: 'Anirban',
      dateOfBirth: DateTime(1984, 3, 12),
      gender: 'male',
      primaryPhone: '+8801711000001',
      primaryEmail: 'anirban.sen@example.org',
      status: PersonStatus.active,
      createdByUserId: 'user-super-admin',
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
    PersonModel(
      id: 'person-madhuri-das',
      organizationId: 'org-gp-central',
      legalName: 'Madhuri Das',
      preferredName: 'Madhuri',
      dateOfBirth: DateTime(1990, 8, 21),
      gender: 'female',
      primaryPhone: '+8801711000002',
      primaryEmail: 'madhuri.das@example.org',
      status: PersonStatus.active,
      createdByUserId: 'user-super-admin',
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
    PersonModel(
      id: 'person-rishav-roy',
      organizationId: 'org-gp-central',
      legalName: 'Rishav Roy',
      preferredName: 'Rishav',
      dateOfBirth: DateTime(2014, 1, 18),
      gender: 'male',
      primaryPhone: '+8801711000101',
      primaryEmail: null,
      status: PersonStatus.active,
      createdByUserId: 'user-pathshala-admin',
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
    PersonModel(
      id: 'person-ishita-pal',
      organizationId: 'org-gp-central',
      legalName: 'Ishita Pal',
      preferredName: 'Ishita',
      dateOfBirth: DateTime(2015, 5, 4),
      gender: 'female',
      primaryPhone: '+8801711000102',
      primaryEmail: null,
      status: PersonStatus.active,
      createdByUserId: 'user-pathshala-admin',
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
    PersonModel(
      id: 'person-subhash-roy',
      organizationId: 'org-gp-central',
      legalName: 'Subhash Roy',
      preferredName: 'Subhash',
      dateOfBirth: DateTime(1979, 11, 2),
      gender: 'male',
      primaryPhone: '+8801711000103',
      primaryEmail: 'subhash.roy@example.org',
      status: PersonStatus.active,
      createdByUserId: 'user-pathshala-admin',
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
  ];
}

List<PersonContactModel> _seedContacts() {
  return [
    PersonContactModel(
      id: 'contact-anirban-phone',
      personId: 'person-anirban-sen',
      type: ContactType.phone,
      label: 'personal',
      value: '+8801711000001',
      isPrimary: true,
      verifiedAt: DateTime(2026, 7, 5, 11),
    ),
    PersonContactModel(
      id: 'contact-madhuri-email',
      personId: 'person-madhuri-das',
      type: ContactType.email,
      label: 'personal',
      value: 'madhuri.das@example.org',
      isPrimary: true,
      verifiedAt: DateTime(2026, 7, 5, 11),
    ),
    PersonContactModel(
      id: 'contact-rishav-guardian',
      personId: 'person-rishav-roy',
      type: ContactType.emergency,
      label: 'father',
      value: '+8801711000103',
      isPrimary: true,
      verifiedAt: null,
    ),
    PersonContactModel(
      id: 'contact-ishita-home',
      personId: 'person-ishita-pal',
      type: ContactType.phone,
      label: 'guardian',
      value: '+8801711000102',
      isPrimary: true,
      verifiedAt: null,
    ),
  ];
}

List<PersonRelationshipModel> _seedRelationships() {
  return [
    PersonRelationshipModel(
      id: 'relationship-rishav-subhash',
      personId: 'person-rishav-roy',
      relatedPersonId: 'person-subhash-roy',
      type: PersonRelationshipType.parent,
      isPrimaryGuardian: true,
      effectiveFrom: DateTime(2026, 7, 5),
      effectiveTo: null,
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
      address: const PathshalaAddressModel(
        addressLine1: 'House 12, Road 4',
        addressLine2: 'Dhanmondi',
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
      address: const PathshalaAddressModel(
        addressLine1: 'Temple Complex Road',
        addressLine2: null,
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
      address: const PathshalaAddressModel(
        addressLine1: 'Community Hall 2',
        addressLine2: 'Zindabazar',
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
      title: 'Pathshala Coordinator',
      effectiveFrom: DateTime(2026, 7, 1),
      effectiveTo: null,
      status: CommitteeMembershipStatus.active,
    ),
    CommitteeMembershipModel(
      id: 'membership-subhash-dhaka',
      committeeId: 'committee-dhaka-local',
      personId: 'person-subhash-roy',
      title: 'Guardian Representative',
      effectiveFrom: DateTime(2026, 7, 1),
      effectiveTo: null,
      status: CommitteeMembershipStatus.active,
    ),
  ];
}
