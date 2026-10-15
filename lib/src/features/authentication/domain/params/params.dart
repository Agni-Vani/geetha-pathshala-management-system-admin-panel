export 'login_params.dart';
export 'assign_role_journey_params.dart';

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
  final String? grantedByUserId;

  const AssignUserRoleParams({
    required this.userAccountId,
    required this.roleId,
    this.scopeOrganizationId,
    this.scopePathshalaId,
    required this.effectiveFrom,
    this.effectiveTo,
    this.grantedByUserId,
  });
}

/// Input parameters for provisioning a Pathshala Administrator.
final class CreatePathshalaAdminParams {
  final String pathshalaId;
  final String email;
  final String password;
  final String? personId;
  final String? legalName;
  final String? preferredName;
  final String? primaryPhone;
  final String? area;
  final String title;
  final DateTime effectiveFrom;

  const CreatePathshalaAdminParams({
    required this.pathshalaId,
    required this.email,
    required this.password,
    this.personId,
    this.legalName,
    this.preferredName,
    this.primaryPhone,
    this.area,
    this.title = 'প্রধান সমন্বয়ক',
    required this.effectiveFrom,
  });
}

/// Input parameters for resetting an application user's password.
final class ResetUserPasswordParams {
  final String userAccountId;
  final String? email;
  final String newPassword;

  const ResetUserPasswordParams({
    required this.userAccountId,
    this.email,
    required this.newPassword,
  });
}

