import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

/// Repository interface for IAM domain actions.
abstract interface class IamRepository {
  /// Fetches a user account by ID.
  AsyncRequest<UserAccount> getUserAccount(String userAccountId);

  /// Fetches user account linked to a specific auth user ID.
  AsyncRequest<UserAccount> getUserAccountByAuthId(String authUserId);

  /// Lists active roles assigned to a user account.
  AsyncRequest<List<UserRole>> listUserRoles(String userAccountId);

  /// Evaluates effective permission for a user under optional scope.
  AsyncRequest<bool> checkPermission(CheckPermissionParams params);

  /// Assigns a role to a user account.
  AsyncRequest<UserRole> assignUserRole(AssignUserRoleParams params);

  /// Lists all roles defined in the system.
  AsyncRequest<List<Role>> listRoles();

  /// Lists all permissions defined in the system.
  AsyncRequest<List<Permission>> listPermissions();

  /// Lists all user accounts.
  AsyncRequest<List<UserAccount>> listUserAccounts();

  /// Lists all user role assignments.
  AsyncRequest<List<UserRole>> listAllUserRoles();

  /// Authenticates a user by email and password.
  AsyncRequest<UserAccount> loginWithEmail(LoginParams params);

  /// Logs out the currently active in-memory session.
  AsyncRequest<void> logout();

  /// Returns the currently active in-memory authenticated user account.
  AsyncRequest<UserAccount?> getCurrentUserAccount();

  /// Provisions a Pathshala Administrator with credentials and scoped role.
  AsyncRequest<Map<String, dynamic>> createPathshalaAdmin(CreatePathshalaAdminParams params);

  /// Resets a user account password.
  AsyncRequest<void> resetUserPassword(ResetUserPasswordParams params);

  /// Executes the multi-step role assignment journey (resolving person, auth, IAM, and role scopes).
  AsyncRequest<Map<String, dynamic>> assignRoleJourney(AssignRoleJourneyParams params);
}
