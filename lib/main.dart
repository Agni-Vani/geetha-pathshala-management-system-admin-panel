import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/config/app_config.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/features/registry/presentation/view/registry_route_builders.dart';
import 'src/features/registry/presentation/view/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.isSupabaseConfigured) {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      // ignore: deprecated_member_use
      anonKey: AppConfig.supabaseAnonKey,
    );
  }

  // Initialize DI service locator (defaults to mock datasources if Supabase credentials are not passed)
  await setupServiceLocator(useMockData: !AppConfig.isSupabaseConfigured);

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
