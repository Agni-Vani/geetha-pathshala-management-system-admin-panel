import '../../domain/params/params.dart';
import '../models/models.dart';

abstract class IamDatasource {
  Future<UserAccountModel> getUserAccount(String userAccountId);
  Future<UserAccountModel> getUserAccountByAuthId(String authUserId);
  Future<List<UserRoleModel>> listUserRoles(String userAccountId);
  Future<bool> checkPermission(CheckPermissionParams params);
  Future<UserRoleModel> assignUserRole(AssignUserRoleParams params);
  Future<List<RoleModel>> listRoles();
  Future<List<PermissionModel>> listPermissions();
  Future<UserAccountModel> loginWithEmail(LoginParams params);
  Future<List<UserAccountModel>> listUserAccounts();
  Future<List<UserRoleModel>> listAllUserRoles();
  Future<void> logout();
  Future<UserAccountModel?> getCurrentUserAccount();
  Future<Map<String, dynamic>> createPathshalaAdmin(CreatePathshalaAdminParams params);
  Future<void> resetUserPassword(ResetUserPasswordParams params);
  Future<Map<String, dynamic>> assignRoleJourney(AssignRoleJourneyParams params);
}
