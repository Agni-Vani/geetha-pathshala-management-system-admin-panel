import 'iam_enums.dart';

/// Role definition in IAM system.
abstract class Role {
  const Role();

  String get id;
  String get code;
  String get name;
  RoleScopeType get scopeType;
  String? get description;
  List<String> get permissionCodes;
  DateTime get createdAt;
}
