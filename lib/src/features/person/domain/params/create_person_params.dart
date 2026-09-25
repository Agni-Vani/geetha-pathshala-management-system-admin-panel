import '../entities/entities.dart';

/// Input required to create a person registry record.
final class CreatePersonParams {
  final String organizationId;
  final String legalName;
  final String? preferredName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? primaryPhone;
  final String? primaryEmail;
  final List<CreatePersonContactParams> contacts;
  final List<CreatePersonRelationshipParams> relationships;

  const CreatePersonParams({
    required this.organizationId,
    required this.legalName,
    required this.preferredName,
    required this.dateOfBirth,
    required this.gender,
    required this.primaryPhone,
    required this.primaryEmail,
    this.contacts = const [],
    this.relationships = const [],
  });
}

/// Input for creating a contact together with a person.
final class CreatePersonContactParams {
  final ContactType type;
  final String label;
  final String value;
  final bool isPrimary;

  const CreatePersonContactParams({
    required this.type,
    required this.label,
    required this.value,
    required this.isPrimary,
  });
}

/// Input for creating a relationship together with a person.
final class CreatePersonRelationshipParams {
  final String relatedPersonId;
  final PersonRelationshipType type;
  final bool isPrimaryGuardian;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;

  const CreatePersonRelationshipParams({
    required this.relatedPersonId,
    required this.type,
    required this.isPrimaryGuardian,
    required this.effectiveFrom,
    required this.effectiveTo,
  });
}
