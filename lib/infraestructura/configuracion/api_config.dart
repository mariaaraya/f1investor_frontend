class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'http://127.0.0.1:5000';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}