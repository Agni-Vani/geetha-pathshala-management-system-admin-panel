/// Centralized App Configuration powered by build-time `--dart-define` variables.
final class AppConfig {
  const AppConfig._();

  /// Target environment identifier ('dev' or 'prod')
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  /// Supabase Project URL passed via `--dart-define=SUPABASE_URL=...`
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://isqtmsisslwtvtuuvbfl.supabase.co',
  );

  /// Supabase Anon API Key passed via `--dart-define=SUPABASE_ANON_KEY=...`
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlzcXRtc2lzc2x3dHZ0dXV2YmZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU3NDA4MjIsImV4cCI6MjEwMTMxNjgyMn0.cnwXiT8kk-fbTt0uv0FS6BbPDBh9dclm1BQcaSMohj8',
  );

  /// Force mock data override flag: `--dart-define=FORCE_MOCK_DATA=true`
  static const bool forceMockData = bool.fromEnvironment(
    'FORCE_MOCK_DATA',
    defaultValue: false,
  );

  /// Returns true if running in production mode.
  static bool get isProduction => environment.toLowerCase() == 'prod';

  /// Returns true if running in development mode.
  static bool get isDev => environment.toLowerCase() == 'dev';

  /// Returns true if valid Supabase URL & Anon Key are available.
  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Returns true if the application should use live remote datasources.
  static bool get shouldUseRemote => isSupabaseConfigured && !forceMockData;
}
