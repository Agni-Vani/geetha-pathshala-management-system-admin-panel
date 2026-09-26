import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/dashboard/data/datasources/mock_dashboard_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/dashboard/data/repositories/dashboard_repository_impl.dart';

void main() {
  group('DashboardRepositoryImpl Tests', () {
    late MockDashboardDatasource mockDatasource;
    late DashboardRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockDashboardDatasource(processingDelay: Duration.zero);
      repository = DashboardRepositoryImpl(datasource: mockDatasource);
    });

    test('getOverview returns seeded dashboard overview data', () async {
      final response = await repository.getOverview();
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.stats.length, equals(4));
      expect(success.data.weeklyAttendance.length, equals(7));
      expect(success.data.recentNotices.length, greaterThanOrEqualTo(1));
      expect(success.data.upcomingEvents.length, greaterThanOrEqualTo(1));
      expect(success.data.genderDistribution.malePercentage, greaterThan(0));
    });
  });
}
