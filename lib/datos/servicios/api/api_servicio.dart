import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../infraestructura/configuracion/api_config.dart';

class ApiServicio {
  ApiServicio();

  final Map<String, String> _headersBase = const {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Uri _construirUrl(String endpoint) {
    final String baseUrl = ApiConfig.baseUrl.endsWith('/')
        ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
        : ApiConfig.baseUrl;

    final String endpointLimpio = endpoint.startsWith('/')
        ? endpoint
        : '/$endpoint';

    return Uri.parse('$baseUrl$endpointLimpio');
  }

  Map<String, String> _construirHeaders({String? token}) {
    final Map<String, String> headers = Map<String, String>.from(_headersBase);

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    try {
      final Uri url = _construirUrl(endpoint);
      final Map<String, String> headers = _construirHeaders(token: token);

      debugPrint('==================== API GET ====================');
      debugPrint('GET URL: $url');
      debugPrint('TOKEN PRESENTE: ${token != null && token.isNotEmpty}');
      debugPrint('HEADERS: $headers');

      final http.Response response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(ApiConfig.connectTimeout);

      debugPrint('GET STATUS CODE: ${response.statusCode}');
      debugPrint('GET RESPONSE BODY: ${response.body}');
      debugPrint('=================================================');

      return _procesarRespuesta(response);
    } on TimeoutException {
      debugPrint('ERROR GET: Timeout');
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } on FormatException catch (error) {
      debugPrint('ERROR GET FORMAT: $error');
      throw Exception('La respuesta del servidor no tiene un formato válido');
    } on http.ClientException catch (error) {
      debugPrint('ERROR GET CLIENT: $error');
      throw Exception('No se pudo conectar con el servidor');
    } catch (error) {
      debugPrint('ERROR GET GENERAL: $error');
      rethrow;
    }
  }

  Future<List<dynamic>> getList(String endpoint, {String? token}) async {
    try {
      final Uri url = _construirUrl(endpoint);
      final Map<String, String> headers = _construirHeaders(token: token);

      debugPrint('==================== API GET LIST ====================');
      debugPrint('GET LIST URL: $url');
      debugPrint('TOKEN PRESENTE: ${token != null && token.isNotEmpty}');
      debugPrint('HEADERS: $headers');

      final http.Response response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(ApiConfig.connectTimeout);

      debugPrint('GET LIST STATUS CODE: ${response.statusCode}');
      debugPrint('GET LIST RESPONSE BODY: ${response.body}');
      debugPrint('======================================================');

      return _procesarRespuestaLista(response);
    } on TimeoutException {
      debugPrint('ERROR GET LIST: Timeout');
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } on FormatException catch (error) {
      debugPrint('ERROR GET LIST FORMAT: $error');
      throw Exception('La respuesta del servidor no tiene un formato válido');
    } on http.ClientException catch (error) {
      debugPrint('ERROR GET LIST CLIENT: $error');
      throw Exception('No se pudo conectar con el servidor');
    } catch (error) {
      debugPrint('ERROR GET LIST GENERAL: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final Uri url = _construirUrl(endpoint);
      final Map<String, String> headers = _construirHeaders(token: token);
      final String bodyJson = jsonEncode(body ?? <String, dynamic>{});

      debugPrint('==================== API POST ====================');
      debugPrint('POST URL: $url');
      debugPrint('POST BODY: $bodyJson');
      debugPrint('TOKEN PRESENTE: ${token != null && token.isNotEmpty}');
      debugPrint('HEADERS: $headers');

      final http.Response response = await http
          .post(
            url,
            headers: headers,
            body: bodyJson,
          )
          .timeout(ApiConfig.connectTimeout);

      debugPrint('POST STATUS CODE: ${response.statusCode}');
      debugPrint('POST RESPONSE BODY: ${response.body}');
      debugPrint('==================================================');

      return _procesarRespuesta(response);
    } on TimeoutException {
      debugPrint('ERROR POST: Timeout');
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } on FormatException catch (error) {
      debugPrint('ERROR POST FORMAT: $error');
      throw Exception('La respuesta del servidor no tiene un formato válido');
    } on http.ClientException catch (error) {
      debugPrint('ERROR POST CLIENT: $error');
      throw Exception('No se pudo conectar con el servidor');
    } catch (error) {
      debugPrint('ERROR POST GENERAL: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final Uri url = _construirUrl(endpoint);
      final Map<String, String> headers = _construirHeaders(token: token);
      final String bodyJson = jsonEncode(body ?? <String, dynamic>{});

      debugPrint('==================== API PUT ====================');
      debugPrint('PUT URL: $url');
      debugPrint('PUT BODY: $bodyJson');
      debugPrint('TOKEN PRESENTE: ${token != null && token.isNotEmpty}');
      debugPrint('HEADERS: $headers');

      final http.Response response = await http
          .put(
            url,
            headers: headers,
            body: bodyJson,
          )
          .timeout(ApiConfig.connectTimeout);

      debugPrint('PUT STATUS CODE: ${response.statusCode}');
      debugPrint('PUT RESPONSE BODY: ${response.body}');
      debugPrint('=================================================');

      return _procesarRespuesta(response);
    } on TimeoutException {
      debugPrint('ERROR PUT: Timeout');
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } on FormatException catch (error) {
      debugPrint('ERROR PUT FORMAT: $error');
      throw Exception('La respuesta del servidor no tiene un formato válido');
    } on http.ClientException catch (error) {
      debugPrint('ERROR PUT CLIENT: $error');
      throw Exception('No se pudo conectar con el servidor');
    } catch (error) {
      debugPrint('ERROR PUT GENERAL: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final Uri url = _construirUrl(endpoint);
      final Map<String, String> headers = _construirHeaders(token: token);
      final String bodyJson = jsonEncode(body ?? <String, dynamic>{});

      debugPrint('==================== API PATCH ====================');
      debugPrint('PATCH URL: $url');
      debugPrint('PATCH BODY: $bodyJson');
      debugPrint('TOKEN PRESENTE: ${token != null && token.isNotEmpty}');
      debugPrint('HEADERS: $headers');

      final http.Response response = await http
          .patch(
            url,
            headers: headers,
            body: bodyJson,
          )
          .timeout(ApiConfig.connectTimeout);

      debugPrint('PATCH STATUS CODE: ${response.statusCode}');
      debugPrint('PATCH RESPONSE BODY: ${response.body}');
      debugPrint('===================================================');

      return _procesarRespuesta(response);
    } on TimeoutException {
      debugPrint('ERROR PATCH: Timeout');
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } on FormatException catch (error) {
      debugPrint('ERROR PATCH FORMAT: $error');
      throw Exception('La respuesta del servidor no tiene un formato válido');
    } on http.ClientException catch (error) {
      debugPrint('ERROR PATCH CLIENT: $error');
      throw Exception('No se pudo conectar con el servidor');
    } catch (error) {
      debugPrint('ERROR PATCH GENERAL: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint, {String? token}) async {
    try {
      final Uri url = _construirUrl(endpoint);
      final Map<String, String> headers = _construirHeaders(token: token);

      debugPrint('==================== API DELETE ====================');
      debugPrint('DELETE URL: $url');
      debugPrint('TOKEN PRESENTE: ${token != null && token.isNotEmpty}');
      debugPrint('HEADERS: $headers');

      final http.Response response = await http
          .delete(
            url,
            headers: headers,
          )
          .timeout(ApiConfig.connectTimeout);

      debugPrint('DELETE STATUS CODE: ${response.statusCode}');
      debugPrint('DELETE RESPONSE BODY: ${response.body}');
      debugPrint('====================================================');

      return _procesarRespuesta(response);
    } on TimeoutException {
      debugPrint('ERROR DELETE: Timeout');
      throw Exception('Tiempo de espera agotado al conectar con el servidor');
    } on FormatException catch (error) {
      debugPrint('ERROR DELETE FORMAT: $error');
      throw Exception('La respuesta del servidor no tiene un formato válido');
    } on http.ClientException catch (error) {
      debugPrint('ERROR DELETE CLIENT: $error');
      throw Exception('No se pudo conectar con el servidor');
    } catch (error) {
      debugPrint('ERROR DELETE GENERAL: $error');
      rethrow;
    }
  }

  Map<String, dynamic> _procesarRespuesta(http.Response response) {
    debugPrint('PROCESANDO RESPUESTA');
    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY RAW: ${response.body}');

    Map<String, dynamic> body = <String, dynamic>{};

    if (response.body.isNotEmpty) {
      final dynamic decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        body = decoded;
      } else {
        throw Exception('La respuesta del servidor no es un objeto JSON válido');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final String mensaje = body['mensaje']?.toString() ??
        body['message']?.toString() ??
        body['error']?.toString() ??
        body['msg']?.toString() ??
        'Error al comunicarse con el servidor';

    debugPrint('ERROR API PROCESADO: $mensaje');

    throw Exception(mensaje);
  }

  List<dynamic> _procesarRespuestaLista(http.Response response) {
    debugPrint('PROCESANDO RESPUESTA LISTA');
    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY RAW: ${response.body}');

    final dynamic decoded = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : <dynamic>[];

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is List<dynamic>) {
        return decoded;
      }

      throw Exception('La respuesta del servidor no es una lista JSON válida');
    }

    if (decoded is Map<String, dynamic>) {
      final String mensaje = decoded['mensaje']?.toString() ??
          decoded['message']?.toString() ??
          decoded['error']?.toString() ??
          decoded['msg']?.toString() ??
          'Error al comunicarse con el servidor';

      debugPrint('ERROR API LISTA PROCESADO: $mensaje');

      throw Exception(mensaje);
    }

    throw Exception('Error al comunicarse con el servidor');
  }
}