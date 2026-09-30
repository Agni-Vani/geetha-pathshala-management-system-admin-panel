import 'iam_enums.dart';

/// Assigned role binding a user to a scope.
abstract class UserRole {
  const UserRole();

  String get id;
  String get userAccountId;
  String get roleId;
  String get roleCode;
  String? get scopeOrganizationId;
  String? get scopePathshalaId;
  DateTime get effectiveFrom;
  DateTime? get effectiveTo;
  String? get grantedByUserId;
  UserRoleStatus get status;

  bool get isCurrentlyEffective {
    if (status != UserRoleStatus.active) return false;
    final now = DateTime.now();
    if (now.isBefore(effectiveFrom)) return false;
    if (effectiveTo != null && now.isAfter(effectiveTo!)) return false;
    return true;
  }
}
