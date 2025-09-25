import 'dart:math';

class ScientificCalculator {
  static double evaluate(String expression) {
    try {
      // Limpiar espacios
      expression = expression.replaceAll(' ', '');
      
      // Reemplazar símbolos
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      
      // Manejar constantes
      expression = expression.replaceAll('π', pi.toString());
      expression = expression.replaceAll('e', e.toString());
      
      // Manejar funciones (implementación básica)
      expression = _replaceFunctions(expression);
      
      return _evaluateBasic(expression);
    } catch (e) {
      throw Exception('Error en la expresión: $e');
    }
  }

  static String _replaceFunctions(String expression) {
    // Implementación básica - para una app real necesitarías un parser más robusto
    var functionPatterns = {
      'sin': (x) => sin(x),
      'cos': (x) => cos(x),
      'tan': (x) => tan(x),
      '√': (x) => sqrt(x),
      'log': (x) => log(x),
      'ln': (x) => log(x),
    };

    for (var function in functionPatterns.entries) {
      final pattern = '${function.key}\\(([^)]+)\\)';
      final regex = RegExp(pattern);
      
      while (regex.hasMatch(expression)) {
        expression = expression.replaceFirstMapped(regex, (match) {
          final value = double.parse(match.group(1)!);
          final result = function.value(value);
          return result.toString();
        });
      }
    }
    
    return expression;
  }

  static double _evaluateBasic(String expression) {
    // Evaluación básica de operaciones aritméticas
    // Para producción, considera usar una librería de parsing matemático
    if (expression.contains('+')) {
      List<String> parts = expression.split('+');
      return _evaluateBasic(parts[0]) + _evaluateBasic(parts[1]);
    } else if (expression.contains('-')) {
      List<String> parts = expression.split('-');
      return _evaluateBasic(parts[0]) - _evaluateBasic(parts[1]);
    } else if (expression.contains('*')) {
      List<String> parts = expression.split('*');
      return _evaluateBasic(parts[0]) * _evaluateBasic(parts[1]);
    } else if (expression.contains('/')) {
      List<String> parts = expression.split('/');
      return _evaluateBasic(parts[0]) / _evaluateBasic(parts[1]);
    } else if (expression.contains('^')) {
      List<String> parts = expression.split('^');
      return pow(_evaluateBasic(parts[0]), _evaluateBasic(parts[1])).toDouble();
    } else {
      return double.tryParse(expression) ?? 0;
    }
  }
}