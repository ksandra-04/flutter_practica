// =============================================================================
// resultado_screen.dart — Pantalla que RECIBE datos de otra pantalla
// -----------------------------------------------------------------------------
// Video FLUTTER_05 (paso de datos entre pantallas):
//   Los formularios de edad e IMC envían un ResultadoArgs. Esta pantalla no
//   sabe quién la llamó: solo muestra lo que recibe. Por eso una sola pantalla
//   sirve para los dos cálculos (reutilización, FLUTTER_03).
// =============================================================================

import 'package:flutter/material.dart';

/// "Paquete" de datos que viaja entre pantallas. Usar una clase en lugar de un
/// Map suelto hace que el compilador avise si falta un dato.
class ResultadoArgs {
  final String titulo;
  final IconData icono;

  /// Dato destacado en grande (por ejemplo "23 años" o "22.5").
  final String valorPrincipal;

  /// Filas adicionales: etiqueta -> valor.
  final Map<String, String> detalles;

  const ResultadoArgs({
    required this.titulo,
    required this.icono,
    required this.valorPrincipal,
    required this.detalles,
  });
}

class ResultadoScreen extends StatelessWidget {
  final ResultadoArgs datos;

  const ResultadoScreen({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      // Esta pantalla NO tiene drawer: como se abrió con pushNamed, el AppBar
      // muestra automáticamente la flecha de volver.
      appBar: AppBar(title: Text(datos.titulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: tema.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(datos.icono,
                      size: 48, color: tema.colorScheme.onPrimaryContainer),
                  const SizedBox(height: 8),
                  Text(
                    datos.valorPrincipal,
                    style: tema.textTheme.displaySmall?.copyWith(
                      color: tema.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Recorre el mapa y crea una fila por cada detalle recibido.
          for (final fila in datos.detalles.entries)
            ListTile(
              title: Text(fila.key),
              trailing: Text(fila.value, style: tema.textTheme.titleMedium),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            // pop quita esta pantalla de la pila y vuelve al formulario,
            // que conserva lo que el usuario había escrito.
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Volver a calcular'),
          ),
        ],
      ),
    );
  }
}
