// =============================================================================
// calculos.dart — Lógica pura (sin widgets)
// -----------------------------------------------------------------------------
// Video FLUTTER_05: en el video se calculan la edad, el signo zodiacal y el IMC.
// Video FLUTTER_03 (Estructura): la lógica se separa de la interfaz. Como estas
// funciones no dependen de Flutter, se pueden probar con tests unitarios
// (ver test/calculos_test.dart) sin abrir un emulador.
// =============================================================================

/// Edad en años cumplidos.
///
/// [hoy] es opcional para poder fijar la fecha en los tests; en la app se usa
/// la fecha actual.
int calcularEdad(DateTime nacimiento, {DateTime? hoy}) {
  final ahora = hoy ?? DateTime.now();
  int edad = ahora.year - nacimiento.year;
  // Si este año todavía no ha llegado el cumpleaños, se resta uno.
  final aunNoCumple = ahora.month < nacimiento.month ||
      (ahora.month == nacimiento.month && ahora.day < nacimiento.day);
  if (aunNoCumple) edad--;
  return edad;
}

/// Signo zodiacal occidental según día y mes de nacimiento.
String calcularSigno(DateTime nacimiento) {
  final d = nacimiento.day;
  switch (nacimiento.month) {
    case 1:
      return d <= 19 ? 'Capricornio' : 'Acuario';
    case 2:
      return d <= 18 ? 'Acuario' : 'Piscis';
    case 3:
      return d <= 20 ? 'Piscis' : 'Aries';
    case 4:
      return d <= 19 ? 'Aries' : 'Tauro';
    case 5:
      return d <= 20 ? 'Tauro' : 'Géminis';
    case 6:
      return d <= 20 ? 'Géminis' : 'Cáncer';
    case 7:
      return d <= 22 ? 'Cáncer' : 'Leo';
    case 8:
      return d <= 22 ? 'Leo' : 'Virgo';
    case 9:
      return d <= 22 ? 'Virgo' : 'Libra';
    case 10:
      return d <= 22 ? 'Libra' : 'Escorpio';
    case 11:
      return d <= 21 ? 'Escorpio' : 'Sagitario';
    default: // 12
      return d <= 21 ? 'Sagitario' : 'Capricornio';
  }
}

/// IMC = peso (kg) / estatura (m)².
double calcularImc({required double pesoKg, required double estaturaCm}) {
  final metros = estaturaCm / 100;
  return pesoKg / (metros * metros);
}

/// Categoría del IMC para adultos según los rangos de la OMS.
String categoriaImc(double imc) {
  if (imc < 18.5) return 'Bajo peso';
  if (imc < 25) return 'Peso normal';
  if (imc < 30) return 'Sobrepeso';
  return 'Obesidad';
}

/// Fecha en formato dd/mm/aaaa (evita agregar el paquete intl solo para esto).
String formatearFecha(DateTime f) {
  final dd = f.day.toString().padLeft(2, '0');
  final mm = f.month.toString().padLeft(2, '0');
  return '$dd/$mm/${f.year}';
}
