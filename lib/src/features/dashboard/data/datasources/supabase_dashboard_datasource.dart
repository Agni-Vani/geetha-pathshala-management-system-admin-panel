import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/dashboard_overview_model.dart';
import 'dashboard_datasource.dart';
import 'mock_dashboard_datasource.dart';

class SupabaseDashboardDatasource implements DashboardDatasource {
  final SupabaseClient supabase;

  SupabaseDashboardDatasource({SupabaseClient? supabase})
      : supabase = supabase ?? Supabase.instance.client;

  @override
  Future<DashboardOverviewModel> getOverview({String? pathshalaId}) async {
    // When real aggregate edge functions or rpc endpoints are deployed, call them here.
    // Falls back to mock data datasource implementation until then.
    return MockDashboardDatasource(processingDelay: Duration.zero).getOverview(
      pathshalaId: pathshalaId,
    );
  }
}
