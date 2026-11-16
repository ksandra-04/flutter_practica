// =============================================================================
// main.dart — Punto de entrada de la aplicación
// -----------------------------------------------------------------------------
// Video FLUTTER_02 (Creación de una aplicación frontend desde cero):
//   - main() + runApp() arrancan la app.
//   - MaterialApp es el widget raíz: define título, tema y navegación.
// Video FLUTTER_03 (Estructura y navegación eficiente):
//   - En lugar de poner todas las pantallas aquí, el código se separa en
//     carpetas (screens/, widgets/, routes/, utils/, services/, config/).
//   - La navegación usa RUTAS CON NOMBRE definidas en un solo archivo
//     (routes/app_routes.dart), así main.dart queda corto y fácil de leer.
// =============================================================================

import 'package:flutter/material.dart';

import 'routes/app_routes.dart';

void main() {
  // runApp recibe el widget raíz y lo dibuja en pantalla.
  runApp(const MiApp());
}

/// Widget raíz. Es un StatelessWidget porque no guarda ningún estado propio:
/// solo configura la aplicación.
class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica Flutter',
      // Quita la cinta "DEBUG" de la esquina para que el video se vea limpio.
      debugShowCheckedModeBanner: false,
      // Tema Material 3 generado a partir de un solo color semilla.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // Ruta que se muestra al abrir la app.
      initialRoute: AppRoutes.inicio,
      // Tabla de rutas simples (sin argumentos).
      routes: AppRoutes.rutas,
      // Rutas que SÍ reciben argumentos (pantalla de resultado, FLUTTER_05).
      onGenerateRoute: AppRoutes.generarRuta,
    );
  }
}
