import '../entities/entities.dart';

/// Parameters for updating an existing person's details in the registry.
final class UpdatePersonParams {
  final String personId;
  final String? legalName;
  final String? preferredName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? primaryPhone;
  final String? primaryEmail;
  final PersonStatus? status;

  const UpdatePersonParams({
    required this.personId,
    this.legalName,
    this.preferredName,
    this.dateOfBirth,
    this.gender,
    this.primaryPhone,
    this.primaryEmail,
    this.status,
  });
}
