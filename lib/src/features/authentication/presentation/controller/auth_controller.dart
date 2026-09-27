import 'package:flutter/material.dart';

import '../../../../core/async_handlers/response.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/usecases/usecases.dart';

class AuthController extends ChangeNotifier {
  final LoginWithEmail loginWithEmail;
  final Logout logoutUseCase;
  final GetCurrentUserAccount getCurrentUserAccount;
  final ListUserRoles listUserRoles;

  AuthController({
    required this.loginWithEmail,
    required this.logoutUseCase,
    required this.getCurrentUserAccount,
    required this.listUserRoles,
  });

  final ProcessStatusNotifier processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  UserAccount? _currentUser;
  UserAccount? get currentUser => _currentUser;

  List<UserRole> _roles = [];
  List<UserRole> get roles => _roles;

  bool get isAuthenticated => _currentUser != null;

  String get userRoleDisplay {
    if (_roles.any((r) => r.roleCode.toUpperCase() == 'SUPERADMIN')) {
      return 'Super Admin';
    }
    if (_roles.isNotEmpty) {
      return _roles.first.roleCode;
    }
    return 'Administrator';
  }

  Future<bool> checkInitialSession() async {
    processStatusNotifier.setLoading();
    notifyListeners();

    final response = await getCurrentUserAccount.call(const NoParams());
    if (response is SuccessRepoCall<UserAccount?> && response.data != null) {
      _currentUser = response.data;
      await _loadUserRoles(_currentUser!.id);
      processStatusNotifier.setEnabled();
      notifyListeners();
      return true;
    }

    _currentUser = null;
    _roles = [];
    processStatusNotifier.setEnabled();
    notifyListeners();
    return false;
  }

  Future<bool> login({
    required String email,
    required String password,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    processStatusNotifier.setLoading(message: 'Authenticating...');
    notifyListeners();

    final response = await loginWithEmail.call(
      LoginParams(email: email.trim(), password: password),
    );

    if (response is SuccessRepoCall<UserAccount> && response.data != null) {
      _currentUser = response.data;
      await _loadUserRoles(_currentUser!.id);
      processStatusNotifier.setEnabled();
      snackbarNotifier?.notifySuccess(message: 'স্বাগতম! সফলভাবে লগইন করা হয়েছে।');
      notifyListeners();
      return true;
    }

    processStatusNotifier.setError();
    final errorMessage = (response is FailedRepoCall)
        ? response.message
        : 'ইমেইল অথবা পাসওয়ার্ড সঠিক নয়।';
    snackbarNotifier?.notifyError(message: errorMessage);
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await logoutUseCase.call(const NoParams());
    _currentUser = null;
    _roles = [];
    notifyListeners();
  }

  Future<void> _loadUserRoles(String userAccountId) async {
    final rolesRes = await listUserRoles.call(userAccountId);
    if (rolesRes is SuccessRepoCall<List<UserRole>>) {
      _roles = rolesRes.data ?? [];
    }
  }
}
