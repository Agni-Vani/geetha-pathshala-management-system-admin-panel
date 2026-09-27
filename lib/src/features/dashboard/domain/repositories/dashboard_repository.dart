import '../../../../core/async_handlers/async_request.dart';
import '../entities/dashboard_overview.dart';
import '../params/get_dashboard_overview_params.dart';

abstract interface class DashboardRepository {
  AsyncRequest<DashboardOverview> getOverview({
    GetDashboardOverviewParams? params,
  });
}
