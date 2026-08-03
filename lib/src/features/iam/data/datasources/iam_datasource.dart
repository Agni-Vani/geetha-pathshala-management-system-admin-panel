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
  Future<void> logout();
  Future<UserAccountModel?> getCurrentUserAccount();
}
