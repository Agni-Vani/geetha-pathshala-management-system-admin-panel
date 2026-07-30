import 'registry_enums.dart';

/// Root human identity for every student, teacher, admin, or committee member.
abstract class Person {
  const Person();

  String get id;
  String get organizationId;
  String get legalName;
  String? get preferredName;
  DateTime? get dateOfBirth;
  String? get gender;
  String? get primaryPhone;
  String? get primaryEmail;
  PersonStatus get status;
  String? get createdByUserId;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Preferred display label while preserving legal name as registry truth.
  String get displayName {
    final normalizedPreferredName = preferredName?.trim();
    if (normalizedPreferredName != null && normalizedPreferredName.isNotEmpty) {
      return normalizedPreferredName;
    }
    return legalName;
  }
}
