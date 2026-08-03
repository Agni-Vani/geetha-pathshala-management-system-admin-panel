import 'registry_enums.dart';

/// Central governing organization that owns the Pathshala ecosystem.
abstract class Organization {
  const Organization();

  String get id;
  String get officialName;
  String get displayName;
  OrganizationStatus get status;
  DateTime get createdAt;
  DateTime get updatedAt;
}
