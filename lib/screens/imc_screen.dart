// =============================================================================
// imc_screen.dart — Formulario del Índice de Masa Corporal
// -----------------------------------------------------------------------------
// Video FLUTTER_05 (Navegación y formularios básicos):
//   - Form + GlobalKey<FormState> para validar todos los campos de una vez.
//   - TextFormField con `validator`.
//   - TextEditingController para leer lo que escribió el usuario.
//   - Envío del resultado a otra pantalla.
// =============================================================================

import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../utils/calculos.dart';
import '../widgets/app_drawer.dart';
import 'resultado_screen.dart';

class ImcScreen extends StatefulWidget {
  const ImcScreen({super.key});

  @override
  State<ImcScreen> createState() => _ImcScreenState();
}

class _ImcScreenState extends State<ImcScreen> {
  /// Llave que identifica al Form; permite llamar a validate() desde el botón.
  final _formKey = GlobalKey<FormState>();

  /// Controladores: guardan el texto de cada campo.
  final _pesoCtrl = TextEditingController();
  final _estaturaCtrl = TextEditingController();

  @override
  void dispose() {
    // Los controladores se liberan al cerrar la pantalla para no dejar
    // memoria ocupada.
    _pesoCtrl.dispose();
    _estaturaCtrl.dispose();
    super.dispose();
  }

  /// Convierte texto a número aceptando coma o punto decimal ("70,5" o "70.5"),
  /// porque en teclados en español suele salir la coma.
  double? _aNumero(String? texto) {
    if (texto == null) return null;
    return double.tryParse(texto.trim().replaceAll(',', '.'));
  }

  /// Fabrica un validador con un rango permitido. Devuelve null si el valor es
  /// válido, o el mensaje de error que se muestra bajo el campo.
  String? Function(String?) _validarRango(double min, double max, String unidad) {
    return (texto) {
      final n = _aNumero(texto);
      if (n == null) return 'Escribe un número';
      if (n < min || n > max) {
        return 'Debe estar entre ${min.toStringAsFixed(0)} y '
            '${max.toStringAsFixed(0)} $unidad';
      }
      return null;
    };
  }

  void _calcular() {
    // validate() ejecuta el validator de cada campo. Si alguno falla, muestra
    // los errores y devuelve false.
    if (!_formKey.currentState!.validate()) return;

    final imc = calcularImc(
      pesoKg: _aNumero(_pesoCtrl.text)!,
      estaturaCm: _aNumero(_estaturaCtrl.text)!,
    );

    // Oculta el teclado antes de cambiar de pantalla.
    FocusScope.of(context).unfocus();

    // Paso de datos a la pantalla de resultado (FLUTTER_05).
    Navigator.pushNamed(
      context,
      AppRoutes.resultado,
      arguments: ResultadoArgs(
        titulo: 'Índice de masa corporal',
        icono: Icons.monitor_weight,
        valorPrincipal: imc.toStringAsFixed(1),
        detalles: {
          'Peso': '${_pesoCtrl.text.trim()} kg',
          'Estatura': '${_estaturaCtrl.text.trim()} cm',
          'Categoría (OMS)': categoriaImc(imc),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Índice de masa corporal')),
      drawer: const AppDrawer(),
      // SingleChildScrollView evita el error de "overflow" cuando aparece el
      // teclado y el contenido ya no cabe.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _pesoCtrl,
                // Teclado numérico con decimales.
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Peso',
                  suffixText: 'kg',
                  border: OutlineInputBorder(),
                ),
                validator: _validarRango(20, 300, 'kg'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _estaturaCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Estatura',
                  suffixText: 'cm',
                  border: OutlineInputBorder(),
                ),
                validator: _validarRango(80, 250, 'cm'),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _calcular,
                child: const Text('Calcular IMC'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
