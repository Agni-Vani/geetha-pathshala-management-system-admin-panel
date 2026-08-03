import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'iam_datasource.dart';

final class SupabaseIamDatasource implements IamDatasource {
  final SupabaseClient client;

  SupabaseIamDatasource({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  @override
  Future<UserAccountModel> getUserAccount(String userAccountId) async {
    final response = await client
        .schema('iam')
        .from('user_accounts')
        .select()
        .eq('id', userAccountId)
        .single();
    return UserAccountModel.fromJson(response);
  }

  @override
  Future<UserAccountModel> getUserAccountByAuthId(String authUserId) async {
    final response = await client
        .schema('iam')
        .from('user_accounts')
        .select()
        .eq('auth_user_id', authUserId)
        .single();
    return UserAccountModel.fromJson(response);
  }

  @override
  Future<List<UserRoleModel>> listUserRoles(String userAccountId) async {
    final response = await client
        .schema('iam')
        .from('user_roles')
        .select()
        .eq('user_account_id', userAccountId);
    return (response as List)
        .map((json) => UserRoleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> checkPermission(CheckPermissionParams params) async {
    final response = await client.rpc(
      'has_permission',
      params: {
        'user_id': params.userAccountId,
        'permission': params.permissionCode,
        'org_id': params.scopeOrganizationId,
        'pathshala_id': params.scopePathshalaId,
      },
    );
    return response as bool? ?? false;
  }

  @override
  Future<UserRoleModel> assignUserRole(AssignUserRoleParams params) async {
    final response = await client
        .schema('iam')
        .from('user_roles')
        .insert({
          'user_account_id': params.userAccountId,
          'role_id': params.roleId,
          'role_code': 'ROLE',
          'scope_organization_id': params.scopeOrganizationId,
          'scope_pathshala_id': params.scopePathshalaId,
          'effective_from': params.effectiveFrom.toIso8601String(),
          'effective_to': params.effectiveTo?.toIso8601String(),
          'granted_by_user_id': params.grantedByUserId,
          'status': 'active',
        })
        .select()
        .single();
    return UserRoleModel.fromJson(response);
  }

  @override
  Future<List<RoleModel>> listRoles() async {
    final response = await client.schema('iam').from('roles').select();
    return (response as List)
        .map((json) => RoleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PermissionModel>> listPermissions() async {
    final response = await client.schema('iam').from('permissions').select();
    return (response as List)
        .map((json) => PermissionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<UserAccountModel> loginWithEmail(LoginParams params) async {
    final authResponse = await client.auth.signInWithPassword(
      email: params.email,
      password: params.password,
    );

    if (authResponse.user == null) {
      throw StateError('Authentication failed: Invalid credentials');
    }

    return getUserAccountByAuthId(authResponse.user!.id);
  }

  @override
  Future<void> logout() async {
    await client.auth.signOut();
  }

  @override
  Future<UserAccountModel?> getCurrentUserAccount() async {
    final currentAuthUser = client.auth.currentUser;
    if (currentAuthUser == null) return null;
    return getUserAccountByAuthId(currentAuthUser.id);
  }
}
