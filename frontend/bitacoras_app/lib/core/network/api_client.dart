import 'dart:convert';
import 'package:bitacoras_app/app/apps.dart';
import 'package:http/http.dart' as http;

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
  String toString() => 'Error de API ($statusCode): $message';
}

class ApiClient {
  // Android emulator: 10.0.2.2:8000
  // Physical device on the same local network: use the Windows host IP.
  static const defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.39:8000/api/',
  );

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

  Future<Uint8List> downloadBinary(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(endpoint, null);
    final headers = <String, String>{
      'Accept': '*/*',
    };

    if (requiresAuth) {
      final token = await tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    final response = await _client.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'No se pudo descargar el PDF del reporte.',
        body: response.body,
      );
    }

    return response.bodyBytes;
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
    } on http.ClientException {
      throw ApiException(
        statusCode: 0,
        message: 'No se pudo conectar al servidor. Verifica tu conexión e inténtalo de nuevo.',
      );
    } on FormatException {
      throw ApiException(
        statusCode: 0,
        message: 'La respuesta del servidor no es válida.',
      );
    } catch (_) {
      throw ApiException(
        statusCode: 0,
        message: 'Ocurrió un error inesperado. Inténtalo de nuevo.',
      );
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
      if (detail != null) {
        final translatedDetail = _translateServerError(detail.toString());
        if (translatedDetail != null) return translatedDetail;
        return detail.toString();
      }

      final fieldErrors = body.entries
          .map((entry) {
            final value = entry.value;
            final messages = value is List ? value : [value];
            return messages
                .map((message) {
                  final label = _fieldLabel(entry.key);
                  final translated = _translateServerError(message.toString());
                  return translated ?? '$label: $message';
                })
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

  String? _translateServerError(String value) {
    final lower = value.toLowerCase();

    if ((lower.contains('period') || lower.contains('período')) &&
        (lower.contains('name') || lower.contains('nombre')) &&
        (lower.contains('already exists') || lower.contains('ya existe'))) {
      return 'Ya existe un período lectivo con ese nombre.';
    }

    if (lower.contains('already exists') || lower.contains('ya existe')) {
      if (lower.contains('telefono') || lower.contains('phone')) {
        return 'El número de teléfono ya está registrado por otro usuario.';
      }
      if (lower.contains('cedula') || lower.contains('dni') || lower.contains('id card')) {
        return 'La cédula ya está registrada por otro usuario.';
      }
      if (lower.contains('email') || lower.contains('correo')) {
        return 'El correo electrónico ya está registrado por otro usuario.';
      }
    }

    if (lower.contains('ensure this field has') ||
        lower.contains('no es válida') ||
        lower.contains('invalid') ||
        lower.contains('formato')) {
      if (lower.contains('telefono') || lower.contains('phone')) {
        return 'El número de teléfono no cumple el formato válido.';
      }
      if (lower.contains('cedula') || lower.contains('dni')) {
        return 'La cédula no cumple el formato válido.';
      }
      if (lower.contains('email') || lower.contains('correo')) {
        return 'El correo electrónico no cumple el formato válido.';
      }
    }

    return null;
  }

  String _fieldLabel(String field) {
    return switch (field) {
      'nombre' => 'Nombre',
      'fecha_inicio' => 'Fecha de inicio',
      'fecha_fin' => 'Fecha de fin',
      'telefono' => 'Teléfono',
      'cedula' => 'Cédula',
      'carrera_id' => 'Carrera',
      'empresa_id' => 'Empresa',
      'non_field_errors' => 'Datos',
      _ => field,
    };
  }
}