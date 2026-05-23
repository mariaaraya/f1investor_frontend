class ApiConfig {
  ApiConfig._();

static const String baseUrl = 'http://192.168.0.11:5000';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}