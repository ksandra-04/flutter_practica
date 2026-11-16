// =============================================================================
// app_drawer.dart — Menú lateral reutilizable
// -----------------------------------------------------------------------------
// Video FLUTTER_04 (Configuración de navegación con Drawer):
//   - Drawer + ListView + DrawerHeader + ListTile.
//   - Cada pantalla lo coloca en la propiedad `drawer:` de su Scaffold; con eso
//     Flutter agrega solo el ícono de hamburguesa en el AppBar.
// Video FLUTTER_03 (Estructura):
//   - Está en widgets/ porque se usa en varias pantallas. Se escribe una vez.
// =============================================================================

import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    // Nombre de la ruta actual: sirve para resaltar la opción activa.
    final rutaActual = ModalRoute.of(context)?.settings.name;

    return Drawer(
      child: ListView(
        // Sin padding para que el encabezado llegue hasta el borde superior.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colores.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.flutter_dash, size: 48, color: colores.onPrimary),
                const SizedBox(height: 8),
                Text(
                  'Práctica Flutter',
                  style: TextStyle(color: colores.onPrimary, fontSize: 20),
                ),
              ],
            ),
          ),
          _opcion(context, rutaActual,
              icono: Icons.home, texto: 'Inicio', ruta: AppRoutes.inicio),
          _opcion(context, rutaActual,
              icono: Icons.cake,
              texto: 'Edad y signo zodiacal',
              ruta: AppRoutes.edad),
          _opcion(context, rutaActual,
              icono: Icons.monitor_weight,
              texto: 'Índice de masa corporal',
              ruta: AppRoutes.imc),
          const Divider(),
          _opcion(context, rutaActual,
              icono: Icons.cloud_done,
              texto: 'Conexión con Docker',
              ruta: AppRoutes.conexion),
        ],
      ),
    );
  }

  /// Construye una fila del menú. Se extrae a un método para no repetir el
  /// mismo ListTile cuatro veces.
  Widget _opcion(
    BuildContext context,
    String? rutaActual, {
    required IconData icono,
    required String texto,
    required String ruta,
  }) {
    return ListTile(
      leading: Icon(icono),
      title: Text(texto),
      // Resalta la opción de la pantalla en la que ya estamos.
      selected: rutaActual == ruta,
      onTap: () {
        // 1) Cierra el drawer (es una "ruta" encima de la pantalla).
        Navigator.pop(context);
        // 2) Si ya estamos en esa pantalla, no hace nada más.
        if (rutaActual == ruta) return;
        // 3) pushReplacementNamed reemplaza la pantalla actual en vez de
        //    apilar otra. Así, al cambiar de sección muchas veces desde el
        //    menú, la pila de navegación no crece sin control.
        Navigator.pushReplacementNamed(context, ruta);
      },
    );
  }
}
