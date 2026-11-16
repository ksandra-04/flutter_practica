// =============================================================================
// edad_screen.dart — Edad y signo zodiacal a partir de la fecha de nacimiento
// -----------------------------------------------------------------------------
// Video FLUTTER_05 (Navegación y formularios básicos):
//   - Selector de fecha con showDatePicker.
//   - StatefulWidget + setState para guardar la fecha elegida (estado).
//   - Envío de datos a otra pantalla con Navigator.pushNamed(arguments: ...).
// Video FLUTTER_04: usa el mismo Drawer que el resto de pantallas.
// =============================================================================

import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../utils/calculos.dart';
import '../widgets/app_drawer.dart';
import 'resultado_screen.dart';

/// StatefulWidget porque la pantalla cambia cuando el usuario elige una fecha.
class EdadScreen extends StatefulWidget {
  const EdadScreen({super.key});

  @override
  State<EdadScreen> createState() => _EdadScreenState();
}

class _EdadScreenState extends State<EdadScreen> {
  /// Fecha elegida. Es null hasta que el usuario seleccione una.
  DateTime? _fechaNacimiento;

  /// Abre el calendario nativo de Material.
  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime(hoy.year - 20),
      firstDate: DateTime(1900),
      // No se permiten fechas futuras: nadie nace mañana.
      lastDate: hoy,
      helpText: 'Fecha de nacimiento',
    );

    // Si el usuario cancela, showDatePicker devuelve null y no cambiamos nada.
    if (elegida == null) return;

    // setState avisa a Flutter que el estado cambió y debe redibujar.
    setState(() => _fechaNacimiento = elegida);
  }

  void _calcular() {
    final fecha = _fechaNacimiento!;
    final edad = calcularEdad(fecha);
    final signo = calcularSigno(fecha);

    // PASO DE DATOS ENTRE PANTALLAS (FLUTTER_05):
    // se empaquetan los resultados en un objeto y viajan en `arguments`.
    // Aquí se usa pushNamed (no replacement) para que la pantalla de
    // resultado tenga flecha de "volver" a este formulario.
    Navigator.pushNamed(
      context,
      AppRoutes.resultado,
      arguments: ResultadoArgs(
        titulo: 'Edad y signo',
        icono: Icons.cake,
        valorPrincipal: '$edad años',
        detalles: {
          'Fecha de nacimiento': formatearFecha(fecha),
          'Signo zodiacal': signo,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edad y signo zodiacal')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Selecciona tu fecha de nacimiento:'),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _elegirFecha,
              icon: const Icon(Icons.calendar_today),
              // El texto del botón depende del estado.
              label: Text(
                _fechaNacimiento == null
                    ? 'Elegir fecha'
                    : formatearFecha(_fechaNacimiento!),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              // onPressed en null deshabilita el botón: no se puede calcular
              // sin fecha. Es una validación visual sencilla.
              onPressed: _fechaNacimiento == null ? null : _calcular,
              child: const Text('Calcular'),
            ),
          ],
        ),
      ),
    );
  }
}
