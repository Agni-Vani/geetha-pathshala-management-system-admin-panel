import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'iam_datasource.dart';

final class SupabaseIamDatasource implements IamDatasource {
  final SupabaseClient client;

  SupabaseIamDatasource({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  Future<dynamic> _invoke(String action, Map<String, dynamic> body) async {
    final response = await client.functions.invoke(
      'iam-api',
      body: {'action': action, ...body},
    );
    if (response.status != 200) {
      throw StateError('Edge Function error: ${response.data}');
    }
    return response.data;
  }

  @override
  Future<UserAccountModel> getUserAccount(String userAccountId) async {
    final data = await _invoke('getUserAccount', {
      'userAccountId': userAccountId,
    });
    return UserAccountModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<UserAccountModel> getUserAccountByAuthId(String authUserId) async {
    final data = await _invoke('getUserAccountByAuthId', {
      'authUserId': authUserId,
    });
    return UserAccountModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<UserRoleModel>> listUserRoles(String userAccountId) async {
    final data = await _invoke('listUserRoles', {
      'userAccountId': userAccountId,
    });
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map((json) => UserRoleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> checkPermission(CheckPermissionParams params) async {
    final data = await _invoke('checkPermission', {
      'userAccountId': params.userAccountId,
      'permissionCode': params.permissionCode,
      'scopeOrganizationId': params.scopeOrganizationId,
      'scopePathshalaId': params.scopePathshalaId,
    });
    return (data is Map && data['isGranted'] != null)
        ? data['isGranted'] as bool
        : data as bool;
  }

  @override
  Future<UserRoleModel> assignUserRole(AssignUserRoleParams params) async {
    final data = await _invoke('assignUserRole', {
      'userAccountId': params.userAccountId,
      'roleId': params.roleId,
      'scopeOrganizationId': params.scopeOrganizationId,
      'scopePathshalaId': params.scopePathshalaId,
      'effectiveFrom': params.effectiveFrom.toIso8601String(),
      'effectiveTo': params.effectiveTo?.toIso8601String(),
      'grantedByUserId': params.grantedByUserId,
    });
    return UserRoleModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<RoleModel>> listRoles() async {
    final data = await _invoke('listRoles', {});
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map((json) => RoleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PermissionModel>> listPermissions() async {
    final data = await _invoke('listPermissions', {});
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
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
