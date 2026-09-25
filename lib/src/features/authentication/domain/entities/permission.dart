/// Granular permission definition in IAM system.
abstract class Permission {
  const Permission();

  String get id;
  String get code;
  String get name;
  String get module;
  String? get description;
  DateTime get createdAt;
}
