import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'iam_datasource.dart';

final class MockIamDatasource implements IamDatasource {
  final Duration processingDelay;
  final List<UserAccountModel> _userAccounts;
  final List<RoleModel> _roles;
  final List<PermissionModel> _permissions;
  final List<UserRoleModel> _userRoles;
  final List<PermissionOverrideModel> _overrides;

  MockIamDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _userAccounts = _seedUserAccounts(),
       _roles = _seedRoles(),
       _permissions = _seedPermissions(),
       _userRoles = _seedUserRoles(),
       _overrides = _seedOverrides();

  @override
  Future<UserAccountModel> getUserAccount(String userAccountId) async {
    await _simulateProcessing();
    return _userAccounts.firstWhere(
      (account) => account.id == userAccountId,
      orElse: () => throw StateError('User account not found.'),
    );
  }

  @override
  Future<UserAccountModel> getUserAccountByAuthId(String authUserId) async {
    await _simulateProcessing();
    return _userAccounts.firstWhere(
      (account) => account.authUserId == authUserId,
      orElse: () => throw StateError('User account not found for auth ID.'),
    );
  }

  @override
  Future<List<UserRoleModel>> listUserRoles(String userAccountId) async {
    await _simulateProcessing();
    return _userRoles
        .where((role) => role.userAccountId == userAccountId)
        .toList();
  }

  @override
  Future<bool> checkPermission(CheckPermissionParams params) async {
    await _simulateProcessing();
    // 1. Check explicit override first
    final overrideMatches = _overrides.where(
      (o) =>
          o.userAccountId == params.userAccountId &&
          o.permissionCode == params.permissionCode &&
          o.isCurrentlyEffective,
    );
    if (overrideMatches.isNotEmpty) {
      return overrideMatches.first.isGranted;
    }

    // 2. Check roles
    final activeRoles = _userRoles.where(
      (r) => r.userAccountId == params.userAccountId && r.isCurrentlyEffective,
    );

    for (final ur in activeRoles) {
      final role = _roles.firstWhere(
        (r) => r.id == ur.roleId,
        orElse:
            () => RoleModel(
              id: '',
              code: '',
              name: '',
              scopeType: RoleScopeType.global,
              description: null,
              permissionCodes: [],
              createdAt: DateTime.now(),
            ),
      );
      if (role.permissionCodes.contains(params.permissionCode) ||
          role.permissionCodes.contains('*')) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<UserRoleModel> assignUserRole(AssignUserRoleParams params) async {
    await _simulateProcessing();
    final role = _roles.firstWhere(
      (r) => r.id == params.roleId,
      orElse: () => throw StateError('Role not found'),
    );

    final newRole = UserRoleModel(
      id: 'ur-${DateTime.now().millisecondsSinceEpoch}',
      userAccountId: params.userAccountId,
      roleId: params.roleId,
      roleCode: role.code,
      scopeOrganizationId: params.scopeOrganizationId,
      scopePathshalaId: params.scopePathshalaId,
      effectiveFrom: params.effectiveFrom,
      effectiveTo: params.effectiveTo,
      grantedByUserId: params.grantedByUserId,
      status: UserRoleStatus.active,
    );
    _userRoles.add(newRole);
    return newRole;
  }

  @override
  Future<List<RoleModel>> listRoles() async {
    await _simulateProcessing();
    return List.unmodifiable(_roles);
  }

  @override
  Future<List<PermissionModel>> listPermissions() async {
    await _simulateProcessing();
    return List.unmodifiable(_permissions);
  }

  Future<void> _simulateProcessing() async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
  }

  static List<UserAccountModel> _seedUserAccounts() {
    return [
      UserAccountModel(
        id: 'usr-admin-anirban',
        personId: 'person-anirban-sen',
        authUserId: 'auth-anirban-001',
        email: 'anirban@pathshala.org',
        status: AccountStatus.active,
        createdAt: DateTime(2026, 6, 30),
        updatedAt: DateTime(2026, 6, 30),
      ),
      UserAccountModel(
        id: 'usr-teacher-madhuri',
        personId: 'person-madhuri-das',
        authUserId: 'auth-madhuri-002',
        email: 'madhuri@pathshala.org',
        status: AccountStatus.active,
        createdAt: DateTime(2026, 6, 30),
        updatedAt: DateTime(2026, 6, 30),
      ),
    ];
  }

  static List<RoleModel> _seedRoles() {
    return [
      RoleModel(
        id: 'role-superadmin',
        code: 'SUPERADMIN',
        name: 'Central Super Admin',
        scopeType: RoleScopeType.global,
        description: 'Full administrative access across all organizations',
        permissionCodes: ['*'],
        createdAt: DateTime(2026, 6, 30),
      ),
      RoleModel(
        id: 'role-pathshala-admin',
        code: 'PATHSHALA_ADMIN',
        name: 'Pathshala Administrator',
        scopeType: RoleScopeType.pathshala,
        description: 'Local administration for assigned Pathshala',
        permissionCodes: [
          'registry.person.read',
          'registry.person.write',
          'education.attendance.write',
        ],
        createdAt: DateTime(2026, 6, 30),
      ),
    ];
  }

  static List<PermissionModel> _seedPermissions() {
    return [
      PermissionModel(
        id: 'perm-person-read',
        code: 'registry.person.read',
        name: 'Read Person Registry',
        module: 'registry',
        description: 'Allows reading person registry records',
        createdAt: DateTime(2026, 6, 30),
      ),
      PermissionModel(
        id: 'perm-person-write',
        code: 'registry.person.write',
        name: 'Write Person Registry',
        module: 'registry',
        description: 'Allows creating/modifying person registry records',
        createdAt: DateTime(2026, 6, 30),
      ),
      PermissionModel(
        id: 'perm-attendance-write',
        code: 'education.attendance.write',
        name: 'Write Attendance Records',
        module: 'education',
        description: 'Allows logging and submitting student attendance',
        createdAt: DateTime(2026, 6, 30),
      ),
    ];
  }

  static List<UserRoleModel> _seedUserRoles() {
    return [
      UserRoleModel(
        id: 'ur-anirban-superadmin',
        userAccountId: 'usr-admin-anirban',
        roleId: 'role-superadmin',
        roleCode: 'SUPERADMIN',
        scopeOrganizationId: 'org-gp-central',
        scopePathshalaId: null,
        effectiveFrom: DateTime(2026, 6, 30),
        effectiveTo: null,
        grantedByUserId: 'system',
        status: UserRoleStatus.active,
      ),
    ];
  }

  static List<PermissionOverrideModel> _seedOverrides() {
    return [];
  }
}
