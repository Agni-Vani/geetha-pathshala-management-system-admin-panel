import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/dashboard_overview.dart';
import '../params/get_dashboard_overview_params.dart';
import '../repositories/dashboard_repository.dart';

final class GetDashboardOverview
    implements AsyncUsecase<DashboardOverview, GetDashboardOverviewParams> {
  final DashboardRepository repository;

  const GetDashboardOverview({required this.repository});

  @override
  AsyncRequest<DashboardOverview> call(GetDashboardOverviewParams params) {
    return repository.getOverview(params: params);
  }
}
