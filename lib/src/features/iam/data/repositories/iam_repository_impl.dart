import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

final class IamRepositoryImpl with ErrorHandler implements IamRepository {
  final IamDatasource datasource;

  const IamRepositoryImpl({required this.datasource});

  @override
  AsyncRequest<UserAccount> getUserAccount(String userAccountId) {
    return _request(() => datasource.getUserAccount(userAccountId));
  }

  @override
  AsyncRequest<UserAccount> getUserAccountByAuthId(String authUserId) {
    return _request(() => datasource.getUserAccountByAuthId(authUserId));
  }

  @override
  AsyncRequest<List<UserRole>> listUserRoles(String userAccountId) {
    return _request(() => datasource.listUserRoles(userAccountId));
  }

  @override
  AsyncRequest<bool> checkPermission(CheckPermissionParams params) {
    return _request(() => datasource.checkPermission(params));
  }

  @override
  AsyncRequest<UserRole> assignUserRole(AssignUserRoleParams params) {
    return _request(() => datasource.assignUserRole(params));
  }

  @override
  AsyncRequest<List<Role>> listRoles() {
    return _request(() => datasource.listRoles());
  }

  @override
  AsyncRequest<List<Permission>> listPermissions() {
    return _request(() => datasource.listPermissions());
  }

  AsyncRequest<T> _request<T>(Future<T> Function() request) {
    return asyncTryCatch<T>(
      tryFunc: () async {
        final data = await request();
        return SuccessRepoCall<T>(data: data);
      },
    );
  }
}
