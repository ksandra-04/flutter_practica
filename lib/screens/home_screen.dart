// =============================================================================
// home_screen.dart — Pantalla de inicio
// -----------------------------------------------------------------------------
// Video FLUTTER_02 (Aplicación frontend desde cero): estructura básica de una
//   pantalla con Scaffold, AppBar y body, usando un StatelessWidget.
// Video FLUTTER_04 (Drawer): `drawer: const AppDrawer()` agrega el menú.
// Video FLUTTER_03 (Navegación): las tarjetas navegan con rutas con nombre.
// =============================================================================

import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      // Al definir drawer, el AppBar muestra solo el botón de hamburguesa.
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '¿Qué quieres calcular?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          const Text('Usa las tarjetas o abre el menú lateral.'),
          const SizedBox(height: 16),
          const _TarjetaAcceso(
            icono: Icons.cake,
            titulo: 'Edad y signo zodiacal',
            descripcion: 'Elige tu fecha de nacimiento.',
            ruta: AppRoutes.edad,
          ),
          const _TarjetaAcceso(
            icono: Icons.monitor_weight,
            titulo: 'Índice de masa corporal',
            descripcion: 'Ingresa tu peso y estatura.',
            ruta: AppRoutes.imc,
          ),
          const _TarjetaAcceso(
            icono: Icons.cloud_done,
            titulo: 'Conexión con Docker',
            descripcion: 'Prueba la conexión con el backend.',
            ruta: AppRoutes.conexion,
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de acceso rápido. Es un widget privado (empieza con _) porque solo
/// se usa en este archivo. Separarlo evita repetir tres veces el mismo Card.
class _TarjetaAcceso extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String descripcion;
  final String ruta;

  const _TarjetaAcceso({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.ruta,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icono, size: 32),
        title: Text(titulo),
        subtitle: Text(descripcion),
        trailing: const Icon(Icons.chevron_right),
        // Igual que el Drawer: se reemplaza la pantalla para que cada sección
        // quede como pantalla principal con su propio menú.
        onTap: () => Navigator.pushReplacementNamed(context, ruta),
      ),
    );
  }
}
