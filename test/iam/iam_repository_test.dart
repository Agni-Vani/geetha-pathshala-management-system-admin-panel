import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/iam/data/datasources/mock_iam_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/iam/data/repositories/iam_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/iam/domain/params/params.dart';

void main() {
  group('IamRepositoryImpl Tests', () {
    late MockIamDatasource mockDatasource;
    late IamRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockIamDatasource(processingDelay: Duration.zero);
      repository = IamRepositoryImpl(datasource: mockDatasource);
    });

    test('getUserAccount returns user account by ID', () async {
      final response = await repository.getUserAccount('usr-admin-anirban');
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.id, equals('usr-admin-anirban'));
    });

    test('checkPermission returns true for superadmin permission check', () async {
      final response = await repository.checkPermission(
        const CheckPermissionParams(
          userAccountId: 'usr-admin-anirban',
          permissionCode: 'registry.person.read',
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data, isTrue);
    });

    test('loginWithEmail authenticates and tracks in-memory session', () async {
      final loginResponse = await repository.loginWithEmail(
        const LoginParams(
          email: 'anirban@pathshala.org',
          password: 'password123',
        ),
      );
      expect(loginResponse, isA<SuccessRepoCall>());
      final loginSuccess = loginResponse as SuccessRepoCall;
      expect(loginSuccess.data.id, equals('usr-admin-anirban'));

      final sessionResponse = await repository.getCurrentUserAccount();
      expect(sessionResponse, isA<SuccessRepoCall>());
      final sessionSuccess = sessionResponse as SuccessRepoCall;
      expect(sessionSuccess.data?.id, equals('usr-admin-anirban'));

      await repository.logout();

      final loggedOutSession = await repository.getCurrentUserAccount();
      expect(loggedOutSession, isA<SuccessRepoCall>());
      final loggedOutSuccess = loggedOutSession as SuccessRepoCall;
      expect(loggedOutSuccess.data, isNull);
    });
  });
}
