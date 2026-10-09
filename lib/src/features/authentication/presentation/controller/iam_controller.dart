import 'package:flutter/foundation.dart';

import '../../../../core/async_handlers/response.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../../../pathshala/domain/entities/pathshala.dart';
import '../../../pathshala/domain/params/list_pathshalas_params.dart';
import '../../../pathshala/domain/usecases/list_pathshalas.dart';
import '../../../person/domain/entities/person.dart';
import '../../../person/domain/params/search_people_params.dart';
import '../../../person/domain/usecases/search_people.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/iam_repository.dart';
import '../../domain/usecases/usecases.dart';

class IamController extends ChangeNotifier {
  final ListUserAccounts listUserAccountsUseCase;
  final ListRoles listRolesUseCase;
  final ListPermissions listPermissionsUseCase;
  final AssignUserRole assignUserRoleUseCase;
  final CreatePathshalaAdmin createPathshalaAdminUseCase;
  final ResetUserPassword resetUserPasswordUseCase;
  final IamRepository iamRepository;
  final SearchPeople searchPeopleUseCase;
  final ListPathshalas listPathshalasUseCase;

  IamController({
    required this.listUserAccountsUseCase,
    required this.listRolesUseCase,
    required this.listPermissionsUseCase,
    required this.assignUserRoleUseCase,
    required this.createPathshalaAdminUseCase,
    required this.resetUserPasswordUseCase,
    required this.iamRepository,
    required this.searchPeopleUseCase,
    required this.listPathshalasUseCase,
  });

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  List<UserAccount> _users = [];
  List<UserAccount> get users => _users;

  List<Role> _roles = [];
  List<Role> get roles => _roles;

  List<Permission> _permissions = [];
  List<Permission> get permissions => _permissions;

  List<UserRole> _allUserRoles = [];
  List<UserRole> get allUserRoles => _allUserRoles;

  Map<String, Person> _personMap = {};
  Map<String, Person> get personMap => _personMap;

  List<Pathshala> _pathshalas = [];
  List<Pathshala> get pathshalas => _pathshalas;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String? _selectedRoleFilter;
  String? get selectedRoleFilter => _selectedRoleFilter;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setRoleFilter(String? roleCode) {
    _selectedRoleFilter = roleCode;
    notifyListeners();
  }

