export 'login_params.dart';

/// Input parameter for checking user authorization on a specific permission code and scope.
final class CheckPermissionParams {
  final String userAccountId;
  final String permissionCode;
  final String? scopeOrganizationId;
  final String? scopePathshalaId;

  const CheckPermissionParams({
    required this.userAccountId,
    required this.permissionCode,
    this.scopeOrganizationId,
    this.scopePathshalaId,
  });
}

/// Input parameter for assigning a role to a user account.
final class AssignUserRoleParams {
  final String userAccountId;
  final String roleId;
  final String? scopeOrganizationId;
  final String? scopePathshalaId;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final String grantedByUserId;

  const AssignUserRoleParams({
    required this.userAccountId,
    required this.roleId,
    this.scopeOrganizationId,
    this.scopePathshalaId,
    required this.effectiveFrom,
    this.effectiveTo,
    required this.grantedByUserId,
  });
}
