// =============================================================================
// api_service.dart — Peticiones HTTP al backend en Docker
// -----------------------------------------------------------------------------
// Video FLUTTER_01 (Conectividad con Docker): la app (frontend) consulta un
// servicio que corre dentro de un contenedor.
// Video FLUTTER_03 (Estructura): las llamadas de red viven en services/, no
// dentro de los widgets. La pantalla solo pide "dame el estado".
// =============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

/// Respuesta de GET /api/estado.
class EstadoServidor {
  final String mensaje;
  final String hora;

  const EstadoServidor({required this.mensaje, required this.hora});

  /// Convierte el JSON del backend en un objeto Dart con tipos.
  factory EstadoServidor.fromJson(Map<String, dynamic> json) {
    return EstadoServidor(
      mensaje: json['mensaje'] as String? ?? '',
      hora: json['hora'] as String? ?? '',
    );
  }
}

class ApiService {
  /// Consulta el estado del backend.
  ///
  /// Es `async` y devuelve un Future porque la red tarda: la interfaz no se
  /// congela mientras llega la respuesta.
  Future<EstadoServidor> obtenerEstado() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/estado');

    // timeout: si Docker está apagado, no dejamos al usuario esperando.
    final respuesta = await http.get(url).timeout(const Duration(seconds: 5));

    if (respuesta.statusCode != 200) {
      throw Exception('El servidor respondió ${respuesta.statusCode}');
    }

    // utf8.decode sobre los bytes para que las tildes lleguen bien.
    final json =
        jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;
    return EstadoServidor.fromJson(json);
  }
}
