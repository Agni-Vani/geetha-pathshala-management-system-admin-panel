import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/params/params.dart';
import '../models/models.dart';
import 'iam_datasource.dart';

final class SupabaseIamDatasource implements IamDatasource {
  final SupabaseClient client;

  SupabaseIamDatasource({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  Future<dynamic> _invoke(String action, Map<String, dynamic> body) async {
    debugPrint('🌐 [SupabaseIamDatasource] Calling iam-api ($action)...');
    final response = await client.functions.invoke(
      'iam-api',
      body: {'action': action, ...body},
    );
    debugPrint('🌐 [SupabaseIamDatasource] iam-api ($action) response status: ${response.status}');

    if (response.status != 200) {
      debugPrint('❌ [SupabaseIamDatasource] iam-api ($action) failed: ${response.data}');
      throw StateError('Edge Function error (${response.status}): ${response.data}');
    }

    final data = response.data;
    if (data is Map && data['success'] == false) {
      final err = data['error']?.toString() ?? 'IAM API error';
      debugPrint('❌ [SupabaseIamDatasource] iam-api returned error: $err');
      throw StateError(err);
    }

    return data;
  }

  @override
  Future<UserAccountModel> getUserAccount(String userAccountId) async {
    final data = await _invoke('getUserAccount', {
      'userAccountId': userAccountId,
    });
    return UserAccountModel.fromJson(_normalizeUserAccount(data as Map<String, dynamic>));
  }

  @override
  Future<UserAccountModel> getUserAccountByAuthId(String authUserId) async {
    final data = await _invoke('getUserAccountByAuthId', {
      'authUserId': authUserId,
    });
    return UserAccountModel.fromJson(_normalizeUserAccount(data as Map<String, dynamic>));
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
        .map((json) => UserRoleModel.fromJson(_normalizeUserRole(json as Map<String, dynamic>)))
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
    return UserRoleModel.fromJson(_normalizeUserRole(data as Map<String, dynamic>));
  }

  @override
  Future<List<RoleModel>> listRoles() async {
    final data = await _invoke('listRoles', {});
    final list =
        (data is Map && data['data'] is List)
            ? data['data'] as List
            : data as List;
    return list
        .map((json) => RoleModel.fromJson(_normalizeRole(json as Map<String, dynamic>)))
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
        .map((json) => PermissionModel.fromJson(_normalizePermission(json as Map<String, dynamic>)))
        .toList();
  }

  @override
  Future<UserAccountModel> loginWithEmail(LoginParams params) async {
    debugPrint('🌐 [SupabaseIamDatasource] Calling client.auth.signInWithPassword for: ${params.email}');
    try {
      final authResponse = await client.auth.signInWithPassword(
        email: params.email,
        password: params.password,
      );

      debugPrint('🌐 [SupabaseIamDatasource] signInWithPassword returned user ID: ${authResponse.user?.id}');

      if (authResponse.user == null) {
        throw StateError('Authentication failed: Invalid credentials');
      }

      return await getUserAccountByAuthId(authResponse.user!.id);
    } catch (e) {
      debugPrint('❌ [SupabaseIamDatasource] signInWithPassword error: $e');
      rethrow;
    }
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

  Map<String, dynamic> _normalizeUserAccount(Map<String, dynamic> json) {
    return {
      'id': json['id']?.toString() ?? '',
      'personId': (json['personId'] ?? json['person_id'])?.toString() ?? '',
      'authUserId': (json['authUserId'] ?? json['auth_user_id'])?.toString(),
      'email': json['email']?.toString() ?? '',
      'status': json['status']?.toString() ?? 'active',
      'createdAt': (json['createdAt'] ?? json['created_at'])?.toString() ??
          DateTime.now().toIso8601String(),
      'updatedAt': (json['updatedAt'] ?? json['updated_at'])?.toString() ??
          DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> _normalizeUserRole(Map<String, dynamic> json) {
    return {
      'id': json['id']?.toString() ?? '',
      'userAccountId':
          (json['userAccountId'] ?? json['user_account_id'])?.toString() ?? '',
      'roleId': (json['roleId'] ?? json['role_id'])?.toString() ?? '',
      'roleCode': (json['roleCode'] ?? json['role_code'])?.toString() ?? '',
      'scopeOrganizationId':
          (json['scopeOrganizationId'] ?? json['scope_organization_id'])?.toString(),
      'scopePathshalaId':
          (json['scopePathshalaId'] ?? json['scope_pathshala_id'])?.toString(),
      'effectiveFrom':
          (json['effectiveFrom'] ?? json['effective_from'])?.toString() ??
              DateTime.now().toIso8601String(),
      'effectiveTo':
          (json['effectiveTo'] ?? json['effective_to'])?.toString(),
      'grantedByUserId':
          (json['grantedByUserId'] ?? json['granted_by_user_id'])?.toString(),
      'status': json['status']?.toString() ?? 'active',
    };
  }

  Map<String, dynamic> _normalizeRole(Map<String, dynamic> json) {
    return {
      'id': json['id']?.toString() ?? '',
      'code': json['code']?.toString() ?? '',
      'name': json['name']?.toString() ?? '',
      'scopeType': (json['scopeType'] ?? json['scope_type'])?.toString() ?? 'global',
      'description': json['description']?.toString(),
      'permissionCodes': json['permissionCodes'] ?? json['permission_codes'] ?? <dynamic>[],
      'createdAt': (json['createdAt'] ?? json['created_at'])?.toString() ??
          DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> _normalizePermission(Map<String, dynamic> json) {
    return {
      'id': json['id']?.toString() ?? '',
      'code': json['code']?.toString() ?? '',
      'name': json['name']?.toString() ?? '',
      'module': json['module']?.toString() ?? '',
      'description': json['description']?.toString(),
      'createdAt': (json['createdAt'] ?? json['created_at'])?.toString() ??
          DateTime.now().toIso8601String(),
    };
  }
}
