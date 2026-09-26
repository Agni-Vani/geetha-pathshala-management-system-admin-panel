import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/dashboard_domain.dart';
import '../datasources/dashboard_datasource.dart';

final class DashboardRepositoryImpl
    with ErrorHandler
    implements DashboardRepository {
  final DashboardDatasource datasource;

  const DashboardRepositoryImpl({required this.datasource});

  @override
  AsyncRequest<DashboardOverview> getOverview({
    GetDashboardOverviewParams? params,
  }) {
    return _request(() => datasource.getOverview(pathshalaId: params?.pathshalaId));
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
