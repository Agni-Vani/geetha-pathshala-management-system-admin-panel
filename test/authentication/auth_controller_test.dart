import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/features/authentication/data/datasources/mock_iam_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/authentication/data/repositories/iam_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/authentication/domain/usecases/usecases.dart';
import 'package:geetha_pathshala_management_web/src/features/authentication/presentation/controller/auth_controller.dart';

void main() {
  group('AuthController Tests', () {
    late MockIamDatasource mockDatasource;
    late IamRepositoryImpl repository;
    late AuthController controller;

    setUp(() {
      mockDatasource = MockIamDatasource(processingDelay: Duration.zero);
      repository = IamRepositoryImpl(datasource: mockDatasource);
      controller = AuthController(
        loginWithEmail: LoginWithEmail(repository: repository),
        logoutUseCase: Logout(repository: repository),
        getCurrentUserAccount: GetCurrentUserAccount(repository: repository),
        listUserRoles: ListUserRoles(repository: repository),
      );
    });

    test('Initial state is unauthenticated', () async {
      expect(controller.isAuthenticated, isFalse);
      expect(controller.currentUser, isNull);
      expect(controller.roles, isEmpty);

      final hasSession = await controller.checkInitialSession();
      expect(hasSession, isFalse);
    });

    test('Login with first admin (arrow360degree@gmail.com) succeeds with Super Admin role', () async {
      final success = await controller.login(
        email: 'arrow360degree@gmail.com',
        password: 'Admin@123456',
      );

      expect(success, isTrue);
      expect(controller.isAuthenticated, isTrue);
      expect(controller.currentUser?.email, equals('arrow360degree@gmail.com'));
      expect(controller.roles.length, equals(1));
      expect(controller.roles.first.roleCode, equals('SUPERADMIN'));
      expect(controller.userRoleDisplay, equals('Super Admin'));

      // Check session persists
      final hasSession = await controller.checkInitialSession();
      expect(hasSession, isTrue);
    });

    test('Login with invalid email fails gracefully', () async {
      final success = await controller.login(
        email: 'invalid@example.com',
        password: 'wrongpassword',
      );

      expect(success, isFalse);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.currentUser, isNull);
    });

    test('Logout clears user session and roles', () async {
      await controller.login(
        email: 'arrow360degree@gmail.com',
        password: 'Admin@123456',
      );
      expect(controller.isAuthenticated, isTrue);

      await controller.logout();
      expect(controller.isAuthenticated, isFalse);
      expect(controller.currentUser, isNull);
      expect(controller.roles, isEmpty);

      final hasSession = await controller.checkInitialSession();
      expect(hasSession, isFalse);
    });
  });
}
