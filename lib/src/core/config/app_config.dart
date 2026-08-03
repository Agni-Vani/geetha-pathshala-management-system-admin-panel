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
    defaultValue: '',
  );

  /// Supabase Anon API Key passed via `--dart-define=SUPABASE_ANON_KEY=...`
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// Returns true if running in production mode.
  static bool get isProduction => environment.toLowerCase() == 'prod';

  /// Returns true if running in development mode.
  static bool get isDev => environment.toLowerCase() == 'dev';

  /// Returns true if valid Supabase URL & Anon Key were supplied via `--dart-define`.
  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
