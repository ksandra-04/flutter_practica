// =============================================================================
// api_config.dart — Dirección del backend que corre en Docker
// -----------------------------------------------------------------------------
// Video FLUTTER_01 (Configuración de conectividad con Docker):
//   El punto clave es que "localhost" NO significa lo mismo en todas partes:
//     - Emulador Android: localhost es el propio emulador. Para llegar al
//       computador (donde Docker publica el puerto) se usa 10.0.2.2.
//     - Simulador iOS, web y escritorio: localhost sí es el computador.
//     - Celular físico: se usa la IP del computador en la red WiFi
//       (por ejemplo 192.168.1.20) y se pasa con --dart-define.
// =============================================================================

import 'package:flutter/foundation.dart';

class ApiConfig {
  ApiConfig._();

  /// Puerto que publica docker-compose.yml (8080:8080).
  static const int puerto = 8080;

  /// Permite cambiar la URL sin tocar el código:
  ///   flutter run --dart-define=API_URL=http://192.168.1.20:8080
  static const String _urlManual = String.fromEnvironment('API_URL');

  static String get baseUrl {
    if (_urlManual.isNotEmpty) return _urlManual;

    // kIsWeb se revisa primero porque en web no existe un "sistema operativo".
    if (kIsWeb) return 'http://localhost:$puerto';

    // defaultTargetPlatform funciona en todas las plataformas (a diferencia de
    // dart:io Platform, que falla en web).
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:$puerto';
    }
    return 'http://localhost:$puerto';
  }
}
