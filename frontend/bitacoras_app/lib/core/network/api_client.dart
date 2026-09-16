import 'dart:convert';

import 'package:http/http.dart' as http;

import 'token_storage.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic body;

  const ApiException({
    required this.statusCode,
    required this.message,
    this.body,
  });

  @override
  String toString() => 'ApiException ($statusCode): $message';
}

class ApiClient {
  static const defaultBaseUrl = 'http://192.168.1.39:8000/api/';

  final String baseUrl;
  final TokenStorage tokenStorage;
  final http.Client _client;

  ApiClient({
    this.baseUrl = defaultBaseUrl,
    TokenStorage? tokenStorage,
    http.Client? client,
  })  : tokenStorage = tokenStorage ?? TokenStorage(),
        _client = client ?? http.Client();

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    bool requiresAuth = true,
  }) async {
    return _send(
      method: 'GET',
      endpoint: endpoint,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    return _send(
      method: 'POST',
      endpoint: endpoint,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    return _send(
      method: 'PUT',
      endpoint: endpoint,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    return _send(
      method: 'PATCH',
      endpoint: endpoint,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    return _send(
      method: 'DELETE',
      endpoint: endpoint,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  void close() => _client.close();

  Future<dynamic> _send({
    required String method,
    required String endpoint,
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
    required bool requiresAuth,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      final encodedBody = body == null ? null : jsonEncode(body);
      final response = switch (method) {
        'GET' => await _client.get(uri, headers: headers),
        'POST' => await _client.post(uri, headers: headers, body: encodedBody),
        'PUT' => await _client.put(uri, headers: headers, body: encodedBody),
        'PATCH' => await _client.patch(uri, headers: headers, body: encodedBody),
        'DELETE' => await _client.delete(uri, headers: headers, body: encodedBody),
        _ => throw ArgumentError('Método HTTP no soportado: $method'),
      };

      dynamic responseBody;
      try {
        responseBody = _decodeBody(response.body);
      } on FormatException {
        responseBody = response.body;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          statusCode: response.statusCode,
          message: _errorMessage(
            responseBody,
            response.reasonPhrase,
            response.statusCode,
          ),
          body: responseBody,
        );
      }

      if (responseBody is String && responseBody.trim().isNotEmpty) {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'El servidor devolvió una respuesta inválida.',
          body: responseBody,
        );
      }

      return responseBody;
    } on ApiException {
      rethrow;
    } on http.ClientException catch (e) {
      throw ApiException(statusCode: 0, message: 'Error de red: $e');
    } on FormatException catch (e) {
      throw ApiException(statusCode: 0, message: 'Respuesta JSON inválida: $e');
    }
  }

  Uri _buildUri(String endpoint, Map<String, String>? queryParameters) {
    final uri = Uri.parse('$baseUrl$endpoint');
    return queryParameters == null
        ? uri
        : uri.replace(queryParameters: {
            ...uri.queryParameters,
            ...queryParameters,
          });
  }

  dynamic _decodeBody(String body) {
    if (body.trim().isEmpty) return null;
    return jsonDecode(body);
  }

  String _errorMessage(
    dynamic body,
    String? reasonPhrase,
    int statusCode,
  ) {
    if (body is Map<String, dynamic>) {
      final detail = body['detail'] ?? body['message'] ?? body['error'];
      if (detail != null) return detail.toString();

      final fieldErrors = body.entries
          .map((entry) {
            final value = entry.value;
            final messages = value is List ? value : [value];
            return messages
                .map((message) => '${_fieldLabel(entry.key)}: $message')
                .join(' ');
          })
          .where((message) => message.isNotEmpty)
          .join(' ');
      if (fieldErrors.isNotEmpty) return fieldErrors;
    }
    if (statusCode >= 500) {
      return 'El servidor no pudo completar la solicitud.';
    }
    return switch (statusCode) {
      400 => 'Los datos enviados no son válidos.',
      401 => 'La sesión ha expirado. Inicia sesión nuevamente.',
      403 => 'No tienes permisos para realizar esta acción.',
      404 => 'No se encontró el recurso solicitado.',
      409 => 'Los datos entran en conflicto con un registro existente.',
      _ => 'La solicitud fue rechazada por el servidor.',
    };
  }

  String _fieldLabel(String field) {
    return switch (field) {
      'telefono' => 'Teléfono',
      'cedula' => 'Cédula',
      'carrera_id' => 'Carrera',
      'empresa_id' => 'Empresa',
      'non_field_errors' => 'Datos',
      _ => field,
    };
  }
}