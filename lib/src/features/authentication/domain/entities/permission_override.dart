/// Explicit permission grant or restriction override for a user account.
abstract class PermissionOverride {
  const PermissionOverride();

  String get id;
  String get userAccountId;
  String get permissionId;
  String get permissionCode;
  bool get isGranted;
  String? get scopeOrganizationId;
  String? get scopePathshalaId;
  DateTime get effectiveFrom;
  DateTime? get effectiveTo;
  String get reason;

  bool get isCurrentlyEffective {
    final now = DateTime.now();
    if (now.isBefore(effectiveFrom)) return false;
    if (effectiveTo != null && now.isAfter(effectiveTo!)) return false;
    return true;
  }
}