  List<UserAccount> get filteredUsers {
    return _users.where((user) {
      final matchesSearch = _searchQuery.isEmpty ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (_personMap[user.personId]?.displayName.toLowerCase() ?? '')
              .contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_selectedRoleFilter != null && _selectedRoleFilter!.isNotEmpty) {
        final userRoles = _allUserRoles.where((r) => r.userAccountId == user.id);
        final hasRole = userRoles.any((r) =>
            r.roleCode.toUpperCase() == _selectedRoleFilter!.toUpperCase() &&
            r.isCurrentlyEffective);
        if (!hasRole) return false;
      }

      return true;
    }).toList();
  }

  List<UserRole> rolesForUser(String userAccountId) {
    return _allUserRoles
        .where((r) => r.userAccountId == userAccountId && r.isCurrentlyEffective)
        .toList();
  }

  Future<void> loadData() async {
    processStatusNotifier.setLoading(message: 'Loading IAM data...');
    notifyListeners();

    try {
      final accountsRes = await listUserAccountsUseCase(const NoParams());
      if (accountsRes is SuccessRepoCall<List<UserAccount>>) {
        _users = accountsRes.data ?? [];
      }

      final rolesRes = await listRolesUseCase(const NoParams());
      if (rolesRes is SuccessRepoCall<List<Role>>) {
        _roles = rolesRes.data ?? [];
      }

      final permissionsRes = await listPermissionsUseCase(const NoParams());
      if (permissionsRes is SuccessRepoCall<List<Permission>>) {
        _permissions = permissionsRes.data ?? [];
      }

      final allRolesRes = await iamRepository.listAllUserRoles();
      if (allRolesRes is SuccessRepoCall<List<UserRole>>) {
        _allUserRoles = allRolesRes.data ?? [];
      }

      final peopleRes = await searchPeopleUseCase(
        const SearchPeopleParams(
          organizationId: AppConfig.defaultOrganizationId,
          pageSize: 100,
        ),
      );
      if (peopleRes is SuccessRepoCall<List<Person>>) {
        _personMap = {for (final p in (peopleRes.data ?? [])) p.id: p};
      }

      final pathshalasRes = await listPathshalasUseCase(
        const ListPathshalasParams(
          organizationId: AppConfig.defaultOrganizationId,
          pageSize: 100,
        ),
      );
      if (pathshalasRes is SuccessRepoCall<List<Pathshala>>) {
        _pathshalas = pathshalasRes.data ?? [];
      }

      processStatusNotifier.setEnabled();
    } catch (e) {
      debugPrint('❌ [IamController] loadData error: $e');
      processStatusNotifier.setError();
    } finally {
      notifyListeners();
    }
  }

  Future<bool> assignRole({
    required String userAccountId,
    required String roleId,
    RoleScopeType scopeType = RoleScopeType.global,
    String? scopePathshalaId,
    String? scopeOrganizationId,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    processStatusNotifier.setLoading(message: 'Assigning role...');
    notifyListeners();

    final params = AssignUserRoleParams(
      userAccountId: userAccountId,
      roleId: roleId,
      scopeOrganizationId: scopeOrganizationId,
      scopePathshalaId: scopePathshalaId,
      effectiveFrom: DateTime.now(),
    );

    final result = await assignUserRoleUseCase(params);
    if (result is SuccessRepoCall<UserRole>) {
      snackbarNotifier?.notifySuccess(message: 'ভূমিকা সফলভাবে বরাদ্দ করা হয়েছে।');
      await loadData();
      return true;
    }

    final errorMsg = (result is FailedRepoCall)
        ? result.message
        : 'ভূমিকা বরাদ্দ করতে সমস্যা হয়েছে।';
    snackbarNotifier?.notifyError(message: errorMsg);
    processStatusNotifier.setError();
    notifyListeners();
    return false;
  }

  Future<bool> createPathshalaAdmin({
    required CreatePathshalaAdminParams params,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    processStatusNotifier.setLoading(message: 'পাঠশালা প্রশাসক তৈরি হচ্ছে...');
    notifyListeners();

    final result = await createPathshalaAdminUseCase(params);
    if (result is SuccessRepoCall<UserAccount>) {
      snackbarNotifier?.notifySuccess(
        message: 'পাঠশালা প্রশাসক সফলভাবে তৈরি করা হয়েছে।',
      );
      await loadData();
      return true;
    }

    final errorMsg = (result is FailedRepoCall)
        ? result.message
        : 'পাঠশালা প্রশাসক তৈরি করতে সমস্যা হয়েছে।';
    snackbarNotifier?.notifyError(message: errorMsg);
    processStatusNotifier.setError();
    notifyListeners();
    return false;
  }

  Future<bool> resetUserPassword({
    required String userAccountId,
    String? email,
    required String newPassword,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    processStatusNotifier.setLoading(message: 'পাসওয়ার্ড পরিবর্তন করা হচ্ছে...');
    notifyListeners();

    final result = await resetUserPasswordUseCase(
      ResetUserPasswordParams(
        userAccountId: userAccountId,
        email: email,
        newPassword: newPassword,
      ),
    );
    if (result is SuccessRepoCall<void>) {
      snackbarNotifier?.notifySuccess(
        message: 'পাসওয়ার্ড সফলভাবে পরিবর্তন করা হয়েছে।',
      );
      processStatusNotifier.setEnabled();
      notifyListeners();
      return true;
    }

    final errorMsg = (result is FailedRepoCall)
        ? result.message
        : 'পাসওয়ার্ড পরিবর্তন করতে সমস্যা হয়েছে।';
    snackbarNotifier?.notifyError(message: errorMsg);
    processStatusNotifier.setError();
    notifyListeners();
    return false;
  }
}

