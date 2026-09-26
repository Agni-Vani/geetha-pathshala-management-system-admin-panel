import '../models/dashboard_overview_model.dart';

abstract class DashboardDatasource {
  Future<DashboardOverviewModel> getOverview({String? pathshalaId});
}
