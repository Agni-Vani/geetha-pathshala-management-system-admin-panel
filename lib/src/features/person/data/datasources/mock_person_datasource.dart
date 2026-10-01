import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'person_datasource.dart';

final class MockPersonDatasource implements PersonDatasource {
  final List<PersonModel> _people;
  final List<PersonContactModel> _contacts;
  final List<PersonRelationshipModel> _relationships;
  final List<PersonEducationModel> _educations;
  final List<PersonWorkExperienceModel> _workExperiences;

  final Duration processingDelay;

  MockPersonDatasource({this.processingDelay = const Duration(milliseconds: 10)})
      : _people = _seedPeople(),
        _contacts = _seedContacts(),
        _relationships = _seedRelationships(),
        _educations = _seedEducations(),
        _workExperiences = _seedWorkExperiences();

  Future<void> _simulateProcessing() async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
  }

  @override
  Future<List<PersonModel>> searchPeople(SearchPeopleParams params) async {
    await _simulateProcessing();
    final query = params.query?.trim().toLowerCase();
    return _people.where((person) {
      if (person.organizationId != params.organizationId) return false;
      if (query == null || query.isEmpty) return true;
      final matchesLegal = person.legalName.toLowerCase().contains(query);
      final matchesPreferred =
          person.preferredName?.toLowerCase().contains(query) ?? false;
      final matchesPhone =
          person.primaryPhone?.toLowerCase().contains(query) ?? false;
      final matchesEmail =
          person.primaryEmail?.toLowerCase().contains(query) ?? false;
      return matchesLegal || matchesPreferred || matchesPhone || matchesEmail;
    }).toList();
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
      id: 'person-${DateTime.now().millisecondsSinceEpoch}',
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

    for (final edu in params.educations) {
      _educations.add(PersonEducationModel(
        id: 'edu-${DateTime.now().millisecondsSinceEpoch}-${_educations.length}',
        personId: person.id,
        academicLevel: edu.academicLevel,
        disciplineOrGroup: edu.disciplineOrGroup,
        institutionName: edu.institutionName,
        governingBoard: edu.governingBoard,
        startYear: edu.startYear,
        passingYear: edu.passingYear,
        isOngoing: edu.isOngoing,
        resultOrScore: edu.resultOrScore,
        remarks: edu.remarks,
        createdByUserId: edu.createdByUserId,
        createdByRoleAtTime: edu.createdByRoleAtTime,
        createdByNameSnapshot: edu.createdByNameSnapshot,
        createdAt: now,
        updatedAt: now,
      ));
    }

    for (final exp in params.workExperiences) {
      _workExperiences.add(PersonWorkExperienceModel(
        id: 'exp-${DateTime.now().millisecondsSinceEpoch}-${_workExperiences.length}',
        personId: person.id,
        organizationName: exp.organizationName,
        roleOrDesignation: exp.roleOrDesignation,
        departmentOrUnit: exp.departmentOrUnit,
        engagementType: exp.engagementType,
        location: exp.location,
        startDate: exp.startDate,
        endDate: exp.endDate,
        isOngoing: exp.isOngoing,
        responsibilities: exp.responsibilities,
        createdByUserId: exp.createdByUserId,
        createdByRoleAtTime: exp.createdByRoleAtTime,
        createdByNameSnapshot: exp.createdByNameSnapshot,
        createdAt: now,
        updatedAt: now,
      ));
    }

    return person;
  }

  @override
  Future<PersonModel> updatePerson(UpdatePersonParams params) async {
    await _simulateProcessing();
    final index = _people.indexWhere((p) => p.id == params.personId);
    if (index == -1) {
      throw StateError('Person not found.');
    }
    final existing = _people[index];
    final updated = existing.copyWith(
      legalName: params.legalName ?? existing.legalName,
      preferredName: params.preferredName ?? existing.preferredName,
      dateOfBirth: params.dateOfBirth ?? existing.dateOfBirth,
      gender: params.gender ?? existing.gender,
      primaryPhone: params.primaryPhone ?? existing.primaryPhone,
      primaryEmail: params.primaryEmail ?? existing.primaryEmail,
      status: params.status ?? existing.status,
      updatedAt: DateTime.now(),
    );
    _people[index] = updated;
    return updated;
  }

  @override
  Future<List<PersonContactModel>> getPersonContacts(String personId) async {
    await _simulateProcessing();
    return _contacts.where((c) => c.personId == personId).toList();
  }

  @override
  Future<List<PersonRelationshipModel>> getPersonRelationships(
    String personId,
  ) async {
    await _simulateProcessing();
    return _relationships.where((r) => r.personId == personId).toList();
  }

  @override
  Future<List<PersonEducationModel>> getPersonEducations(String personId) async {
    await _simulateProcessing();
    return _educations.where((e) => e.personId == personId).toList();
  }

  @override
  Future<PersonEducationModel> createPersonEducation(
    CreatePersonEducationParams params,
  ) async {
    await _simulateProcessing();
    final now = DateTime.now();
    final edu = PersonEducationModel(
      id: 'edu-${now.millisecondsSinceEpoch}',
      personId: params.personId,
      academicLevel: params.academicLevel,
      disciplineOrGroup: params.disciplineOrGroup,
      institutionName: params.institutionName,
      governingBoard: params.governingBoard,
      startYear: params.startYear,
      passingYear: params.passingYear,
      isOngoing: params.isOngoing,
      resultOrScore: params.resultOrScore,
      remarks: params.remarks,
      createdByUserId: params.createdByUserId,
      createdByRoleAtTime: params.createdByRoleAtTime,
      createdByNameSnapshot: params.createdByNameSnapshot,
      createdAt: now,
      updatedAt: now,
    );
    _educations.add(edu);
    return edu;
  }

  @override
  Future<List<PersonWorkExperienceModel>> getPersonWorkExperiences(
    String personId,
  ) async {
    await _simulateProcessing();
    return _workExperiences.where((w) => w.personId == personId).toList();
  }

  @override
  Future<PersonWorkExperienceModel> createPersonWorkExperience(
    CreatePersonWorkExperienceParams params,
  ) async {
    await _simulateProcessing();
    final now = DateTime.now();
    final exp = PersonWorkExperienceModel(
      id: 'exp-${now.millisecondsSinceEpoch}',
      personId: params.personId,
      organizationName: params.organizationName,
      roleOrDesignation: params.roleOrDesignation,
      departmentOrUnit: params.departmentOrUnit,
      engagementType: params.engagementType,
      location: params.location,
      startDate: params.startDate,
      endDate: params.endDate,
      isOngoing: params.isOngoing,
      responsibilities: params.responsibilities,
      createdByUserId: params.createdByUserId,
      createdByRoleAtTime: params.createdByRoleAtTime,
      createdByNameSnapshot: params.createdByNameSnapshot,
      createdAt: now,
      updatedAt: now,
    );
    _workExperiences.add(exp);
    return exp;
  }
}

