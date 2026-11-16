// =============================================================================
// app_routes.dart — Todas las rutas de la app en un solo lugar
// -----------------------------------------------------------------------------
// Video FLUTTER_03 (Estructura y navegación eficiente):
//   Centralizar los nombres de las rutas evita escribir cadenas sueltas como
//   '/imc' por todo el proyecto (un error de tipeo rompería la navegación).
// Video FLUTTER_05 (Navegación y formularios):
//   La pantalla de resultado recibe datos de otra pantalla. Eso se resuelve en
//   generarRuta(), leyendo settings.arguments.
// =============================================================================

import 'package:flutter/material.dart';

import '../screens/conexion_screen.dart';
import '../screens/edad_screen.dart';
import '../screens/home_screen.dart';
import '../screens/imc_screen.dart';
import '../screens/resultado_screen.dart';

class AppRoutes {
  // Constructor privado: esta clase solo agrupa constantes, no se instancia.
  AppRoutes._();

  static const String inicio = '/';
  static const String edad = '/edad';
  static const String imc = '/imc';
  static const String conexion = '/conexion';
  static const String resultado = '/resultado';

  /// Rutas que no necesitan argumentos. MaterialApp las usa directamente.
  static final Map<String, WidgetBuilder> rutas = {
    inicio: (_) => const HomeScreen(),
    edad: (_) => const EdadScreen(),
    imc: (_) => const ImcScreen(),
    conexion: (_) => const ConexionScreen(),
  };

  /// Rutas que reciben argumentos. MaterialApp llama a este método cuando el
  /// nombre pedido no está en [rutas].
  static Route<dynamic>? generarRuta(RouteSettings settings) {
    if (settings.name == resultado) {
      // Los datos enviados con Navigator.pushNamed(..., arguments: ...)
      // llegan aquí. Se convierten al tipo esperado y se pasan por constructor.
      final datos = settings.arguments as ResultadoArgs;
      return MaterialPageRoute(
        builder: (_) => ResultadoScreen(datos: datos),
        settings: settings,
      );
    }
    // null = ruta desconocida.
    return null;
  }
}
