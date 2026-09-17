import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/view/registry_route_builders.dart';

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await setupServiceLocator(useMockData: true);
  });

  Future<void> boot(WidgetTester tester, String route) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(393, 900);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme().lightTheme,
      initialRoute: route,
      routes: RegistryRouteBuilders.routes,
    ));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    while (tester.takeException() != null) {}
  }

  testWidgets('attendance', (tester) async {
    await boot(tester, '/attendance');
    final btn = tester.getRect(find.text('Export Report'));
    final grid = tester.getRect(find.byType(GridView).first);
    debugPrint('ATT button bottom=${btn.bottom} grid top=${grid.top} gap=${grid.top - btn.bottom}');
  });

  testWidgets('dashboard', (tester) async {
    await boot(tester, '/dashboard');
    final sub = tester.getRect(find.textContaining('স্বাগতম'));
    final grid = tester.getRect(find.byType(GridView).first);
    debugPrint('DASH subtitle bottom=${sub.bottom} grid top=${grid.top} gap=${grid.top - sub.bottom}');
  });

  testWidgets('people', (tester) async {
    await boot(tester, '/people-registry');
    final bar = tester.getRect(find.byType(TextField).last);
    final grid = tester.getRect(find.byType(GridView).first);
    debugPrint('PEOPLE search bottom=${bar.bottom} grid top=${grid.top} gap=${grid.top - bar.bottom}');
  });
}
