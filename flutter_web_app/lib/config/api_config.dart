class ApiConfig {
  static const String baseUrl =
      String.fromEnvironment(
       'API_BASE_URL',
        defaultValue: 'http://76.13.210.38:5000/api',
      );
}