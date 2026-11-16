// =============================================================================
// conexion_screen.dart — Prueba de conexión con el backend en Docker
// -----------------------------------------------------------------------------
// Video FLUTTER_01 (Conectividad con Docker): comprueba que la app llega al
//   contenedor. Muestra la URL usada, para ver la diferencia entre
//   10.0.2.2 (emulador Android) y localhost (web / iOS / escritorio).
// Además se usa FutureBuilder, que dibuja tres estados de una operación
//   asíncrona: cargando, error y datos.
// =============================================================================

import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../services/api_service.dart';
import '../widgets/app_drawer.dart';

class ConexionScreen extends StatefulWidget {
  const ConexionScreen({super.key});

  @override
  State<ConexionScreen> createState() => _ConexionScreenState();
}

class _ConexionScreenState extends State<ConexionScreen> {
  final _api = ApiService();

  /// El Future se guarda en el estado. Si se creara dentro de build(), cada
  /// redibujado lanzaría una petición nueva.
  late Future<EstadoServidor> _consulta;

  @override
  void initState() {
    super.initState();
    // Primera consulta al abrir la pantalla.
    _consulta = _api.obtenerEstado();
  }

  void _reintentar() {
    // Asignar un Future nuevo dentro de setState hace que FutureBuilder
    // vuelva al estado "cargando" y repita la petición.
    setState(() => _consulta = _api.obtenerEstado());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conexión con Docker')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Servidor: ${ApiConfig.baseUrl}'),
            const SizedBox(height: 16),
            FutureBuilder<EstadoServidor>(
              future: _consulta,
              builder: (context, snapshot) {
                // 1) Todavía esperando la respuesta.
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                // 2) Falló (Docker apagado, URL equivocada, sin red...).
                if (snapshot.hasError) {
                  return _Aviso(
                    icono: Icons.cloud_off,
                    color: Theme.of(context).colorScheme.error,
                    titulo: 'Sin conexión',
                    detalle: 'No se pudo llegar al backend. Verifica que '
                        'Docker esté corriendo (docker compose up).\n\n'
                        '${snapshot.error}',
                  );
                }
                // 3) Llegaron los datos.
                final estado = snapshot.data!;
                return _Aviso(
                  icono: Icons.cloud_done,
                  color: Colors.green,
                  titulo: 'Conectado',
                  detalle: '${estado.mensaje}\nHora del servidor: '
                      '${estado.hora}',
                );
              },
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _reintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Probar de nuevo'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta con ícono, título y detalle. Se usa para éxito y para error.
class _Aviso extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String titulo;
  final String detalle;

  const _Aviso({
    required this.icono,
    required this.color,
    required this.titulo,
    required this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icono, size: 48, color: color),
            const SizedBox(height: 8),
            Text(titulo, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(detalle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
