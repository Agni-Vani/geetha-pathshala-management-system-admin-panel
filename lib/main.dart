import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/config/app_config.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/core/navigation/app_route_builders.dart';
import 'src/core/utils/debug/debug_service.dart';
import 'src/features/authentication/presentation/view/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable all debug logging labels in development
  DebugService.instance(allowsOnly: DebugLabel.values.toSet());

  if (AppConfig.isSupabaseConfigured) {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      // ignore: deprecated_member_use
      anonKey: AppConfig.supabaseAnonKey,
    );
  }

  // Initialize DI service locator (uses live Supabase remote datasources by default)
  await setupServiceLocator(useMockData: !AppConfig.shouldUseRemote);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pathshala Management',
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      themeMode: ThemeMode.light,
      routes: RegistryRouteBuilders.routes,
      home: const SplashView(),
    );
  }
}
