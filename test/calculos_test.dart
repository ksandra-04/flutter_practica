// Pruebas unitarias de la lógica (lib/utils/calculos.dart).
// Se ejecutan con:  flutter test

import 'package:flutter_practica/utils/calculos.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calcularEdad', () {
    final hoy = DateTime(2026, 11, 15);

    test('ya cumplió años este año', () {
      expect(calcularEdad(DateTime(2000, 3, 10), hoy: hoy), 26);
    });

    test('todavía no ha cumplido años este año', () {
      expect(calcularEdad(DateTime(2000, 12, 1), hoy: hoy), 25);
    });

    test('cumple años hoy', () {
      expect(calcularEdad(DateTime(2000, 11, 15), hoy: hoy), 26);
    });
  });

  group('calcularSigno', () {
    test('límites entre signos', () {
      expect(calcularSigno(DateTime(2000, 3, 20)), 'Piscis');
      expect(calcularSigno(DateTime(2000, 3, 21)), 'Aries');
      expect(calcularSigno(DateTime(2000, 12, 22)), 'Capricornio');
      expect(calcularSigno(DateTime(2000, 1, 19)), 'Capricornio');
      expect(calcularSigno(DateTime(2000, 1, 20)), 'Acuario');
    });
  });

  group('IMC', () {
    test('cálculo', () {
      final imc = calcularImc(pesoKg: 70, estaturaCm: 175);
      expect(imc, closeTo(22.86, 0.01));
    });

    test('categorías OMS', () {
      expect(categoriaImc(17), 'Bajo peso');
      expect(categoriaImc(22), 'Peso normal');
      expect(categoriaImc(27), 'Sobrepeso');
      expect(categoriaImc(32), 'Obesidad');
    });
  });

  test('formatearFecha usa dd/mm/aaaa', () {
    expect(formatearFecha(DateTime(2001, 2, 5)), '05/02/2001');
  });
}
