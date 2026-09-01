class AppConfig {
  static const String appName = 'Tenlord Property';
  static const String appTagline = 'Smart PG & Property Management';
  static const String appVersion = '1.0.0';

  /// Toggle this to `false` when connecting to live production API.
  /// Defaults to `true` for mock demonstration mode.
  static const bool useMockData = true;

  static const String liveBaseUrl = 'https://dormly.in/api/v1';
  static const String localBaseUrl = 'http://localhost/hostel-management-saas/public/api/v1';

  static String get baseUrl => liveBaseUrl;
}