List<PersonModel> _seedPeople() {
  final createdAt = DateTime(2026, 7, 1, 10);
  return [
    PersonModel(
      id: 'person-anirban-sen',
      organizationId: 'org-gp-central',
      legalName: 'Anirban Sen',
      preferredName: 'Anirban',
      dateOfBirth: DateTime(1984, 3, 14),
      gender: 'male',
      primaryPhone: '+8801711000001',
      primaryEmail: 'anirban.sen@example.org',
      status: PersonStatus.active,
      createdByUserId: 'user-system-admin',
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
    PersonModel(
      id: 'person-madhuri-das',
      organizationId: 'org-gp-central',
      legalName: 'Madhuri Das',
      preferredName: 'Madhuri',
      dateOfBirth: DateTime(1991, 8, 22),
      gender: 'female',
      primaryPhone: '+8801711000002',
      primaryEmail: 'madhuri.das@example.org',
      status: PersonStatus.active,
      createdByUserId: 'user-system-admin',
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
    PersonModel(
      id: 'person-tanmoy-chatterjee',
      organizationId: 'org-gp-central',
      legalName: 'Tanmoy Chatterjee',
      preferredName: 'Tanmoy',
      dateOfBirth: DateTime(1989, 12, 5),
      gender: 'male',
      primaryPhone: '+8801711000003',
      primaryEmail: 'tanmoy.chatterjee@example.org',
      status: PersonStatus.active,
      createdByUserId: 'user-system-admin',
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
    PersonModel(
      id: 'person-rishav-roy',
      organizationId: 'org-gp-central',
      legalName: 'Rishav Roy',
      preferredName: 'Rishav',
      dateOfBirth: DateTime(2015, 6, 18),
      gender: 'male',
      primaryPhone: null,
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
      dateOfBirth: DateTime(2014, 9, 30),
      gender: 'female',
      primaryPhone: null,
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

List<PersonEducationModel> _seedEducations() {
  final now = DateTime(2026, 7, 1);
  return [
    PersonEducationModel(
      id: 'edu-anirban-1',
      personId: 'person-anirban-sen',
      academicLevel: 'B.A. (Honours) in Sanskrit',
      disciplineOrGroup: 'Sanskrit Literature',
      institutionName: 'University of Dhaka',
      governingBoard: 'University of Dhaka',
      startYear: 2004,
      passingYear: 2008,
      isOngoing: false,
      resultOrScore: 'First Class',
      remarks: 'Department Gold Medalist',
      createdByUserId: 'user-system-admin',
      createdByRoleAtTime: 'SuperAdmin',
      createdByNameSnapshot: 'System Administrator',
      createdAt: now,
      updatedAt: now,
    ),
    PersonEducationModel(
      id: 'edu-rishav-1',
      personId: 'person-rishav-roy',
      academicLevel: 'Class 4',
      disciplineOrGroup: 'General',
      institutionName: 'Mirpur Model High School',
      governingBoard: 'Dhaka Education Board',
      startYear: 2024,
      passingYear: null,
      isOngoing: true,
      resultOrScore: 'GPA 5.0',
      remarks: null,
      createdByUserId: 'user-system-admin',
      createdByRoleAtTime: 'SuperAdmin',
      createdByNameSnapshot: 'System Administrator',
      createdAt: now,
      updatedAt: now,
    ),
  ];
}

List<PersonWorkExperienceModel> _seedWorkExperiences() {
  final now = DateTime(2026, 7, 1);
  return [
    PersonWorkExperienceModel(
      id: 'exp-anirban-1',
      personId: 'person-anirban-sen',
      organizationName: 'Geetha Pathshala Trust',
      roleOrDesignation: 'Lead Gita Instructor',
      departmentOrUnit: 'Academics',
      engagementType: 'volunteer',
      location: 'Dhaka',
      startDate: DateTime(2018, 1, 1),
      endDate: null,
      isOngoing: true,
      responsibilities: 'Instructing senior class batches and training teachers.',
      createdByUserId: 'user-system-admin',
      createdByRoleAtTime: 'SuperAdmin',
      createdByNameSnapshot: 'System Administrator',
      createdAt: now,
      updatedAt: now,
    ),
  ];
}
