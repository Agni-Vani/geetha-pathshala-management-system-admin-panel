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

  bool get isSuperAdmin =>
      _roles.any((r) =>
          r.roleCode.toUpperCase() == 'SUPERADMIN' ||
          r.roleCode.toUpperCase() == 'SUPER_ADMIN');

  String get userRoleDisplay {
    if (isSuperAdmin) {
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

      // Gatekeeper: Reject non-superadmins from accessing the central panel
      if (!isSuperAdmin) {
        debugPrint(
            '⛔ [AuthController] User ${_currentUser!.email} lacks Super Admin role. Revoking session.');
        await logout();
        processStatusNotifier.setEnabled();
        notifyListeners();
        return false;
      }

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

    debugPrint('🔑 [AuthController] Attempting login for email: $email');

    final response = await loginWithEmail.call(
      LoginParams(email: email.trim(), password: password),
    );

    if (response is SuccessRepoCall<UserAccount> && response.data != null) {
      _currentUser = response.data;
      debugPrint('✅ [AuthController] Authentication successful for user ID: ${_currentUser!.id}, personId: ${_currentUser!.personId}');
      await _loadUserRoles(_currentUser!.id);

      // Gatekeeper: Only Super Admins can log in to the Central Super Admin portal
      if (!isSuperAdmin) {
        debugPrint('⛔ [AuthController] Login denied: ${_currentUser!.email} is not a Super Admin.');
        await logout();
        processStatusNotifier.setError();
        snackbarNotifier?.notifyError(
          message: 'অনুমতি নেই: এই পোর্টালে শুধুমাত্র কেন্দ্রীয় সুপার অ্যাডমিন প্রবেশ করতে পারবেন। পাঠশালা অ্যাডমিনদের জন্য পৃথক পোর্টাল ব্যবহৃত হবে।',
        );
        notifyListeners();
        return false;
      }

      processStatusNotifier.setEnabled();
      snackbarNotifier?.notifySuccess(message: 'স্বাগতম! সফলভাবে লগইন করা হয়েছে।');
      notifyListeners();
      return true;
    }

    processStatusNotifier.setError();
    final errorMessage = (response is FailedRepoCall)
        ? response.message
        : 'ইমেইল অথবা পাসওয়ার্ড সঠিক নয়।';
    debugPrint('❌ [AuthController] Login failed: $errorMessage');
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
