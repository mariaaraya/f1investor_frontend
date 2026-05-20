import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../infraestructura/configuracion/api_config.dart';

class ApiServicio {
  ApiServicio();

  final Map<String, String> _headersBase = const {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Uri _construirUrl(String endpoint) {
    return Uri.parse('${ApiConfig.baseUrl}$endpoint');
  }

  Map<String, String> _construirHeaders({String? token}) {
    final headers = Map<String, String>.from(_headersBase);

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    try {
      final response = await http
          .get(
            _construirUrl(endpoint),
            headers: _construirHeaders(token: token),
          )
          .timeout(ApiConfig.connectTimeout);

      return _procesarRespuesta(response);
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } catch (error) {
      throw Exception('Error de conexión con el servidor: $error');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final response = await http
          .post(
            _construirUrl(endpoint),
            headers: _construirHeaders(token: token),
            body: jsonEncode(body ?? {}),
          )
          .timeout(ApiConfig.connectTimeout);

      return _procesarRespuesta(response);
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } catch (error) {
      throw Exception('Error de conexión con el servidor: $error');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final response = await http
          .put(
            _construirUrl(endpoint),
            headers: _construirHeaders(token: token),
            body: jsonEncode(body ?? {}),
          )
          .timeout(ApiConfig.connectTimeout);

      return _procesarRespuesta(response);
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } catch (error) {
      throw Exception('Error de conexión con el servidor: $error');
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? token,
  }) async {
    try {
      final response = await http
          .delete(
            _construirUrl(endpoint),
            headers: _construirHeaders(token: token),
          )
          .timeout(ApiConfig.connectTimeout);

      return _procesarRespuesta(response);
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } catch (error) {
      throw Exception('Error de conexión con el servidor: $error');
    }
  }

  Map<String, dynamic> _procesarRespuesta(http.Response response) {
    final Map<String, dynamic> body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    throw Exception(
      body['message'] ??
          body['error'] ??
          body['msg'] ??
          'Error al comunicarse con el servidor',
    );
  }
}